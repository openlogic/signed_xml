require "openssl"

module SignedXml
  class DigestTransform
    include DigestMethodResolution

    attr_reader :digest

    def initialize(method_id)
      @digest = digester_for_id(method_id)
    end

    def apply(input)
      digest.digest(input)
    end
  end
end
