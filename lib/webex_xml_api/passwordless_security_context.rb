require 'webex_xml_api/security_context'

module WebexXmlApi
  ##
  # PasswordlessSecurityContext is a SecurityContext that is valid without password/session ticket/access token,
  # for API endpoints that do not require these.
  #
  class PasswordlessSecurityContext < SecurityContext
    ##
    # Returns true if required parameters provided, otherwise false.
    # Parameters :site_name and :webex_id are required.
    #
    def valid?(context = self)
      !context.site_name.nil? && !context.webex_id.nil?
    end
  end
end
