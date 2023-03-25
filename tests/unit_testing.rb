load "./src/scrubber.rb"

test_dir = "./tests"
test_results = {}

# very basic test
# for each test case in ./tests, grab the inputs and run code
# then test equality of actual and expected (expected coming from output)
Dir.children(test_dir).each do |sub_dir|
    next if sub_dir == "unit_testing.rb"
    test_files = Dir.children(test_dir + '/' + sub_dir)

    input_path = test_dir + '/' + sub_dir + '/' + test_files[0]
    sensitive_field_path = test_dir + '/' + sub_dir + '/' + test_files[2]
    output_path = test_dir + '/' + sub_dir + '/' + test_files[1]
    
    expected = JSON.load(File.open(output_path))
    actual = Scrubber.new(sensitive_field_path, input_path).scrub
    
    test_result = expected == actual ? "PASS" : "FAIL"
    test_results[sub_dir] = test_result

    p "CASE: #{sub_dir}: #{test_result}"
end

p test_results


# dev debugging
# TO BE RAN FROM SHELL

# alphanumberic
# ruby scrub.rb ./tests/01_alphanumeric/sensitive_fields.txt ./tests/01_alphanumeric/input.json

# Array
# ruby scrub.rb ./tests/02_array/sensitive_fields.txt ./tests/02_array/input.json

# boolean
# ruby scrub.rb ./tests/03_booleans/sensitive_fields.txt ./tests/03_booleans/input.json

# numbers
# ruby scrub.rb ./tests/04_numbers/sensitive_fields.txt ./tests/04_numbers/input.json

# floats
# ruby scrub.rb ./tests/05_floats/sensitive_fields.txt ./tests/05_floats/input.json

# nested
# ruby scrub.rb ./tests/06_nested_object/sensitive_fields.txt ./tests/06_nested_object/input.json

# mixed array
# ruby scrub.rb ./tests/07_mixed_type_arrays/sensitive_fields.txt ./tests/07_mixed_type_arrays/input.json

# sensitive nested objects
# ruby scrub.rb ./tests/08_sensitive_nested_objects/sensitive_fields.txt ./tests/08_sensitive_nested_objects/input.json

# sensitive nested arrays
# ruby scrub.rb ./tests/09_sensitive_nested_arrays/sensitive_fields.txt ./tests/09_sensitive_nested_arrays/input.json
