require File.expand_path('../helper',__FILE__)

class TestRackPiwik < Test::Unit::TestCase

  context "Asynchronous" do
    context "default" do
      setup { mock_app :async => true, :tracker => 'somebody', :piwik_url => 'piwik.example.org', :piwik_id => '123' }
      should "show asynchronous tracker" do
        get "/"
        assert_match %r{https://piwik.example.org/}, last_response.body
        assert_match %r{123\);}, last_response.body
        assert_match %r{</script>\n<!-- End Piwik Code --></head>}, last_response.body
        assert_equal "538", last_response.headers['Content-Length']
      end

      setup { mock_app :async => true, :multiple => true, :tracker => 'gonna', :piwik_url => 'piwik.example.org', :piwik_id => '123'  }
      should "not add tracker to none html content-type" do
        get "/test.xml"
        assert_no_match %r{Piwik}, last_response.body
        assert_match %r{Xml here}, last_response.body
      end

      setup { mock_app :async => true, :multiple => true, :tracker => 'gonna', :piwik_url => 'piwik.example.org', :piwik_id => '123'  }
      should "not add without </head>" do
        get "/bob"
        assert_no_match %r{Piwik}, last_response.body
        assert_match %r{bob here}, last_response.body
      end
    end

  end

=begin
  context "Synchronous" do
    setup { mock_app :async => false, :tracker => 'whatthe', :piwik_url => 'piwik.example.org', :piwik_id => '123'  }
    should "show non-asynchronous tracker" do
      get "/bob"
      assert_match %r{.getTracker}, last_response.body
      assert_match %r{</script></body>}, last_response.body
      assert_match %r{\"whatthe\"}, last_response.body
    end
  end
=end
end
