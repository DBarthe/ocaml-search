
type 'a node = {
  state : 'a ;
  cost : int ;
}

type 'a problem = {
  initial_state : 'a ;
  is_goal : 'a -> bool ;
  expand : 'a node -> 'a node list ;
}

type ('a, 'b) strategy = {
  initial_frange : 'b PriorityQueue.t ;
  push : 'b PriorityQueue.t -> 'a node -> 'b PriorityQueue.t ;
  pop : 'b PriorityQueue.t -> ('b PriorityQueue.t * 'a node) ;
}

type 'a result = Failure | Solution of 'a node

let tree_search strategy problem =

  let rec child_nodes_loop frange = function
  | [] -> frange_loop frange
  | node::nodes ->
    let frange = strategy.push frange node in
    child_nodes_loop frange nodes

  and frange_loop frange =
    if PriorityQueue.is_empty frange then
      Failure
    else
      let (frange, node) = strategy.pop frange in
      if problem.is_goal node.state then
        Solution node
      else
        let child_nodes = problem.expand node in
        child_nodes_loop frange child_nodes

  in frange_loop strategy.initial_frange

