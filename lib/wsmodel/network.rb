require "set"

module WSModel

  class Network

    def initialize(beta=0.5, nodes_nb=1000, node_degree=10)
      @beta        = beta
      @node_degree = node_degree
      @nodes_nb    = nodes_nb
      # a node is just represented by an index: 0, 1, 2...
      @nodes       = 0..(nodes_nb -1) 
      # @links array indexes are the node indexes, the values are sets of
      # indexes of the linked nodes
      # for example if the node 0 is linked to the nodes 2 and 4
      # @links[0] = Set.new [2, 4]
      @links       = Array.new(nodes_nb) { Set.new }

      build_initial_links
      rewire_links
    end

    def average_path_length
    end

    # see "Calculation of the clustering coefficient" in the README
    def clustering_coefficient
      local_clustering_coeff_sum = 0.0
      @nodes.each do |node| 
        local_clustering_coeff_sum += local_clustering_coeff node
      end

      local_clustering_coeff_sum / @nodes_nb
    end

    def local_clustering_coeff(node)
      neighbours = @links[node]
      return 0.0 if neighbours.size < 2

      possible_links_nb = neighbours.size * (neighbours.size - 1) / 2

      actual_links_nb = 0
      neighbours.each do |neighbour|
        actual_links_nb += (@links[neighbour] & neighbours).size
      end
      # we have counted twice each link (x => y and y => x)
      # so we need to divide the total by 2
      actual_links_nb = actual_links_nb / 2

      actual_links_nb.to_f / possible_links_nb
    end

    def to_s
      @links.each_with_index do |links, node|
        puts node.to_s + " => " + links.to_a.join(", ")
      end
    end

    private
    
    def add_link_between(node, other_node)
      @links[node] << other_node
      @links[other_node] << node
    end

    def build_initial_links
      @nodes.each do |node|
        (@node_degree / 2).times do |i|
          add_link_between node, (node + i + 1) % @nodes_nb
        end
      end
    end

    def remove_link_between(node, other_node)
      @links[node].delete other_node
      @links[other_node].delete node
    end

    def rewire_links
      (@node_degree / 2).times do |i|
        @nodes.each do |node|
          if rand < @beta
            neighbour = (node + i + 1) % @nodes_nb
            remove_link_between node, neighbour

            unlinkable_nodes = [node, neighbour] + @links[node].to_a
            new_neighbour    = (@nodes.to_a - unlinkable_nodes).sample
            add_link_between node, new_neighbour
          end
        end
      end
    end

  end

end
