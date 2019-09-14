# Anomaly

Easy-to-use anomaly detection

[![Build Status](https://travis-ci.org/ankane/anomaly.svg?branch=master)](https://travis-ci.org/ankane/anomaly)

## Installation

Add this line to your application’s Gemfile:

```ruby
gem "anomaly"
```

## How to Use

Say we have weather data and we want to predict if it’s sunny. In this example, sunny days are non-anomalies, and days with other types of weather (rain, snow, etc.) are anomalies. The data looks like:

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
detector = Anomaly::Detector.new(weather_data)

# 85°F, 42% humidity, 12.3 in. pressure
detector.anomaly?([85, 42, 12.3])
```

Anomaly automatically finds the best value for ε, which you can access with:

```ruby
detector.eps
```

If you already know you want ε = 0.01, initialize the detector with:

```ruby
detector = Anomaly::Detector.new(weather_data, eps: 0.01)
```

### Persistence

You can easily persist the detector to a file or database - it’s very tiny.

```ruby
dump = Marshal.dump(detector)
File.binwrite("detector.dump", dump)
```

Then read it later

```ruby
dump = File.binread("detector.dump")
detector = Marshal.load(dump)
```

## Credits

A special thanks to [Andrew Ng](http://www.ml-class.org).

## History

View the [changelog](https://github.com/ankane/anomaly/blob/master/CHANGELOG.md)

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/ankane/anomaly/issues)
- Fix bugs and [submit pull requests](https://github.com/ankane/anomaly/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features
