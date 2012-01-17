module WSModel

  # To run the experimentation of figure 2 of 
  # http://tam.cornell.edu/tam/cms/manage/upload/SS_nature_smallworld.pdf
  class Experiment

    def initialize(nodes_nb=1000, node_degree=10, iterations=20)
      @nodes_nb     = 1000
      @node_degree  = 10
      @iterations   = 20
    end

    def run
      c0 ||= WSModel::Network.new(0, 1000, 10).clustering_coefficient
      beta_values = [0.0001, 0.001, 0.01, 0.1, 0.2, 0.5]

      beta_values.each do |beta|
        coeffs = []
        @iterations.times do |i|
          coeffs[i] = WSModel::Network.new(beta, @nodes_nb, @node_degree).\
clustering_coefficient
        end
        clustering_coeff = coeffs.inject{ |sum, val| sum + val } / coeffs.size
        puts "C(#{beta}) / C(0) = " + (clustering_coeff / c0).to_s
      end
    end

  end
end
