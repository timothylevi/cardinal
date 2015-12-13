# == Schema Information
#
# Table name: petition_signatures
#
#  id          :integer          not null, primary key
#  user_id     :integer          not null
#  petition_id :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class PetitionSignature < ActiveRecord::Base
  #attr_accessible :user_id, :petition_id

  validates :user_id, :petition_id, presence: true

  belongs_to :user
  belongs_to :petition

  def self.find_single(user, petition)
    if user && petition
      user_id = user.id
      petition_id = petition.id
      PetitionSignature.find_by_user_id_and_petition_id(user_id, petition_id)
    else
      nil
    end
  end
end
