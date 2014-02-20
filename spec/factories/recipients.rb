# == Schema Information
#
# Table name: recipients
#
#  id          :integer          not null, primary key
#  title       :string(255)      not null
#  first_name  :string(255)      not null
#  middle_name :string(255)
#  last_name   :string(255)
#  bioguide_id :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :recipient do
  end
end