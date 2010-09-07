feature "Assertion Counts" do

  #"AE tracks the number of assertions made and the number that",
  #"failed to pass." do

  require 'ae'

  scenario "count assertions" do
    before do
      ::Assertion.recount
    end

    to do |pass|
      begin
        assert(pass)
      rescue ::Assertion
      end
      ::Assertion.count
    end

    ok true  => 1
    ok true  => 2
    ok true  => 3
    ok false => 4
    ok false => 5
    ok false => 6
  end


  scenario "count failures" do
    before do
      ::Assertion.recount
    end

    to do |pass|
      begin
        assert(pass)
      rescue ::Assertion
      end
      ::Assertion.fails
    end

    ok true  => 0
    ok true  => 0
    ok true  => 0
    ok false => 1
    ok false => 2
    ok false => 3
  end

end

