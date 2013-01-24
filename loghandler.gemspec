# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'loghandler/version'

Gem::Specification.new do |gem|
  gem.name          = "loghandler"
  gem.version       = Loghandler::VERSION
  gem.authors       = ["Olivier Gosse-Gardet"]
  gem.email         = ["olivier.gosse.gardet@gmail.com"]
  gem.description   = %q{a demo process for handling log with eventmachine}
  gem.summary       = %q{a demo process for handling log with eventmachine}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency('eventmachine', '>= 1.0.0')
  gem.add_dependency('eventmachine-tail')
  gem.add_dependency('json')
  gem.add_dependency('mongo_mapper')
  gem.add_dependency('bson_ext')
  gem.add_dependency('em-websocket')
  
  
  gem.bindir = "bin"
  gem.executables << "loghandler_client"
  gem.executables << "loghandler_server"
  
end
