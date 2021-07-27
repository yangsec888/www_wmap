#--
# www_wmap
#
# A  Ruby application for enterprise web application asset tracking
#
# Developed by Sam (Yang) Li, <yang.li@owasp.org>.
#
#++

module SiteUrlsHelper

  # Reload site table based on the current WMAP discovery data file
  def site_urls_table_update(uid,data_dir)
    puts "Update the site url table ..."
    db = Sequel.connect(ENV['DATABASE_URL'])
    puts "Database connection success. "
    urls_table = db[:site_urls]
    #site_table.truncate
    #puts "site table truncate success."
    tracker=Wmap::SiteTracker.instance
    tracker.data_dir=data_dir
    tracker.sites_file = tracker.data_dir + "/" + "sites"
    tracker.load_site_stores_from_file(tracker.sites_file)
    urls_file = tracker.data_dir + "/logs/" + "cur_urls.log"
    urls = tracker.file_2_list(urls_file)
    sites = tracker.known_sites.keys
    urls.map do |url|
      site = tracker.url_2_site(url).downcase
      if sites.include?(site)
        url_count = urls_table.where(:url =>url).count
        if url_count < 1
          puts "Insert record for url: #{url}"
          urls_table.insert(site: site,  url: url, user_id: uid, created_at: Time.now, updated_at: Time.now)
        else
          puts "Update the url timestamps: #{url}"
          urls_table.where(:url =>url).update(updated_at: Time.now)
        end
      else
        next
      end
    end

    tracker=nil
    db = nil
    puts "Update complete. "
  end

end
