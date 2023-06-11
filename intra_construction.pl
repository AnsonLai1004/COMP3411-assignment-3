% Anson Lai, z5361987, Assignment 3 – Planning and Machine Learning Question 2.1: Intra-construction

:- op(300, xfx, <-).
intra_construction(C1 <- B1, C2 <- B2, C1 <- X, C <- Z1, C <- Z2) :-
    C1 == C2,
    intersection(B1, B2, Z1B),
    Z1B \= [],
    subtract(B1, Z1B, Z1),
    subtract(B2, Z1B, Z2),
    gensym(z, C),
    append(Z1B, [C], X).

% tests
% expected:
% X = x<-[b, d, z1],
% Y = z1<-[c, e],
% Z = z1<-[a, f].
test(X, Y, Z) :-
    intra_construction(x <- [b, c, d, e], x <- [a, b, d, f], X, Y, Z).

% expected:
% X = x<-[a, b, c, d, e, z1],
% Y = z1<-[f],
% Z = z1<-[g, h].
test2(X, Y, Z) :-
    intra_construction(x <- [a, b, c, d, e, f], x <- [a, b, c, d, e, g, h], X, Y, Z).