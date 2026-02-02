---- MODULE bfs ----
\* A TLA+ Module traversal the state space of bfs algorithm described in CLRS
\* - Cormen, Thomas H, et al. Introduction To Algorithms. India, MIT Press, 2001.
EXTENDS TLC, Integers, Sequences

Vertices == 1..8
\* The [key |-> val] syntax is for Record definitions only.
\* To define a Function with arbitrary keys (like Integers),
\* use the :> and @@ operators from the TLC module
\* - https://github.com/tlaplus/tlaplus/blob/master/tlatools/org.lamport.tlatools/src/tla2sany/StandardModules/TLC.tla
Adj == 
    (1 :> {2, 5}) @@
    (2 :> {1, 6}) @@
    (3 :> {4, 6, 7}) @@
    (4 :> {3, 7, 8}) @@
    (5 :> {1}) @@
    (6 :> {2, 3, 7}) @@
    (7 :> {3, 4, 6}) @@
    (8 :> {4, 7})

CONSTANT s
ASSUME s \in Vertices
VARIABLES color, queue

Init ==
    /\ queue = <<s>>
    /\ color = [v \in Vertices |-> IF v = s THEN "GRAY" ELSE "WHITE"]

\* Auxiliary function convert set into sequence
\* - https://groups.google.com/g/tlaplus/c/d1UnxjNaYYc
\* WARNING: It 's not recommended to do this
\* - https://groups.google.com/g/tlaplus/c/hGET5zebLNI/m/7sE5fnGOBgAJ
RECURSIVE SeqFromSet(_)
SeqFromSet(S) == 
  IF S = {} THEN << >> 
  ELSE LET x == CHOOSE x \in S : TRUE
       IN  << x >> \o SeqFromSet(S \ {x})

WhiteNeighbors(v) == {u \in Adj[v] : color[u] = "WHITE"}
Next ==
    /\ queue /= <<>>
    /\ LET u == Head(queue)
           W == WhiteNeighbors(u)
       IN
           /\ color' = [color EXCEPT ![u] = "BLACK"] @@ [v \in W |-> "GRAY"]
           /\ queue' = Tail(queue) \o SeqFromSet(W)

====