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
          if from_node < to_node # to avoid calculating for both x=>y and y=>x
            shortest_path_lengths_sum += shortest_path_length from_node, to_node
          end
        end
      end

      2.0 * shortest_path_lengths_sum / (@nodes_nb * (@nodes_nb - 1))
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

    # TODO delete
    def puts_paths
      puts "Current values of @paths:"
      puts "---"
      @paths.each do |value, key|
        puts " @paths[#{value}] = #{key}"
      end
      puts "---"
    end

    # see "Calculation of the average path length" in the README
    def shortest_path_length(from_node, to_node)
      @paths ||= Hash.new

      if !@paths[[from_node, to_node]].nil?
        return @paths[[from_node, to_node]].length
      end

      @paths[[from_node, from_node]] = []
      visited_nodes                  = [from_node]
      queue                          = [from_node]

      while queue.any? do
        visiting_node = queue.shift

        @neighbours[visiting_node].select do |neighbour| 
          unless visited_nodes.include?(neighbour)
            @paths[[from_node, neighbour]] = @paths[[from_node, visiting_node]] + 
              [neighbour]

            if neighbour == to_node
              return @paths[[from_node,to_node]].length
            else
              visited_nodes << neighbour
              queue         << neighbour 
            end
          end
        end
      end

      # we arrive here when we could not find a path between from_node and to_node
      # in this case by definition the path length is 0
      0
    end

    def print_to_console
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
