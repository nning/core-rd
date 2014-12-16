class TargetAttribute < ActiveRecord::Base
  belongs_to :typed_link

  self.inheritance_column = :sti

  def to_a
    [self.type.to_sym, self.value]
  end

  def self.to_h(attributes = nil)
    a = attributes.nil? ? all : where(id: attributes)
    a.map(&:to_a).to_h
  end
end
