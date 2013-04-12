module SignedXml
  class EnvelopedSignatureTransform
    def apply(input)
      envelope = Nokogiri::XML::Document.new
      envelope.root = input
      envelope.at_xpath('//ds:Signature', ds: XMLDSIG_NS).remove
      envelope
    end
  end
end
