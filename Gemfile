source 'https://rubygems.org'

ruby '2.2.2'

# Bundle edg e Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.3'
gem 'pg', '0.18.2'
gem 'devise'
gem 'resque'
gem 'business_time'

gem "paperclip", git: "git://github.com/thoughtbot/paperclip.git"

group :production do
  gem 'rails_12factor'
end

gem 'wice_grid','~> 3.4.14'

gem 'heroku'
gem 'sass-rails', '~> 5.0'

gem 'coffee-rails', '~> 4.1.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jbuilder', '~> 2.0'

gem 'exception_notification', "2.6.1"

gem 'therubyracer', :platforms => :ruby

group :development, :test do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end
