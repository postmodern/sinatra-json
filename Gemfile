source 'https://rubygems.org'

gemspec

group :development, :test do
  platform :ruby_18, :jruby do
    gem 'json'
  end

  platform :ruby do
    gem 'yajl-ruby'
  end

  gem 'multi_json'
end

group :development do
  gem 'rake'
  gem 'rubygems-tasks', '~> 0.2'
  gem 'rspec',          '~> 3.0'
  gem 'rack-test',      '~> 0.6'

  gem 'kramdown'
  gem 'redcarpet',       platform: :mri
  gem 'yard',           '~> 0.9'
  gem 'yard-spellcheck', require: false
end
