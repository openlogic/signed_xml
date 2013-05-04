SignedXml [![Build Status](https://travis-ci.org/toddthomas/signed_xml.png)](https://travis-ci.org/toddthomas/signed_xml)
=========

SignedXml is a Ruby implementation of [XML Signatures](http://www.w3.org/TR/xmldsig-core).

Dependencies
------------

SignedXml requires and is in love with [Nokogiri](http://nokogiri.org).

Limitations
-----------

They are legion. Allowed transformations are enveloped-signature and c14n. Only
same-document Reference URIs are supported, and of those only the null URI
(URI="", i.e. the whole document) and fragment URIs which specify a literal ID
are supported. XPointer expressions are not supported.

SignedXml can also sign documents which contain certain required
placeholder elements. For an example, see the file
saml_response_template.xml in spec/resources.

Installation
------------

Add this line to your application's Gemfile:

```ruby
gem 'signed_xml'
```

And then execute:

```shell
bundle
```

Or install it yourself as:

```shell
gem install signed_xml
```

Usage
-----

```ruby
require 'signed_xml'

# Verification
# using certificate in document
signed_doc = SignedXml::Document(File.read 'some_signed_doc.xml')
signed_doc.is_verified?

# using certificate provided by caller
certificate = OpenSSL::X509::Certificate.new(File.read 'certificate.pem')
signed_doc.is_verified? certificate

# using certificate which matches the one in the document
# (and failing if it doesn't)
cert_fingerprint = Digest::SHA1.hexdigest(certificate.to_der)
certificate_store = {cert_fingerprint => certificate}
signed_doc.is_verified? certificate_store

# Signing
doc = SignedXml::Document(File.read 'doc_with_placeholder_elems.xml')
private_key = OpenSSL::PKey::RSA.new(File.new 'private_key.pem')
certificate = OpenSSL::X509::Certificate.new(File.read 'certificate.pem')
doc.sign(private_key, certificate)
File.open('signed_doc.xml', 'w') { |file| file.puts doc.to_xml }
```

Contributing
------------

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
