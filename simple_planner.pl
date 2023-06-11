% Anson Lai, z5361987, Assignment 3 – Planning and Machine Learning Question 1: Planning
% State of the robot's world = state(RobotLocation, BasketLocation, RubbishLocation)
% action(Action, State, NewState): Action in State produces NewState
% We assume robot never drops rubbish on floor and never pushes rubbish around

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

% tests
% expected [mc, mc, puc, mc, dc]
test1(Plan) :-
	id_plan(
		state(lab, false, true, false, false),
		state(_, _, false, _, _),
		Plan).

% expected [mc, pum, mc, puc, mc, dc, dm]
test2(Plan) :-
	id_plan(
		state(lab, false, true, true, false),
		state(off, false, false, false, false),
		Plan).

% expected [mc, pum, mc, mc, dm]
test3(Plan) :-
	id_plan(
		state(lab, false, false, true, false),
		state(off, false, false, false, false),
		Plan).