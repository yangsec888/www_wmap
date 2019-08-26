#--
# www_wmap
#
# A  Ruby application for enterprise web application asset tracking
#
# Developed by Sam (Yang) Li, <yang.li@owasp.org>.
#
#++

module CidrsHelper

  # Reload CIDR table based on the WMAP CIDR data file
  def cidr_table_reload()
    puts "Update the cidr table ..."
    db = Sequel.connect(YAML.load(File.read(File.join(::Rails.root, 'config', 'database.yml')))[::Rails.env] || 'development')
    puts "Database connection success. "
    cidr_table = db[:cidrs]
    cidr_table.truncate
    puts "cidr table truncate success."
    tracker=Wmap::CidrTracker.new
    tracker.known_cidr_blks.each do |key, val|
      cidr_table.insert(owed_cidr: key,  ref: val['ref'], netname: val['netname'], user_id: current_user.id, created_at: Time.now, updated_at: Time.now)
    end
    tracker=nil
    db = nil
    puts "Update complete. "
  end

end
