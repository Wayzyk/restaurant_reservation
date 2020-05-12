class Table < ApplicationRecord
  validates :restaurant, :name, presence: true
  validate :unique_table_for_restaurant

  belongs_to :restaurant
  has_many :reservations

  def free_table(date)
    restaurant_schedule = self.restaurant.restaurant_schedule(date)
    return nil if restaurant_schedule.nil?

    reserved_time = []
    self.reservations.where(date: date).each do |reservation|
      time = reservation.time
      time = time[0..1].to_i + time[3..-1].to_i/60.0
      reserved_time << time
      duration = reservation.duration.to_i
      (duration / 30 - 1).times do |n|
        reserved_time << time + 0.5 * (n + 1)
      end
    end

    free_time = restaurant_schedule - reserved_time
    return nil if free_time.empty?
    free_time
  end

  private

  def unique_table_for_restaurant
    if self.class.exists?(restaurant_id: restaurant_id, name: name)
      errors.add(:table, 'already exists.')
    end
  end
end
