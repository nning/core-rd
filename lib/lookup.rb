class Lookup
  class << self
    def res(params)
      TypedLink.filter(params)
    end

#   %i[d ep gp].each { |m| define_method(m) { |p| [] } }
  end
end
