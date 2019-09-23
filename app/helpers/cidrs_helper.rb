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
  def cidr_table_reload(uid,data_dir)
    puts "Update the cidr table ..."
    db = Sequel.connect(ENV['DATABASE_URL'])
    puts "Database connection success. "
    cidr_table = db[:cidrs]
    cidr_table.truncate
    puts "cidr table truncate success."
    tracker=Wmap::CidrTracker.new(:data_dir => data_dir)
    tracker.known_cidr_blks.each do |key, val|
      cidr_table.insert(owed_cidr: key,  ref: val['ref'], netname: val['netname'], user_id: uid, created_at: Time.now, updated_at: Time.now)
    end
    tracker=nil
    db = nil
    puts "Update complete. "
  end

end
