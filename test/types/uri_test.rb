require "obix"
require "minitest/unit"
require "minitest/autorun"
require "nokogiri"
require "active_support/all"

require "test_helper"

class URITest < MiniTest::Unit::TestCase
  def setup
    @object = OBIX::Objects::Object.new
    @type   = OBIX::Types::URI.new @object
  end

  def test_cast
    assert_equal "http://example.org/", @type.cast("http://example.org/")
  end

  def test_concatenates
    obix = OBIX::Builder.new do |obix|
      obix.obj href: "http://domain/" do |obix|
        obix.obj href: "path/"
      end
    end

    assert_equal "http://domain/path/", obix.object.objects.first.href
  end

  def test_derives_base_uri_from_request
    builder = OBIX::Builder.new do |obix|
      obix.obj do |obix|
        obix.obj href: "path/"
      end
    end

    OBIX::Network.
      expects(
        :get
      ).
      returns(
        builder.object.to_xml
      )

    object = OBIX.parse url: "http://domain"

    assert_equal "http://domain/path/", object.objects.first.href
  end
end
