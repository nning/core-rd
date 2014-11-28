class CoreController < ApplicationController
  def create
  end

  def index
    # env['coap.multicast']

    if ['core.rd', 'core.rd*'].include?(params[:rt])
      render link: '</rd>;rt=core.rd' and return
    end

    render link: ''
  end
end
