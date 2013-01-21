require "obix"
require "minitest/unit"
require "minitest/autorun"
require "active_support/all"

require "test_helper"

class ConfigurationTest < MiniTest::Unit::TestCase
  def test_configures
    OBIX::Configuration.configure do |config|
      config.username = "username"
      config.password = "password"
      config.scheme   = "scheme"
      config.host     = "host"
    end

    assert_equal "username", OBIX::Configuration.username
    assert_equal "password", OBIX::Configuration.password
    assert_equal "scheme", OBIX::Configuration.scheme
    assert_equal "host", OBIX::Configuration.host
  end
end
