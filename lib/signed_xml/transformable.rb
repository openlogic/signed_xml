module SignedXml
  module Transformable
    include Logging

    def transforms
      @transforms ||= []
    end

    def apply_transforms
      transforms.reduce(start) do |input, transform|
        logger.debug "applying transform #{transform.inspect}"
        logger.debug "input:  [#{input}]"

        result = transform.apply(input)
        logger.debug "output: [#{result}]"
        result
      end
    end
  end
end
