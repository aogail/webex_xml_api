require 'spec_helper'

describe WebexXmlApi::PasswordlessSecurityContext do
  subject { described_class }

  describe '#initialize' do
    it 'creates attr_accessors and sets variables' do
      sc = subject.new(site_name: 'test', site_id: '123456')
      expect(sc.site_name).to eql('test')
      expect(sc.site_id).to eql('123456')
      expect(sc.email).to be_nil
    end

    it 'ignores invalid parameters' do
      sc = subject.new(site_name: 'test', invalid_param: 'test')
      expect(sc.site_name).to eql('test')
      expect(sc).not_to respond_to(:invalid_param)
    end
  end

  describe '#to_xml' do
    it 'raises a NotEnoughArguments exception if arguments missing' do
      sc = subject.new(site_name: 'test')
      expect { sc.to_xml }
        .to raise_error(WebexXmlApi::NotEnoughArguments, 'SecurityContext')
    end

    it 'returns formatted XML text' do
      expected = "<header>\n  <securityContext>\n"
      expected += "    <webExID>test</webExID>\n"
      expected += "    <siteName>test</siteName>\n"
      expected += "  </securityContext>\n</header>\n"
      sc = subject.new(site_name: 'test', webex_id: 'test')
      expect(sc.to_xml).to eql(expected)
    end
  end

  describe '#valid?' do
    it 'fails if site_name is missing' do
      sc = subject.new(webex_id: 'test')
      expect(sc).to_not be_valid
    end

    it 'fails if webex_id is missing' do
      sc = subject.new(site_name: 'test')
      expect(sc).to_not be_valid
    end

    it 'succeeds if required parameters are set' do
      sc = subject.new(site_name: 'test', webex_id: 'test')
      expect(sc).to be_valid
    end
  end
end
