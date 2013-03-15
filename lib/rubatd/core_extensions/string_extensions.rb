module StringExtensions
  def camelize
    gsub(/\/(.?)/) { "::" + $1.upcase }.gsub(/(^|_)(.)/) { $2.upcase }
  end

  def underscore
    gsub(/([a-z])([A-Z])/, '\1_\2').downcase
  end
end

String.send(:include, StringExtensions)
