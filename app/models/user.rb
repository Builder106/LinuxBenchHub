# app/models/user.rb
class User < ApplicationRecord
   enum role: { viewer: 0, contributor: 1, admin: 2 }
   # Devise modules and other configurations
 end