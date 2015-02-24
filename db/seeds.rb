r = ResourceRegistration.new(ep: '::1')

#['', '-group', '-lookup'].each do |suffix|
['', '-lookup'].each do |suffix|
  l = r.typed_links.build(uri: '/rd' + suffix)
  l.target_attributes.build(type: 'rt', value: 'core.rd' + suffix)
end

r.save!(validate: false)
