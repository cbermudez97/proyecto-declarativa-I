:-[utils].

% Get Column C from Tile of type T in Row R of the Wall
findCol(rojo, 1, 3).
findCol(rojo, 2, 4).
findCol(rojo, 3, 5).
findCol(rojo, 4, 1).
findCol(rojo, 5, 2).

findCol(negro, 1, 4).
findCol(negro, 2, 5).
findCol(negro, 3, 1).
findCol(negro, 4, 2).
findCol(negro, 5, 3).

findCol(amarillo, 1, 2).
findCol(amarillo, 2, 3).
findCol(amarillo, 3, 4).
findCol(amarillo, 4, 5).
findCol(amarillo, 5, 1).

findCol(azul, 1, 1).
findCol(azul, 2, 2).
findCol(azul, 3, 3).
findCol(azul, 4, 4).
findCol(azul, 5, 5).

findCol(blanco, 1, 5).
findCol(blanco, 2, 1).
findCol(blanco, 3, 2).
findCol(blanco, 4, 3).
findCol(blanco, 5, 4).

% Can play tile T in row R of wall W
validWallIns(T, R, W) :-
    findCol(T, R, C),
    not(member((R, C, T), W)),
    !.

% Get row R tiles from wall W sorted by columns
getRowH(_, [], []).
getRowH(R, [(R, C, T)|W], [(R, C, T)|L]) :- 
    getRowH(R, W, L), 
    !.
getRowH(R, [(R1, _, _)|W], L) :- 
    R1 =\= R,
    getRowH(R, W, L),
    !.
getRow(R, W, L) :-
    getRowH(R, W, L1),
    sort(2, @<, L1, L),
    !.

% Get column C tiles from wall W sorted by rows
getColumnH(_, [], []).
getColumnH(C, [(R, C, T)|W], [(R, C, T)|L]) :- 
    getColumnH(C, W, L), 
    !.
getColumnH(C, [(_, C1, _)|W], L) :- 
    C1 =\= C,
    getColumnH(C, W, L),
    !.
getColumn(C, W, L) :-
    getColumnH(C, W, L1),
    sort(1, @<, L1, L),
    !.

% Get type T tiles from wall W
getColor(_, [], []).
getColor(T, [(R, C, T)|W], [(R, C, T)|L]) :- 
    getColor(T, W, L), 
    !.
getColor(T, [(_, _, T1)|W], L) :- 
    not(T1 = T),
    getColor(T, W, L),
    !.


% Calculate length of continous sequence of list L, tail(L) column is EC
getContR(EC, [(_,C,_)|L], S) :- 
    length([(_,C,_)|L], S),
    S =:= abs(C - EC) + 1,
    !.
getContR(EC, [(_,C,_)|L], S) :- 
    length([(_,C,_)|L], N),
    N =\= abs(C - EC) + 1,
    getContR(EC, L, S),
    !.

% Calculate Row Score when inserting tile T in row R of wall W
getRowScore(R, T, W, S) :-
    validWallIns(T, R, W),
    findCol(T, R, C),
    E=(R,C,T),
    getRow(R, W, RL),
    sort(2, @<, [E|RL], L),
    splitList(E, L, RI, RD),
    reverseList([E|RD], D),
    concatList(RI, [E], I),
    getContR(C, I, S1),
    getContR(C, D, S2),
    S is S1 + S2 - 1,
    !.

% Calculate length of continous sequence of list L, tail(L) row is ER
getContC(ER, [(R,_,_)|L], S) :- 
    length([(R,_,_)|L], S),
    S =:= abs(R - ER) + 1,
    !.
getContC(ER, [(R,_,_)|L], S) :- 
    length([(R,_,_)|L], N),
    N =\= abs(R - ER) + 1,
    getContC(ER, L, S),
    !.

% Calculate Column Score when inserting tile T in row R of wall W
getColumnScore(R, T, W, S) :-
    validWallIns(T, R, W),
    findCol(T, R, C),
    E=(R,C,T),
    getColumn(C, W, CL),
    sort(1, @<, [E|CL], L),
    splitList(E, L, RI, RD),
    reverseList([E|RD], D),
    concatList(RI, [E], I),
    getContC(R, I, S1),
    getContC(R, D, S2),
    S is S1 + S2 - 1,
    !.
% Calculate Bonus score when inserting tile T in row R of wall W
getBonusScoreRow(R, T, W, 2) :-
    validWallIns(T, R, W),
    getRow(R, W, RL),
    length([[]|RL], 5).
getBonusScoreRow(R, T, W, 0) :-
    validWallIns(T, R, W),
    getRow(R, W, RL),
    not(length([[]|RL], 5)).

getBonusScoreColumn(R, T, W, 7) :-
    validWallIns(T, R, W),
    findCol(T, R, C),
    getColumn(C, W, RL),
    length([[]|RL], 5).
getBonusScoreColumn(R, T, W, 0) :-
    validWallIns(T, R, W),
    findCol(T, R, C),
    getColumn(C, W, RL),
    not(length([[]|RL], 5)).

getBonusScoreColor(R, T, W, 10) :-
    validWallIns(T, R, W),
    getColor(T, W, RL),
    length([[]|RL], 5).
getBonusScoreColor(R, T, W, 0) :-
    validWallIns(T, R, W),
    getColor(T, W, RL),
    not(length([[]|RL], 5)).

getBonusScore(R, T, W, S) :-
    getBonusScoreRow(R, T, W, S1),    
    getBonusScoreColor(R, T, W, S2),
    getBonusScoreColumn(R, T, W, S3),
    S is S1 + S2 + S3,
    !.

% Calculate Total score when inserting tile T in row R of wall W
calculateScore(R, T, W, S) :-
    getRowScore(R, T, W, S1),
    getColumnScore(R, T, W, S2),
    getBonusScore(R, T, W, S3),
    S is S1 + S2 + S3, 
    !.
