require "openssl"
require "options"

module SignedXml
  class Document
    attr_reader :doc

    def initialize(doc)
      @doc = doc
    end

    def is_verifiable?
      signatures.any?
    end

    def is_verified?(opts = {})
      return false unless is_verifiable?

      set_key_for_signatures(opts[:certificate]) if opts.has_key? :certificate

      signatures.all?(&:is_verified?)
    end

    private

    def signatures
      @signatures ||= init_signatures
    end

    def init_signatures
      signatures = []
      doc.xpath("//ds:Signature", ds: XMLDSIG_NS).each do |signature_node|
        signatures << Signature.new(signature_node)
      end
      signatures
    end

    def set_key_for_signatures(x509_cert)
      raise "#{x509_cert.inspect} doesn't implement public_key" unless x509_cert.respond_to? :public_key

      signatures.each { |sig| sig.public_key = x509_cert.public_key }
    end
  end
end
