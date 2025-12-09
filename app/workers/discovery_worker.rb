#--
# www_wmap
#
# A  Ruby application for enterprise web application asset tracking
#
# Developed by Sam (Yang) Li, <yang.li@owasp.org>.
#
#++


class DiscoveryWorker
  include Sidekiq::Worker
  include SitesHelper
  include HostsHelper
  include DomainsHelper
  include SiteUrlsHelper
  sidekiq_options retry: false


  def on_complete(uid,start_time,data_dir,email,success=true)
    receiver=email
    logger.info "Sending out email notice to: #{receiver}"
    end_time=Time.now.to_s
    UserMailer.discovery_completion_notice(receiver, start_time, end_time).deliver_later
    
    # Email notification sent above - users can check discovery results manually
    
    if success
      site_table_reload(uid,data_dir)
      host_table_reload(uid,data_dir)
      domain_table_reload(uid,data_dir)
      site_urls_table_update(uid,data_dir)
    end
  end

  def perform(uid,email)
    start_time=Time.now.to_s
    #file = Pathname.new(Gem.loaded_specs['wmap'].full_gem_path).join('data', 'seed')
    dir = Rails.root.join('shared', 'data')
    file = dir.join('seed')
    import_domain_from_seed(dir.to_s,file.to_s)
    cmd = "wmap" + " -t " + file.to_s + " -d " + dir.to_s + "/" + " -v"
    logger.info "Starting background command: #{cmd}"
    if system(cmd)
      logger.info "Discovery successful!"
      on_complete(uid,start_time,dir.to_s,email,true)
    else
      logger.info "Discovery failed!"
      logger.debug "Here's some information related to failed discovery: #{self.class.name}, #{__method__}"
      # Email notification will be sent for failed discovery too
      on_complete(uid,start_time,dir.to_s,email,false)
    end
  end


end
