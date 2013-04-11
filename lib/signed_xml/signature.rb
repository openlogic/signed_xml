require 'base64'

module SignedXml
  class Signature
    attr_accessor :here

    def initialize(here)
      @here = here
    end

    def value
      @value ||= @here.at_xpath('//ds:SignatureValue', ds: XMLDSIG_NS).text.strip
    end

    def decoded_value
      @decoded_value ||= Base64.decode64 value
    end
  end
end
