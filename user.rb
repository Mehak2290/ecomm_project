class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # validates :email, presence: true, uniqueness: true
  # validates :name, presence: true
  # validates :password, presence: true, length: { minimum: 6 }, on: :create
  has_one :customer, dependent: :destroy
  accepts_nested_attributes_for :customer
end
