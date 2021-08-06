#--
# www_wmap
#
# A  Ruby application for enterprise web application asset tracking
#
# Developed by Sam (Yang) Li, <yang.li@owasp.org>.
#
#++

module HostsHelper
  # Reload host table based on the WMAP host data file
  def host_table_reload(uid,data_dir)
    puts "Update the host table ..."
    db = Sequel.connect(ENV['DATABASE_URL'])
    puts "Database connection success. "
    host_table = db[:hosts]
    host_table.truncate
    puts "host table truncate success."
    tracker=Wmap::HostTracker.instance
    tracker.data_dir = data_dir
    tracker.hosts_file = tracker.data_dir + "/" + "hosts"
    known_hosts=tracker.load_known_hosts_from_file(tracker.hosts_file)
    known_hosts.each do |key, val|
      block = /\d{,2}|1\d{2}|2[0-4]\d|25[0-5]/
      re = /\A#{block}\.#{block}\.#{block}\.#{block}\z/
      if re =~ key
        #puts "Skip host: #{key}"
        next
      else
        puts "Insert record #{key} => #{val} to host table ..."
        host_table.insert(host_name: key,  ip: val, \
          uid: uid, created_at: Time.now, updated_at: Time.now)
      end
    end
    tracker=nil
    db = nil
    puts "Update complete. "
  end

end
