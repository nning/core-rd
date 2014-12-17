class RdLookupController < ApplicationController
  def lookup
    render json: lookup_params
  end

  private

  def lookup_params
    params.permit(:d, :ep, :gp, :et, :rt, :page, :count, :'resource-param')
  end
end
