namespace :wmap do
  desc "Refresh Wordpress data file task"
  task wp_refresh: :environment do |task|
    puts "Refresh Wordpress data in local data file ..."
    k=Wmap::WpTracker.new()
    k.refresh(20,false)
    k.save!
    k=nil
    puts "Task completed. "
  end

  desc "Reload database site table task"
  task site_table_reload: :environment do |task|
    puts "Update the site table ..."
    db = Sequel.connect(YAML.load(File.read(File.join(::Rails.root, 'config', 'database.yml')))[::Rails.env] || 'development')
    puts "Database connection success. "
    site_table = db[:sites]
    site_table.truncate
    puts "Site table truncate success."
    k=Wmap::SiteTracker.instance
    y=Wmap::DomainTracker.instance
    k.known_sites.each do |key, val|
      my_host = k.url_2_host(key)
      my_domain_root=k.get_domain_root(my_host)
      if y.domain_known?(my_domain_root)
        puts "Insert record for site: #{key}"
        site_table.insert(site: key, ip: val["ip"], port: val["port"], status: val["status"], \
          server: val["server"], redirection: val['redirection'], md5: val["md5"], \
          code: val["code"], created_at: Time.now, updated_at: Time.now)
      else
        next
      end
    end
    k=y=nil
    db.disconnect
    puts "Task completed. "
  end


end
