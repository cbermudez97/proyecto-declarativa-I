:-[
    "Azul/player_logic.pl"
].

% Update next round first player
checkEspecial(_, no) :-
    !.
checkEspecial(PlayerId, si) :-
    dropEspecial(PlayerId, si),
    format("El jugador ~a tomo la ficha especial y sera el primero en la siguiente Ronda.~n",[PlayerId]),
    update_first(PlayerId),
    !.

% Start players rotations making all moves possible
startPlayerRotation(_) :- % No more possible moves
    getAllMoves([]),
    center([]),
    format("No se pueden realizar jugadas.~n",[]),
    !.
startPlayerRotation(_) :- % Weird Case
    getAllMoves([]),
    center([especial]),
    actual_player(PlayerId),
    checkEspecial(PlayerId, si),
    format("No se pueden realizar jugadas.~n",[]),
    !.
startPlayerRotation(CantPlayers) :-
    actual_player(PlayerId),
    format("Turno del Jugador ~a.~n",[PlayerId]),
    format("Estado de la Mesa:~n", _),
    print_factories,
    print_center,
    playerMove(PlayerId, Move, Especial),
    Move,
    checkEspecial(PlayerId, Especial),
    format("Fin del Turno.~n",[]),
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
    Enders=[First|_],
    format("El juego termina pues los jugadores ~a han completado una fila~n", [First]),
    !.
startAzulRound(CantPlayers) :-
    format("Empezando Nueva Ronda: ~n",_),
    first_player(RoundFirst), % Set round first player
    update_actual(RoundFirst),
    toBuildFacts(CantPlayers, CantFacts), % Build Factories
    notrace(buildFacts(CantFacts)), 
    startPlayerRotation(CantPlayers), % All players make all moves
    format("Fin de la Ronda.~n",[]),
    format("Preparando Siguiente Ronda.~n",[]),
    findall(_, (player(PlayerId,_,_,_,_,_,_,_,_), playerRoundEnd(PlayerId)), _), % Update players board
    discarted(Discarted), % Rebuild bag
    retract(bag(Bag)),
    concatList(Bag,Discarted,NewBag),
    assert(bag(NewBag)),
    buildCenter, % Reset Center
    buildDiscarted, % Reset Discarted
    format("Fin de la Preparación.~n",[]),
    startAzulRound(CantPlayers), % Play next round
    !.

% Start Azul Game with N players
startAzulGame(CantPlayers) :-
    format("Empazando juego de Azul con ~a jugadores!~n", [CantPlayers]),
    erase_players,
    createPlayers(CantPlayers),
    update_first(1), % Always player 1 starts
    buildBag(_),
    buildCenter,
    buildDiscarted,
    startAzulRound(CantPlayers),
    !.
