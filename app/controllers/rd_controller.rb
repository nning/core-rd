class RdController < ApplicationController
  def create
    raise ActionController::ParameterMissing.new(:ep) if params[:ep].blank?

    begin
      links = CoRE::Link.parse_multiple(request.body.read)
    rescue ArgumentError
      head :bad_request and return
    end

    if links.empty?
      head :bad_request and return
    else
      render text: links.map(&:to_s).join(',')
    end
  end

  def destroy
  end

  def show
  end

  def update
    render json: update_params
  end

  private

  def create_params
    params.permit(:ep, :d, :et, :lt, :con)
  end

  def update_params
    params.permit(:lt, :con)
  end
end
