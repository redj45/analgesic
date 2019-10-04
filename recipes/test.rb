node.default['test_attrs'].tap do |test_attr|
  test_attr['me'] = 'inf'
  test_attr['you'] = node['test_attrs']['you'] + 'square'
  test_attr['we'] = ['uni']
end

extend Analgesic::DatabagMagic

reload_attributes(attribute_key_name: 'test_attrs', data_bag_collection: 'my_data_bag_about_hosts')

puts "TEST: #{ node['test_attrs'] }"
