namespace :rdoc do
  require 'sdoc'
  require 'rdoc/task'

  RDoc::Task.new do |rdoc|
    rdoc.rdoc_dir = 'doc/rdoc'
    rdoc.generator = 'sdoc'
    rdoc.template = 'rails'
    rdoc.main = 'README.md'
    rdoc.rdoc_files.include('README.md', 'Setup.md', 'app/', 'lib/')
  end


end
