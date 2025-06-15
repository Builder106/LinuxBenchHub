class User < ApplicationRecord
   # Include default devise modules. Others available are:
   # :confirmable, :lockable, :timeoutable, :trackable, :omniauthable
   devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable
 
   has_many :performance_benchmarks, dependent: :destroy
   has_many :notifications, dependent: :destroy
 
   # Validations
   validates :email, presence: true, uniqueness: true
 end