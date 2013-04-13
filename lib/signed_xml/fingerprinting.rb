require 'digest'

module SignedXml
  module Fingerprinting
    def fingerprint(data)
      Digest::SHA1.hexdigest(data)
    end
  end
end
