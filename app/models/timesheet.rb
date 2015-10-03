class Timesheet < ActiveRecord::Base
  
  belongs_to :employee
  
  
  validates :from_date, :presence => true#, :message => "combination of event name and start date exists" 
  validates :to_date, :presence => true#, :message => "combination of event name and start date exists" 
  validate :validate_from_date, :if=>:from_date?
  validate :validate_to_date, :if=>:to_date?
  validate :validate_to_date_30_days, :if=>:to_date?
  # validate :validate_from_date_30_days, :if=>:from_date?
  validates :hours, :presence => true#, :message => "combination of event name and start date exists" 
  # validates :to_date, :presence => true




def validate_from_date
    #timenow = Time.now.in_time_zone;
    #localtime =  Time.utc(timenow.year,timenow.month,timenow.day,timenow.hour,timenow.min,timenow.sec);
    #Swati Ahire 17-07-2013: Replaced UTC with configured timezone
    # 16/06/14 @matt: allow historic events to be saved (in the past)
    # if self.from_date.blank?
      # localtime =  Time.now.in_time_zone
      # if (start_date.to_i < localtime.to_i) and (event_bookings.nil? or event_bookings.empty?)
        # errors.add(:start_date, " should be greater than current time.")
      # end
    # end
  end

  def validate_to_date
    if from_date.to_i >= to_date.to_i
      errors.add(:to_date, " should be greater than from date")
    end
  end
  
  def validate_to_date_30_days
     # date = from_date + 30.days
     if to_date > (from_date + 30.days)
     
      errors.add(:to_date, " should not be greater than 30 days of from date")
    end
  end
  
  # def validate_from_date_30_days
     # # date = from_date + 30.days
     # if from_date < (to_date - 30.days)
#      
      # errors.add(:from_date, " should not be lesser than 30 days of to date")
    # end
  # end
  
end