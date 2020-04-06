:- [utils, tiles, wall].

:- dynamic player/9, first_player/1, actual_player/1.

% player(I, S, D, R1, R2, R3, R4, R5, W).
% I - player index from 1 to N
% S - player score
% D - number of droped tiles in the actual round
% Ri - tuple with the format (Type, Cant), Type is `none` if row is empty
% W - player wall with all tiles in format (Row, Column, Type)

% Create and Update First Player, this assumes always start the first player
:- assert(first_player(1)).
update_first(NewFirst) :-
    retract(first_player(_)),
    assert(first_player(NewFirst)),
    !.

% Create and Rotate Actual Player
:- assert(actual_player(1)).
rotate_actual(CantPlayer) :- 
    retract(actual_player(Actual)),
    N is Actual - 1,
    Next is ((N + 1) mod CantPlayer) + 1,
    assert(actual_player(Next)),
    !.

% Create a new players data
createPlayer(I) :-
    assert(player(I, 0, 0, (none, 0), (none, 0), (none, 0), (none, 0), (none, 0), [])),
    !.

createPlayers(1) :-
    createPlayer(1),
    !.

createPlayers(N) :-
    N > 1,
    N1 is N - 1,
    createPlayers(N1),
    createPlayer(N),
    !.

% Erase all players
erase_players :-
    findall(_, retract(player(_,_,_,_,_,_,_,_,_)), _),
    !.

% Update player I data
updateScore(I, N):-
    retract(player(I, A, B, C, D, E, F, G, H)),
    NS is max(0, A + N),
    assert(player(I, NS, B, C, D, E, F, G, H)),
    !.

updateDroped(I, N):-
    retract(player(I, A, _, C, D, E, F, G, H)),
    assert(player(I, A, N, C, D, E, F, G, H)),
    !.

updateR1(I, R1):-
    retract(player(I, A, B, _, D, E, F, G, H)),
    assert(player(I, A, B, R1, D, E, F, G, H)),
    !.

updateR2(I, R2):-
    retract(player(I, A, B, C, _, E, F, G, H)),
    assert(player(I, A, B, C, R2, E, F, G, H)),
    !.

updateR3(I, R3):-
    retract(player(I, A, B, C, D, _, F, G, H)),
    assert(player(I, A, B, C, D, R3, F, G, H)),
    !.

updateR4(I, R4):-
    retract(player(I, A, B, C, D, E, _, G, H)),
    assert(player(I, A, B, C, D, E, R4, G, H)),
    !.

updateR5(I, R5):-
    retract(player(I, A, B, C, D, E, F, _, H)),
    assert(player(I, A, B, C, D, E, F, R5, H)),
    !.

updateRow(PlayerId, 1, NewRowData) :-
    updateR1(PlayerId, NewRowData),
    !.

updateRow(PlayerId, 2, NewRowData) :-
    updateR2(PlayerId, NewRowData),
    !.

updateRow(PlayerId, 3, NewRowData) :-
    updateR3(PlayerId, NewRowData),
    !.

updateRow(PlayerId, 4, NewRowData) :-
    updateR4(PlayerId, NewRowData),
    !.

updateRow(PlayerId, 5, NewRowData) :-
    updateR5(PlayerId, NewRowData),
    !.

updateWall(I, W):-
    retract(player(I, A, B, C, D, E, F, G, _)),
    assert(player(I, A, B, C, D, E, F, G, W)),
    !.


% Modify score statements

% Calcule score C with alrady D droped tiles
calculeDropScore(1, -1).
calculeDropScore(2, -2).
calculeDropScore(3, -4).
calculeDropScore(4, -6).
calculeDropScore(5, -8).
calculeDropScore(6, -11).
calculeDropScore(7, -14).
calculeDropScore(N, -14) :-
    N > 7.

% Player drop a tile, this update the player number of droped tiles
dropTile(I, C) :-
    player(I, _, D, _,_,_,_,_,_),
    D1 is D + 1,
    calculeDropScore(D1, C),
    updateDroped(I, D1),
    !.

dropTiles(I, 0, C) :-
    player(I, _, D, _,_,_,_,_,_),
    calculeDropScore(D, C),
    !.

dropTiles(I, 1, C) :-
    dropTile(I, C),
    !.

dropTiles(I, N, C) :-
    N > 1,
    N1 is N - 1,
    dropTiles(I, N1, _),
    dropTile(I, C),
    !.

% Calculate player I score when inserting Tile of type T in row R
calculatePlayerMoveScore(I, R, T, S) :-
    player(I, _, _,_,_,_,_,_, W),
    calculateScore(R, T, W, S),
    !.

% Get Player Row
getPlayerRow(PlayerId, Pos, Row) :-
    Pos >= 1,
    Pos =< 5,
    RealPos is Pos + 3,
    player(PlayerId, S, D, R1, R2, R3, R4, R5, W),
    arg(RealPos, player(PlayerId, S, D, R1, R2, R3, R4, R5, W), Row),
    !.

% Add C tiles of type T to player I in row R
getNewRow(Row, (none, 0), (Type, ToAddCant), (Type, AddedCant), (Type, DiscartedCant)) :-
    AddedCant is min(Row, ToAddCant),
    DiscartedCant is  ToAddCant - AddedCant,
    !.
getNewRow(Row, (Type, ActCant), (Type, ToAddCant), (Type, NewCant), (Type, DiscCant)) :-
    NewCant is min(ActCant + ToAddCant, Row),
    DiscCant is max(ActCant + ToAddCant - Row, 0),
    !.

addTilesToRow(PlayerId, Row, Type, Cant) :-
    getPlayerRow(PlayerId, Row, ActRow),
    player(PlayerId,_,_,_,_,_,_,_,Wall),
    not(member((Row, _, Type), Wall)),
    getNewRow(Row, ActRow, (Type, Cant),NewRow, Discarted),
    expand([Discarted], ExpDiscarted),
    length(ExpDiscarted, N),
    dropTiles(PlayerId, N, _),
    discardTiles(ExpDiscarted),
    updateRow(PlayerId, Row, NewRow),
    !.     
