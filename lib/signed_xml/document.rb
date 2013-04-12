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
  end
end
