#\ -o :: -p 5683 -E none

ENV['RAILS_ENV'] ||= 'development'

require ::File.expand_path('../config/environment',  __FILE__)
run Rails.application
