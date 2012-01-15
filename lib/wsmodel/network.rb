require "set"

module WSModel

  class Network

    def initialize(beta=0.5, nodes_nb=1000, node_degree=10)
      @beta        = beta
      @node_degree = node_degree
      @nodes_nb    = nodes_nb
      @nodes       = 0..(nodes_nb -1)
      @links       = Array.new(nodes_nb) { Set.new }

      build_initial_links
      rewire_links
    end

    def average_path_length
    end

    def clustering_coefficient
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
