class RdLookupController < ApplicationController
  discovery \
    index: { rt: 'coap.rd-lookup' }

  def index
  end
end
