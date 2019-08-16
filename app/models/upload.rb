#--
# www_wmap
#
# A  Ruby application for enterprise web application asset tracking
#
# Developed by Sam (Yang) Li, <yang.li@owasp.org>.
#
#++

class Upload < ApplicationRecord
  mount_uploader :attachment, DivisionalDomainsUploader
  validates :name, :file_type, presence: true
  validates_integrity_of :attachment
  validates_processing_of :attachment

  private
  def size_validation
    errors[:name] << "should be less than 20MB" if attachment.size > 20.megabytes
  end
end
