:- use_module(library(clpfd)).
:- use_module(library(readutil)).

:- set_prolog_flag(stack_limit, 8_000_000_000).
:- set_prolog_flag(debug, false).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MAIN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

resolver_fichero(Entrada, Salida) :-
    open(Entrada, read, In, [buffer(full)]),
    open(Salida, write, Out, [buffer(full)]),
    procesar(In, Out),
    close(In),
    close(Out).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PROCESAR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

procesar(In, Out) :-
    read_line_to_codes(In, Codes),
    (
        Codes == end_of_file ->
            true
        ;
            (
                resolver(Codes, Sol)
                ->
                    format(Out, '~s~n', [Sol])
                ;
                    format(Out, 'SIN_SOLUCION~n', [])
            ),
            procesar(In, Out)
    ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% RESOLVER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

resolver(Codes, Solucion) :-

    length(Vars, 81),

    parse(Codes, Vars),

    Vars ins 1..9,

    restricciones(Vars),

    once(labeling([ffc], Vars)),

    to_codes(Vars, Solucion).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PARSER RAPIDO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

parse([], []).

parse([46|Cs], [_|Vs]) :-     % '.'
    parse(Cs, Vs).

parse([C|Cs], [V|Vs]) :-
    C >= 49,
    C =< 57,
    V #= C - 48,
    parse(Cs, Vs).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SALIDA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

to_codes([], []).

to_codes([V|Vs], [C|Cs]) :-
    C is V + 48,
    to_codes(Vs, Cs).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% RESTRICCIONES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

restricciones(V) :-

    filas(V),
    columnas(V),
    bloques(V).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FILAS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

filas(V) :-

    fila(V, 0),
    fila(V, 9),
    fila(V, 18),
    fila(V, 27),
    fila(V, 36),
    fila(V, 45),
    fila(V, 54),
    fila(V, 63),
    fila(V, 72).

fila(V, I) :-

    nth0(I, V, A1),
    I1 is I+1, nth0(I1, V, A2),
    I2 is I+2, nth0(I2, V, A3),
    I3 is I+3, nth0(I3, V, A4),
    I4 is I+4, nth0(I4, V, A5),
    I5 is I+5, nth0(I5, V, A6),
    I6 is I+6, nth0(I6, V, A7),
    I7 is I+7, nth0(I7, V, A8),
    I8 is I+8, nth0(I8, V, A9),

    diferentes([A1,A2,A3,A4,A5,A6,A7,A8,A9]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% COLUMNAS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

columnas(V) :-

    columna(V,0),
    columna(V,1),
    columna(V,2),
    columna(V,3),
    columna(V,4),
    columna(V,5),
    columna(V,6),
    columna(V,7),
    columna(V,8).

columna(V, I) :-

    nth0(I, V, A1),
    I1 is I+9, nth0(I1, V, A2),
    I2 is I+18, nth0(I2, V, A3),
    I3 is I+27, nth0(I3, V, A4),
    I4 is I+36, nth0(I4, V, A5),
    I5 is I+45, nth0(I5, V, A6),
    I6 is I+54, nth0(I6, V, A7),
    I7 is I+63, nth0(I7, V, A8),
    I8 is I+72, nth0(I8, V, A9),

    diferentes([A1,A2,A3,A4,A5,A6,A7,A8,A9]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% BLOQUES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

bloques(V) :-

    bloque(V,0),
    bloque(V,3),
    bloque(V,6),

    bloque(V,27),
    bloque(V,30),
    bloque(V,33),

    bloque(V,54),
    bloque(V,57),
    bloque(V,60).

bloque(V, I) :-

    nth0(I, V, A1),
    I1 is I+1, nth0(I1, V, A2),
    I2 is I+2, nth0(I2, V, A3),

    I3 is I+9, nth0(I3, V, A4),
    I4 is I+10, nth0(I4, V, A5),
    I5 is I+11, nth0(I5, V, A6),

    I6 is I+18, nth0(I6, V, A7),
    I7 is I+19, nth0(I7, V, A8),
    I8 is I+20, nth0(I8, V, A9),

    diferentes([A1,A2,A3,A4,A5,A6,A7,A8,A9]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TODOS DIFERENTES (BINARIO)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

diferentes([]).

diferentes([X|Xs]) :-
    distintos(X, Xs),
    diferentes(Xs).

distintos(_, []).

distintos(X, [Y|Ys]) :-
    X #\= Y,
    distintos(X, Ys).
