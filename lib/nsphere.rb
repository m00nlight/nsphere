# encoding: utf-8

# The program define the NSphere in any dimensional
# space, and offer the +, -, *, / operator for vector
# operation in the space.
#
# Author::      m00nlight (mailto:dot_wangyushi@yeah.net)
# Copyright::   Copyright(c) 2014 m00nlight
# License::     Distributed under the MIT-License


class NSphere
  attr_reader :radius, :thetas, :coordinates, :dim

  # A implementation of the n-sphere in any dimensional space
  # In two dimensional, it is a circle to origin point(0, 0), in
  # three dimensional space, it is a sphere to origin(0, 0, 0).
  #
  # === Attributes
  #
  # * +radius+          - Radius of the object
  # * +thetas+          - angles value in radians
  # * +coordinates+     - coordinates of the object
  # * +dim+             - dimension of the space


  def initialize(args)
    if not (args[:radius].nil? or args[:thetas].nil?)
      if check_argument(args[:radius], args[:thetas])
        build_by_radius_thetas(args[:radius], args[:thetas])
      else
        raise "Argument range error, please make sure you initialize" +
          " proper n-dimensional sphere."
      end
    elsif not args[:coord].nil?
      build_by_coordinate(args[:coord])
    else
      raise ArgumentError, "Arguments must contain :radius and :thetas field" +
        " or :coord field"
    end
  end

  # Check argument of radius and thetas, the last theta must in range [0, 2PI],
  # while the rest thetas values must be in the range of [0, PI]
  def check_argument(radius, thetas)
    radius >= 0.0 and thetas[0..-2].all? { |x| x >= 0 and x <= Math::PI} and
      thetas[-1] >= 0 and thetas[-1] <= 2 * Math::PI
  end

  def build_by_radius_thetas(radius, thetas)
    @radius = radius
    @thetas = thetas
    @dim = @thetas.size + 1
    @coordinates = [0.0] * @dim
    (0..(@dim - 2)).to_a.each do |idx|
      tmp = @radius
      (0..(idx - 1)).to_a { |j| tmp = tmp * Math.sin(@thetas[j])}
      @coordinates[idx] = tmp * Math.cos(@thetas[idx])
    end
    @coordinates[-1] = @thetas.map { |x| Math.sin(x)}.inject(@radius, :*)
  end

  def build_by_coordinate(coordinates)
    @coordinates = coordinates
    @dim = @coordinates.size
    coord_square = coordinates.map { |x| x ** 2}
    @radius = Math.sqrt(coord_square.inject(:+))
    sum = [0] * (@dim + 1)
    coord_square.each_with_index do |elem, idx|
      sum[idx + 1] = sum[idx] + elem
    end
    @thetas = [0.0] * (@dim - 1)
    @thetas[@dim - 2] = normalize_angle(Math.atan2(coordinates[@dim - 1],
                                                   coordinates[@dim - 2]),
                                        2 * Math::PI)
    (0..(@dim - 3)).to_a.reverse.each do |idx|
      @thetas[idx] = normalize_angle(atan((sum[@dim - 1] - sum[idx]) ,
                                          coordinates[idx]),
                                     Math::PI)
    end
  end

  # atan wrapper for the Math.atan method to avoid produce 0 / 0 as NaN
  #
  # ==== Attributes
  #
  # * +y+       - denominator of the atan function
  # * +x+       - numerator of the atan function
  #
  # ==== Example
  #   atan(0, 0) => 0.0
  #   atan(3, 4) => 0.6435011087932844
  def atan(y, x)
    if x.abs <= 10e-6 && y.abs <= 10e-6
      return 0.0
    else
      return Math.atan(y / x)
    end
  end


  # normalize an angle value to [0..range]
  def normalize_angle(angle, range)
    (angle + range) % range
  end

  # negate the object
  def negate
    NSphere.new(coord: @coordinates.map { |x| -x})
  end

  # help function for doing vector multiplication and division
  def add_angles(thetas1, thetas2)

    res = []
    res = thetas1[0..-2].zip(thetas2[0..-2]) { |x|
      (x.inject(:+) + Math::PI) % Math::PI
    } || res

    res << ((thetas1[-1] + thetas2[-1] + 2 * Math::PI) % (2 * Math::PI))
    res
  end

  # add operator for two vectors
  def +(a)
    raise "Dimension not match" if @dim != a.dim
    tmp = self.coordinates.zip(a.coordinates).map { |x|
      x.inject(:+)
    }
    NSphere.new(coord: tmp)
  end

  # minus operator for two vectors
  def -(a)
    raise "Dimension not match" if @dim != a.dim
    self + a.negate
  end

  # multiply operator for two vectors
  def *(a)
    tmp = add_angles(@thetas, a.thetas)
    NSphere.new(radius: self.radius * a.radius,
                thetas: tmp)
  end

  # divide operator for two vectors
  def /(a)
    tmp = add_angles(@thetas, a.thetas.map { |x| -x})

    NSphere.new(radius: @radius / a.radius,
                thetas: tmp)
  end

  # Class method, generate a random vector in any dimensional space
  #
  # ==== Attributes
  #
  # * +dim+     - dimension of the generate vector
  # * +radius+  - radius with default value set to 1.0
  #
  # An random NSphere object is returned as result.
  def self.random_vector(dim, radius = 1.0)
    thetas = [0.0] * (dim - 1)
    thetas[-1] = Random.rand(0..(2 * Math::PI))
    (0..(dim - 3)).to_a.each do |idx|
      thetas[idx] = Random.rand(0..Math::PI)
    end
    NSphere.new(radius: radius,
                thetas: thetas)
  end

  # override to string method of NSphere object
  def to_s
    "radius: #{radius}, thetas: #{thetas}, coordinates: #{coordinates}"
  end
end
