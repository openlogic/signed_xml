# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'signed_xml/version'

Gem::Specification.new do |gem|
  gem.name          = "signed_xml"
  gem.version       = SignedXml::VERSION
  gem.authors       = ["Todd Thomas"]
  gem.email         = ["todd.thomas@openlogic.com"]
  gem.description   = %q{XML Signature verification}
  gem.summary       = %q{Provides [incomplete] support for verification of XML Signatures <http://www.w3.org/TR/xmldsig-core>.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "nokogiri", "~> 1.5"
  gem.add_dependency "options"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
end
