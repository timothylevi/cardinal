puts "1. Start Destroying everything"
User.destroy_all
ContactDetail.destroy_all
Petition.destroy_all
Victory.destroy_all
Recipient.destroy_all
PetitionRecipient.destroy_all
PetitionSignature.destroy_all
Cause.destroy_all
puts "   Finish Destroying everything\n"


# -----

causes = [
  "animals", "criminal_justice", "disabled_rights",
  "economic_justice", "education", "environment",
  "gay_rights", "health", "human_rights",
  "human_trafficking", "immigrant_rights", "sports",
  "sustainable_food", "technology", "feminism"
  ]

def create_cause(name)
  Cause.create(name: name)
end

def create_petition(user, count)
  count.times do |i|
    user.petitions.create(
    title: Faker::Company.catch_phrase,
    body: Faker::Lorem.paragraph(3),
    background: Faker::Lorem.paragraph(6),
    goal: 21)
  end
end

def create_fake_victory(petition)
  petition.create_victory(
  description: Faker::Lorem.paragraph(1),
  message: Faker::Lorem.paragraph(6))
  petition.update_attributes(is_victory: true)
end


puts "2. Start Creating my account"
m = User.create!(
              email: "tlc9406@gmail.com",
              password: "password",
              name: "Timothy Levi Campbell")
puts "   Finish Creating my account\n"


puts "3. Start Creating new users"
50.times do |i|
  name = Faker::Name.name

  u = User.new(email: Faker::Internet.safe_email(name),
              password: "password",
              name: name)
  puts "- Creating user #{u.id} - #{u.name}"

  u.save! if u.valid?
end
puts "  Finish Creating new users\n"

puts "4. Start Creating Contact Details and Petitions"
User.find_in_batches do |batch|
  batch.each do |user|
    user.contact_details.create(
      street_address: Faker::Address.street_address,
      city: Faker::Address.city,
      state: Faker::Address.state_abbr,
      zip: Faker::Address.zip[0..4],
      phone: Faker::PhoneNumber.phone_number,
      country: "United States",
      description: Faker::Lorem.paragraph(6),
      website: Faker::Internet.url)
      puts " - created CD for user #{user.id}" if user.contact_details

    if (user.id % 2 == 0)
      create_petition(user, 1)
    elsif (user.id % 3 == 0)
      create_petition(user, 2)
    end
    puts "4a. Creates petitions for user #{user.id}" if user.petitions
  end
end
puts "   End creating Contact Details and Petitions\n"

puts "5. Creating Causes"
causes.each do |cause|
  create_cause(cause)
end

Petition.find_each do |petition|
  petition.petition_causes
    .create(cause_id: rand(Cause.first.id..Cause.last.id))
  petition.save
end
puts "   Finishes creating causes"


puts "6. Start Creating PetitionSignatures"
1000.times do |i|
  j = User.find(rand(User.first.id..User.last.id))
  k = Petition.find(rand(Petition.first.id..Petition.last.id))
  unless PetitionSignature.find_single(j, k)
    PetitionSignature.create(user_id: j.id, petition_id: k.id)
  end
end
puts "   End Creating PetitionSignatures"


puts "7. Creates Recipients"
Congress.key = ENV["CONGRESS_KEY"]
m = User.first
legislators = Congress.legislators(per_page: "all")[:results]

legislators.each do |legislator|
  recipient = m.recipients.create(
    title: legislator[:title],
    first_name: legislator[:first_name],
    middle_name: legislator[:middle_name],
    last_name: legislator[:last_name],
    bioguide_id: legislator[:bioguide_id],
    gov_state: legislator[:state],
    office: legislator[:office],
    party: legislator[:party])

  recipient.contact_details.create(
    phone: legislator[:phone],
    birthday: legislator[:birthday],
    website: legislator[:website],
    contact_form: legislator[:contact_form],
    twitter_id: legislator[:twitter_id],
    facebook_id: legislator[:facebook_id],
    zip: "xxxxx"
  )
end
puts "   Finishes creating recipients"

puts "8. Getting Recipients' descriptions"
Recipient.set_descriptions
puts "   Finishes seeding descriptions"


puts "9. Sets images for Recipients"
Recipient.set_images
puts "   Finishes setting images for Recipients"


puts "10. Creates PetitionRecipients"
Petition.find_in_batches do |batch|
  batch.each do |petition|
    3.times do
      j = rand(Recipient.first.id..Recipient.last.id)
      k = petition.id

      unless PetitionRecipient.find_single(j, k)
        petition.petition_recipients.create(recipient_id: j)
      end
    end

    if (petition.id % 7 == 0)
      create_fake_victory(petition)
    end
  end
end
puts "   Finished PetitionRecipients"
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
