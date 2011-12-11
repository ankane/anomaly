# Anomaly

Anomaly detection using a normal distribution.

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

Train the detector with **only non-anomalies**. Each row is a sample.

```ruby
train_data = [
  [0.1, 100, 1.4],
  [0.2, 101, 2.1],
  [0.5, 102, 1.6]
]
ad = Anomaly::Detector.new(train_data)
```

That's it! Let's test for anomalies.

```ruby
test_sample = [1.0, 100, 1.4]
ad.probability(test_sample)
# => 0.0007328491480297603
```

**Super-important:** You must select a threshold for anomalies (which we denote with ε - "epsilon")

Probabilities less than ε are considered anomalies. If ε is higher, more things are considered anomalies.

``` ruby
ad.anomaly?(test_sample, 1e-10)
# => false
ad.anomaly?(test_sample, 0.5)
# => true
```

Here's sample to code to help you find the best ε for your application.

```ruby
# TODO
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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Thanks

A special thanks to [Andrew Ng](http://www.ml-class.org).
