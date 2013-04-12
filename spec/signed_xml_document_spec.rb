require 'spec_helper'

describe SignedXml::Document do
  include SignedXml::DigestMethodResolution

  let(:resources_path) { File.join(File.dirname(__FILE__), 'resources') }

  let(:unsigned_doc_nodes) do
    xml_doc_from_file(File.join(resources_path, 'unsigned_saml_response.xml'))
  end

  let(:unsigned_doc) { SignedXml::Document.new(unsigned_doc_nodes) }

  let(:signed_doc_nodes) do
    xml_doc_from_file(File.join(resources_path, 'signed_saml_response.xml'))
  end

  let(:signed_doc) { SignedXml::Document.new(signed_doc_nodes) }

  it "knows which documents can be verified" do
    unsigned_doc.is_verifiable?.should be false
    signed_doc.is_verifiable?.should be true
  end

  it "knows unsigned documents can't be verified" do
    unsigned_doc.is_verified?.should be false
  end

  let(:test_certificate) { OpenSSL::X509::Certificate.new IO.read(File.join(resources_path, 'test_cert.pem')) }

  it "can read an embedded X.509 certificate" do
    signed_doc.send(:signatures).first.send(:x509_certificate).to_pem.should eq test_certificate.to_pem
  end

  it "knows the public key of the embedded X.509 certificate" do
    signed_doc.send(:signatures).first.send(:public_key).to_s.should eq test_certificate.public_key.to_s
  end

  it "knows the signature method of the signed info" do
    digester_for_id(signed_doc.send(:signatures).first.send(:signed_info).signature_method).class.should == OpenSSL::Digest::SHA1
  end

  it "knows how to canonicalize its signed info" do
    signed_doc.send(:signatures).first.send(:signed_info).transforms.first.method.should == Nokogiri::XML::XML_C14N_EXCLUSIVE_1_0
  end

  it "verifies its signed info" do
    signed_doc.send(:signatures).first.send(:is_signed_info_verified?).should be true
  end

  it "verifies docs with one enveloped-signature Resource element and embedded X.509 key" do
    signed_doc.is_verified?.should be true
  end

  let(:same_doc_ref_nodes) do
    xml_doc_from_file(File.join(resources_path, 'same_doc_reference.xml'))
  end

  let(:same_doc_ref_doc) { SignedXml::Document.new(same_doc_ref_nodes) }

  it "verifies docs with same-document references" do
    same_doc_ref_doc.is_verified?.should be true
  end

  let(:two_sig_nodes) do
    xml_doc_from_file(File.join(resources_path, 'two_sig_doc.xml'))
  end

  let(:two_sig_doc) { SignedXml::Document.new(two_sig_nodes) }

  it "verifies docs with more than one signature" do
    two_sig_doc.is_verified?.should be true
  end

  let(:badly_signed_doc_nodes) do
    xml_doc_from_file(File.join(resources_path, 'badly_signed_saml_response.xml'))
  end

  let(:badly_signed_doc) { SignedXml::Document.new(badly_signed_doc_nodes) }

  it "fails verification of a badly-signed doc" do
    badly_signed_doc.is_verified?.should be false
  end

  let(:incorrect_digest_doc_nodes) do
    xml_doc_from_file(File.join(resources_path, 'incorrect_digest_saml_response.xml'))
  end

  let(:incorrect_digest_doc) { SignedXml::Document.new(incorrect_digest_doc_nodes) }

  it "fails verification of a doc with an incorrect Resource digest" do
    incorrect_digest_doc.is_verified?.should be false
  end
end
