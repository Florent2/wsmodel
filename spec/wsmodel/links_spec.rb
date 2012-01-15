require "minitest/autorun"
require_relative "../../lib/wsmodel"

describe WSModel::Links do

  before do
    @links = WSModel::Links.new
  end

  it "add_between? adds a new link" do
    @links.add_between 1, 2 
    @links.exists_between?(1, 2).must_equal true
  end

  it "remove_between? removes an existing link" do
    @links.add_between 1, 2 
    @links.remove_between 1, 2 
    @links.exists_between?(1, 2).must_equal false
  end

end

 
