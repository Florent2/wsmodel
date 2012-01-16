#!/usr/bin/env ruby

require_relative "../lib/wsmodel"

# This a random network (because the first parameter is 1)
# with the characteristics of the neural network of the 
# nematode worm C. elegans (node number = 282 and degree = 14)
# We found similar result than in the paper
# http://tam.cornell.edu/tam/cms/manage/upload/SS_nature_smallworld.pdf
# table 1, Crandom

network = WSModel::Network.new 1, 282, 14
puts "Clustering coefficient 'on random C elegans neural network' = " + network.clustering_coefficient.to_s


# http://tam.cornell.edu/tam/cms/manage/upload/SS_nature_smallworld.pdf
# reproduction of the figure 2 results

l0      = WSModel::Network.new(0, 1000, 10).clustering_coefficient
l0dot01 = WSModel::Network.new(0.01, 1000, 10).clustering_coefficient
l0dot1  = WSModel::Network.new(0.1, 1000, 10).clustering_coefficient

puts "L(0.01) / L(0) = " + (l0dot01 / l0).to_s
puts "L(0.1)  / L(0) = " + (l0dot1 / l0).to_s
