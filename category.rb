class Category < ApplicationRecord
    has_many :products

    def self.ransackable_attributes(auth_object = nil)
        ["id", "name", "created_at", "updated_at"]
      end
    validates :name, presence: true, uniqueness: true
end
