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
    logger.debug "Update the cidr table ..."
    db = Sequel.connect(ENV['DATABASE_URL'])
    logger.debug "Database connection success. "
    cidr_table = db[:cidrs]
    cidr_table.truncate
    logger.debug "cidr table truncate success."
    tracker=Wmap::CidrTracker.new(:data_dir => data_dir, :cidr_seeds => data_dir + "/" + "cidrs")
    tracker.load_cidr_blks_from_file(tracker.cidr_seeds)
    tracker.known_cidr_blks.each do |key, val|
      cidr_table.insert(owed_cidr: key,  ref: val['ref'], netname: val['netname'], user_id: uid, created_at: Time.now, updated_at: Time.now)
    end
    tracker=nil
    db = nil
    logger.debug "Update complete. "
  end

end
