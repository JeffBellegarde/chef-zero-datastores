require 'simplecov'
SimpleCov.start do
  add_filter "/vendor/"
end

require 'chef/zero/datastores/fallback_datastore'
require 'chef/zero/datastores/filesystem_datastore'
