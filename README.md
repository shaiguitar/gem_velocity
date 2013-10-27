# GemVelocity

A way to see gem velocity. There are two ways you can view graphs.

`SingleVelocitator`

This is a single line graph of a single version.

`AggregatedVelocitator`

This is a signle line graph that has an aggregated view of a major version (or bunch of single minor versions, etc).

See specs and [examples](examples/) for more info.

There is also the `Multiplexer`, this is a wrapper around being able to draw multiple lines at once. You pass it any number of the above and it will graph multiple lines together in one graph.

## Note

There may be some inconstancies due to bad data coming back from the api. These are outlined in:

[https://gist.github.com/shaiguitar/d2af997b7f58e24fd305](https://gist.github.com/shaiguitar/d2af997b7f58e24fd305)

It seems it happens with older data. I'm investigating though with the help of the rubygems team as per [this](https://github.com/rubygems/rubygems.org/pull/606) and will hopefully have some progress soon.

## Requirements

It draws graphs. So you'll need imagemagick/rmagick. Any problems with installation let me know and I'll try to help out.

`brew install imagemagick && brew link imagemagick && gem install gem_velocity`

# Example

See [examples](examples/) for pictures. The specs have more examples as well.

Important to note, you should be able to pass in specific start time, end time, max and min values.

This essentially completes you being able to manipulate the boundries of the graph in question.

## Web UI

Do you want to see this with ease (Hey, the api is easy. Whatever) on the web at `http://rubygems-velocity.org/gem/rails/4.0.0,3.2.14` or something similar?

[Work](https://github.com/shaiguitar/gem_velocity_web) has been started to put it on a UI, but your feedback in necessary for it to be useful:

So if you have any idea of how you'd like to use it, please put your thoughts on the [issue](https://github.com/shaiguitar/gem_velocities/issues/3)

Lemme know.

## Feedback

Is appreciated! Also, contributions! Any (other) ideas?
