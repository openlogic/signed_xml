require 'logger'
require 'nokogiri'

module SignedXml
  XMLDSIG_NS = "http://www.w3.org/2000/09/xmldsig#"

  def self.Document(thing)
    Document.new(thing)
  end

  # Logger that does nothing
  BITBUCKET_LOGGER = Logger.new(nil)
  class << BITBUCKET_LOGGER
    def add(*args)
    end
  end

  # The logger signed_xml should use
  def self.logger
    @@logger ||= BITBUCKET_LOGGER
  end

  # Set the logger for signed_xml
  def self.logger=(a_logger)
    @@logger = a_logger
  end

  autoload :Transformable, 'signed_xml/transformable'
  autoload :Document, 'signed_xml/document'
  autoload :Signature, 'signed_xml/signature'
  autoload :SignedInfo, 'signed_xml/signed_info'
  autoload :Reference, 'signed_xml/reference'
  autoload :DigestMethodResolution, 'signed_xml/digest_method_resolution'
  autoload :DigestTransform, 'signed_xml/digest_transform'
  autoload :Base64Transform, 'signed_xml/base64_transform'
  autoload :C14NTransform, 'signed_xml/c14n_transform'
  autoload :EnvelopedSignatureTransform, 'signed_xml/enveloped_signature_transform'
  autoload :Fingerprinting, 'signed_xml/fingerprinting'
  autoload :Logging, 'signed_xml/logging'
end
