['', '-group', '-lookup'].each do |suffix|
  l = TypedLink.create!(path: '/rd' + suffix)
  l.target_attributes.create!(type: 'rt', value: 'core.rd' + suffix)
end
