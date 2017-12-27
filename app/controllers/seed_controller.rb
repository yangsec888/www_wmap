#--
# www_wmap
#
# A  Ruby application for enterprise web application asset tracking
#
# Developed by Yang Li, <yang.li@owasp.org>. Creative Common License
#
#++

class SeedController < ApplicationController
  before_action :authenticate_user!

  def start
    @file = Rails.root.join('uploads', 'seed', current_user.id.to_s)
    @uid = current_user.id
  end

  def show
    @file = Rails.root.join('uploads', 'seed', current_user.id.to_s)
    @uid = current_user.id
  end

  def create
    file_content = params[:file_tag]
    f = Rails.root.join('uploads', 'seed', params[:uid_tag])
    file = File.open(f, 'w+')
    file.write(file_content)
    file.close
    redirect_to seed_start_path, notice: "The seed file is saved!"
  end

  def dis_test
    @file = Rails.root.join('uploads', 'seed', current_user.id.to_s)
    puts "Parsing the discovery seed file: \"#{@file}\" "
    scanner = Wmap::PortScanner.new(:verbose=>false, :socket_timeout=>600) # default time-out of 600 milliseconds
    @hosts=Array.new
    seeds=scanner.file_2_list(@file)-[nil,""]
    puts "Discovery seeds: #{seeds}"
    @domains=Array.new
    @cidrs=Array.new
    raise "Error: empty seed file or no legal entry found!" if seeds.nil? or seeds.empty?
    seeds.map do |x|
      x=x.split(%r{(,|\s+)})[0]
      urls.push(x) if scanner.is_url?(x)
      @domains.push(x) if scanner.is_domain_root?(x) or Wmap.sub_domain_known?(x)
      # invoke bruter if the hostname contains a numeric number.
      @domains.push(x) if scanner.is_fqdn?(x) and (x.split('.')[0] =~ /\d+/)
      @hosts.push(x) if scanner.is_fqdn?(x) or scanner.is_ip?(x)
      @cidrs.push(x) if scanner.is_cidr?(x)
    end
    puts "Parsing done. "
    @hosts+=Wmap::DnsBruter.new(:verbose=>false).dns_brute_workers(@domains.uniq).values.flatten if @domains.size > 0
    @cidrs.map { |x| @hosts+= scanner.cidr_2_ips(x) } if @cidrs.size > 0

  end



end
