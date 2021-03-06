# == Schema Information
#
# Table name: recipients
#
#  id                 :integer          not null, primary key
#  title              :string(255)      not null
#  first_name         :string(255)      not null
#  middle_name        :string(255)
#  last_name          :string(255)
#  bioguide_id        :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  gov_state          :string(255)
#  office             :string(255)
#  party              :string(255)
#  email              :string(255)
#  creator_id         :integer
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :recipient do |f|
    f.title "Sen"
    f.first_name "Elizabeth"
    f.last_name "Warren"
    f.bioguide_id "W000817"
    f.gov_state "MA"
    f.office "317 Hart Senate Office Building"
  end
end
