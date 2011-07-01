module AE

  #
  module CheckOK

    #
    def check(&block)
      @_check = block
    end

    #
    def ok(*args)
      @_check.call(*args)
    end

    #def no(*args)
    #  @_check.call(*args)
    #end
  end

  module World
    include CheckOK
  end

end


