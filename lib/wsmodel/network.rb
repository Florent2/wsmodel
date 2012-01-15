require "set"

module WSModel

  class Network

    def initialize(beta=0.5, nodes_nb=1000, node_degree=10)
      @beta        = beta
      @node_degree = node_degree
      @nodes       = Nodes.new nodes_nb
      @links       = Links.new

      build_initial_links
      puts @links.links_set.size
      rewire_links
      puts @links.links_set.size
    end

    def average_path_length
    end

    def clustering_coefficient
    end

    private

    def build_initial_links
      @nodes.each do |node|
        (@node_degree / 2).times do |i|
          @links.add_between node, @nodes.neighbour_of(node, i + 1)
        end
      end
    end

    def rewire_links
      (@node_degree / 2).times do |i|
        @nodes.each do |node|
          if rand < @beta
            neighbour = @nodes.neighbour_of node, i + 1
            @links.remove_between node, neighbour

            already_linked = @nodes.select { |other| @links.exists_between? \
              node, other }
            new_linked = @nodes.random_except [node, neighbour] + already_linked
            @links.add_between node, new_linked
          end
        end
      end
    end

  end

end
