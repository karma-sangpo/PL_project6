

parse(CharList) :- lines(CharList, []).

% Lines -> Line ; Lines
lines(Stream, Remaining) :-
    line(Stream, [';' | AfterSemicolon]),
    lines(AfterSemicolon, Remaining).
% Lines -> Line
lines(Stream, Remaining) :-
    line(Stream, Remaining).

% Line -> Num , Line
line(Stream, Remaining) :-
    num(Stream, [',' | AfterComma]),
    line(AfterComma, Remaining).
% Line -> Num
line(Stream, Remaining) :-
    num(Stream, Remaining).

% Num -> Digit Num
num(Stream, Remaining) :-
    digit(Stream, AfterDigit),
    num(AfterDigit, Remaining).
% Num -> Digit
num(Stream, Remaining) :-
    digit(Stream, Remaining).

% Digit -> 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
digit(['0' | Tail], Tail).
digit(['1' | Tail], Tail).
digit(['2' | Tail], Tail).
digit(['3' | Tail], Tail).
digit(['4' | Tail], Tail).
digit(['5' | Tail], Tail).
digit(['6' | Tail], Tail).
digit(['7' | Tail], Tail).
digit(['8' | Tail], Tail).
digit(['9' | Tail], Tail).

% Example execution:
% ?- parse(['3', '2', ',', '0', ';', '1', ',', '5', '6', '7', ';', '2']).
% true.
% ?- parse(['3', '2', ',', '0', ';', '1', ',', '5', '6', '7', ';', '2', ',']).
% false.
% ?- parse(['3', '2', ',', ';', '0']).
% false.