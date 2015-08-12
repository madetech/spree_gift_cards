# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_gift_cards'
  s.version     = '2.4.0.beta'
  s.summary     = 'Gift Cards'
  s.description = 'Allows redeeming a gift card for Store Credit on the user\'s account'
  s.required_ruby_version = '>= 2.1.0'

  s.author    = 'Bonobos'
  s.email     = 'engineering@bonobos.com'
  s.homepage  = 'http://www.bonobos.com'

  #s.files       = `git ls-files`.split("\n")
  #s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree', '2.4.7.beta'

  s.add_development_dependency 'capybara'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
end
