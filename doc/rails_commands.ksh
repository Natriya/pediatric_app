#!/bin/ksh

# Last Update : 08 july 2012 / 16h30

RAILS_DEV_HOME="/media/Donnees/developpements/rubyonrails"
APP_HOME="${RAILS_DEV_HOME}/pediatric_app"


##### heroku
heroku run urake db:setup ## to re-init db

# application creation
rails new pediatric_app

#### Authentification 
# User model creation
rails generate model User username:string name:string address:text phone_number:string email:string other:text admin:boolean encrypted_password:string salt:string

#  generation du controller de "Page" statique "home" et "contact"
rails generate controller Pages home contact

# generation du controller Users
rails generate controller Users new create edit update destroy index

# generation du controller de sessions
rails generate controller Sessions new create destroy

# Person model creation
rails generate model Person name:string surname:string sex:string birthday:date address:text cell_phone_number:string  email:string

# Address model creation
rails generate model Address address:text phone_number:string


##### Medical

# generation du controller de Person
rails generate controller People new create edit update destroy index show

# rails g scaffold Person --migration=false --skip
rails g scaffold Person --skip name:string surname:string sex:string birthday:date address:text cell_phone_number:string  email:string

rails generate migration RemoveAddressToPeople address:string
rails generate migration AddAddressIdToPeople address_id:integer

rails g scaffold Patient  name:string surname:string sex:string birthday:date next_appointment_date:date mother_id:integer father_id:integer tutor_id:integer 

 f = Father.new(:name=>"f",:surname=>"f",:gender=>"M")
 f = Father.new(:name=>"f",:surname=>"f")
 p2 = Patient.new(:name=>"p2",:surname=>"p2",:gender=>"M")
 p = Patient.first
 
 params = { :member => { :name => 'Jack', :surname => 'smilJack', :gender => 'M', :father_attributes => { :name => 'smiling', :surname => 'smil', :gender => 'M' } } }
 params3 = { :member => { :name => 'lili', :gender => 'M'}}
 p3 = Patient.new(params[:member])


rails g scaffold CompanyContact full_name:string phone_number:string cell_phone_number:string company_id:integer insurance_company_id:integer
rails g scaffold Company name:string address:text phone_number:string

rails generate migration AddCompanyPatientIdentificationIdToPatient company_patient_identification:integer

rails generate migration RemoveCompanyPersonIdentificationFromPerson company_person_identification:integer
rails generate migration AddCompanyPersonIdentificationToPerson company_person_identification:string


