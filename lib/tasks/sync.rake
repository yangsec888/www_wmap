namespace :sync do
  require "wmap"
  require "sequel"

  desc "Sync division column from domains to tags db table"
  task tag_division: :environment do |task|
    puts "Refresh tag division column in db table ..."
    k = Wmap::DomainTracker.instance
    db = Sequel.connect(YAML.load(File.read(File.join(::Rails.root, 'config', 'database.yml')))[::Rails.env] || 'development')
    dataset_tag = db[:tags]
    puts "Database connection success. "
    # build custom hash based on domain table
    domain_hash = Hash.new
    db['select name, division from domains'].all.map do |entry| # [{:name:"domain1",:division:"ca"},{name:"domain2",:division:"cm"}]
      domain_hash.merge!({entry[:name] => entry[:division]})
    end
    # build tag custom data set
    tag_roll = db['select site from tags']
    # iterate through custom data set, calculate the division based on the hash above, then update the record accordingly
    tag_roll.all.map do |tag|
      my_host = k.url_2_host(tag[:site])
      my_domain = k.domain_root(my_host)
      if domain_hash.key?(my_domain)
        my_division = domain_hash[my_domain]
      else
        my_division = nil
      end
      puts "Update tag table: #{tag[:site]} => #{my_division}"
      dataset_tag.where(:site => tag[:site]).update(:division => my_division)
    end
    puts "Task completed. "
    db.disconnect
    k = nil
  end


end
