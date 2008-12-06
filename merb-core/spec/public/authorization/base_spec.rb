require File.dirname(__FILE__) + '/spec_helper'
class Merb::Authorization

  def self.allows?(user, verb, opts = {})
    Viking.capture([Merb::Authorization, verb, opts])
    user && user.pass
  end
end

class GuardedClass
  
  def self._allows?(verb, opts)
    [:verb,:admin].include?(verb)
  end
  
  def self.allows?(user, verb, opts={})
    Viking.capture([GuardedClass, verb, opts])
    user.pass
  end
  
  def _allows?(verb, opts)
    [:verb,:edit,:show].include?(verb)
  end
  
  def allows?(user, verb, opts={})
    Viking.capture(["GuardedClass(Instance)", verb, opts])
    user.pass
  end
end

module NameSpace
  def self.allows?(user, verb, opts={})
    Viking.capture([NameSpace, verb, opts])
    user.pass
  end
  
  module Nested
    class Foo
    end
  end
end



describe "authz" do
  before(:each) do
    @user = User.new("Homer", true)
    Viking.captures.clear
  end
  
  after(:all) do
    Viking.captures.clear
  end
  
  it "should put the authorized? method onto kernel" do
    Kernel.should respond_to(:authorized?)
  end
  
  it "should fall back to Merb::Authorization.allows? when no target is given" do
    authorized?(@user, :edit).should be_true
    Viking.captures.should include([Merb::Authorization, :edit, {}])
  end
  
  it "should fail when the conditions aren't met" do
    authorized?(User.new("Fred", false), :edit).should be_false
    Viking.captures.should include([Merb::Authorization, :edit, {}])
  end
  
  it "should run the allows? on an instance that impelments it" do
    obj = GuardedClass.new
    authorized?(@user, :verb, :target => obj)
    Viking.captures.should have(1).item
    Viking.captures.should include(["GuardedClass(Instance)", :verb, {:target => obj}])
  end
  
  it "should run the allows? on an object of type Class that impleents it" do
    authorized?(@user, :verb, :target => GuardedClass).should be_true
    Viking.captures.should have(1).item
    Viking.captures.should include([GuardedClass, :verb, {:target => GuardedClass}])
  end
  
  it "should fall back to Merb::Authorization.allows? when the target instance does not have an allows? method" do
    authorized?(@user, :verb, :target => {}).should be_true
    Viking.captures.should have(1).item
    Viking.captures.should include([Merb::Authorization, :verb, {:target => {}}])
  end
  
  it "should fall back to Merb::Authorization.allows? when the target class does not have an allows? method" do
    authorized?(@user, :verb, :target => Hash).should be_true
    Viking.captures.should have(1).item
    Viking.captures.should include([Merb::Authorization, :verb, {:target => Hash}])
  end
  
  it "should look in an items namespace for allows? in turn until it finds one that implments allows?" do
    authorized?(@user, :verb, :target => NameSpace::Nested::Foo).should be_true
    Viking.captures.should have(1).item
    Viking.captures.should include([NameSpace, :verb, {:target => NameSpace::Nested::Foo}])
  end
  
  it "should skip the obect if the object provies an _allows? method, but it does not allow that particular verb" do
    gc = GuardedClass.new
    authorized?(@user, :admin, :target => gc).should be_true
    Viking.captures.should have(1).item
    Viking.captures.should include([GuardedClass, :admin, {:target => gc}])
  end
  
  it "should skip back to Merb::Authorization? if it can't find anything in the objects implementing _allows?" do
    gc = GuardedClass.new
    authorized?(@user, :foo, :target => gc).should be_true
    Viking.captures.should have(1).item
    Viking.captures.should include([Merb::Authorization, :foo, {:target => gc}])
  end
end