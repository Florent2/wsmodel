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

c0 = WSModel::Network.new(0, 1000, 10).clustering_coefficient

beta_values= [0.0001, 0.001, 0.01, 0.1, 0.2, 0.5]
beta_values.each do |beta|
  coeffs = []
  20.times do |i|
    coeffs[i] = WSModel::Network.new(beta, 1000, 10).clustering_coefficient
  end
  clustering_coefficient = coeffs.inject{ |sum, val| sum + val } / coeffs.size
  puts "C(#{beta}) / C(0) = " + (clustering_coefficient / c0).to_s
end
#c0dot01 = WSModel::Network.new(0.01, 1000, 10).clustering_coefficient
#c0dot1  = WSModel::Network.new(0.1, 1000, 10).clustering_coefficient

#puts "C(0.01) / C(0) = " + (c0dot01 / c0).to_s
#puts "C(0.1)  / C(0) = " + (c0dot1 / c0).to_s
