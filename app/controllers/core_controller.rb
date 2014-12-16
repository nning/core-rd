class CoreController < ApplicationController
  def index
    @links = TypedLink.filter(params.except(:controller, :action))

    if @links.empty?
      head :not_found
    else
      render text: @links.to_link
    end
  end
end
