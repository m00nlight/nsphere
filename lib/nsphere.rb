# encoding: utf-8

class NSphere
  attr_reader :radius, :thetas, :coordinates

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

  def check_argument(radius, thetas)
    radius >= 0.0 and thetas[0..-2].all? { |x| x >= 0 and x <= Math::PI} and
      thetas[-1] >= 0 and thetas[-1] <= 2 * Math::PI
  end

  def build_by_radius_thetas(radius, thetas)
    @radius = radius
    @thetas = thetas
    dim = @thetas.size + 1
    @coordinates = [0.0] * dim
    (0..(dim - 2)).to_a.each do |idx|
      tmp = @radius
      (0..(idx - 1)).to_a { |j| tmp = tmp * Math.sin(@thetas[j])}
      @coordinates[idx] = tmp * Math.cos(@thetas[idx])
    end
    @coordinates[-1] = @thetas.map { |x| Math.sin(x)}.inject(@radius, :*)
  end

  def build_by_coordinate(coordinates)
    @coordinates = coordinates
    dim = @coordinates.size
    coord_square = coordinates.map { |x| x ** 2}
    @radius = Math.sqrt(coord_square.inject(:+))
    sum = [0] * (dim + 1)
    coord_square.each_with_index do |elem, idx|
      sum[idx + 1] = sum[idx] + elem
    end
    @thetas = [0.0] * (dim - 1)
    @thetas[dim - 2] = Math.atan2(coordinates[dim - 1], coordinates[dim - 2])
    (0..(dim - 3)).to_a.reverse.each do |idx|
      @thetas[idx] = atan((sum[dim - 1] - sum[idx]) , coordinates[idx])
    end
  end

  def atan(y, x)
    if x.abs <= 10e-6 && y.abs <= 10e-6
      return 0.0
    else
      return Math.atan(y / x)
    end
  end

  def negate
    NSphere.new(radius: -self.radius,
                thetas: self.thetas.map { |x| -x})
  end

  def +(a)
    tmp = self.coordinates.zip(a.coordinates).map { |x|
      x.inject(:+)
    }
    NSphere.new(coord: tmp)
  end

  def -(a)
    self + a.negate
  end

  def *(a)
    tmp = self.coordinates.zip(a.coordinates).map { |x|
      x.inject(:+)
    }
    NSphere.new(radius: self.radius * a.radius,
                thetas: tmp)
  end

  def /(a)
    tmp = self.coordinates.zip(a.coordinates).map { |x|
      x[0] - x[1]
    }
    NSphere.new(radius: self.radius / a.radius,
                thetas: tmp)
  end

  def self.random_vector(dim, radius = 1.0)
    thetas = [0.0] * (dim - 1)
    thetas[-1] = Random.rand(0..(2 * Math::PI))
    (0..(dim - 3)).to_a.each do |idx|
      thetas[idx] = Random.rand(0..Math::PI)
    end
    NSphere.new(radius: radius,
                thetas: thetas)
  end
end
