#!/bin/ksh

# Last Update : 08 july 2012 / 16h30

RAILS_DEV_HOME="/media/Donnees/developpements/rubyonrails"
APP_HOME="${RAILS_DEV_HOME}/pediatric_app"


##### heroku
heroku run urake db:setup ## to re-init db

# application creation
rails new pediatric_app

# User model creation
rails generate model User username:string name:string address:text phone_number:string email:string other:text admin:boolean encrypted_password:string salt:string

#  generation du controller de "Page" statique "home" et "contact"
rails generate controller Pages home contact

# generation du controller Users
rails generate controller Users new create edit update destroy index

# generation du controller de sessions
rails generate controller Sessions new create destroy

# Person model creation
rails generate model Person name:string surname:string sex_male:boolean birthday:date address:text cell_phone_number:string  email:string

# Address model creation
rails generate model Address address:text phone_number:string

# generation du controller de Person
rails generate controller People new create edit update destroy index show

rails g scaffold Person --migration=false --skip
