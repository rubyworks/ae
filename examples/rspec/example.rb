require 'ae/adapters/rspec'

describe "AE RSpec Support" do

  it "handles passing assert" do
    x = 5
    y = 5
    x.assert == y
  end

  it "handles failing assert" do
    x = 5
    y = 6
    x.assert == y
  end

end
