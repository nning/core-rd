class RdGroupController < ApplicationController
  def create
    render json: create_params
  end

  def destroy
  end

  private

  def create_params
    params.permit(:gp, :d, :con)
  end
end
