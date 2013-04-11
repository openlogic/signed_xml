require 'base64'

module SignedXml
  class Base64Transform
    def apply(input)
      Base64.encode64(input)
    end
  end
end
