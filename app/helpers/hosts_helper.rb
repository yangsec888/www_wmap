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
  def host_table_reload()
    puts "Update the host table ..."
    db = Sequel.connect(YAML.load(File.read(File.join(::Rails.root, 'config', 'database.yml')))[::Rails.env] || 'development')
    puts "Database connection success. "
    host_table = db[:hosts]
    host_table.truncate
    puts "host table truncate success."
    tracker=Wmap::HostTracker.instance
    tracker.known_hosts.each do |key, val|
      block = /\d{,2}|1\d{2}|2[0-4]\d|25[0-5]/
      re = /\A#{block}\.#{block}\.#{block}\.#{block}\z/
      next if re =~ key
      host_table.insert(host_name: key,  ip: val, \
        uid: current_user.id, created_at: Time.now, updated_at: Time.now)
    end
    tracker=nil
    db = nil
    puts "Update complete. "
  end

end
