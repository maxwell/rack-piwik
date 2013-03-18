require File.expand_path('../helper',__FILE__)

class TestRackPiwik < Test::Unit::TestCase

  context "Asynchronous" do
    context "default" do
      setup { mock_app :async => true, :tracker => 'somebody', :piwik_url => 'piwik.example.org', :piwik_id => '123' }
      should "add tracker if body element is present" do
        get "/body_only"
        assert_match 'http://piwik.example.org/', last_response.body
        assert_match '_paq.push(["setSiteId", "123"]);', last_response.body
        assert_match %r{</noscript>\n<!-- End Piwik --></body>}, last_response.body
        assert_equal 787, last_response.headers['Content-Length'].to_i
      end

      should "omit 404 tracking for other responses with other status" do
        get "/body_only"
        assert_no_match %r{.setDocumentTitle\('404/URL}, last_response.body
      end

      should "omit addition of tracking code for non-html content" do
        get "/arbitrary.xml"
        assert_no_match %r{Piwik}, last_response.body
        assert_match %r{xml only}, last_response.body
      end

      should "omit addition of tracking code if </body> tag is missing" do
        get "/head_only"
        assert_no_match %r{Piwik}, last_response.body
        assert_match %r{head only}, last_response.body
      end
      
    end
    
    context "with a number as piwik id" do
      setup { mock_app :async => true, :tracker => 'somebody', :piwik_url => 'piwik.example.org', :piwik_id => 123 }
      should "not raise an exception" do
        assert_nothing_raised do
          get "/body_only"
        end
      end
    end
  end

=begin
  context "Synchronous" do
    setup { mock_app :async => false, :tracker => 'somebody', :piwik_url => 'piwik.example.org', :piwik_id => '123' }

    should "add tracker if body element is present" do
      get "/body_only"
      assert_match %r{https://piwik.example.org/}, last_response.body
      assert_match %r{123\);}, last_response.body
      assert_match %r{</noscript>\n<!-- End Piwik --></body>}, last_response.body
      assert_equal "650", last_response.headers['Content-Length']
    end

    should "show non-asynchronous tracker" do
      get "/bob"
      assert_match %r{.getTracker}, last_response.body
      assert_match %r{</script></body>}, last_response.body
      assert_match %r{\"whatthe\"}, last_response.body
    end
  end
=end
end
