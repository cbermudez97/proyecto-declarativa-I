concatList([], Z, Z).
concatList([A|X], Y, [A|Z]) :- 
    concatList(X, Y, Z).

insertList(X, Y, [X|Y]).
insertList(X, [A|Y], [A|Z]) :- 
    insertList(X, Y, Z).

removeList(X, Y, Z) :- 
    insertList(X, Z, Y).

reverseList([], []).
reverseList([A|X], Y) :-
    reverseList(X, Z), 
    concatList( Z, [A], Y).

getIndex(1, [X|L], X, L) :- 
    !.
getIndex(I, [Y|L], X, [Y|R]) :- 
    I2 is I - 1, 
    !, 
    getIndex(I2, L, X, R).


countSumHelp(X, Y, 1) :- 
    X = Y.
countSumHelp(X, Y, 0) :- 
    not(X = Y).

count(_, [], 0) :- 
    !.
count(X, [Y|L], C) :- 
    count(X,L,C1), 
    countSumHelp(X, Y, S), 
    C is C1 + S, 
    !.

reduce(L, R) :- 
    list_to_set(L, S), 
    reduceHelp(S, L, R), 
    !.
reduceHelp([], _, []).
reduceHelp([X| L], O, [(X, S)| R]) :- 
    reduceHelp(L, O, R), 
    count(X, O, S).

expand([], []) :- 
    !.
expand([(_, 0)| L], R) :- 
    expand(L, R), 
    !.
expand([(X, Y)| L], [X| R]) :- 
    Y > 0, 
    Y1 is Y - 1,
    expand([(X, Y1)|L], R), 
    !.

splitList(E, [E|D], [], D) :- 
    !. 
splitList(E, [E1|R], [E1|L], D) :- 
    not(E == E1),
    splitList(E, R, L, D),
    !.
