class Employee < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_many :timesheets
  
  # validates :forname, :presence => true
  # validates :from_date, :presence => true
  # validates :from_date, :presence => true
  # validates :from_date, :presence => true
  # validates :from_date, :presence => true
  
  
end
