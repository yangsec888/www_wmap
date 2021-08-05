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

  # parse the urls list then generate the tree data structure
  def urls_2_tree (site, urls)
    $tree = []
    $tree << { 'text' => site,
               'children' => [], 'icon' => 'glyphicon glyphicon-list',
               'state' => { 'opened' => true } }
    urls.map do |url|
      u = url.split(site)
      if u[1].nil?
        next
      else
        nodes = u[1].split('/') - [nil,""]
        traverse_tree_branch($tree[0], nodes)
      end
    end
    return $tree
  end

  # traverse the tree branches and build the data structure in json
  def traverse_tree_branch(branch,nodes)
    node = nodes.shift
    cnt = branch['children'].count
    puts "node: #{node}"
    if has_node(branch,node)
      i = get_branch_index(branch,node)
      if nodes.count <= 0    # end of leaf
        return
      else
        traverse_tree_branch(branch['children'][i], nodes)
      end
    else
      branch['children'] << {
                  'text' => node,
                  'children' => [], 'icon' => 'glyphicon glyphicon-list',
                  'state' => { 'opened' => true }
      }
      if nodes.count <= 0    # end of leaf
        return
      else
        traverse_tree_branch(branch['children'][cnt],nodes)
      end
    end
  end

  # check if the node was existing in the tree branch
  def has_node(branch,node)
    default = false
    return false if branch['children'].count==0
    branch['children'].map do |leaf|
      if leaf['text'] == node
        return true
      end
    end
    return default
  end

  # Given branch is certain of the existing tree, found the index of the branch in the tree
  def get_branch_index(branch,node)
    branch['children'].each_with_index.map do |l,i|
      return i if l['text'] == node
    end
  end

  # write an worksheet row
  def worksheet_write_row(worksheet, index, my_row)
    puts "Writing record into the spreadsheet: #{my_row}"
    (0...my_row.count).map do |col|
      worksheet.add_cell(index, 0, '') if worksheet[index].nil?
      worksheet.add_cell(index,col,'') if worksheet[index][col].nil?
      puts "Write to cell [#{index},#{col}]: #{my_row[col]}"
      worksheet[index][col].change_contents(my_row[col])
    end
  end

end
