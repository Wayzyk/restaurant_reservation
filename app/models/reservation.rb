class Reservation < ApplicationRecord
  include TimeFormatter

  belongs_to :restaurant
  belongs_to :table
  belongs_to :user
  validates :restaurant, :table, :user, :date, :time, :duration, presence: true
  validates :time,
    format: { with: TIME_FORMAT,
    message: "Not valid format.Nedeed format for time: '12:30' or '00.00'" }
  validate :reservation_time_format, :working_time

  private

  def reservation_time_format
    duration = self.duration.to_i
    unless duration%30 == 0
      errors.add(:duration, "User can reserve table only for" +
                            " 30, 60, 90 etc. minutes.")
      return
    end
  end

  def working_time
    reservation_time = reservation_time_arr(self.time, self.duration)
    working_time = self.restaurant.restaurant_schedule(self.date)

    if working_time.nil?
      errors.add(:date, "The restaurant '#{self.restaurant.name}'" +
                        " does not work this day.")
    else
      able_to_reserve = (working_time & reservation_time)
      unless able_to_reserve == reservation_time
        errors.add(:time, "The restaurant '#{self.restaurant.name}'" +
          " does not work at " +
          "#{arr_to_time(reservation_time - able_to_reserve)}" +
          " this day.")
      else
        not_reserved_time = self.table.free_table(self.date)
        able_to_reserve = (not_reserved_time & reservation_time)
        unless reservation_time == able_to_reserve
          errors.add(:time, "This table is already reserved at " +
            "#{arr_to_time(reservation_time - able_to_reserve, working_time)}.")
        end
      end
    end
  end
end
