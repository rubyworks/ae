module AE

  # The Ok mixin is a reusable assertion helper that
  # makes it easy to construct parameterized assertions
  # with an elegant syntax.
  #
  module Check

    # The Check::Proc class encapsulates a labeled procedure 
    # for making assertions using the `ok`/`no` methods.
    #
    class Proc
      # Setup new check procedure.
      def initialize(options={}, &check)
        @name    = options[:name]
        @message = options[:message] || @name
        @check   = check
      end

      #
      def message(&block)
        if block
          @message = message
        end
        @message
      end
    
      #
      def message=(msg)
        @message = msg
      end

      # Call check procedure.
      def call(*args)
        @check.call(*args)
      end

      #
      def to_s(*args)
        case @message
        when nil
          @name.to_s
        when ::Proc
          @message.call(*args)
        else
          # TODO: count %\S and apply `% args.map{|a|a.inspect}[0,count]`
          @message.to_s
        end
      end

      #
      def ok!(*args)
        assert(call(*args), to_s(*args))
      end

      #
      def no!(*args)
        refute(call(*args), to_s(*args))
      end
    end

    # TODO: Better way to customize error message so it can have
    # arguments in the messages ?

    # Built-in check procedures.
    TABLE = {
      :equality       => Check::Proc.new(:message=>"should be equal"){|h| h.any?{|a,b| b==a}},
      :case_equality  => Check::Proc.new(:message=>"should be equal"){|h| h.any?{|a,b| b===a}}
    }

    #
    def self.table
      @table ||= TABLE.dup
    end

    # Define a univerally available ok/no check.
    #
    #   AE::Check.define(:palindrome) do |x|
    #     x.reverse == x
    #   end
    #
    def self.define(name, &block)
      table[name] = Check::Proc.new(name, &block)
    end

    #
    def check_table
      Check.table
    end

    # Define an ok/no check procedure. A one-off procedure is defined
    # with a block.
    #
    #   check do |x, y|
    #     x == y
    #   end
    #
    #   ok 1,1
    #   no 1,2
    #
    # The check method can also be used to define reusable checks.
    #
    #   check(:palindrome) do |x|
    #     x.reverse == x
    #   end
    #
    # This will also cause the current check to be set.
    # Later in the code, the check procedure can be restored
    # by just passing the symbolic name.
    #
    #   check :palindrome
    #
    #   ok 'abracarba'
    #   no 'foolishness'
    #
    def check(name=nil, &block)
      if name
        if block
          check_table[name] = Check::Proc.new(:name=>name, &block)
        end
        @__check__ = check_table[name]
      else
        #raise ArgumentError if block.arity == 0
        @__check__ = Check::Proc.new(&block)
      end
    end

    #
    def ok(*args)
      __check__.ok!(*args)
    end

    #
    def no(*args)
      __check__.no!(*args)
    end

    # Returns the current check.
    def __check__
      @__check__ || check_table[:equality]
    end

  end

end

module AE::World
  # It's upto the test framework to include where needed.
  include AE::Check
end

