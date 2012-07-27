#!/bin/ksh

# Last Update : 08 july 2012 / 16h30

RAILS_DEV_HOME="/media/Donnees/developpements/rubyonrails"
APP_HOME="${RAILS_DEV_HOME}/pediatric_app"


# application creation
rails new pediatric_app

# User model creation
rails generate model User \
        username:string \
        name:string \
        address:text \
        phone_number:string \
        email:string \
        other:text \
        admin:boolean \
        encrypted_password:string \
        salt:string


