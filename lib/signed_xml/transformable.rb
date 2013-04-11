module SignedXml
  module Transformable
    def transforms
      @transforms ||= []
    end

    def apply_transforms
      transforms.reduce(start) do |input, transform|
        transform.apply(input)
      end
    end
  end
end
