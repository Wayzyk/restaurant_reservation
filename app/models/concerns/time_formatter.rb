module TimeFormatter
  WORKING_HOURS = (0...24).step(0.5).to_a
  TIME_FORMAT = /[01]\d[.:][03]0|2[0-3][.:][03]0/

  private

  def arr_to_time(arr, working_time = WORKING_HOURS)
    return nil if arr.empty?
    array = working_time & arr
    time = "#{num_to_time_str(array[0])} - "
    if array.size == 1 || array[1] - array[0] > 0.5
      time << "#{num_to_time_str(array[0] + 0.5)}; "
    end
    (array.size - 1).times do |i|
      i = i + 1
      if array[i] - array[i-1] != 0.5 && array[i] - array[i-1] != -23.5
        time << "#{num_to_time_str(array[i])} - "
      end
      if i == array.size - 1 ||
         array[i+1] - array[i] > 0.5 ||
         (array[i+1] - array[i] < 0 && array[i+1] - array[i] != -23.5)
        t = array[i] + 0.5
        time << "#{num_to_time_str(t)}; "
      end
    end
    time[0..-3].gsub('24', '00')
  end

  def num_to_time_str(num)
    "#{'%02d' % num.to_i}:#{'%02d' % (num%1*60).to_i}"
  end

  def time_str_to_num(time)
    time[0..1].to_i + time[3..-1].to_i/60.0
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
end
