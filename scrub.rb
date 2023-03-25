load "./src/scrubber.rb"

sensitive_fields = ARGV[0]
input = ARGV[1]

p Scrubber.new(sensitive_fields, input).scrub
