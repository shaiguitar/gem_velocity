# GemVelocity

A way to see gem velocity. There are two ways you can view graphs.

`SingleVelocitator`

This is a single line graph of a single version.

`AggregatedVelocitator`

This is a signle line graph that has an aggregated view of a major version (or bunch of single minor versions, etc).

See specs and [examples](examples/) for more info.

There is also the `Multiplexer`, this is a wrapper around being able to draw multiple lines at once. You pass it any number of the above and it will graph multiple lines together in one graph.

## Note

There are inconstancies of some bad data coming back from the api. 

Sometimes this is due to older data, some historical data was deleted to accommodate for performance issues at the time.

[This](https://github.com/rubygems/rubygems.org/pull/606) [this](https://github.com/rubygems/rubygems.org/issues/616) and [this](https://gist.github.com/shaiguitar/d2af997b7f58e24fd305) have a bit more info if you want to dig in yourself.

There are some other smaller slight inconsistencies due to the [rubygems.org](https://github.com/rubygems/rubygems.org) counter implementation that I believe is being worked on as well.

## Requirements

It draws graphs. So you'll need imagemagick/rmagick. Any problems with installation let me know and I'll try to help out.

`brew install imagemagick && brew link imagemagick && gem install gem_velocity`

# Example

See [examples](examples/) for pictures. The specs have more examples as well.

Important to note, you should be able to pass in specific start time, end time, max and min values.

This essentially completes you being able to manipulate the boundries of the graph in question.

## Web UI

[Work](https://github.com/shaiguitar/gem_velocity_web) has been started to put it on a UI, but your feedback/contributions will be necessary for it to be useful.

It's available [here](http://gem-velocity.shairosenfeld.com/)

Feel free to put your thoughts on the [issue](https://github.com/shaiguitar/gem_velocities/issues/3) and or pull requests.
