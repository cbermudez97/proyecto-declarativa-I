:-[
    "Azul/player_logic.pl"
].

% Update next round first player
checkEspecial(_, no).
checkEspecial(PlayerId, si) :-
    dropEspecial(PlayerId, si),
    update_first(PlayerId).

% Start players rotations making all moves possible
startPlayerRotation(_) :-
    getAllMoves([]).
startPlayerRotation(CantPlayers) :-
    actual_player(PlayerId),
    playerMove(PlayerId, Move, Especial),
    checkEspecial(PlayerId, Especial),
    Move,
    rotate_actual(CantPlayers),
    startPlayerRotation(CantPlayers),
    !.

% Number of Factories with N players
toBuildFacts(2, 5).
toBuildFacts(3, 7).
toBuildFacts(4, 9).

% Start Azul Round with N players
startAzulRound(_) :-
    findall(
        PlayerId, 
        (
            player(PlayerId,_,_,_,_,_,_,_,Wall),
            member(Row, [1,2,3,4,5]),
            getRow(Row, Wall, RowData),
            length(RowData, 5)
        ),
        Enders
    ),
    length(Enders, Len),
    Len =\= 0,
    !.
startAzulRound(CantPlayers) :-
    first_player(RoundFirst), % Set round first player
    update_actual(RoundFirst),
    toBuildFacts(CantPlayers, CantFacts), % Build Factories
    buildFacts(CantFacts), 
    startPlayerRotation(CantPlayers), % All players make all moves
    findall(_, (player(PlayerId,_,_,_,_,_,_,_,_), playerRoundEnd(PlayerId)), _), % Update players board
    discarted(Discarted), % Rebuild bag
    retract(bag(Bag)),
    concatList(Bag,Discarted,NewBag),
    assert(bag(NewBag)),
    buildCenter, % Reset Center
    buildDiscarted, % Reset Discarted
    !.

% Start Azul Game with N players
startAzulGame(CantPlayers) :-
    erase_players,
    createPlayers(CantPlayers),
    buildBag(_),
    buildCenter,
    buildDiscarted,
    startAzulRound(CantPlayers),
    !.
