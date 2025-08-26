# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Clear existing data in development
if Rails.env.development?
  Transfer.destroy_all
  Article.destroy_all
  Person.destroy_all
end

# Create 3 people
people = [
  { first_name: "Juan", last_name: "Pérez" },
  { first_name: "María", last_name: "González" },
  { first_name: "Carlos", last_name: "Rodríguez" }
]

people.each do |person_attrs|
  Person.find_or_create_by!(person_attrs)
end

puts "Created #{Person.count} people"

# Get the created people
juan = Person.find_by!(first_name: "Juan", last_name: "Pérez")
maria = Person.find_by!(first_name: "María", last_name: "González")
carlos = Person.find_by!(first_name: "Carlos", last_name: "Rodríguez")

# Create 5 articles
articles_data = [
  { brand: "Dell", model: "Latitude 5520", entry_date: 1.year.ago.to_date, current_person: juan },
  { brand: "HP", model: "EliteBook 840", entry_date: 8.months.ago.to_date, current_person: maria },
  { brand: "Lenovo", model: "ThinkPad X1 Carbon", entry_date: 6.months.ago.to_date, current_person: carlos },
  { brand: "Apple", model: "MacBook Pro 14", entry_date: 4.months.ago.to_date, current_person: juan },
  { brand: "ASUS", model: "ZenBook 14", entry_date: 2.months.ago.to_date, current_person: maria }
]

articles_data.each do |article_attrs|
  Article.find_or_create_by!(
    brand: article_attrs[:brand],
    model: article_attrs[:model]
  ) do |article|
    article.entry_date = article_attrs[:entry_date]
    article.current_person = article_attrs[:current_person]
  end
end

puts "Created #{Article.count} articles"

# Create 2 transfers
# Transfer 1: Dell laptop from Juan to María
dell_laptop = Article.find_by!(brand: "Dell", model: "Latitude 5520")
transfer1 = Transfer.find_or_create_by!(
  article: dell_laptop,
  from_person: juan,
  to_person: maria,
  transfer_date: 3.months.ago.to_date,
  notes: "Transferred for new project assignment"
)

# Transfer 2: HP laptop from María to Carlos
hp_laptop = Article.find_by!(brand: "HP", model: "EliteBook 840")
transfer2 = Transfer.find_or_create_by!(
  article: hp_laptop,
  from_person: maria,
  to_person: carlos,
  transfer_date: 1.month.ago.to_date,
  notes: "Department reorganization"
)

puts "Created #{Transfer.count} transfers"

puts "\nSeed data summary:"
puts "- #{Person.count} people"
puts "- #{Article.count} articles"
puts "- #{Transfer.count} transfers"

# Display current article carriers
puts "\nCurrent article assignments:"
Article.includes(:current_person).each do |article|
  puts "- #{article.brand} #{article.model}: #{article.current_person.full_name}"
end
