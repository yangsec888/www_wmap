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
  title: "Domain Portfolio - Division 1",
  description: "Divisional workbooks - Divison 1 Portfolio.",
  department: "IT",
  division: "division_1",
  category: "domain",
  published: true
},
{
  title: "Domain Portfolio - Division 2",
  description: "Divisional workbooks - Divison 2 Portfolio.",
  department: "IT",
  division: "division_2",
  category: "domain",
  published: true
},
{
  title: "Domain Portfolio - Division 3",
  description: "Divisional workbooks - Divison3 Portfolio.",
  department: "IT",
  division: "division_3",
  category: "domain",
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
