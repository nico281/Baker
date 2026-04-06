class Payment < ApplicationRecord
  belongs_to :customer
  before_validation :set_date
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :date, presence: true

  scope :recent, -> { order(date: :desc) }
  def set_date
    self.date ||= Date.today
  end
end
