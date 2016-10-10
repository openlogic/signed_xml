require 'openssl'

module SignedXml
  module DigestMethodResolution
    include OpenSSL

    # The XML Signature Syntax and Processing (Second Edition) specification defines IDs for algorithms which must be
    # supported by implementations. It also defines IDs for some algorithms which it recommends be supported. See
    # https://www.w3.org/TR/xmldsig-core/#sec-AlgID.
    #
    # The XML Encryption Syntax and Processing Version 1.1 specification defines IDs for its own set of required and
    # recommended algorithms, and some of these have been seen in signed XML docs in the wild. See
    # https://www.w3.org/TR/xmlenc-core1/#sec-AlgID
    #
    # RFC 6931 defines IDs for yet more algorithms which have also been encountered in the wild. See
    # https://tools.ietf.org/html/rfc6931.
    #
    # Note that some of these are encryption algorithms, of which the digest or hashing algorithm is only one component.
    # Nevertheless, it is the only component this method aims to identify.

    SHA1_IDS = %w(
      http://www.w3.org/2000/09/xmldsig#sha1
      http://www.w3.org/2000/09/xmldsig#dsa-sha1
      http://www.w3.org/2000/09/xmldsig#rsa-sha1
    )

    SHA224_IDS = %w(
      http://www.w3.org/2001/04/xmldsig-more#sha224
    )

    SHA256_IDS = %w(
      http://www.w3.org/2001/04/xmldsig-more#rsa-sha256
      http://www.w3.org/2001/04/xmlenc#sha256
    )

    SHA384_IDS = %w(
      http://www.w3.org/2001/04/xmldsig-more#sha384
      http://www.w3.org/2001/04/xmldsig-more#rsa-sha384
      http://www.w3.org/2001/04/xmlenc#sha384
    )

    SHA512_IDS = %w(
      http://www.w3.org/2001/04/xmldsig-more#rsa-sha512
      http://www.w3.org/2001/04/xmlenc#sha512
    )

    def new_digester_for_id(id)
      case id
        when *SHA1_IDS
          Digest::SHA1.new
        when *SHA224_IDS
          Digest::SHA224.new
        when *SHA256_IDS
          Digest::SHA256.new
        when *SHA384_IDS
          Digest::SHA384.new
        when *SHA512_IDS
          Digest::SHA512.new
        else
          raise ArgumentError, "unknown digest method #{id}"
      end
    end
  end
end
