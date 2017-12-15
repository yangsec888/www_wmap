#--
# www_wmap
#
# A  Ruby application for enterprise web application asset tracking
#
# Developed by Yang Li, <yang.li@owasp.org>. Creative Common License
#
#++

class DocumentsController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
  	@docs = Document.all #where(:uid => current_user.id )
  end
end
