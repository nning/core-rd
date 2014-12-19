r = ResourceRegistration.new(ep: '::1')

['', '-group', '-lookup'].each do |suffix|
  l = r.typed_links.build(path: '/rd' + suffix)
  l.target_attributes.build(type: 'rt', value: 'core.rd' + suffix)
end

r.save!(validate: false)
