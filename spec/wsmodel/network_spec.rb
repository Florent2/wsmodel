require "minitest/autorun"
require_relative "../../lib/wsmodel"

describe WSModel::Network do

  describe "#clustering_coefficient" do

    it "is 1 when all neighbours of every node are linked" do
      # we create this network: 0 <=> 1 <=> 2 <=> 0
      network = WSModel::Network.new 0, 3, 2  
      network.clustering_coefficient.must_equal 1
    end

    it "is 0 when no neighbours are linked" do
      # we create this network: 0 <=> 1 <=> 2 <=> 3 <=> 4
      network = WSModel::Network.new 0, 4, 2  
      network.clustering_coefficient.must_equal 0
    end

    it "is 0.5833 for this specific network" do
      network = WSModel::Network.new 0, 4, 2
      # we rebuild the links to create the 2nd network of
      # http://upload.wikimedia.org/wikipedia/commons/thumb/0/0f/Clustering_coefficient_example.svg/142px-Clustering_coefficient_example.svg.png
      # we 0 is the blue node, 1 is the bottom node, 2 is the right node and 3
      # the top node
      network.instance_variable_set :@neighbours, [
        Set.new([1, 2, 3]),
        Set.new([0, 2]),
        Set.new([0, 1]),
        Set.new([0])
      ]
      # node 0 has a coeff of 0.33
      # node 1 has a coeff of 1
      # node 2 has a coeff of 1
      # node 3 has a coeff of 0
      network.clustering_coefficient.must_be_within_delta 0.5833, 0.00004
    end

  end

  describe "#local_clustering_coeff" do

    it "is 1 when all neighbours are linked" do
      # we create this network: 0 <=> 1 <=> 2 <=> 0
      network = WSModel::Network.new 0, 3, 2  
      # coeff must be 1 because node 0 neighbours (1, 2) are linked
      network.local_clustering_coeff(0).must_equal 1
    end

    it "is 0 when no neighbours are linked" do
      # we create this network: 0 <=> 1 <=> 2 <=> 3 <=> 4
      network = WSModel::Network.new 0, 4, 2  
      # coeff must be 0 because node 0 neighbours (1, 2) are not linked
      network.local_clustering_coeff(0).must_equal 0
    end

    describe "for this specific network" do

      before do
        @network = WSModel::Network.new 0, 4, 2
        # we rebuild the links to create the 2nd network of
        # http://upload.wikimedia.org/wikipedia/commons/thumb/0/0f/Clustering_coefficient_example.svg/142px-Clustering_coefficient_example.svg.png
        # we 0 is the blue node, 1 is the bottom node, 2 is the right node 
        # and 3 the top node
        @network.instance_variable_set :@neighbours, [
          Set.new([1, 2, 3]),
          Set.new([0, 2]),
          Set.new([0, 1]),
          Set.new([0])
        ]
      end

      it "is 0.33 when only a third of the neighbours are linked" do
        @network.local_clustering_coeff(0).must_be_within_delta 0.33, 0.004
      end

      it "is 0 when there is only one neighbour" do
        @network.local_clustering_coeff(3).must_equal 0.0
      end

    end

  end

  describe "shortest_path_length" do

    before do
      @network = WSModel::Network.new 0, 9, 1
      @network.instance_variable_set :@neighbours, [
        Set.new([1, 2]),
        Set.new([0, 3]),
        Set.new([0, 5, 4]),
        Set.new([1, 5]),
        Set.new([2, 5, 6]),
        Set.new([2, 3, 4]),
        Set.new([4]),
        Set.new([8]),
        Set.new([7])
      ]
    end

    it {
      @network.shortest_path_length(1, 4).must_equal 3 
      #@network.shortest_path_length(1, 5).must_equal 2 
      #@network.shortest_path_length(1, 6).must_equal 4 
      #@network.shortest_path_length(6, 1).must_equal 4 
      #@network.shortest_path_length(7, 1).must_equal 0 
    }
  end

end

