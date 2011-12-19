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

For max performance (trains ~3x faster for large datasets), also install the NArray gem:

```ruby
gem "narray"
```

Anomaly will automatically detect it and use it.

## How to Use

Say we have weather data and we want to predict if it's sunny. In this example, sunny days are non-anomalies, and days with other types of weather (rain, snow, etc.) are anomalies. The data looks like:

```ruby
# [temperature(°F), humidity(%), pressure(in), sunny?(y=0, n=1)]
weather_data = [
  [85, 68, 10.4, 0],
  [88, 62, 12.1, 0],
  [86, 64, 13.6, 0],
  [88, 90, 11.1, 1],
  ...
]
```

The last column **must** be 0 for non-anomalies, 1 for anomalies. Non-anomalies are used to train the detector, and both anomalies and non-anomalies are used to find the best value of ε.

To train the detector and test for anomalies, run:

```ruby
ad = Anomaly::Detector.new(weather_data)

# 85°F, 42% humidity, 12.3 in. pressure
ad.anomaly?([85, 42, 12.3])
# => true
```

Anomaly automatically finds the best value for ε, which you can access with:

```ruby
ad.eps
```

If you already know you want ε = 0.01, initialize the detector with:

```ruby
ad = Anomaly::Detector.new(weather_examples, {:eps => 0.01})
```

### Persistence

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
