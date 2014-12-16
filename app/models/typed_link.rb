class TypedLink < ActiveRecord::Base
  has_many :target_attributes

  # Instance to CoRE::Link
  def to_link
    CoRE::Link.new(path, target_attributes.all.to_h).to_s
  end

  # Relation to CoRE::Link
  def self.to_link(links = nil)
    a = links.nil? ? all : where(id: links)
    a.map(&:to_link).join(',')
  end
end
