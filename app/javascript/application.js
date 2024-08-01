// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import Rails from "@rails/ujs";
Rails.start();

//= require activestorage
//= require turbolinks
//= require_tree .
//= require jquery
//= require jquery_ujs