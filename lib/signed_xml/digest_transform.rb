require "openssl"

module SignedXml
  class DigestTransform
    include DigestMethodResolution

    attr_reader :digester

    def initialize(method_id)
      @digester = new_digester_for_id(method_id)
    end

    def apply(input)
      digester.digest(input)
    end
  end
end
