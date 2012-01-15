require "forwardable"

module WSModel

  class Nodes
    extend Forwardable

    def initialize(nodes_nb)
      @nodes_array = Array.new(nodes_nb) { |i| Node.new i }
    end

    def_delegators :@nodes_array, :each, :first, :last, :select

    def neighbour_of(node, rank)
      @nodes_array[(node.index + rank) % @nodes_array.size]
    end

    def random_except(exceptions)
      (@nodes_array - exceptions).sample
    end

  end
end
