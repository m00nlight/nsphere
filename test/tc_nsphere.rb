require_relative "../lib/nsphere.rb"
require "test/unit"

class TestNSphere < Test::Unit::TestCase
  def test_initialize
    t = NSphere.new(coord: [3.0, 4.0])
    assert((t.radius - 5.0).abs < 10e-6, "radius test")
    assert((t.thetas[0] - 0.927295218).abs < 10e-6,
           "test for angle size")

    t = NSphere.new(radius: 5.0, thetas: [0.927295218])
    assert((t.coordinates[0] - 3.0) < 10e-6, "test x axis")
    assert((t.coordinates[1] - 4.0) < 10e-6, "test y axis")
  end


end
