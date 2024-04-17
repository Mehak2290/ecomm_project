class Order < ApplicationRecord
    belongs_to :customer
    has_many :order_items, dependent: :destroy
    has_many :products, through: :order_items
    belongs_to :province, optional: true 
   

    def self.ransackable_attributes(auth_object = nil)
      %w[id created_at updated_at total]
    end

     def self.ransackable_associations(auth_object = nil)
  
       %w[customer order_items  products province]
     end
  
  
    accepts_nested_attributes_for :order_items
  
    before_save :calculate_total
  
    def calculate_total
      self.subtotal = order_items.to_a.sum { |item| (item.quantity || 0) * (item.price || 0) }
      self.gst = 0
      self.pst = 0
      self.hst = 0
    
      calculate_taxes 
    

      self.total = subtotal + gst + pst + hst
    end
    
    private
  
    def calculate_taxes
      provinceName = customer.province
      province_tax_rates = provinceName.present? ? provinceName.attributes.slice('gst', 'pst', 'hst') : {}
      self.gst = subtotal * (province_tax_rates['gst'] || 0) / 100
      self.pst = subtotal * (province_tax_rates['pst'] || 0) / 100
      self.hst = subtotal * (province_tax_rates['hst'] || 0) / 100
    end
  
  end
  
