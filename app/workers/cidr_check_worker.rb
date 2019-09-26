#--
# www_wmap
#
# A  Ruby application for enterprise web application asset tracking
#
# Developed by Sam (Yang) Li, <yang.li@owasp.org>.
#
#++


class CidrCheckWorker
  include Sidekiq::Worker
  include CidrsHelper
  sidekiq_options retry: false


  def on_complete(uid,start_time,data_dir)
    #receiver=User.find(uid).email
    #logger.info "Sending out email notice to: #{receiver}"
    #end_time=Time.now.to_s
    #UserMailer.discovery_completion_notice(receiver, start_time, end_time).deliver_later
    cidr_table_reload(uid,data_dir)
  end


  def perform(uid,dir,new_cidrs)
    puts "Start background sanity check on the new cidrs: #{new_cidrs}"
    start_time = Time.now
    k=Wmap::CidrTracker.new
    k.data_dir = dir
    k.cidr_seeds = dir + "/" + "cidrs"
    k.load_cidr_blks_from_file(k.cidr_seeds)
    new_cidrs.keys.map { |key| k.add(key) }
    k.save!
    k=nil 
    on_complete(uid,start_time,dir.to_s)
  end

end
