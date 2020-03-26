require 'spec_helper'

describe WebexXmlApi::History::ListMeetingAttendeeHistory do
  subject { described_class }

  describe '#initialize' do
    it 'creates attr_accessors and sets variables' do
      lmah = subject.new(site_name: 'test', webex_id: '4321', meeting_key: '1234', webex_access_token: '7890')
      expect(lmah.meeting_key).to eql('1234')
      expect(lmah.security_context).to be_valid
    end

    it 'ignores invalid parameters' do
      lmah = subject.new(webex_id: 'test', meeting_key: '1234', invalid_param: 'test', webex_access_token: '7890')
      expect(lmah.meeting_key).to eql('1234')
      expect(lmah).not_to respond_to(:invalid_param)
    end
  end

  describe '#to_xml' do
    it 'raises a NotEnoughArguments exception if arguments missing' do
      lmah = subject.new(site_name: 'test')
      expect { lmah.to_xml }
          .to raise_error(WebexXmlApi::NotEnoughArguments, 'History::ListMeetingAttendeeHistory')
    end

    it 'returns formatted XML text' do
      expected = file_fixture('history_list_meeting_attendee_history_request.xml')
      lmah = subject.new(site_name: 'test', webex_id: '123456', password: 'test', meeting_key: 123456789)
      expect(lmah.to_xml).to eql(expected)
    end
  end

  describe '#valid?' do
    it 'fails if meeting_key is missing' do
      lmah = subject.new
      expect(lmah).to_not be_valid
    end

    it 'succeeds if all required parameters are set' do
      lmah = subject.new(meeting_key: 12347890)
      expect(lmah).to be_valid
    end
  end

  describe '#send_request' do
    it 'raises a NotEnoughArguments exception for ListMeetingAttendeeHistory' do
      lmah = subject.new(site_name: 'test', password: 'test')
      expect { lmah.send_request }
          .to raise_error(WebexXmlApi::NotEnoughArguments, 'History::ListMeetingAttendeeHistory')
    end

    it 'raises a NotEnoughArguments exception for SecurityContext' do
      lmah = subject.new(meeting_key: 'test')
      expect { lmah.send_request }
          .to raise_error(WebexXmlApi::NotEnoughArguments, 'SecurityContext')
    end

    it 'returns Response bodyContent as hash' do
      lmah = subject.new(site_name: 'test', webex_id: 'test', password: 'test', meeting_key: 12347890)
      good_reply = file_fixture('history_list_meeting_attendee_history_response_good.xml')
      stub_request(:post, 'https://test.webex.com/WBXService/XMLService')
          .to_return(good_reply)
      ret = lmah.send_request
      expect(ret).to be
      expect(ret.key?('meetingAttendeeHistory')).to be_truthy
      expect(ret['meetingAttendeeHistory'].first['meetingKey']).to eql('12347890')
    end

    it 'raises a RequestFailed exception with error message' do
      lmah = subject.new(site_name: 'test', webex_id: 'test', password: 'test', meeting_key: 12347890)
      bad_reply = file_fixture('history_list_meeting_attendee_history_response_bad.xml')
      stub_request(:post, 'https://test.webex.com/WBXService/XMLService')
          .to_return(bad_reply)
      expect { lmah.send_request }
          .to raise_error { |error|
            expect(error.message)
                .to eql('Error 000015: Sorry, no record found')
          }
    end
  end
end
