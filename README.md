# Get started

Clone project
```
git clone git@github.com:Wayzyk/restaurant_reservation.git
```

Install missing gems

```
bundle exec install
```

Create DB

```
rake db:create
rake db:migrate
```

## Using

```
rails console
```

### Create user

```
-> User.create!(name: 'Roman')
#<User id: 1, name: "Roman", created_at: "2020-05-12 14:35:36", updated_at: "2020-05-12 14:35:36">
```

### Create restaurant
```
-> Restaurant.create(name: 'Test')
#<Restaurant id: 1, name: "Test", created_at: "2020-05-12 14:37:24", updated_at: "2020-05-12 14:37:24">
```

### Create schedule for restaurant

```
-> restaurant = Restaurant.create(name: 'Test')
-> restaurant
#<Restaurant id: 1, name: "Test", created_at: "2020-05-12 14:37:24", updated_at: "2020-05-12 14:37:24">
-> restaurant.schedules.create!(day: "Tue, Wed, Thu", start_at: "11:00", end_at: "23:00")
#<Schedule id: 1, day: "Tue, Wed, Thu", start_at: "11:00", end_at: "23:00", restaurant_id: 1, created_at: "2020-05-12 14:41:31", updated_at: "2020-05-12 14:41:31">
-> restaurant.schedules.create!(day: "Fri, Sat, Sun", start_at: "11:00", end_at: "01:00")
 #<Schedule id: 2, day: "Fri, Sat, Sun", start_at: "11:00", end_at: "01:00", restaurant_id: 1, created_at: "2020-05-12 14:42:37", updated_at: "2020-05-12 14:42:37">
```

### Add tables for restaurant

```
-> restaurant.tables.create!(name: '1')
#<Table id: 1, name: "1", restaurant_id: 1, created_at: "2020-05-12 14:43:53", updated_at: "2020-05-12 14:43:53">
```

### Reservation table

```
-> Reservation.create!(user_id: 1, restaurant_id: 1, table_id: 1, date: Date.parse("2020-05-20"), time: "20:00", duration: "90")
#<Reservation id: 1, date: "2020-05-20", time: "20:00", duration: "90", restaurant_id: 1, table_id: 1, user_id: 1, created_at: "2020-05-12 14:47:25", updated_at: "2020-05-12 14:47:25">
```

### Validations

```
-> Reservation.create!(user_id: 1, restaurant_id: 1, table_id: 1, date: Date.parse("2020-05-20"), time: "20:00", duration: "90")
#ActiveRecord::RecordInvalid (Validation failed: Time This table is already reserved at 20:00 - 21:30.)

-> Reservation.create!(user_id: 1, restaurant_id: 1, table_id: 1, date: Date.parse("2020-05-25"), time: "20:00", duration: "90")
#ActiveRecord::RecordInvalid (Validation failed: Date The restaurant 'Test' does not work this day.)

-> Reservation.create!(user_id: 1, restaurant_id: 1, table_id: 1, date: Date.parse("2020-05-26"), time: "10:00", duration: "90")
#ActiveRecord::RecordInvalid (Validation failed: Time The restaurant 'Test' does not work at 10:00 - 11:00 this day.)
```

### Get free tables

```
-> restaurant.free_tables(Date.parse("2020-05-21"))
# {"1"=>"11:00 - 23:00"}
```

### Also you could set date an duration for reserve table

```
-> restaurant.free_tables(Date.parse("2020-05-21"), '21:00', '90')
```

# What I can do if I had more time

1. Add Rspec
2. Add Sidekiq with Crone and set schedule
3. Add Redis for storage 'id' for scheduled objects
4. Add system reservation by User name
