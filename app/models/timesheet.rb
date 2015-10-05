require 'business_time'

class Timesheet < ActiveRecord::Base

  belongs_to :employee

  validates :from_date, :presence => true#, :message => "combination of event name and start date exists"
  validates :to_date, :presence => true#, :message => "combination of event name and start date exists"
  validate :validate_to_date, :if=>:to_date?
  validate :validate_to_date_30_days, :if=>:to_date?
  def validate_to_date
    if from_date.to_i >= to_date.to_i
      errors.add(:to_date, " should be greater than from date")
    end
  end

  def validate_to_date_30_days
    if to_date > (from_date + 29.days)
      errors.add(:to_date, " should not be greater than 30 days of from date")
    end
  end

  def self.business_days_between(date1, date2)
    business_days = 0
    while date2 > date1
      business_days = business_days + 1 unless date2.saturday? or date2.sunday?
      date2 = date2 - 1.day
    end
    business_days + 1
  end
end