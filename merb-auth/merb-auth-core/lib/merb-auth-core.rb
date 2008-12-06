# make sure we're running inside Merb

require 'extlib'

require 'merb-auth-core/authentication/authentication'
require 'merb-auth-core/authentication/strategy'
require 'merb-auth-core/authentication/session_mixin'
require 'merb-auth-core/authentication/errors'
require 'merb-auth-core/authentication/responses'
require 'merb-auth-core/authentication/authenticated_helper'
require 'merb-auth-core/authentication/customizations'
require 'merb-auth-core/authentication/bootloader'
require 'merb-auth-core/authentication/router_helper'
require 'merb-auth-core/authentication/callbacks'

Merb::BootLoader.before_app_loads do
  # require code that must be loaded before the application 
  Merb::Controller.send(:include, Merb::AuthenticatedHelper)
end

Merb::BootLoader.after_app_loads do
  # code that can be required after the application loads
end

Merb::Plugins.add_rakefiles "merb-auth-core/merbtasks"

Merb.push_path(:lib_authentication, Merb.root_path("merb" / "merb-auth"), "*.rb" )
