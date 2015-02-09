require 'openssl'

module SignedXml
  module DigestMethodResolution
    include OpenSSL

    def new_digester_for_id(id)
      case id
      when "http://www.w3.org/2001/04/xmldsig-more#rsa-sha256","http://www.w3.org/2001/04/xmlenc#sha256"
        Digest::SHA256.new
      when "http://www.w3.org/2000/09/xmldsig#sha1","http://www.w3.org/2000/09/xmldsig#rsa-sha1"
        Digest::SHA1.new
      else
        raise ArgumentError, "unknown digest method #{id}"
      end
    end
  end
end
