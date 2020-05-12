class Schedule < ApplicationRecord
  include TimeFormatter

  belongs_to :restaurant
  validates :restaurant, :day, :start_at, :end_at, presence: true
  validates :start_at, :end_at,
    format: { with: TIME_FORMAT,
    message: "Wrong format. Needed time format is: '12:30' or '00.00" }
  validates :day,
    format: { with: /Sun|Mon|Tue|Wed|Thu|Fri|Sat|20\d{2}-[0-1]\d-[0-3]\d/,
    message: "Wrong format. Needed day format is: 'Mon, Tue, Wed, Thu, Fri, Sat, Sun' or '2017-05-01'" }
  validate :date_format

  private

  def date_format
    if self.day =~ /20\d{2}-[0-1]\d-[0-3]\d/
      begin
        Date.parse(self.day)
      rescue ArgumentError
        errors.add(:day, "Invalid day format")
      end
    end
  end
end
