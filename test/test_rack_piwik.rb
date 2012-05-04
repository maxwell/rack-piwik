require File.expand_path('../helper',__FILE__)

class TestRackPiwik < Test::Unit::TestCase

  context "Asynchronous" do
    context "default" do
      setup { mock_app :async => true, :tracker => 'somebody', :piwik_url => 'piwik.example.org' }
      should "show asynchronous tracker" do
        get "/"
        assert_match %r{\_gaq\.push}, last_response.body
        assert_match %r{\'\_setAccount\', \"somebody\"}, last_response.body
        assert_match %r{</noscript></body>}, last_response.body
        assert_equal "532", last_response.headers['Content-Length']
      end

      setup { mock_app :async => true, :multiple => true, :tracker => 'gonna', :piwik_url => 'piwik.example.org' }
      should "not add tracker to none html content-type" do
        get "/test.xml"
        assert_no_match %r{\_gaq\.push}, last_response.body
        assert_match %r{Xml here}, last_response.body
      end

      setup { mock_app :async => true, :multiple => true, :tracker => 'gonna', :piwik_url => 'piwik.example.org' }
      should "not add without </head>" do
        get "/bob"
        assert_no_match %r{\_gaq\.push}, last_response.body
        assert_match %r{bob here}, last_response.body
      end
    end

    context "multiple sub domains" do
      setup { mock_app :async => true, :multiple => true, :tracker => 'gonna', :piwik_url => 'piwik.example.org' }
      should "add multiple domain script" do
        get "/"
        assert_match %r{'_setDomainName', \"piwik.example.org\"}, last_response.body
        assert_equal "579", last_response.headers['Content-Length']
      end
    end

    context "multiple top-level domains" do
      setup { mock_app :async => true, :top_level => true, :tracker => 'get', :piwik_url => 'piwik.example.org' }
      should "add top_level domain script" do
        get "/"
        assert_match %r{'_setDomainName', 'none'}, last_response.body
        assert_match %r{'_setAllowLinker', true}, last_response.body
      end
    end

  end

  context "Synchronous" do
    setup { mock_app :async => false, :tracker => 'whatthe', :piwik_url => 'piwik.example.org' }
    should "show non-asynchronous tracker" do
      get "/bob"
      assert_match %r{_gat._getTracker}, last_response.body
      assert_match %r{</script></body>}, last_response.body
      assert_match %r{\"whatthe\"}, last_response.body
    end
  end
end
