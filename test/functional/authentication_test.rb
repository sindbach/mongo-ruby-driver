# Copyright (C) 2009-2013 MongoDB, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'test_helper'
require 'shared/authentication/authentication_shared'
require 'shared/authentication/sasl_plain_shared'

class AuthenticationTest < Test::Unit::TestCase
  include Mongo
  include AuthenticationTests
  include SASLPlainTests

  def setup
    @client = MongoClient.new(TEST_HOST, TEST_PORT)
    @db     = @client[TEST_DB]
    init_auth
  end

  def test_authenticate_with_connection_uri
    silently do
      @db.add_user('eunice', 'uritest')

      client =
        MongoClient.from_uri("mongodb://eunice:uritest@#{host_port}/#{@db.name}")

      assert client
      assert_equal client.auths.size, 1
      assert client[TEST_DB]['auth_test'].count

      auth = client.auths.first
      assert_equal @db.name, auth[:db_name]
      assert_equal 'eunice', auth[:username]
      assert_equal 'uritest', auth[:password]
    end
  end
end