(**
  Functional and generic search algorithms.

  @author Barthelemy Delemotte
*)

(* the node type used during search, and to communicate with user *)
type 'a node = {
  state : 'a ;
  cost : int ;
  depth: int ;
}

(* a record that stores problem-specific data *)
type 'a problem = {
  initial_state : 'a ;
  is_goal : 'a -> bool ;
  expand : 'a node -> 'a node list ;
}

(* a strategy defines the behavior of the search algorithm, which is generic *)
type ('a, 'b) strategy = {
  initial_frange : 'b PriorityQueue.t ;
  push : 'b PriorityQueue.t -> 'a node -> 'b PriorityQueue.t ;
  pop : 'b PriorityQueue.t -> ('b PriorityQueue.t * 'a node) ;
}

(* the return of the search *)
type 'a result = Failure | Solution of 'a node

(* node construcotr and accessors *)
let _create_node ?(depth=0) state cost  =
  { state; cost; depth }
let create_node state cost = 
    _create_node state cost

let node_state node = node.state
let node_cost node = node.cost
let node_depth node = node.depth

(* problem construtor *)
let create_problem ~initial_state ~is_goal ~expand =
  { initial_state; is_goal; expand; }

(* the main algorithm for tree searh *)
let tree_search strategy problem =

  let rec child_nodes_loop depth frange = function
  | [] -> frange_loop frange
  | node::nodes ->
    let node = { node with depth } in
    let frange = strategy.push frange node in
    child_nodes_loop depth frange nodes

  and frange_loop frange =
    if PriorityQueue.is_empty frange then
      Failure
    else
      let (frange, node) = strategy.pop frange in
      if problem.is_goal node.state then
        Solution node
      else
        let child_nodes = problem.expand node
        and child_depth = (node_depth node) + 1 in
        child_nodes_loop child_depth frange child_nodes in

  let first_node = _create_node problem.initial_state 0 ~depth:0 in
  let frange = strategy.push strategy.initial_frange first_node in
  frange_loop frange

(* strategy template, with common push and pop *)
let create_common_strategy compare_fun =
  let initial_frange = PriorityQueue.create compare_fun
  and push = PriorityQueue.push
  and pop frange =
    let node = PriorityQueue.top frange in
    (PriorityQueue.pop frange, node)
  in {
    initial_frange ; push ; pop
  }

(* several strategies *)

let depth_first_strategy () =
  let compare_fun node1 node2 =
    Pervasives.compare (node_depth node2) (node_depth node1)
  in create_common_strategy compare_fun

let breadth_first_strategy () =
  let compare_fun node1 node2 = 
    Pervasives.compare (node_depth node1) (node_depth node2)
  in create_common_strategy compare_fun

let uniform_strategy () =
  let compare_fun node1 node2 =
    Pervasives.compare node1.cost node2.cost
  in create_common_strategy compare_fun

let a_star_strategy heuristic_fun =
  let initial_frange = PriorityQueue.create (
    fun (sum1, _) (sum2, _) -> Pervasives.compare sum1 sum2 )
  and push frange node =
    let h = heuristic_fun (node_state node) in
    let sum = h + (node_cost node) in
    PriorityQueue.push frange (sum, node)
  and pop frange =
    let (_, node) = PriorityQueue.top frange in
    (PriorityQueue.pop frange, node)
  in {
    initial_frange ; push ; pop
  }
