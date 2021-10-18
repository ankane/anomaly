# Anomaly

Easy-to-use anomaly detection for Ruby

[![Build Status](https://github.com/ankane/anomaly/workflows/build/badge.svg?branch=master)](https://github.com/ankane/anomaly/actions)

## Installation

Add this line to your application’s Gemfile:

```ruby
gem 'anomaly'
```

## Getting Started

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

Train the detector

```ruby
detector = Anomaly::Detector.new(weather_data)
```

Test for anomalies

```ruby
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

## Persistence

You can easily persist the detector to a file or database - it’s very tiny.

```ruby
bin = Marshal.dump(detector)
File.binwrite("detector.bin", bin)
```

Then read it later:

```ruby
bin = File.binread("detector.bin")
detector = Marshal.load(bin)
```

## Related Projects

- [AnomalyDetection.rb](https://github.com/ankane/AnomalyDetection.rb) - Time series anomaly detection for Ruby
- [IsoTree](https://github.com/ankane/isotree) - Outlier/anomaly detection for Ruby using Isolation Forest
- [OutlierTree](https://github.com/ankane/outliertree) - Explainable outlier/anomaly detection for Ruby
- [MIDAS](https://github.com/ankane/midas) - Edge stream anomaly detection for Ruby
- [Trend](https://github.com/ankane/trend) - Anomaly detection and forecasting for Ruby

## Credits

A special thanks to [Andrew Ng](https://www.coursera.org/learn/machine-learning).

## History

View the [changelog](https://github.com/ankane/anomaly/blob/master/CHANGELOG.md)

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/ankane/anomaly/issues)
- Fix bugs and [submit pull requests](https://github.com/ankane/anomaly/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features

To get started with development:

```sh
git clone https://github.com/ankane/anomaly.git
cd anomaly
bundle install
bundle exec rake spec
```
