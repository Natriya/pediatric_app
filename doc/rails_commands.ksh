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

# Person model creation
rails generate model Person name:string surname:string sex_male:boolean birthday:date address:text cell_phone_number:string  email:string

# Address model creation
rails generate model Address address:text phone_number:string


class Person < ActiveRecord::Base
  belongs_to :father, :class_name => 'Person'
  belongs_to :mother, :class_name => 'Person'
  has_many :children_of_father, :class_name => 'Person', :foreign_key => 'father_id'
  has_many :children_of_mother, :class_name => 'Person', :foreign_key => 'mother_id'
  def children
     children_of_mother + children_of_father
  end
end


class Person < ActiveRecord::Base
  has_one :father, :class_name => 'Person', :foreign_key => 'father_id'
  has_one :mother, :class_name => 'Person', :foreign_key => 'mother_id'
  has_many :children, :class_name => 'Person'
end


