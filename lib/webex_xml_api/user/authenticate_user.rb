module WebexXmlApi
  ##
  # The +User+ module of the API
  #
  module User
    ##
    # The +AuthenticateUser+ Class uses the AuthenticateUser Webex API to convert a Webex Teams access token
    # to a Webex Meetings session ticket.
    #
    class AuthenticateUser
      include WebexXmlApi::Common

      # XML Request Type for the <tt>WebexXmlApi::User::AuthenticateUser</tt> service
      REQUEST_TYPE = 'java:com.webex.service.binding.user.AuthenticateUser'.freeze

      # The access_token is required for this service
      PARAMETER_MAPPING = {
          access_token: 'accessToken',
      }.freeze

      attr_accessor :access_token, :security_context
      attr_reader :request, :response

      ##
      # The +initialize+ method for newly created instance parsing provided
      # parameters (if any). The +initialize+ method automatically creates
      # new +PasswordlessSecurityContext+ instance and passes the attribs.
      #
      def initialize(attributes = {})
        attributes.each_pair do |k, v|
          send("#{k}=", v) if PARAMETER_MAPPING.key?(k)
        end
        @security_context ||= WebexXmlApi::PasswordlessSecurityContext.new(attributes)
      end

      ##
      # The +to_xml+ method returns XML representation of the
      # <tt>WebexXmlApi::User::AuthenticateUser</tt> instance as understood by
      # the WebEx XML Service.
      #
      def to_xml
        raise WebexXmlApi::NotEnoughArguments, 'User::AuthenticateUser' unless valid?
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
        !context.access_token.nil?
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
