module SignedXml
  # Logging stuff borrowed from https://github.com/pezra/saml-sp

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

  module Logging
    def logger
      SignedXml.logger
    end

    def self.included(base)
      base.extend(self)
    end
  end
end
