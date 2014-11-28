ocaml-search
============

This is an ocaml library that contains various and generics search algorithms.

It can be used for :

 * path finding
 * puzzle solving
 * robot decision
 * video game bot
 * ...

The search is configurable in several ways :

  * adaptation to a specific problem
  * two kind of search : graph or tree
  * different search strategies : depth-first, breadth-first, uniform or A*

### Compilation
```bash
$ git submodule init      # to fetch another library
$ git submodule update    # required by this one
$ make
```

### Usage
The full documenation is in ***doc/libsearch/html/***

##### 1 - Define problem specific type and value.
```ocaml
(* the type which represents the states *)
type state = ...

(* the initial state *)            
let initital_state = ...

(* a predicat that says 'true' when the goal is reached by the state *)
let is_goal state = ...

(* a function that expands a node into a list of node
  (see the documentation for the type 'node') *)
let expand node = ...

(* then, create a 'problem' value with the previous data *)
let problem = Search.create_problem initial_state is_goal expand

```

##### 2 - Choose a strategy
```ocaml
let strategy = Search.depth_first_strategy ()

(* You can also choose breadth-first, uniform, or A *)
```

##### 3 - Let's search !
```ocaml
let result = Search.tree_search strategy problem in

match result with
| Search.Failure       -> ... (* no solution *)
| Search.Solution node -> ... (* one solution in node *)

(*  There is two kind of search : tree and graph.
    In tree search, the same node can be expanded several times, from
    differents paths. *)
```