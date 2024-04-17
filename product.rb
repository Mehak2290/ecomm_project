class Product < ApplicationRecord
  has_one_attached :image
  belongs_to :category
  has_many :order_items

  def self.ransackable_associations(auth_object = nil)
    %w[category]
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[id name description price  created_at updated_at]
  end

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :category_id, presence: true
end
