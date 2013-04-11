require "nokogiri"
require "openssl"
require "options"

module SignedXml
  class Document
    include DigestMethodResolution

    attr_reader :doc

    def initialize(doc)
      @doc = doc
    end

    def is_verifiable?
      !signature.here.nil?
    end

    def is_verified?(opts = {})
      return false unless is_verifiable?

      is_signed_info_verified? && are_reference_digests_verified?
    end

    private

    def is_signed_info_verified?
      public_key.verify(digester_for_id(signed_info.signature_method), signature.decoded_value, signed_info.apply_transforms)
    end

    def are_reference_digests_verified?
      references.all?(&:is_verified?)
    end

    def references
      @references ||= init_references
    end

    def init_references
      references = []

      doc.xpath('//ds:Reference', ds: XMLDSIG_NS).each do |reference_node|
        references << Reference.new(reference_node)
      end

      references
    end

    def signed_info
      @signed_info ||= SignedInfo.new(doc.at_xpath("//ds:SignedInfo", ds: XMLDSIG_NS))
    end

    def signature
      @signature ||= Signature.new(doc.at_xpath("//ds:Signature", ds: XMLDSIG_NS))
    end

    def public_key
      @public_key ||= x509_certificate.public_key
    end

    def x509_certificate
      @x509_certificate ||= OpenSSL::X509::Certificate.new(certificate(x509_cert_data))
    end

    def x509_cert_data
      @x509_cert_data ||= doc.at_xpath("//ds:X509Certificate", ds: XMLDSIG_NS).text
    end

    def certificate(data)
      "-----BEGIN CERTIFICATE-----\n#{data}\n-----END CERTIFICATE-----"
    end
  end
end
