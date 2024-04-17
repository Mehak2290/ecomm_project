class ApplicationController < ActionController::Base
  
  before_action :configure_permitted_parameters, if: :devise_controller?
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :email, :password, :password_confirmation,
      customer_attributes: [:name, :address, :province]
    ])
  end
  
    def after_sign_in_path_for(resource)
        if resource.is_a?(Admin)
          admin_products_path 
        else
          super
        end
      end

    before_action :initialize_session
    helper_method :cart
    
    private
    
    def initialize_session
        # Initializes an empty cart as an array in the session if it doesn't already exist
        session[:cart] ||= []
    end
    
    def cart
        # Converts the session cart into a more structured array of product objects and quantities
        session[:cart].map do |item|
          product = Product.find(item["product_id"])
          {
            product: product,
            quantity: item["quantity"]
          }
      end
    end
end


