# TODO Move model logic to model
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
    rr = ResourceRegistration.find(params[:id])
    rr.destroy!

    head :accepted
  end

  def update
    r = ResourceRegistration.find(params[:id])

    begin
      r.transaction do
        r.update!(update_params)

        links = CoRE::Link.parse_multiple(request.body.read)

        links.each do |link|
          # This does not work, strangely:
          # l = r.typed_links.first_or_initialize(path: link.uri)

          l   = r.typed_links.where(path: link.uri).first
          l ||= r.typed_links.build(path: link.uri)

          link.attrs.each do |type, value|
            a = l.target_attributes.first_or_initialize(type: type)
            a.update!(value: value)
          end
        end

        r.save!
      end
    rescue
      head :bad_request and return
    end

    head 204
  end

  private

  def create_params
    params.permit(:ep, :d, :et, :lt, :con)
  end

  def update_params
    params.permit(:lt, :con)
  end
end
