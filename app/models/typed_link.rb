class TypedLink < ActiveRecord::Base
  belongs_to  :resource_registration
  has_many    :target_attributes, dependent: :destroy

  # Instance to CoRE::Link
  def to_link
    CoRE::Link.new(uri, target_attributes.all.to_h).to_s
  end

  # Relation to CoRE::Link
  def self.to_link(links = nil)
    a = links.nil? ? all : where(id: links)
    a.map(&:to_link).join(',')
  end

  def self.filter(query)
    if query.empty?
      TypedLink.all
    elsif query[:rt] == 'core.rd*'
      TypedLink
        .joins(:target_attributes)
        .where(target_attributes: {type: 'rt'})
        .where('target_attributes.value like ?', 'core.rd%')
    else
      TypedLink
        .uniq
        .joins(:target_attributes)
        .where(target_attributes: {type: query.keys, value: query.values})
    end
  end
end
