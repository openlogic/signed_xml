require 'signed_xml'

def xml_doc_from_file(path)
  file = File.open(path)
  doc = Nokogiri::XML(file)
  file.close
  doc
end
