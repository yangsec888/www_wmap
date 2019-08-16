#--
# www_wmap
#
# A  Ruby application for enterprise web application asset tracking
#
# Developed by Sam (Yang) Li, <yang.li@owasp.org>.
#
#++

# app/controllers/sessions_controller.rb
# override the devise sessions controller actions
class SessionsController < Devise::SessionsController

  # support both ldap and local auth strategy
  # http://stackoverflow.com/questions/17464548/user-authentication-by-both-ldap-and-database
  def create
    if (params[:log]=="local")
      self.resource = warden.authenticate!(:database_authenticatable)
      sign_in(resource_name, resource)
      yield resource if block_given?
      respond_with resource, location: after_sign_in_path_for(resource)
    else
      self.resource = warden.authenticate!(:ldap_authenticatable)
      sign_in(resource_name, resource)
      yield resource if block_given?
      respond_with resource, location: after_sign_in_path_for(resource)
    end
  end

end
