module SignedXml
  class Reference
    include Transformable

    attr_reader :here, :start

    def initialize(here)
      @here = here

      uri = here['URI']
      case uri
      when nil, ""
        @start = here.document
      else raise ArgumentError.new("unsupported Reference URI #{uri}")
      end

      @transforms = init_transforms
    end

    def is_verified?
      apply_transforms.chomp == digest_value
    end

    private

    def init_transforms
      transforms = []

      here.xpath('//ds:Transform', ds: XMLDSIG_NS).each do |transform_node|
        method = transform_node['Algorithm']
        case method
        when "http://www.w3.org/2000/09/xmldsig#enveloped-signature"
          transforms << EnvelopedSignatureTransform.new
        else raise ArgumentError.new("unknown transform method #{method}")
        end
      end

      # TODO: check whether another c14n transform has already been specified.
      transforms << C14NTransform.new

      digest_method = here.at_xpath('//ds:DigestMethod/@Algorithm', ds: XMLDSIG_NS).value.strip
      transforms << DigestTransform.new(digest_method)

      transforms << Base64Transform.new
    end

    def digest_value
      @digest_value ||= here.at_xpath('ds:DigestValue', ds: XMLDSIG_NS).text.strip
    end
  end
end
