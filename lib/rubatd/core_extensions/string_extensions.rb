module StringExtensions
  def camelize
    gsub(/\/(.?)/) { "::" + $1.upcase }.gsub(/(^|_)(.)/) { $2.upcase }
  end

  def underscore
    gsub(/([a-z])([A-Z])/, '\1_\2').downcase
  end

  def pluralize
    self[-1] == "s" ? self : "#{self}s"
  end

  def singularize
    self[-1] == "s" ? self[0..-2] : self
  end

  def foreign_key
    "#{underscore}_id"
  end
end

String.send(:include, StringExtensions)
