module SignedXml
  class EnvelopedSignatureTransform
    def apply(input)
      envelope = input.clone
      envelope.at_xpath('//ds:Signature', ds: XMLDSIG_NS).remove
      envelope
    end
  end
end
