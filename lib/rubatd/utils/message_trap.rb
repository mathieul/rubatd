class MessageTrap < BasicObject
  def initialize
    @messages = []
  end

  def messages
    @messages
  end

  def method_missing(method, *args, &block)
    @messages << {method: method, args: args}
  end
end
