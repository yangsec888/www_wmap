#--
# www_wmap
#
# A  Ruby application for enterprise web application asset tracking
#
# Developed by Yang Li, <yang.li@owasp.org>. Creative Common License
#
#++

class Document < ActiveRecord::Base
  mount_uploader :attachment, AttachmentUploader
	validates :name, presence: true

end
