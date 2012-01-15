require "minitest/autorun"
require_relative "../../lib/wsmodel"

describe WSModel::Nodes do

  it "#random_except returns a random node different than the listed nodes" do
    @nodes = WSModel::Nodes.new 2
    @nodes.random_except(@nodes.first).must_equal @nodes.last
  end

end
