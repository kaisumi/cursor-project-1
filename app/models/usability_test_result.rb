class UsabilityTestResult < ApplicationRecord
  belongs_to :usability_test
  belongs_to :user
  
  validates :completion_time, presence: true, numericality: { greater_than: 0 }
  validates :difficulty_rating, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :success, inclusion: { in: [true, false] }
end
