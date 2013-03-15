module HashExtensions
  def except(*keys)
    reject { |k,v| keys.include?(k.to_sym) }
  end

  def slice(*keys)
    select { |k,v| keys.include?(k.to_sym) }
  end
end

Hash.send(:include, HashExtensions) unless Hash.new.respond_to?(:except)
