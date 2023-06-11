% Anson Lai, z5361987, Assignment 3 – Planning and Machine Learning 

% -----------------------------------------------------------------------------
% Question 1: Planning

% action(Action, State, NewState)
% state(RLoc, RHC, SWC, MW, RHM)
% 	RLoc - Robot Location,
% 	RHC - Robot Has Coffee,
% 	SWC - Sam Wants Coffee,
% 	MW - Mail Waiting,
% 	RHM - Robot Has Mail
% action spec:
% 	mc - move clockwise
% 	mcc - move counterclockwise
% 	puc - pickup coffee
% 	dc - deliver coffee
% 	pum - pickup mail
% 	dm - deliver mail
% clockwise and counterclockwise logic for 4 locations (lab, cs, mr, off)
clockwise(cs, off).
clockwise(off, lab).
clockwise(lab, mr).
clockwise(mr, cs).

counterclockwise(cs, mr).
counterclockwise(mr, lab).
counterclockwise(lab, off).
counterclockwise(off, cs).

% actions
action(mc, 
	state(CurrRoom, RHC, SWC, MW, RHM),
	state(NewRoom, RHC, SWC, MW, RHM)) :-
		clockwise(CurrRoom, NewRoom).

action(mcc, 
	state(CurrRoom, RHC, SWC, MW, RHM),
	state(NewRoom, RHC, SWC, MW, RHM)) :-
		counterclockwise(CurrRoom, NewRoom).

% can pick up coffee if Rob is at the coffee shop,
% not rhc and RLoc = cs
action(puc, 
	state(cs, false, SWC, MW, RHM),
	state(cs, true, SWC, MW, RHM)).

% deliver coffee if Rob is carrying coffee and is at Sam's office
% rhc and RLoc = off
action(dc, 
	state(off, true, _SWC, MW, RHM),
	state(off, false, false, MW, RHM)).

% pick up mail if Rob is at the mail room and there is mail waiting there
action(pum, 
	state(mr, RHC, SWC, true, _RHM),
	state(mr, RHC, SWC, false, true)).

% deliver mail if Rob is carrying mail and at Sam’s office.
action(dm, 
	state(off, RHC, SWC, MW, true),
	state(off, RHC, SWC, MW, false)).

% plan(StartState, FinalState, Plan)

plan(State, State, []).				% To achieve State from State itself, do nothing

plan(State1, GoalState, [Action1 | RestofPlan]) :-
	action(Action1, State1, State2),		% Make first action resulting in State2
	plan(State2, GoalState, RestofPlan). 		% Find rest of plan

% Iterative deepening planner
% Backtracking to "append" generates lists of increasing length
% Forces "plan" to ceate fixed length plans

id_plan(Start, Goal, Plan) :-
    append(Plan, _, _),
    plan(Start, Goal, Plan).

% -----------------------------------------------------------------------------
% Question 2: Inductive Logic Programming 

% Question 2.1: Intra-construction
% This transformation takes two rules, with the same head, such as
% x <- [b, c, d, e]
% x <- [a, b, d, f]
% and replaces the with rules
% x <- [b, d, z]
% z <- [c, e]
% z <- [a, f]
% That is, we merge the two, x, clauses, keeping the intersection and adding a new
% predicate, z, that distributes the differences to two new clauses.
:- op(300, xfx, <-).
intra_construction(C1 <- B1, C2 <- B2, C1 <- X, C <- Z1, C <- Z2) :-
    C1 == C2,
    intersection(B1, B2, Z1B),
    Z1B \= [],
    subtract(B1, Z1B, Z1),
    subtract(B2, Z1B, Z2),
    gensym(z, C),
    append(Z1B, [C], X).

% Question 2.2: Absorption
% This transformation takes two rules, with the different heads, such as
% x <- [a, b, c, d, e]
% y <- [a, b, c]
% and replaces the with rules
% x <- [d, e, y]
% y <- [a, b, c]
% Note that the second clause is unchanged. This operator checks to see if the body of one
% clause is a subset of the other. If it is, the common elements can be removed from the
% larger clause and the head of the smaller one appended to the larger one.
absorption(C1 <- B1, C2 <- B2, C1 <- X, C2 <- Y) :-
    subset(B2, B1),
    subtract(B1, B2, B3),
    B3 \= [],
    append(B3, [C2], X),
    intersection(B1, B2, Y).

% Question 2.3: Truncation
% Truncation. This is the simplest transformation. It takes two rules that have the same
% head and simply drops the differences to leave just one rule. For example
% x <- [a, b, c, d]
% x <- [a, c, j, k]
% are replaced by
% x <- [a, c]
truncation(C1 <- B1, C2 <- B2, C1 <- X) :-
    C1 = C2,
    intersection(B1, B2, X), 
    X \= [].
