#--
# www_wmap
#
# A  Ruby application for enterprise web application asset tracking
#
# Developed by Sam (Yang) Li, <yang.li@owasp.org>.
#
#++


class DomainCheckWorker
  include Sidekiq::Worker
  include DomainsHelper
  sidekiq_options retry: false


  def on_complete(uid,start_time,data_dir)
    #receiver=User.find(uid).email
    #logger.info "Sending out email notice to: #{receiver}"
    #end_time=Time.now.to_s
    #UserMailer.discovery_completion_notice(receiver, start_time, end_time).deliver_later
    domain_table_reload(uid,data_dir.to_s)
  end


  def perform(uid,dir,new_domains)
    puts "Start background sanity check on the new domains: #{new_domains}"
    start_time = Time.now
    k=Wmap::DomainTracker.instance
    k.data_dir = dir
    k.domains_file = dir + "/" + "domains"
    k.load_domains_from_file(k.domains_file)
    k.adds(new_domains.keys)
    k.save!
    on_complete(uid,start_time,dir.to_s)
  end

end
