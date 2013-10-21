# GemVelocity

A way to see gem velocity. There are three ways you can view graphs. 

`AggregatedVelocitator`

`SingleVelocitator`

`MultipleVelocitator`

Some examples are noted below.

## Note

There may be some inconstancies due to bad data coming back from the api. These are outlined in:

[https://gist.github.com/shaiguitar/d2af997b7f58e24fd305](https://gist.github.com/shaiguitar/d2af997b7f58e24fd305)

It seems it happens with older data. I'm investigating though with the help of the rubygems team as per [this](https://github.com/rubygems/rubygems.org/pull/606) and will hopefully have some progress soon.

## Requirements

It draws graphs. So...you'll need imagemagick/rmagick. Any problems with installation let me know and I'll try to help out.

There are plans to put it on the web somewhere, so if you wait long enough you may not even need to install it.

# Example

See below. More importantly though you should be able to pass in specific start time, end time, max and min values.

This completes you being able to manipulate the boundries of the graph in question.

<pre>
velocitator = MultipleVelocitator.new("rails", ["4.0.0","3.2.14"])
file = velocitator.graph("/tmp")
</pre>

Renders:

![here](examples/rails-4.0.0-3.2.14.png)

See and run the specs to see other graphs.

<!-- Another: [celluloid](https://gist.github.com/shaiguitar/7e6d95971c5254fa3665) -->

## Web UI

Do you want to see this with ease (Hey, the api is easy. Whatever) on the web at `http://rubygems-velocity.org/gem/rails/4.0.0,3.2.14` or something similar? I could do it, but I need to know it's worth the hassle.

Also, if you have any idea of how you'd like to use it, please leave a comment on the [issue](https://github.com/shaiguitar/gem_velocities/issues/3)

Lemme know.

## Feedback

Is appreciated! Also, contributions! Any (other) ideas?
