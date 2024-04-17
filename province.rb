class Province < ApplicationRecord
  has_many :customers
  has_many :orders
  def self.ransackable_attributes(auth_object = nil)
    %w[name gst pst hst created_at updated_at]
  end


end
