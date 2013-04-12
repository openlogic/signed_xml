require 'nokogiri'

module SignedXml
  XMLDSIG_NS = "http://www.w3.org/2000/09/xmldsig#"

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
end
