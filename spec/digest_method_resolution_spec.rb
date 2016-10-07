require 'spec_helper'

describe SignedXml::DigestMethodResolution do
  include SignedXml::DigestMethodResolution

  let(:sha1_ids) do
    %w(
      http://www.w3.org/2000/09/xmldsig#sha1
      http://www.w3.org/2000/09/xmldsig#dsa-sha1
      http://www.w3.org/2000/09/xmldsig#rsa-sha1
    )
  end

  let(:sha224_ids) do
    %w(
      http://www.w3.org/2001/04/xmldsig-more#sha224
    )
  end

  let(:sha256_ids) do
    %w(
      http://www.w3.org/2001/04/xmldsig-more#rsa-sha256
      http://www.w3.org/2001/04/xmlenc#sha256
    )
  end

  let(:sha384_ids) do
    %w(
      http://www.w3.org/2001/04/xmldsig-more#sha384
      http://www.w3.org/2001/04/xmldsig-more#rsa-sha384
      http://www.w3.org/2001/04/xmlenc#sha384
    )
  end

  let(:sha512_ids) do
    %w(
      http://www.w3.org/2001/04/xmldsig-more#rsa-sha512
      http://www.w3.org/2001/04/xmlenc#sha512
    )
  end

  it 'works for known SHA-1 IDs' do
    sha1_ids.each do |id|
      expect(new_digester_for_id(id).class).to eq OpenSSL::Digest::SHA1
    end
  end

  it 'works for known SHA-224 IDs' do
    sha224_ids.each do |id|
      expect(new_digester_for_id(id).class).to eq OpenSSL::Digest::SHA224
    end
  end

  it 'works for known SHA-256 IDs' do
    sha256_ids.each do |id|
      expect(new_digester_for_id(id).class).to eq OpenSSL::Digest::SHA256
    end
  end

  it 'works for known SHA-384 IDs' do
    sha384_ids.each do |id|
      expect(new_digester_for_id(id).class).to eq OpenSSL::Digest::SHA384
    end
  end

  it 'works for known SHA-512 IDs' do
    sha512_ids.each do |id|
      expect(new_digester_for_id(id).class).to eq OpenSSL::Digest::SHA512
    end
  end
end