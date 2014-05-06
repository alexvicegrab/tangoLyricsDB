# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Genre seeds
genres = Genre.create([ { name: "Tango" }, 
  { name: "Vals" }, 
  { name: "Milonga" },
  { name: "Candombe" }, 
  { name: "Foxtrot" }, 
  { name: "Otros Ritmos" }])
  
# Initial song seeds
