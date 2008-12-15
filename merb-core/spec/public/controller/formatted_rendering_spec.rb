require File.join(File.dirname(__FILE__), "spec_helper")

describe Merb::AbstractController, " nested rendering" do  
  before(:all) do
    Merb::Router.prepare do
      with(:controller => "merb/test/fixtures/controllers/nested_render") do
        match("/index(.:format)").register
        match("/complex(.:format)").to(:action => "complex")
        match("/show(.:format)").to(:action => "show")
        match("/complex_show(.:format)").to(:action => "complex_show")
      end
    end
  end
  
  it "should render with a layout" do
    result = request("/index.html1")
    result.should have_selector("div.html1_layout div.html1_content")
  end
  
  it "should support rendering a nested render with no nested layout" do
    result = request("/index.html2")
    result.should have_selector("div.html2_layout div.html2_content div.html1_content")
    result.should_not have_selector("div.html2_layout div.html2_content div.html1_layout div.html1_content")
    result.should_not have_selector("div.html2_layout div.html2_content div.html2_layout div.html1_content")
  end
  
  it "should support rendering a nested render with a layout" do
    result = request("/index.html3")
    result.should have_selector("div.html3_layout div.html3_content div.html2_layout div.html2_content")
  end
  
  it "should support rendering a nested render with a different format and no layout" do
    result = request("/index.html4")
    result.should have_selector("div.html4_layout div.html4_content div.html2_content")
    result.should_not have_selector("div.html4_layout div.html4_content div.html2_layout div.html2_content")
    result.should_not have_selector("div.html4_layout div.html4_content div.html4_layout div.html2_content")
  end
  
  it "should support multiple nested renders of different formats" do
    result = request("/complex.html1")
    result.should have_selector("div.html1_layout div.html1_complex_content div.html3_content div.html2_layout div.html2_content")
    result.should_not have_selector("div.html1_layout div.html1_complex_content div.html3_layout div.html3_content div.html2_layout div.html2_content")
    result.should_not have_selector("div.html1_layout div.html1_complex_content div.html1_layout div.html3_content div.html2_layout div.html2_content")
  end
  
  it "should display with a layout" do
    result = request("/show.html1")
    result.should have_selector("div.html1_layout div.html1_show")
  end
  
  it "should display inside a display with no nested layout" do
    result = request("/show.html2")
    result.should have_selector("div.html2_layout div.html2_show div.html1_show")
    result.should_not have_selector("div.html2_layout div.html2_show div.html1_layout")
  end
  
  it "should display inside a display with a nested layout" do
    result = request("/show.html3")
    result.should have_selector("div.html3_layout div.html3_show div.html1_layout div.html1_show")
  end
  
  it "should display the object inside an display with a layout" do
    result = request("/show.html4")
    result.should have_selector("div.html4_layout div.html4_show div.html3_layout div.to_html3")
  end
  
  it "should display the object inside a display without a layout" do
    result = request("/complex_show.html1")
    result.should have_selector("div.html1_layout div.html1_complex_content div.to_html2")
  end
  
end