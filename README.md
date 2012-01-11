Watts-Strogatz model network generator
===

A Ruby command-line utility to generate
[Watts-Strogatz models](http://en.wikipedia.org/wiki/Watts_and_Strogatz_model)
defining input parameters (number of nodes, beta parameter) and
collecting output parameters (average path length, the clustering coefficient, 
and the degree distribution).

Background
---

(from Wikipedia and the 
[Six Degrees](http://books.wwnorton.com/books/Six-Degrees/) book)

Watts and Strogatz published this network model in 1998. They intended to 
create the simplest model that can produce graphs with 
[small-world properties](http://en.wikipedia.org/wiki/Small-world_network).

Small-worlds network are graphs in which most nodes are not neighbors of one 
another, but most nodes can be reached from every other by a small number of 
hops or steps.

It is translated in graph theory and topology by two main properties:

1. a large *[clustering coefficient](http://en.wikipedia.org/wiki/Clustering_coefficient)*: 
the nodes in the graph tends to cluster together
2. a low *[average path length](http://en.wikipedia.org/wiki/Average_path_length)*: 
two nodes can be joined in a few steps

A classical example of small-world network is the graph of human
relationships, where two complete strangers can be linked through a chain of 
few acquaintances. There are many other 
[examples of small-world network](http://en.wikipedia.org/wiki/Small-world_network#Examples_of_small-world_networks).

Watts-Strogatz model
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

![Construction of a Watts-Strogratz model network]()

When beta is 0 the lattice remains unchanged. When beta is 1 all links
are rewired, generating a full random network. In the middle the network
is partly ordered and partly random.
