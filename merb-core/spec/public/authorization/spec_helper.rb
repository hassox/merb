__DIR__ = File.dirname(__FILE__)

require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper"))
startup_merb

Merb.start :environment => 'test', :init_file => File.join(__DIR__, 'config', 'init')

User = Struct.new(:name, :pass)

class Viking
  def self.captures
    @captures ||= []
  end
  
  def self.capture(obj)
    captures << obj
  end
end