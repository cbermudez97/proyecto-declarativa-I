:- [player].

% Best Fit Metric
calculeMetricCompleteFit(PlayerId, Row, Type, Metric) :-
    player(PlayerId,
           _,
           _,
           _,
           _,
           _,
           _,
           _,
           Wall),
    calculateScore(Row, Type, Wall, Metric), !.

% Get Player First Posible Move
getImpData((_, Type, Cant),  (Type, Cant)) :- !.
getImpData((Type, Cant),  (Type, Cant)) :- !.

buildMove(PlayerId,  ((FactId, Type, Cant), -1), Move, no) :-
    Move=(moveTile((FactId, Type, Cant), no), format("Jugador ~a descarta ~a fichas de tipo ~a desde la Factoría ~a~n", [PlayerId, Cant, Type, FactId]), addTilesToRow(PlayerId, -1, Type, Cant)), !.

buildMove(PlayerId,  ((FactId, Type, Cant), Row), Move, no) :-
    Move=(moveTile((FactId, Type, Cant), no), format("Jugador ~a juega ~a fichas de tipo ~a en la fila ~a desde la Factoría ~a~n", [PlayerId, Cant, Type, Row, FactId]), addTilesToRow(PlayerId, Row, Type, Cant)), !.

buildMove(PlayerId,  ((Type, Cant), -1), Move, Especial) :-
    Move=(moveTile((Type, Cant), Especial), format("Jugador ~a descarta ~a fichas de tipo ~a desde el centro~n", [PlayerId, Cant, Type]), addTilesToRow(PlayerId, -1, Type, Cant)), !.

buildMove(PlayerId,  ((Type, Cant), Row), Move, Especial) :-
    Move=(moveTile((Type, Cant), Especial), format("Jugador ~a juega ~a fichas de tipo ~a en la fila ~a desde el centro~n", [PlayerId, Cant, Type, Row]), addTilesToRow(PlayerId, Row, Type, Cant)), !.

% Check if move is Valid for a Player
checkValidMove(_, -1, _, _) :- !.
checkValidMove(PlayerId, Row, Type, Cant) :-
    Row=\= -1,
    getPlayerRow(PlayerId, Row, ActRow),
    player(PlayerId,
           _,
           _,
           _,
           _,
           _,
           _,
           _,
           Wall),
    not(member((Row, _, Type), Wall)),
    getNewRow(Row,
              ActRow,
              (Type, Cant),
              _,
              _), !.

getFirstMove(PlayerId, Move, Especial) :-
    getAllMoves(PossiblePlays),
    findall((Y, Row),
            ( member(Y, PossiblePlays),
              member(Row, [1, 2, 3, 4, 5, -1]),
              getImpData(Y,  (Type, Cant)),
              checkValidMove(PlayerId, Row, Type, Cant)
            ),
            [RawMove|_]),
    buildMove(PlayerId, RawMove, Move, Especial), !.
% Posible Good Move
getCompleteFitMove(PlayerId, Move, Especial) :-
    getAllMoves(PossiblePlays),
    findall(
        ((Y, Row), Metric),
        (
            member(Y,PossiblePlays),
            member(Row, [1, 2, 3, 4, 5]), 
            getImpData(Y, (Type, Cant)),
            checkValidMove(PlayerId, Row, Type, Cant),
            getPlayerRow(PlayerId, Row, ActRow), 
            getNewRow(Row, ActRow, (Type, Cant), (Type, Row), (Type, 0)), % Make sure the move complete the Row
            calculeMetricCompleteFit(PlayerId, Row, Type, Metric)
        ), 
        RawMoves
        ),
        sort(2, @>=, RawMoves, Sorted),
        [(RawMove, _)|_]=Sorted,
        buildMove(PlayerId, RawMove, Move, Especial),
    !.

% Generate Best Positive Move
findBestofTheBest(BestScore, List, SolData) :-
    findall(
        (Data, BestScore),
        (
            member((Data, BestScore), List),
            (_, Row)=Data, 
            findall(
                ((_, Row2), BestScore),
                (member(((_, Row2), BestScore), List),
                Row2 > Row),
                []
            ) 
        ),
        [(SolData, BestScore)|_]
    ),
    !.

getBestPosMove(PlayerId, Move, Especial) :-
    getAllMoves(PossiblePlays),
    findall(
        ((Y, Row), Metric),
        (
            member(Y,PossiblePlays),
            member(Row, [5, 4, 3, 2, 1, -1]), 
            getImpData(Y, (Type, Cant)),
            player(PlayerId,A,B,C,D,E,F,G,H),
            assert(player(-1,A,B,C,D,E,F,G,H)),
            fakeAddTilesToRow(-1, Row, Type, Cant),
            fakePlayerRoundEnd(-1),
            retract(player(-1, Metric,_,_,_,_,_,_,_))
        ), 
        RawMoves
    ),
    sort(2, @>=, RawMoves, Sorted),
    [(_, BestScore)|_]=Sorted,
    findBestofTheBest(BestScore, Sorted, RawMove),
    buildMove(PlayerId, RawMove, Move, Especial),
    !.


% Generic Move provider, change it to follow a different Strategy
playerMove(PlayerId, Move, Especial) :-
    getBestPosMove(PlayerId, Move, Especial),
    !.
playerMove(PlayerId, Move, Especial) :-
    getCompleteFitMove(PlayerId, Move, Especial),
    !.
playerMove(PlayerId, Move, Especial) :-
    getFirstMove(PlayerId, Move, Especial),
    !.
