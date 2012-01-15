require "forwardable"

module WSModel

  class Links
    
    attr_reader :links_set # TODO remove, only used for a puts

    def initialize
      @links_set = Set.new
    end

    def add_between(node, other_node)
      @links_set << link(node, other_node)
    end

    def exists_between?(node, other_node)
      @links_set.include? link(node, other_node)
    end

    def remove_between(node, other_node)
      @links_set.delete link(node, other_node)
    end

    private

    def link(node, other_node)
      Set.new [node, other_node] 
    end

  end

end
