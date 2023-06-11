% Anson Lai, z5361987, Assignment 3 – Planning and Machine Learning Question 2.2: Absorption

:- op(300, xfx, <-).
truncation(C1 <- B1, C2 <- B2, C1 <- X) :-
    C1 = C2,
    intersection(B1, B2, X).

% tests
% expected:
% X = x<-[a, c].
test(X) :-
    truncation(x <- [a, b, c, d], x <- [a, c, j, k], X).
