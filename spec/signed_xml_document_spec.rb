require 'spec_helper'

describe SignedXml::Document do
  include SignedXml::DigestMethodResolution
  include SignedXml::Fingerprinting

  let(:resources_path) { File.join(File.dirname(__FILE__), 'resources') }

  let(:unsigned_doc) do
    SignedXml::Document(File.read(File.join(resources_path, 'unsigned_saml_response.xml')))
  end

  let(:signed_doc) do
    SignedXml::Document(File.read(File.join(resources_path, 'signed_saml_response.xml')))
  end

  it "knows which documents can be verified" do
    unsigned_doc.is_verifiable?.should be false
    signed_doc.is_verifiable?.should be true
  end

  it "knows unsigned documents can't be verified" do
    unsigned_doc.is_verified?.should be false
  end

  let(:test_certificate) { OpenSSL::X509::Certificate.new File.read(File.join(resources_path, 'test_cert.pem')) }

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

  let(:passed_in_nokogiri_doc) do 
    SignedXml::Document(Nokogiri::XML(File.read(File.join(resources_path, 'signed_saml_response.xml'))))
  end

  it "works when passed a Nokogiri::XML::Document instead of a string" do
    passed_in_nokogiri_doc.is_verified?.should be true
  end

  let(:same_doc_ref_doc) do
    SignedXml::Document(File.read(File.join(resources_path, 'same_doc_reference.xml')))
  end

  it "verifies docs with same-document references" do
    same_doc_ref_doc.is_verified?.should be true
  end

  let(:two_sig_doc) do
    SignedXml::Document(File.read(File.join(resources_path, 'two_sig_doc.xml')))
  end

  it "verifies docs with more than one signature" do
    two_sig_doc.is_verified?.should be true
  end

  let(:no_key_doc) do
    SignedXml::Document(File.read(File.join(resources_path, 'no_key_doc.xml')))
  end

  it "verifies docs lacking keys if X.509 cert is provided at runtime" do
    no_key_doc.is_verified? test_certificate
  end

  let(:test_cert_fingerprint) { fingerprint(test_certificate.to_der) }
  let(:cert_store) { {test_cert_fingerprint => test_certificate} }

  it "uses a key matching the embedded key if a cert store is provided" do
    signed_doc.is_verified?(cert_store).should be true
  end

  let(:another_test_cert) { OpenSSL::X509::Certificate.new File.read(File.join(resources_path, 'another_test_cert.pem')) }
  let(:another_test_cert_fp) { Digest::SHA1.hexdigest(test_certificate.to_der) }
  let(:another_cert_store) { {another_test_cert_fp => another_test_cert} }

  it "fails validation if provided cert store does not contain a key matching the embedded key" do
    signed_doc.is_verified?(another_cert_store).should be false
  end

  let(:wrong_key_doc) do
    SignedXml::Document(File.read(File.join(resources_path, 'wrong_key_doc.xml')))
  end

  it "fails validation of a doc with the wrong key" do
    wrong_key_doc.is_verified?.should be false
  end

  it "uses provided cert instead of embedded cert" do
    wrong_key_doc.is_verified? test_certificate
  end

  let(:badly_signed_doc) do
    SignedXml::Document(File.read(File.join(resources_path, 'badly_signed_saml_response.xml')))
  end

  it "fails verification of a badly-signed doc" do
    badly_signed_doc.is_verified?.should be false
  end

  let(:incorrect_digest_doc) do
    SignedXml::Document(File.read(File.join(resources_path, 'incorrect_digest_saml_response.xml')))
  end

  it "fails verification of a doc with an incorrect Resource digest" do
    incorrect_digest_doc.is_verified?.should be false
  end
end
