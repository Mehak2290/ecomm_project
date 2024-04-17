class ProvincesController < ApplicationController
    def tax_rates
      province = Province.find(params[:id])
      render json: { gst: province.gst, pst: province.pst, hst: province.hst }
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Province not found" }, status: :not_found
    end
  end