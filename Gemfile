source 'https://rubygems.org'
ruby "2.4.0"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'annotate'
gem 'bootstrap-sass'
gem 'cancancan', '~> 1.16'
gem 'devise'
gem 'coffee-script'
gem 'faker', '~> 1.7.3'
gem 'paperclip'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'jquery-turbolinks'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'
gem 'omniauth-facebook'
gem 'omniauth-google'
gem 'omniauth-twitter'
gem 'rails', '~> 5.0.2'
gem 'sass-rails', '~> 5.0'
gem 'simple_form'
gem 'bootstrap-social-rails'
gem 'font-awesome-rails'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'

group :development do
  gem 'better_errors'
  gem 'listen', '~> 3.0.5'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'rails-controller-testing'
  gem 'minitest-reporters',       '1.1.9'
  gem 'guard',                    '2.13.0'
  gem 'guard-minitest',           '2.4.4'
  gem 'minitest', '~> 5.10', '!= 5.10.2'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
