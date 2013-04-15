module SignedXml
  # Logging stuff borrowed from https://github.com/pezra/saml-sp

  module Logging
    def logger
      SignedXml.logger
    end

    def self.included(base)
      base.extend(self)
    end
  end
end
