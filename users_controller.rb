class UsersController < ApplicationController
    before_action :authenticate_user!
    def update
      @user = current_user
      if @user.customer.update(customer_params)
        redirect_to profile_path, notice: 'Profile was successfully updated.'
      else
        render :show, status: :unprocessable_entity
      end
    end

    def show
      @user = current_user
    end

    private

    def customer_params
      params.require(:customer).permit(:address, :province_id)
    end

    
end