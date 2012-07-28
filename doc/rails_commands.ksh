#!/bin/ksh

# Last Update : 08 july 2012 / 16h30

RAILS_DEV_HOME="/media/Donnees/developpements/rubyonrails"
APP_HOME="${RAILS_DEV_HOME}/pediatric_app"


# application creation
rails new pediatric_app

# User model creation
rails generate model User username:string name:string address:text phone_number:string email:string other:text admin:boolean encrypted_password:string salt:string

#  generation du controler de "Page" statique "home" et "contact"
rails generate controller Pages home contact

# generation du controler Users
rails generate controller Users new create edit update destroy index

# generation du controler de sessions
rails generate controller Sessions new create destroy

