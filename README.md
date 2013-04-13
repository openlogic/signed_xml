SignedXml [![Build Status](https://travis-ci.org/toddthomas/signed_xml.png)](https://travis-ci.org/toddthomas/signed_xml)
=========

SignedXml is a Ruby implementation of [XML Signatures](http://www.w3.org/TR/xmldsig-core).

Dependencies
------------

SignedXml requires and is in love with [Nokogiri](http://nokogiri.org).

Limitations
-----------

They are legion. Currently only verification of signed documents is supported.
Allowed transformations are enveloped-signature and c14n. Only same-document
Reference URIs are supported, and of those only the null URI (URI="", or
the whole document) and fragment URIs which specify a literal ID are supported.
XPointer expressions are not supported.

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

doc = Nokogiri::XML(File.read 'some_signed_doc.xml')
signed_doc = SignedXml::Document.new(doc)
signed_doc.is_verified?
```

Contributing
------------

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
