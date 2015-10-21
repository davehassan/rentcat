# == Schema Information
#
# Table name: cat_rental_requests
#
#  id         :integer          not null, primary key
#  cat_id     :integer          not null
#  start_date :datetime         not null
#  end_date   :datetime         not null
#  status     :string           default("PENDING"), not null
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer          not null
#

class CatRentalRequest < ActiveRecord::Base
  validates :cat_id, :start_date, :end_date, :status, :user_id, presence: true
  validates :status, inclusion: { in: ["PENDING", "APPROVED", "DENIED"] }
  validate :validate_no_overlap
  validate :valid_start_end_dates


  belongs_to :cat

  belongs_to :requester,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id


  def approve!
    CatRentalRequest.transaction do
      self.status = "APPROVED"
      self.save
      overlapping_pending_requests.each(&:deny!)
    end
  end

  def deny!
    self.status = "DENIED"
    self.save!
  end

  def pending?
    self.status == "PENDING"
  end

  private
    def overlapping_requests
      CatRentalRequest.where("end_date >= ?", self.start_date)
        .where("start_date <= ?", self.end_date)
        .where("cat_id = ?", self.cat_id)
        #.where("id != ?", self.id)
    end

    def overlapping_approved_requests
      overlapping_requests.where("status = 'APPROVED'")
    end

    def overlapping_pending_requests
      overlapping_requests.where("status = 'PENDING'")
    end

    # custom validations
    def validate_no_overlap
      if self.status == "APPROVED" && !overlapping_approved_requests.empty?
        errors.add(:overlapping_dates,
          "Can't overlap with other rental period!")
      end
    end

    def valid_start_end_dates
      if self.start_date > self.end_date
        errors.add(:overlapping_dates, "Invalid rental period!")
      end
    end


end
