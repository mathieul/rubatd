guard 'rspec', all_on_start: false do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/rubatd/(.+)\.rb$})     { |m| p "spec/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end
