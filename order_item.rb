class OrderItem < ApplicationRecord
    belongs_to :order
    belongs_to :product
  
    validates :product, presence: true
    validates :quantity, numericality: { greater_than_or_equal_to: 0 }, presence: true
  end
  