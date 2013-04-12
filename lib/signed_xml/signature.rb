require 'base64'

module SignedXml
  class Signature
    include DigestMethodResolution

    attr_accessor :here
    attr_accessor :public_key

    def initialize(here)
      @here = here
    end

    def is_verified?
      is_signed_info_verified? && are_reference_digests_verified?
    end

    private

    def is_signed_info_verified?
      public_key.verify(digester_for_id(signed_info.signature_method), decoded_value, signed_info.apply_transforms)
    end

    def are_reference_digests_verified?
      references.all?(&:is_verified?)
    end

    def references
      @references ||= init_references
    end

    def init_references
      references = []

      here.xpath('//ds:Reference', ds: XMLDSIG_NS).each do |reference_node|
        references << Reference.new(reference_node)
      end

      references
    end

    def decoded_value
      @decoded_value ||= Base64.decode64 value
    end

    def value
      @value ||= here.at_xpath('//ds:SignatureValue', ds: XMLDSIG_NS).text.strip
    end

    def signed_info
      @signed_info ||= SignedInfo.new(here.at_xpath("//ds:SignedInfo", ds: XMLDSIG_NS))
    end

    def public_key
      @public_key ||= x509_certificate.public_key
    end

    def x509_certificate
      OpenSSL::X509::Certificate.new(certificate(x509_cert_data))
    end

    def x509_cert_data
      here.at_xpath("//ds:X509Certificate", ds: XMLDSIG_NS).text
    end

    def certificate(data)
      "-----BEGIN CERTIFICATE-----\n#{wrap_text(data, 64)}-----END CERTIFICATE-----\n"
    end

    # http://blog.macromates.com/2006/wrapping-text-with-regular-expressions/
    def wrap_text(txt, col = 80)
      txt.gsub(/(.{1,#{col}})( +|$)\n?|(.{#{col}})/, "\\1\\3\n")
    end
  end
end
