require 'base64'

module SignedXml
  class Signature
    include DigestMethodResolution
    include Logging

    attr_accessor :here
    attr_accessor :public_key
    attr_accessor :certificate_store

    def initialize(here)
      @here = here
    end

    def is_verified?
      is_signed_info_verified? && are_reference_digests_verified?
    end

    private

    def is_signed_info_verified?
      return false if public_key.nil?

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

    def certificate_store
      @certificate_store ||= {}
    end

    def public_key
      # If the user provided a certificate store, we MUST only use a
      # key which matches the one in the signature's KeyInfo. Otherwise,
      # use the key in the signature.
      @public_key ||= if certificate_store.any?
                        logger.debug "using cert store #{certificate_store}"
                        if certificate_store.has_key? x509_cert_fingerprint
                          certificate_store[x509_cert_fingerprint].public_key
                        else
                          logger.warn "Store has no certificate with fingerprint #{x509_cert_fingerprint}. Signature validation will fail."
                          nil
                        end
                      else
                        x509_certificate.public_key
                      end
    end

    def x509_certificate
      OpenSSL::X509::Certificate.new(certificate(x509_cert_data))
    end

    def x509_cert_fingerprint
      @x509_cert_fingerprint ||= Digest::SHA1.hexdigest(x509_certificate.to_der)
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
