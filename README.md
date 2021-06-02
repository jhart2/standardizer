# Standardizer

Standardardizer is a Ruby program that transforms raw data into a standardized (E.164, ISO8601) compliant format. Standardizer provides a valid .csv which allows the highest number of valid patient records
to be imported by the next stage of the process. Data is output 
from the program in two files. One of which will be the output.csv and the other a report.txt file containing invalid records.


### Installation

```
sudo gem build standardizer.gemspec 
sudo gem install ./standardizer-0.0.0.gem 
rake test
```

### How To Use Standardizer


```ruby
#! /usr/bin/env ruby

require 'standardizer'

Standardizer.perform('input.csv','.')
```

```
~/standardizer/bin/standardizer input.csv .
```
