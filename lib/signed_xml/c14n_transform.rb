module SignedXml
  class C14NTransform
    include Nokogiri::XML

    attr_reader :method
    attr_reader :with_comments

    def initialize(method = "http://www.w3.org/TR/2001/REC-xml-c14n-20010315")
      method, with_comments = method.split('#')
      @method = case method
                when "http://www.w3.org/TR/2001/REC-xml-c14n-20010315" then XML_C14N_1_0
                when "http://www.w3.org/2001/10/xml-exc-c14n" then XML_C14N_EXCLUSIVE_1_0
                when "http://www.w3.org/2006/12/xml-c14n11" then XML_C14N_1_1
                else raise ArgumentError, "unknown canonicalization method #{method}"
                end

      @with_comments = !!with_comments
    end

    def apply(input)
      raise ArgumentError, "input #{input.inspect}:#{input.class} is not canonicalizable" unless input.respond_to?(:canonicalize)

      input.canonicalize(method, nil, with_comments)
    end
  end
end
