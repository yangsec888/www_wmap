# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Report.destroy_all

Report.create!([
{
  title: "All Websites",
  description: "All live websites that are stored within our system.",
  department: "IT",
  published: true
},
{
  title: "All Domains",
  description: "All registrated domains belong to us, that's stored within our system.",
  department: "IT",
  published: true
},
{
  title: "All Hosts",
  description: "All hosts belong to us, that's stored within our system",
  department: "IT",
  published: true
},
{
  title: "All Networks",
  description: "All registrated networks belong to us, in CIDR format, that's stored within our system.",
  department: "IT",
  published: true
}
])

puts "Created #{Report.count} Reports"
