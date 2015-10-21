# == Schema Information
#
# Table name: cats
#
#  id          :integer          not null, primary key
#  birth_date  :datetime
#  color       :string
#  name        :string           not null
#  sex         :string(1)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#  user_id     :integer
#

class Cat < ActiveRecord::Base
  SEC_TO_YR = 60*60*24*365
  CAT_SEXES = ['M', 'F']
  CAT_COLORS = ['brown', 'black',
    'orange', 'green', 'white', 'striped', 'spotted']

  validates :name, :sex, :birth_date, :owner, presence: true
  validates :color, inclusion: { in: CAT_COLORS, message: "Invalid color!" }
  validates :sex, inclusion: { in: CAT_SEXES, message: "Invalid sex!" }


  has_many :cat_rental_requests, dependent: :destroy
  belongs_to :owner, class_name: "User", foreign_key: :user_id, primary_key: :id
  
  def age
    ((Time.now - self.birth_date) / SEC_TO_YR).floor
  end


end
