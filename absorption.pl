% Anson Lai, z5361987, Assignment 3 – Planning and Machine Learning Question 2.2: Absorption

:- op(300, xfx, <-).
absorption(C1 <- B1, C2 <- B2, C1 <- X, C2 <- Y) :-
    subset(B2, B1),
    subtract(B1, B2, B3),
    B3 \= [],
    append(B3, [C2], X),
    intersection(B1, B2, Y).

% tests
% expected:
% X = x<-[d, e, y],
% Y = y<-[a, b, c].
test(X, Y) :-
    absorption(x <- [a, b, c, d, e], y <- [a, b, c], X, Y).

% expected:
% X = x<-[e, y],
% Y = y<-[a, c, d].
test2(X, Y) :-
    absorption(x <- [a, c, d, e], y <- [a, d, c], X, Y).