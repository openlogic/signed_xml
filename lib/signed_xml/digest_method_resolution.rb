require 'openssl'

module SignedXml
  module DigestMethodResolution
    include OpenSSL

    def digester_for_id(id)
      case id
      when "http://www.w3.org/2000/09/xmldsig#sha1","http://www.w3.org/2000/09/xmldsig#rsa-sha1"
        Digest::SHA1.new
      else raise ArgumentError.new("unknown digest method #{id}")
      end
    end
  end
end
