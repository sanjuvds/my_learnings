class Employee < ActiveRecord::Base
  include Paperclip::Glue
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_many :timesheets
  
  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  validates :forname, :format => { :with => /\A[a-zA-Z0-9\ \'\-]+$\z/, :message => "only letters allowed" },
                :length => { :maximum => 30 },
                :if => Proc.new {|employee| employee.forname.present? }
  validates :surname,
            :format => { :with => /\A[a-zA-Z0-9\ \'\-]+$\z/, :message => "only letters allowed" },
            :length => { :maximum => 30 },
            :if => Proc.new {|employee| employee.surname.present? }

  validates :phone, :length => {:minimum => 7, :maximum => 20},
                :allow_blank => true,
                :format => {:with => /\A[\s0-9#()+-\[\]\|:;',.?\/\\]*$\z/}

end
