require "trollop"
require "gem_velocity/version"
require "gem_velocity/helpers"
require "gem_velocity/gem_data"
require "gem_velocity/gruff_builder"

require "gem_velocity/velocitators/base_velocitator"
require "gem_velocity/velocitators/single_velocitator"
require "gem_velocity/velocitators/aggregated_velocitator"
require "gem_velocity/velocitators/multiplexer"
require "gem_velocity/velocitators/factory"


require "gem_velocity/errors"

require 'active_support/all'
require 'date'

module GemVelocity
end

# this should be used for short-lived scripts.
# can be configurable if need be.
GC.disable
