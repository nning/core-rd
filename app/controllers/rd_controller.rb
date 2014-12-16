class RdController < ApplicationController
  discovery \
    index:  { rt: 'coap.rd' }

  def index
    render nothing: true
  end
end
