require "minitest/autorun"
require_relative "../../lib/wsmodel"

describe WSModel::Network do

  describe "#local_clustering_coeff" do

    it "is 1 if all neighbours are linked" do
      # we create this network: 0 <=> 1 <=> 2 <=> 0
      network = WSModel::Network.new 0, 3, 2  
      # coeff must be 1 because node 0 neighbours (1, 2) are linked
      network.local_clustering_coeff(0).must_equal 1
    end

    it "is 0 if no neighbours are linked" do
      # we create this network: 0 <=> 1 <=> 2 <=> 3 <=> 4
      network = WSModel::Network.new 0, 4, 2  
      # coeff must be 0 because node 0 neighbours (1, 2) are not linked
      network.local_clustering_coeff(0).must_equal 0
    end

    it "is 0.33 if only a third of the neighbour are connected" do
      network = WSModel::Network.new 0, 4, 2
      # we rebuild the links to create the 2nd network of
      # http://upload.wikimedia.org/wikipedia/commons/thumb/0/0f/Clustering_coefficient_example.svg/142px-Clustering_coefficient_example.svg.png
      # we 0 is the blue node, 1 is the bottom node, 2 is the right node and 3
      # the top node
      network.instance_variable_set :@links, [
        Set.new([1, 2, 3]),
        Set.new([0, 2]),
        Set.new([0, 1, 3]),
        Set.new([0])
      ]
      network.local_clustering_coeff(0).must_be_within_delta 0.33, 0.004
    end
  end
end

