module WSModel

  # To run the experimentation of figure 2 of 
  # http://tam.cornell.edu/tam/cms/manage/upload/SS_nature_smallworld.pdf
  class Experiment

    BETA_VALUES = [0.0001, 0.001, 0.01, 0.1, 0.2, 0.5]

    def initialize(params)
      @nodes_nb     = (params[:nodes_nb]    || 1000).to_i
      @node_degree  = (params[:node_degree] ||   10).to_i
      @iterations   = (params[:iterations]  ||   20).to_i
    end

    def run
      puts "Running experiment on #{@iterations} iterations for " +
          "#{@nodes_nb} nodes with #{@node_degree} degree..."

      non_random_network = WSModel::Network.new(0, @nodes_nb, @node_degree)
      c0 = non_random_network.clustering_coefficient
      l0 = non_random_network.average_path_length

      BETA_VALUES.each do |beta|
        puts "Iterating for beta = #{beta}..."
        coeffs  = []
        lengths = []
        @iterations.times do |i|
          beta_network = WSModel::Network.new(beta, @nodes_nb, @node_degree)
          coeffs[i]    = beta_network.clustering_coefficient
          lengths[i]   = beta_network.average_path_length
        end
        clustering_coeff = coeffs.inject{ |sum, val| sum + val } / @iterations
        puts "C(#{beta}) / C(0) = " + (clustering_coeff / c0).to_s

        average_length  = lengths.inject{ |sum, val| sum + val } / @iterations
        puts "L(#{beta}) / L(0) = " + (average_length / l0).to_s
      end


    end

  end
end
