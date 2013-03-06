# Borrowing Capybara acceptance test DSL extension
# https://github.com/jnicklas/capybara/blob/2.0.2/lib/capybara/rspec/features.rb

module Features
  def self.included(base)
    base.instance_eval do
      alias :background :before
      alias :scenario :it
      alias :xscenario :xit
      alias :given :let
      alias :given! :let!
    end
  end
end

def self.feature(*args, &block)
  options = if args.last.is_a?(Hash) then args.pop else {} end
  options[:feature] = true
  options[:type] = :feature
  options[:caller] ||= caller
  args.push(options)

  describe(*args, &block)
end

RSpec.configuration.include Features, :feature => true
