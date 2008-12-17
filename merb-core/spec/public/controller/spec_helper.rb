__DIR__ = File.dirname(__FILE__)

require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "lib", "merb-core", "test", "matchers"))

startup_merb

require File.join(__DIR__, "controllers", "base")
require File.join(__DIR__, "controllers", "responder")
require File.join(__DIR__, "controllers", "display")
require File.join(__DIR__, "controllers", "authentication")
require File.join(__DIR__, "controllers", "redirect")
require File.join(__DIR__, "controllers", "cookies")
require File.join(__DIR__, "controllers", "conditional_get")
require File.join(__DIR__, "controllers", "streaming")
require File.join(__DIR__, "controllers", "nested_render")

Merb.add_mime_type :html1, :to_html1, ["text/html"]
Merb.add_mime_type :html2, :to_html2, ["text/html"]
Merb.add_mime_type :html3, :to_html3, ["text/html"]
Merb.add_mime_type :html4, :to_html4, ["text/html"]

Merb.start :environment => 'test', :init_file => File.join(__DIR__, 'config', 'init')

Spec::Runner.configure do |config|
  config.include(Merb::Test::ViewHelper)
  config.include(Merb::Test::ControllerHelper)
end
