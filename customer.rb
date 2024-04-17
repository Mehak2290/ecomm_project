class Customer < ApplicationRecord
  belongs_to :user
  has_many :orders
  belongs_to :province
  validates :name, presence: true
  def self.ransackable_associations(auth_object = nil)
    %w[orders province user]
  end
  def self.ransackable_attributes(auth_object = nil)
    %w[name email address created_at updated_at province_id]
  end
end

