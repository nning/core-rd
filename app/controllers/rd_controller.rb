class RdController < ApplicationController
  def create
    raise ActionController::ParameterMissing.new(:ep) if params[:ep].blank?

    begin
      links = CoRE::Link.parse_multiple(request.body.read)
    rescue ArgumentError
      head :bad_request and return
    end

    head :bad_request and return if links.empty?

    if params[:con].nil?
      params[:con] = ResourceRegistration.default_con(request)
    end

    r = ResourceRegistration.new(create_params)

    links.each do |link|
      l = r.typed_links.build(path: link.uri)
      link.attrs.each do |type, value|
        l.target_attributes.build(type: type, value: value)
      end
    end

    r.save!

    # TODO Use path helper
    response.headers['Location'] = "/rd/#{r.id}"

    head :created
  end

  def destroy
    r = ResourceRegistration.find(params[:id])
    r.destroy!

    head :accepted
  end

  def update
    rr = ResourceRegistration.find(params[:id])

    head 204 and return if rr.update!(update_params)

    head :service_unavailable
  end

  private

  def create_params
    params.permit(:ep, :d, :et, :lt, :con)
  end

  def update_params
    params.permit(:lt, :con)
  end
end
