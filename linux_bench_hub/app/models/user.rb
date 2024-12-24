class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
   # Include default Devise modules. Others available are:
   # :confirmable, :lockable, :timeoutable, :trackable, :omniauthable
   devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable
 
   has_many :performance_benchmarks, dependent: :destroy
 
   # Validations (if any)
   # validates :email, presence: true, uniqueness: true
 end