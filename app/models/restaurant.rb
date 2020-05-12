class Restaurant < ApplicationRecord
  include TimeFormatter

  validates :name, presence: true

  has_many :tables, dependent: :destroy
  has_many :schedules, dependent: :destroy
  has_many :reservations


  def free_tables(date, time = nil, duration = nil)
    unless time.nil? || duration.nil?
      reservation_time = reservation_time_arr(time, duration)
    end

    working_time = self.restaurant_schedule(date)
    return nil if working_time.nil?

    free_tables = {}
    self.tables.each do |table|
      free_time = table.free_table(date)
      if free_time && reservation_time.nil?
        free_tables[table.name] = arr_to_time(free_time, working_time)
      elsif free_time && reservation_time
        able_to_reserve = free_time & reservation_time
        if able_to_reserve == reservation_time
          free_tables[table.name] = arr_to_time(free_time, working_time)
        end
      end
    end
    free_tables
  end

  def reservation_time_arr(time, duration)
    time = time_str_to_num(time)
    reservation_time = [time]
    duration = duration.to_i
    (duration / 30 - 1).times do |n|
      reservation_time << time + 0.5 * (n + 1)
    end
    reservation_time
  end

  def restaurant_schedule(date)
    schedule = self.schedules.where("day LIKE ?", "%#{date.to_s}%")

    if schedule.empty?
      schedule = self.schedules.where("day LIKE ?", "%#{date.strftime("%a")}%")
    end
    return nil if schedule.empty?

    schedule = schedule.last

    from = time_str_to_num(schedule.start_at)
    till = time_str_to_num(schedule.end_at)

    working_time = WORKING_HOURS[(from*2)..-1]
    working_time = working_time[0..(working_time[1..-1].index(till))]
  end
end
