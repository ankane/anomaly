# Anomaly

Easy-to-use anomaly detection

## Installation

Add this line to your application's Gemfile:

```ruby
gem "anomaly"
```

And then execute:

```sh
bundle install
```

For max performance (about 3x faster), also install the NArray gem:

```ruby
gem "narray"
```

Anomaly will automatically detect it and use it.

## How to Use

Say we have weather data for sunny days and we're trying to detect days that aren't sunny. The data looks like:

```ruby
# Each row is a different day.
# [temperature (F), humidity (%), pressure (in)]
weather_data = [
  [85, 68, 10.4],
  [88, 62, 12.1],
  [86, 64, 13.6],
  ...
]
```

Train the detector with **only non-anomalies** (sunny days in our case).

```ruby
ad = Anomaly::Detector.new(weather_data)
```

That's it! Let's test for anomalies.

```ruby
# 40° F, 80% humidity, 10.2 in. pressure
test_sample = [79, 66, 12.3]
ad.probability(test_sample)
# => 7.537174740907633e-08
```

**Super-important:** You must select a threshold for anomalies (which we denote with ε - "epsilon")

Probabilities less than ε are considered anomalies. If ε is higher, more things are considered anomalies.

``` ruby
ad.anomaly?(test_sample, 1e-10)
# => false
ad.anomaly?(test_sample, 1e-5)
# => true
```

Here's sample to code to help you find the best ε for your application.

```ruby
# TODO
# 1. Partition data
# 2. Train detector
# 3. Calculate f1_score for test data
# 4. Repeat for multiple values of epsilon
```

You can easily persist the detector to a file or database - it's very tiny.

```ruby
serialized_ad = Marshal.dump(ad)

# Save to a file
File.open("anomaly_detector.dump", "w") {|f| f.write(serialized_ad) }

# ...

# Read it later
ad2 = Marshal.load(File.open("anomaly_detector.dump", "r").read)
```

## TODO

- Train in chunks (for very large datasets)
- Multivariate normal distribution (possibly)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Thanks

A special thanks to [Andrew Ng](http://www.ml-class.org).
