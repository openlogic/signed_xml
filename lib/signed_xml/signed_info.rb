module SignedXml
  class SignedInfo
    include Transformable

    attr_reader :start, :signature_method

    def initialize(here)
      @start = here

      canonicalization_method = here.at_xpath('//ds:CanonicalizationMethod/@Algorithm', ds: XMLDSIG_NS).value.strip

      transforms << C14NTransform.new(canonicalization_method)

      @signature_method = here.at_xpath('//ds:SignatureMethod/@Algorithm', ds: XMLDSIG_NS).value.strip
    end
  end
end
