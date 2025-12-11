%%%%%%%%%%%%%%%%%%%%%%
% Your code goes here:
%%%%%%%%%%%%%%%%%%%%%%
:- use_module(library(lists)).

search(Moves) :-
    initial(StartRoom),
    gather_keys(StartRoom, [], InitialKeys),
    bfs([[node(StartRoom, InitialKeys), []]], [], ReversedMoves),
    reverse(ReversedMoves, Moves).

gather_keys(Location, CurrentKeys, UpdatedKeys) :-
    findall(KeyColor, key(Location, KeyColor), FoundColors),
    append(FoundColors, CurrentKeys, Combined),
    sort(Combined, UpdatedKeys).

transition(node(CurrentRoom, Inventory), node(NextRoom, NewInventory), move(CurrentRoom, NextRoom)) :-
    can_traverse(CurrentRoom, NextRoom, Inventory),
    gather_keys(NextRoom, Inventory, NewInventory).

can_traverse(RoomA, RoomB, _Inventory) :-
    door(RoomA, RoomB) ;
    door(RoomB, RoomA).

can_traverse(RoomA, RoomB, Inventory) :-
    ( locked_door(RoomA, RoomB, DoorColor)
    ; locked_door(RoomB, RoomA, DoorColor)
    ),
    memberchk(DoorColor, Inventory).

bfs([[node(CurrentPos, _Inventory), AccumulatedMoves] | _], _Explored, AccumulatedMoves) :-
    treasure(CurrentPos), !.

bfs([[CurrentNode, AccumulatedMoves] | Frontier], Explored, Result) :-
    (   memberchk(CurrentNode, Explored)
    ->  bfs(Frontier, Explored, Result)
    ;   findall([SuccessorNode, [TransitionAction | AccumulatedMoves]],
                ( transition(CurrentNode, SuccessorNode, TransitionAction),
                  \+ memberchk(SuccessorNode, Explored),
                  \+ memberchk([SuccessorNode, _], Frontier)
                ),
                Successors),
        append(Frontier, Successors, UpdatedFrontier),
        bfs(UpdatedFrontier, [CurrentNode | Explored], Result)
    ).