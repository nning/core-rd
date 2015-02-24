class RdLookupController < ApplicationController
  VALID_PARAMS      = %i[type d ep gp et rt page count].freeze
  VALID_PARAMS_RES  = (VALID_PARAMS + CoRE::Link::VALID_ATTRS).uniq.freeze

  VALID_TYPES       = %w[d ep res gp].freeze

  def lookup
    params  = lookup_params.dup
    type    = params.delete(:type)

    head 4.00 and return unless VALID_TYPES.include?(type)

    results = Lookup.send(type.to_sym, params)

    head 4.04 and return if results.empty?

    render status: 2.05, text: results.to_link
  end

  private

  def lookup_params
    if params[:type] == 'res'
      params.permit(*VALID_PARAMS_RES)
    else
      params.permit(*VALID_PARAMS)
    end
  end
end
