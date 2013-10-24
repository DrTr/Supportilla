$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "supportilla/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "supportilla"
  s.version     = Supportilla::VERSION
  s.authors     = ["Dmytro Muravskyi"]
  s.email       = ["dmytromuravskyi@gmail.com"]
  s.homepage    = "https://github.com/DrTr/Supportilla"
  s.summary     = "Gem for support ticket processing."
  s.description = "For more details please visit homeage."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.14"
  s.add_dependency "jquery-rails"
  s.add_dependency "haml", '~> 4.0.3'
  s.add_dependency 'will_paginate', '~> 3.0'
  s.add_dependency 'sass-rails'
  s.add_dependency 'bcrypt-ruby', '~> 3.0.0'

  s.add_development_dependency "sqlite3"
end
