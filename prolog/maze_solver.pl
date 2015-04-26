position(1,1).
position(1,2).
position(1,3).
position(1,4).
position(2,1).
position(2,2).
position(2,3).
position(2,4).
position(3,1).
position(3,2).
position(3,3).
position(3,4).
barrier(2,1).
barrier(2,2).
adjacent(position(1,1), position(1,2)).
adjacent(position(1,2), position(1,3)).
adjacent(position(1,3), position(2,3)).
adjacent(position(1,3), position(1,4)).
adjacent(position(1,4), position(2,4)).
adjacent(position(2,2), position(2,3)).
adjacent(position(3,2), position(3,3)).
adjacent(position(3,3), position(2,3)).
adjacent(position(3,1), position(3,2)).
adjacent(position(3,3), position(1,3)).

next(X,Y) :- adjacent(X,Y).
next(X,Y) :- adjacent(Y,X).
connect(X,Y) :- adjacent(X,Y).
connect(X,Y) :- adjacent(X,Z), connect(Z,Y).
direct_connect(X,Y,S,F) :- next(X,Y), not(member(Z,S)), direct_connect(Z,Y,[Z|S],F).
direct_connect(X,Y,S,[Y|S]) :- next(X,Y).

add_connect(X,Y,S,F) :- connect(X,Z), not(member(Z,S)), add_connect(Z,Y,[Z|S],F).
add_connect(X,Y,S,[Y|S]) :- connect(X,Y).

exist(X) :- next(X,_).
member(X,[X|_]).
member(X,[_|T]) :- member(X,T).

route(X,Y,F) :- /* exist(X), exist(Y),*/ direct_connect(X,Y,[X],F), write('Path'), nl, revwrite(F).
newroute(X,Y,F) :- /* exist(X), exist(Y),*/ add_connect(X,Y,[X],F), write('Path'), nl, revwrite(F).


revwrite([X]) :- write(X).
revwrite([H|T]) :- revwrite(T), write('->'), write(H).