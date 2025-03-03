# ActiveRecord Performance Test

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
3.4.1

* System dependencies
PostgreSQL

* Database creation
```ruby
bin/rails db:prepare
```

* Run the benchmark script
```ruby
bin/rails console

ActiveRecord::Base.logger = nil # Disable logging to speed up the benchmark
TestScript.benchmark_time(1000, 10) # Evaluate the time needed for 1000 subscriptions and 10 terms
TestScript.benchmark_memory(1000, 10) # Evaluate the memory used for 1000 subscriptions and 10 terms
```
