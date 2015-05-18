require File.expand_path("../lib/nala/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "nala"
  s.version     = Nala::VERSION
  s.date        = "2015-05-18"
  s.summary     = "Emits events from classes"
  s.description = "Help remove conditionals by emitting events from classes"
  s.authors     = ["Andy Pike"]
  s.email       = "andy@andypike.com"
  s.files       = ["lib/nala.rb"]
  s.homepage    = "http://rubygems.org/gems/nala"
  s.license     = "MIT"

  s.add_development_dependency "rspec", "~> 3.2"
end
