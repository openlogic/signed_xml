require 'openssl'

module SignedXml
  module DigestMethodResolution
    include OpenSSL

    def new_digester_for_id(id)
      id = id && id =~ /sha(.*?)$/i && $1.to_i
      case id
      when 256 then OpenSSL::Digest::SHA256.new
      when 384 then OpenSSL::Digest::SHA384.new
      when 512 then OpenSSL::Digest::SHA512.new        
      when 1   then OpenSSL::Digest::SHA1.new
      else
        raise ArgumentError, "unknown digest method #{id}"
      end
    end
  end
end
