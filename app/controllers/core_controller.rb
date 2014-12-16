class CoreController < ApplicationController
  def index
    query = params.except(:controller, :action)

    if query.empty?
      @links = TypedLink.all
    elsif query[:rt] == 'core.rd*'
      @links = TypedLink
        .joins(:target_attributes)
        .where(target_attributes: {type: 'rt'})
        .where('target_attributes.value like ?', 'core.rd%')
    else
      @links = TypedLink
        .joins(:target_attributes)
        .where(target_attributes: {type: query.keys, value: query.values})
    end

    if @links.empty?
      head :not_found
    else
      render text: @links.to_link
    end
  end
end
