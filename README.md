# GemVelocity

A way to see gem velocity. Right now it's just aggregated totals.

So, not a number of downloads each day, but rather just the general timeline of total downloads.

## Note

The data is currently somewhat incorrect, due to inconstancies outlined in:

[https://gist.github.com/shaiguitar/d2af997b7f58e24fd305](https://gist.github.com/shaiguitar/d2af997b7f58e24fd305)

I'm investigating though with the help of the rubygems team as per [this](https://github.com/rubygems/rubygems.org/pull/606) and will hopefully have some progress soon.

## Requirements

It draws graphs. So...you'll need imagemagick/rmagick. I'm sure you'll survive. Any problems with installation let me know and I'll try to help out.

# Example

Here's one: [celluloid](https://gist.github.com/shaiguitar/7e6d95971c5254fa3665)

Here's some more:

<pre>
  velocitator = MultipleVelocitator.new("rails", ["4.0.0","3.2.14","2.3.5"])
  file = velocitator.graph("/tmp")
</pre>

Produces:

![here](examples/rails-4.0.0-3.2.14-2.3.5.png)

Notice the date range:

<pre>
  velocitator = MultipleVelocitator.new("rails", ["4.0.0","3.2.14","0.9.1"])
  file = velocitator.graph("/tmp", [3.months.ago, Time.now])
</pre>

Produces:

![here](examples/rails-4.0.0-3.2.14-0.9.1.png)

Also, you should be able to pass in max,min values which completes you being able to manipulate the boundries of the graph in question.

## Web UI

Do you want to see this with ease (Hey, the api is easy. Whatever) on the web at `http://rubygems-velocity.org/gem/rails/4.0.0,3.2.14` or something similar? I could do it, but I need to know it's worth the hassle.

Lemme know.

## Feedback

Is appreciated! Any (other) ideas?
