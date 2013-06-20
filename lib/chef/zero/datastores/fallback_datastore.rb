#
# Author:: Jeff Bellegarde (<jbellegarde@whitepages.com>)
# Copyright:: Copyright (c) 2013 Whitepages.com, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'forwardable'
require 'set'
module Chef
  module Zero
    module DataStores
      class FallbackStore
        attr_accessor :read_write_store
        extend Forwardable
        def_delegators :@read_write_store, :clear, :create_dir, :create, :set, :delete, :delete_dir

        def initialize(read_write_store, *read_only_stores)
          @read_write_store = read_write_store
          @read_only_stores = read_only_stores
        end

        def get(path, request=nil)
          all_stores.each do |store|
            result = store.get(path, request)
            return result if result
          end
          nil
        end

        def list(path)
          Set.new(all_stores.map {|s| s.list(path)}.flatten).to_a.sort
        end

        def exists?(path)
          !(all_stores.find {|s| s.exists?(path)}.nil?)
        end

        def exists_dir?(path)
          !(all_stores.find {|s| s.exists_dir?(path)}.nil?)
        end

        private

        def all_stores
          [@read_write_store, *@read_only_stores]
        end
      end
    end
  end
end
