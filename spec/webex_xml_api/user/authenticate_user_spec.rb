require 'spec_helper'

describe WebexXmlApi::User::AuthenticateUser do
  subject { described_class }

  describe '#initialize' do
    it 'creates attr_accessors and sets variables' do
      au = subject.new(site_name: 'test', webex_id: '4321', access_token: '1234')
      expect(au.access_token).to eql('1234')
      expect(au.security_context).to be_valid
    end

    it 'ignores invalid parameters' do
      au = subject.new(webex_id: 'test', access_token: '1234', invalid_param: 'test')
      expect(au.access_token).to eql('1234')
      expect(au).not_to respond_to(:invalid_param)
    end
  end

  describe '#to_xml' do
    it 'raises a NotEnoughArguments exception if arguments missing' do
      au = subject.new(site_name: 'test')
      expect { au.to_xml }
          .to raise_error(WebexXmlApi::NotEnoughArguments, 'User::AuthenticateUser')
    end

    it 'returns formatted XML text' do
      expected = file_fixture('user_authenticate_user_request.xml')
      au = subject.new(site_name: 'webex_subdomain', webex_id: 'username', access_token: 'ZjJiMjZlMj...~...ae0e10f')
      expect(au.to_xml).to eql(expected)
    end
  end

  describe '#valid?' do
    it 'fails if access_token is missing' do
      au = subject.new(webex_id: '1234')
      expect(au.valid?).to be_falsey
    end

    it 'succeeds if all required parameters are set' do
      au = subject.new(webex_id: 'test', access_token: '1234')
      expect(au.valid?).to be_truthy
    end
  end

  describe '#send_request' do
    it 'raises a NotEnoughArguments exception for AuthenticateUser' do
      au = subject.new(site_name: 'test')
      expect { au.send_request }
          .to raise_error(WebexXmlApi::NotEnoughArguments, 'User::AuthenticateUser')
    end

    it 'raises a NotEnoughArguments exception for SecurityContext' do
      au = subject.new(site_name: 'test', access_token: 'test')
      expect { au.send_request }
          .to raise_error(WebexXmlApi::NotEnoughArguments, 'SecurityContext')
    end

    it 'raises a RequestFailed exception with error message' do
      au = subject.new(site_name: 'test', webex_id: 'test', access_token: 'test')
      bad_reply = file_fixture('user_authenticate_user_response_bad.xml')
      stub_request(:post, 'https://test.webex.com/WBXService/XMLService')
          .to_return(bad_reply)
      expect { au.send_request }
          .to raise_error { |error|
            expect(error.message)
                .to eql("Error 030048: Authentication Server can't generate a valid session ticket")
          }
    end

    it 'returns Response bodyContent as hash' do
      au = subject.new(site_name: 'test', webex_id: 'test', access_token: 'test')
      good_reply = file_fixture('user_authenticate_user_response_good.xml')
      stub_request(:post, 'https://test.webex.com/WBXService/XMLService')
          .to_return(good_reply)
      ret = au.send_request
      expect(ret).to be
      expect(ret['sessionTicket']).to eq 'AAABbKs70Bc...~...MR09SSVRITV8='
      expect(ret['createTime']).to eq '1564617600000'
      expect(ret['timeToLive']).to eq '5400'
    end
  end
end
