class UsabilityTest < ApplicationRecord
  has_many :usability_test_results, dependent: :destroy
  
  validates :title, presence: true
  validates :description, presence: true
  validates :task, presence: true
  validates :token, presence: true, uniqueness: true
  
  before_validation :generate_token, on: :create
  
  private
  
  def generate_token
    self.token ||= SecureRandom.hex(10)
  end
end
