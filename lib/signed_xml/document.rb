require "openssl"
require "options"

module SignedXml
  class Document
    attr_reader :doc

    def initialize(thing)
      if thing.is_a? Nokogiri::XML::Document
        @doc = thing
      else
        @doc = Nokogiri::XML(thing)
      end
    end

    def is_verifiable?
      signatures.any?
    end

    def is_verified?(arg = nil)
      return false unless is_verifiable?

      if arg.respond_to? :public_key
        set_public_key_for_signatures(arg)
      elsif arg.respond_to? :[]
        set_certificate_store_for_signatures(arg)
      elsif !arg.nil?
        raise ArgumentError, "#{arg.inspect}:#{arg.class} must have a public key or be a hash of public keys"
      end

      signatures.all?(&:is_verified?)
    end

    def sign(private_key, certificate = nil)
      signatures.each { |sig| sig.sign(private_key, certificate) }
      self
    end

    def to_xml
      doc.to_xml
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

    def set_public_key_for_signatures(certificate)
      signatures.each { |sig| sig.public_key = certificate.public_key }
    end

    def set_certificate_store_for_signatures(cert_store)
      raise "#{cert_store.inspect} doesn't implement []" unless cert_store.respond_to? :[]

      signatures.each { |sig| sig.certificate_store = cert_store }
    end
  end
end
