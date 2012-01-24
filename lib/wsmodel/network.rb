require "set"

module WSModel

  class Network

    def initialize(beta=0.5, nodes_nb=1000, node_degree=10)
      @beta        = beta
      @node_degree = node_degree
      @nodes_nb    = nodes_nb
      # a node is just represented by an index: 0, 1, 2...
      @nodes       = 0..(nodes_nb -1) 
      # @neighbours array indexes are the node indexes
      # the values are sets of indexes of the neighbour nodes
      # for example if the node 0 is linked to the nodes 2 and 4:
      # @neighbours[0] = Set.new [2, 4]
      @neighbours       = Array.new(nodes_nb) { Set.new }

      build_initial_links
      rewire_links
    end

    # see "Calculation of the average path length" in the README
    def average_path_length
      shortest_path_lengths_sum = 0

      @nodes.each do |from_node|
        @nodes.each do |to_node|
          shortest_path_lengths_sum += shortest_path_length from_node, to_node
        end
      end

      shortest_path_lengths_sum / (@nodes_nb * (@nodes_nb - 1))
    end

    # see "Calculation of the clustering coefficient" in the README
    def clustering_coefficient
      @nodes.inject(0.0) do |sum, node| 
        sum += local_clustering_coeff node
      end / @nodes_nb
    end

    def local_clustering_coeff(node)
      neighbours = @neighbours[node]
      return 0.0 if neighbours.size < 2

      possible_links_nb = neighbours.size * (neighbours.size - 1) / 2

      actual_links_nb = 0
      neighbours.each do |neighbour|
        actual_links_nb += (@neighbours[neighbour] & neighbours).size
      end
      # we have counted twice each link (x => y and y => x)
      # so we need to divide the total by 2
      actual_links_nb = actual_links_nb / 2

      actual_links_nb.to_f / possible_links_nb
    end


    # see "Calculation of the average path length" in the README
    def shortest_path_length(from_node, to_node)
      lengths = Array.new(@nodes_nb, Float::INFINITY)
      lengths[from_node] = 0
      
      queue = [from_node]
      while queue.any? do
        examined_node = queue.shift
        length        = lengths[examined_node]

        if examined_node == to_node
          return length 
        end

        @neighbours[examined_node].select do |neighbour| 
          if lengths[neighbour] == Float::INFINITY
            queue << neighbour 
            lengths[neighbour] = length + 1
          end
        end
      end

      # we arrive here when we could not find a path
      # in this case by definition the path length is 0
      0
    end

    def to_s
      @neighbours.each_with_index do |neighbours, node|
        puts node.to_s + " => " + neighbours.to_a.join(", ")
      end
    end

    private
    
    def add_link_between(node, other_node)
      @neighbours[node] << other_node
      @neighbours[other_node] << node
    end

    def build_initial_links
      @nodes.each do |node|
        (@node_degree / 2).times do |i|
          add_link_between node, (node + i + 1) % @nodes_nb
        end
      end
    end

    # this method calculates the path length between from_node and to_node
    # by going back from from_node to to_node through the visited nodes
    def path_length(from_node, to_node, visited_nodes)
      if from_node == to_node
       0
      else
        next_to_last_node = (@neighbours[to_node] & visited_nodes).first
        visited_nodes.delete to_node
        1 + path_length(from_node, next_to_last_node, visited_nodes)
      end
    end

    def remove_link_between(node, other_node)
      @neighbours[node].delete other_node
      @neighbours[other_node].delete node
    end

    def rewire_links
      (@node_degree / 2).times do |i|
        @nodes.each do |node|
          if rand < @beta
            neighbour = (node + i + 1) % @nodes_nb
            remove_link_between node, neighbour

            unlinkable_nodes = [node, neighbour] + @neighbours[node].to_a
            new_neighbour    = (@nodes.to_a - unlinkable_nodes).sample
            add_link_between node, new_neighbour
          end
        end
      end
    end

  end

end
