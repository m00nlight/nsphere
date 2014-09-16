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


  def test_atan
    t = NSphere.new(coord: [3.0, 4.0])
    assert(t.atan(0.0, 0.0).abs < 10e-6, "atan for [0, 0]")
    assert((t.atan(3.0, 4.0) - 0.6435011088).abs < 10e-6, "normal case")
  end

  def test_add
    a = NSphere.new(coord: [3.0, 4.0])
    b = NSphere.new(coord: [4.0, 3.0])

    t = a + b
    assert((t.coordinates[0] - 7.0).abs < 10e-6, "x axis is wrong")
    assert((t.coordinates[1] - 7.0).abs < 10e-6, "y axis is wrong")
  end

  def test_minus
    a = NSphere.new(coord: [3.0, 4.0])
    b = NSphere.new(coord: [4.0, 3.0])

    t = a - b
    assert((t.coordinates[0] - (-1.0)).abs < 10e-6, "x axis is wrong for -")
    assert((t.coordinates[1] - 1.0).abs < 10e-6, "y axis is wrong for -")

    t = a - a
    assert((t.coordinates[0]).abs < 10e-6, "x axis is wrong for self minus")
    assert((t.coordinates[1]).abs < 10e-6, "y axis is wrong for self minus")
  end

  def test_multiply
    a = NSphere.new(coord: [3.0, 4.0])
    b = NSphere.new(coord: [4.0, 3.0])

    t = a * b
    assert((t.coordinates[0]).abs < 10e-6, "x axis for * is wrong")
    assert((t.coordinates[1] - 25).abs < 10e-6, "y axis for * is wrong")
    assert((t.thetas[0] - Math::PI / 2) < 10e-6, "angle is wrong for *")
  end

  def test_divide
    a = NSphere.new(coord: [3.0, 4.0])
    b = NSphere.new(coord: [4.0, 3.0])

    t = a / a
    assert((t.coordinates[0] - 1.0).abs < 10e-6, "x axis for / is wrong")
    assert((t.coordinates[1]).abs < 10e-6, "y axis for / is wrong")
  end

end
