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
require 'chef_zero'
require 'chef_zero/data_store/data_not_found_error'
require 'json'

module Chef
  module Zero
    module DataStores
      class FilesystemStore
        attr_accessor :directory

        def initialize(directory)
          @directory = directory
        end

        def get(path, request=nil)
          if exists?(path)
            JSON.parse(File.read(file_path(path)))
          else
            raise ChefZero::DataStore::DataNotFoundError.new(path)
          end
        end

        def list(path)
          if exists_dir?(path)
            Dir.entries(dir_path(path))
              .reject {|s| s=~/^\./}
              .map    {|s| s =~ /(.*)\.json$/ ? $~[1] : s}
          else
            raise ChefZero::DataStore::DataNotFoundError.new(path)
          end
        end

        def exists?(path)
          File.exists?(file_path(path))
        end

        def exists_dir?(path)
          Dir.exists?(dir_path(path))
        end

        private

        def file_path(path)
          "#{dir_path(path)}.json"
        end

        def dir_path(path)
          File.join(directory, path)
        end

      end
    end
  end
end
