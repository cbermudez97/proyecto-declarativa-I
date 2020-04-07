:-[
    "Azul/player_logic.pl"
].

% Number of Factories with N players
toBuildFacts(2, 5).
toBuildFacts(3, 7).
toBuildFacts(4, 9).

% Start Azul Round with N players
startAzulRound(_) :-
    findall(
        _, 
        (
            player(_,_,_,_,_,_,_,_,Wall),
            member(Row, [1,2,3,4,5]),
            getRow(Row, Wall, RowData),
            length(RowData, 5)
        ),
        _
    ),
    !.
startAzulRound(CantPlayers) :-
    toBuildFacts(CantPlayers, CantFacts),
    buildFacts(CantFacts),

% Start Azul Game with N players
startAzulGame(CantPlayers) :-
    createPlayers(CantPlayers),
    buildBag(_),
    buildCenter,
    buildDiscarted,
    startAzulRound(CantPlayers),
    !.
