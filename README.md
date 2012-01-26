Watts-Strogatz model network generator
===

A Ruby command-line utility to generate
[Watts-Strogatz model](http://en.wikipedia.org/wiki/Watts_and_Strogatz_model)
networks defining input parameters (number of nodes, beta parameter) and
collecting output parameters (average path length, the clustering coefficient).

Usage
---

Require Ruby 1.9+.

Run `ruby -Ilib bin/wsmodel <node_number> <node_degree> <iteration_nb>`

It performs the experiment of the 
[Collective dynamics of 'small-world' network](http://tam.cornell.edu/tam/cms/manage/upload/SS_nature_smallworld.pdf) 
article (Figure 2) and outputs the resulting average path lengths
and clustering coefficients.

`node_number` indicates the number of nodes of the network to be
constructed, `node_degree` the number of links per node and
`iterations_nb` the number of times a network is rebuilt with the same
parameters.

They are all optional parameters, their default values are respectively 
1000, 10 and 20 as in the article experiment.

Running tests
---

Run `ruby spec/suite.rb`

Terminology
---

Various concepts can be named by different equivalent words in the
various sources mentioned here.

* node = vertice
* link = edge, connection
* node degree *k* = number of links per node
* parameter *beta* = probability *p*
* characteristic path length = average path length
 
Background
---

Main Sources:
* [the Wikipedia page](http://en.wikipedia.org/wiki/Watts_and_Strogatz_model)
* [the Six Degrees book](http://books.wwnorton.com/books/Six-Degrees/)
* the [Collective dynamics of 'small-world' network](http://tam.cornell.edu/tam/cms/manage/upload/SS_nature_smallworld.pdf) 
article

Watts and Strogatz published their network model in 1998. They intended to 
create the simplest model that can produce graphs with 
[small-world properties](http://en.wikipedia.org/wiki/Small-world_network).

Small-worlds network are graphs in which most nodes are not neighbors of one 
another, but most nodes can be reached from every other by a small number of 
hops or steps.

It is translated in graph theory by two main properties:

1. a large *[clustering coefficient](http://en.wikipedia.org/wiki/Clustering_coefficient)*: 
the nodes in the graph tends to cluster together
2. a low *[average path length](http://en.wikipedia.org/wiki/Average_path_length)*: 
two nodes can be joined in a few steps

A classical example of small-world network is the graph of human
relationships, where two complete strangers can be linked through a chain of 
few acquaintances. There are many other 
[examples of small-world network](http://en.wikipedia.org/wiki/Small-world_network#Examples_of_small-world_networks).

The Watts-Strogatz model network construction
---

It is built on a ring lattice, basically it means that the network nodes 
are arranged along a circle. It is a useful topology because it allows to 
start from a clean ordered network, where initially each node is connected 
to its neighbours.

From this initial lattice the network is built by injecting some
tunable randomness in the node connections. For that the links are 
randomly rewired.

How? Each link in the lattice is visited and is randomly rewired with
some probability. This probability is the parameter *beta*. For instance
a link from node A to B has a beta probability to be rewired from A to
another random node Bnew in the lattice.

![Construction of a Watts-Strogratz model network](https://github.com/Florent2/Watts-Strogatz-model-network-generator/raw/master/assets/images/construction-of-the-model.png)

When beta is 0 the lattice remains unchanged. When beta is 1 all links
are rewired, generating a full random network. In the middle the network
is partly ordered and partly random.

Here is the exact rewiring algorithm described in
[Collective dynamics of 'small-world' network](http://tam.cornell.edu/tam/cms/manage/upload/SS_nature_smallworld.pdf),
legend of figure 1:

Note first that:

* vertex = node
* edge = link
* probability p = probability beta

"We choose a vertex and the edge that connects it to its nearest neighbour in a
clockwise sense. With probability p, we reconnect this edge to a vertex chosen
uniformly at random over the entire ring, with duplicate edges forbidden; 
otherwise we leave the edge in place. We repeat this process by moving clockwise
around the ring, considering each vertex in turn until one lap is completed. Next,
we consider the edges that connect vertices to their second-nearest neighbours
clockwise. As before, we randomly rewire each of these edges with probability p,
and continue this process, circulating around the ring and proceeding outward to
more distant neighbours after each lap, until each edge in the original lattice has
been considered once. (As there are nk/2 edges in the entire graph, the rewiring
process stops after k/2 laps.)"

Interest of the Watts-Strogatz model
---

Networks generated by this simple model exhibit small-world properties,
i.e. a large clustering coefficient and a low average path length.

We can calculate those values based on the possible values of the input
parameter beta, and thus see which range of beta values produces small-world 
networks.

The model shows also that small-world networks can arise from a very simple
compromise between very basic forces - order & disorder - and not from
the specific mechanisms by which that compromise brokered (the link
rewiring in the model is a random process, it does not follow some rules).

Exact results obtained by Watts and Strogatz
---

They will serve as the reference to check the correctness and appropriate use 
of the my implementation.

The values of the clustering coefficient and the average path length based on the
beta parameter are presented and detailed on the figure 2 of the article
[Collective dynamics of 'small-world'
network](http://tam.cornell.edu/tam/cms/manage/upload/SS_nature_smallworld.pdf).
 
Calculation of the clustering coefficient
---

From the ["clustering coefficient"](http://en.wikipedia.org/wiki/Clustering_coefficient) 
Wikipedia page.

We want to calculate the "Network average clustering coefficient". It is the 
average of the local clustering coefficients of all the nodes.

The local clustering coefficient of a node is the proportion of links between 
the nodes within its neighbourhood divided by the number of links that could 
possibly exist between them (the neighbourhoud of a node is the set of
all the nodes linked to this node).

We can say that the local clustering coefficient of a node is the 
*interconnectedness* of its neighbours. See [an example with the public
transport network of Turkey](http://www.few.vu.nl/~dvdberg/swn/swn.html)

From Wikipedia:

![Local clustering coefficient of the blue node in different graphs](http://upload.wikimedia.org/wikipedia/commons/thumb/0/0f/Clustering_coefficient_example.svg/220px-Clustering_coefficient_example.svg.png)

"The local clustering coefficient of the light blue node is computed as the 
proportion of connections among its neighbors which are actually realized 
compared with the number of all possible connections. In the figure, the 
light blue node has three neighbours, which can have a maximum of 3 
connections among them. In the top part of the figure all three possible 
connections are realised (thick black segments), giving a local clustering 
coefficient of 1. In the middle part of the figure only one connection is 
realised (thick black line) and 2 connections are missing (dotted red lines), 
giving a local cluster coefficient of 1/3. Finally, none of the possible 
connections among the neighbours of the light blue node are realised, 
producing a local clustering coefficient value of 0."

Calculation of the average path length
---

From the ["average path length"](http://en.wikipedia.org/wiki/Average_path_length)
Wikipedia page.

It is defined as the average number of steps along the shortest paths for all 
possible pairs of network nodes. It is a measure of the efficiency of 
information or mass transport on a network.

Basically the algorithm is:

1. for each possible pair of nodes, calculate the shortest path length between 
them
2. calculate the average of those shortest paths

To calculate the shortest path between two nodes A and B, we can use a 
[Breadth-first search](http://en.wikipedia.org/wiki/Breadth-first_search) where
the starting node is A and the goal node is B. As the search is done through 
the successive "layers" of neighbours of node A, the first time we found the 
node B we know we found it through the shortest possible path. 
