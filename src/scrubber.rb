require "json"

class Scrubber
    attr_reader :fields_to_scrub, :data

    def initialize(sensitive_fields, input)
        @data = get_json(input)
        @fields_to_scrub = Set.new(File.open(sensitive_fields).readlines.map(&:chomp))
    end

    def scrub
        scrub_object(data)
    end

    def scrub_object(obj)
        obj.each do |key, value|
            if sensitive_feild?(key)
                case value.class.to_s
                when String.to_s
                    obj[key] = scrub_str(value)
                when Array.to_s
                    obj[key] = handle_array(value, true)
                when TrueClass.to_s, FalseClass.to_s
                    obj[key] = "-"
                when Integer.to_s, Float.to_s
                    obj[key] = scrub_str(value.to_s)
                when Hash.to_s
                    obj[key] = scrub_all(value)
                end
            else
                if value.is_a?(Hash)
                    res = scrub_object(value)
                    obj[key] = res
                elsif value.is_a?(Array)
                    handle_array(value)
                end
            end
        end

        obj
    end

    private

    def get_json(input)
        f = File.open(input)
        json = JSON.load f
        json
    end

    def alphanumeric_pat
        /[0-9a-zA-Z]/
    end

    def scrub_str(value)
        new_str = ""
        value.split('').each do |c|
            if c.match?(alphanumeric_pat)
                new_str += "*"
            else
                new_str += c
            end
        end

        new_str
    end

    def handle_array(arr, scrub_all = false)
        scrubbed = arr.map do |element|
            if element.is_a?(Hash) 
                if scrub_all
                    scrub_all(element)
                else
                    scrub_object(element)
                end
            elsif element.is_a?(Array)
                handle_array(element, true)
            else
                if scrub_all
                    scrub_str(element.to_s)
                else
                    element
                end
            end
        end
        scrubbed
    end

    def scrub_all(obj)
        obj.each do |key, value|
        case value.class.to_s
            when String.to_s
                obj[key] = scrub_str(value)
            when Array.to_s
                obj[key] = handle_array(value, true)
            when TrueClass.to_s, FalseClass.to_s
                obj[key] = "-"
            when Integer.to_s, Float.to_s
                obj[key] = scrub_str(value.to_s)
            when Hash.to_s
                obj[key] = scrub_all(value)
            end
        end
    end

    def sensitive_feild?(feild)
        fields_to_scrub.include?(feild)
    end
end
