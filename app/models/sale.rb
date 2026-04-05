class Sale < ApplicationRecord
  belongs_to :customer

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :description, presence: true
  validates :date, presence: true

  scope :recent, -> { order(date: :desc) }
end
