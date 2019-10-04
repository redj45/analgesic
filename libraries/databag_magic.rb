# MIT License

# Copyright:: (c) 2019 Denis Pischuhin https://github.com/redj45
# Copyright:: (c) 2019 Nikolay Fedorov https://github.com/iadanos

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

module Analgesic
  # Within your recipe you would write:
  #
  # extend Analgesic::DatabagMagic
  #
  # reload_attributes
  #
  module DatabagMagic
    def reload_attributes(attribute_key_name:, data_bag_collection: 'hosts', data_bag_id: node['fqdn'], attribute_type_from: 'default', attribute_type_to: 'force_default')
      # checking data_bag

      # if attribute_key_name.nil? raise 'Fail! Undefined `attribute_key_name`'
      # end

      attributes_types = %w(default force_default override force_override)

      begin
        if attributes_types.include?(attribute_type_from) && attributes_types.include?(attribute_type_to)
          data_cfg = data_bag_item(data_bag_collection, data_bag_id)
          data_merge = Chef::Mixin::DeepMerge

          data_new = data_merge.hash_only_merge!(node.send(attribute_type_from)[attribute_key_name], data_cfg[attribute_key_name])

          node.send(attribute_type_to)[attribute_key_name] = data_new

          run_context.loaded_attributes.each do |attribute_file|
            puts "Files attributes: #{ attribute_file } =>> #{ attribute_file.split('::')[1] }"
            puts "Current cookbook: #{ current_cookbook }"
            @data_recompiled = node.from_file(run_context.resolve_attribute(current_cookbook, attribute_file.split('::')[1]))
          end

          data_recompiled_reloaded = data_merge.hash_only_merge!(@data_recompiled, data_cfg[attribute_key_name])

          node.send(attribute_type_to)[attribute_key_name] = data_recompiled_reloaded
        else
          raise "Fatal! You want use undeclared attributes type: #{ attribute_type_from } #{ attribute_type_to }\n \
                You must use only one from [default, force_default, overrice, force_verride]"
        end
      rescue StandardError
        puts "There's something very wrong with us... We get out!"
      end
    end
  end
end

Chef::Recipe.include(Analgesic::DatabagMagic)
Chef::Resource.include(Analgesic::DatabagMagic)
