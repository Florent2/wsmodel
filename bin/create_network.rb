#!/usr/bin/env ruby

require_relative "../lib/wsmodel"

network = WSModel::Network.new 1, 5000, 3

puts "Clustering coefficient = " + network.clustering_coefficient.to_s
