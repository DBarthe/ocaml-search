(**
  Functional and generic search algorithms.

  @author Barthelemy Delemotte
*)

(** {2 Types } *)

(** The next types have all a type parameter ['a] which is user defined
    and stands for a state. *)

(** [node] is the type used during searches for trees and graphs.
    It contains the state, the cost and the depth of a node. *)
type 'a node

(** [problem] is a collection of problem-specific data. It is used
    to specialize the search algorithms which are generics. *)
type 'a problem

(** [strategy] is a collection of data which define the behavior of the search.
    That means: in which order the nodes are expanded. *)
type ('a, 'b) strategy 

(** [result] is the type of the value returned by the search functions. *)
type 'a result = Failure | Solution of 'a node

(** {2 User interface for data manipulation } *)

(** [create_problem ~initial_state ~is_goal ~expand] creates a [problem] with
    given data :
      - [initial_state] is where the search should start.
      - [is_goal state] is a function that takes a [state] and returns true
        if this state is a goal. 
      - [expand node] is a function that expands a [node] by returning a list
        of all reachable nodes from it. *)
val create_problem : initial_state:'a
  -> is_goal:('a -> bool)
  -> expand:('a node -> 'a node list)
  -> 'a problem

(** [create_node state cost] creates a [node] with [state] and [cost]. The depth
    has not to be defined by the user. *)
val create_node : 'a -> int -> 'a node

(** [node_state node] returns the state of [node]. *)
val node_state : 'a node -> 'a

(** [node_cost node] returns the cost of [node]. *)
val node_cost : 'a node -> int

(** [node_depth node] returns the depth of [node]. *)
val node_depth : 'a node -> int


(** {2 Generics Searches } *)

(** [tree_search strategy problem] is the main function for tree search.
    It is a generic function that has to be specialized in some ways.
    It takes a [strategy] to define the kind of exploration (A* for example);
    and a [problem] which makes the search problem-specific. *)
val tree_search : ('a, 'b) strategy -> 'a problem -> 'a result

(** {2 Strategies } *)

(** [depth_first strategy ()] returns a strategy which expands nodes
    in depth as priority. It digs until finding a solution or a leaf, then
    it terminates or backtracks. *)
val depth_first_strategy : unit -> ('a, 'a node) strategy

(** [breadth_first_strategy ()] returns a strategy which expands nodes in 
    a homogeneous fashion compared to their depth. If a solution is found, 
    it is one of the shallowest. *)
val breadth_first_strategy : unit -> ('a, 'a node) strategy

(** [uniform_strategy ()] returns a strategy wihch expands nodes with the
    lower cost first. The solution, if there is, is assured to be an optimal.
    However, the number of nodes expanded is large. *)
val uniform_strategy : unit -> ('a, 'a node) strategy

(** [a_star_strategy heuristic_fun] returns a strategy which pairs up the cost
    and the heuristic to choose which nodes to expands.
    Note: the heuristic value is an estimation of the real cost from a state
    until the goal.
    The result depends on the [heuristic_fun]. If the heuristic is "admissible",
    that means it doesn't overevaluate the real cost, the solution will be
    optimal in tree searches. If the heuritic is "consistent", that means it is
    admissible and coherent between all states, the solution will be optimal in
    graph searches. *)
val a_star_strategy : ('a -> int) -> ('a, int * 'a node) strategy
