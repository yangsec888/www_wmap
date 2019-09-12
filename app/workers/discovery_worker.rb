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
  sidekiq_options retry: false


  def on_complete(uid,start_time)
    receiver=User.find(uid).email
    logger.info "Sending out email notice to: #{receiver}"
    end_time=Time.now.to_s
    UserMailer.discovery_completion_notice(receiver, start_time, end_time).deliver_later
    site_table_reload(uid)
    host_table_reload(uid)
  end

  def perform(uid)
    start_time=Time.now.to_s
    file = Pathname.new(Gem.loaded_specs['wmap'].full_gem_path).join('data', 'seed')
    #file = Rails.root.join('shared', 'data', 'seed')
    cmd = "wmap" + " " + file.to_s
    logger.info "Starting background command: #{cmd}"
    if system(cmd)
      logger.info "Discovery successful!"
      on_complete(uid,start_time)
      #end_time=Time.now.to_s
      #receiver=User.find(uid).email
      #logger.info "Sending out email notice to: #{receiver}"
      #UserMailer.discovery_completion_notice(receiver, start_time, end_time).deliver_later
    else
      logger.info "Discovery failed!"
      logger.debug "Here's some information related to failed discovery: #{self.class.name}, #{__method__}"
    end
  end

end
