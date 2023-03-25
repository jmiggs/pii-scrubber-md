## PII SCRUBBER
Hello! This basic scrubber script should cover all test cases included in the assignment

## Requirements
- ruby 3.2.0 (this is the version I used on my system to develop the script)

## How To Use
1. Download Zip and extract onto system
2. from terminal, cd into the project directory, pii-scrub-mig-delacruz-master
3. run the following command
  ```
    ruby scrub.rb **PATH TO SENSITIVE-FIELDS.TXT** **PATH TO JSON INPUT **
  ```
## Unit Testing
Please feel free to run the below command to verify all sample inputs are correctly scrubbed:
```
  # from project directory:
  ruby ./tests/unit_testing.rb
```
These tests take in the inputs from each example, run the scrubber on them, and compare the outcome to the expected

## dev concerns
in the time alloted I was only able to address the provided cases in the tests directory. Something that might cause error is deeply nested JSON
objects containing various different types of values.
