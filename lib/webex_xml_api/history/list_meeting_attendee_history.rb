module WebexXmlApi
  ##
  # The +History+ module of the API
  #
  module History
    ##
    # The +ListMeetingAttendeeHistory+ Class uses the ListMeetingAttendeeHistory Webex API to retrieve attendee
    # history for a meeting.
    #
    class ListMeetingAttendeeHistory
      include WebexXmlApi::Common

      # XML Request Type for the <tt>WebexXmlApi::History::ListMeetingAttendeeHistory</tt> service
      REQUEST_TYPE = 'java:com.webex.service.binding.history.LstmeetingattendeeHistory'.freeze

      # The meeting_key is required parameter for this service
      PARAMETER_MAPPING = {
          meeting_key: 'meetingKey'
      }.freeze

      attr_accessor :meeting_key, :security_context
      attr_reader :request, :response

      ##
      # The +initialize+ method for newly created instance parsing provided
      # parameters (if any). The +initialize+ method automatically creates
      # new +SecurityContext+ instance and passes the attribs.
      #
      def initialize(attributes = {})
        attributes.each_pair do |k, v|
          send("#{k}=", v) if PARAMETER_MAPPING.key?(k)
        end
        @security_context ||= WebexXmlApi::SecurityContext.new(attributes)
      end

      #
      # The +to_xml+ method returns XML representation of the
      # <tt>WebexXmlApi::History::ListMeetingAttendeeHistory</tt> instance as understood by
      # the WebEx XML Service.
      #

      def to_xml
        raise WebexXmlApi::NotEnoughArguments, 'History::ListMeetingAttendeeHistory' unless valid?
        body_content = {}
        PARAMETER_MAPPING.each_pair do |k, v|
          body_content[v] = send(k) if send(k)
        end
        create_xml_request(@security_context.to_xml, REQUEST_TYPE,
                           body_content)
      end

      ##
      # Returns true if required parameters provided, otherwise false.
      #
      def valid?(context = self)
        !context.meeting_key.nil?
      end

      ##
      # The +send_request+ method will issue the XML API request to WebEx,
      # parse the results and return data if successful. Upon failure an
      # exception is raised.
      #
      def send_request
        @request = to_xml
        @response = post_webex_request(security_context.site_name, @request)
        check_response_and_return_data(@response)
      end
    end
  end
end
