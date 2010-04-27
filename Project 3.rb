require 'pp'

class Array
  def sum
    inject {|a,b| a + b }
  end
  
  def probability(x)
    count { |y| x==y }.to_f / size.to_f
  end
  
  def mu
    map {|x| x.to_f * probability(x) }.sum
  end
  
  def x_bar
    sum.to_f / size.to_f
  end
  
  def sigma_squared
    uniq.map {|x| (x - mu)**2 * probability(x) }.sum
  end
  
  def s_squared
    map {|x| (x - x_bar)**2 }.sum.to_f / (size - 1).to_f
  end
  
  def sigma
    Math.sqrt(sigma_squared)
  end
  
  def s
    Math.sqrt(s_squared)
  end
end


class TwoByTwo
  def initialize(n)
    @a, @b, @c, @d = ("%04b" % n).split(//).map{ |s| s.to_i}
  end
  
  def det
    @a * @d - @b * @c
  end
  
  def to_s
    "\\left[ \\begin{array}{cc} #{@a}&#{@b}\\\\#{@c}&#{@d} \\end{array} \\right]"
  end
end

# Print out all the possible determinants for 2x2's consisting of only 1's and 0's
dets=[]
(0..15).each do |i|
  matrix = TwoByTwo.new(i)
  puts "\\mathrm{det} #{matrix} = #{matrix.det}" + ((i % 3 == 2) ? "\\\\" : "&")
  dets << matrix.det
end

dets.uniq.each do |x|
  puts "P(X=#{x}) &= #{dets.probability(x)}\\\\"
end

puts "The mean $\\mu$ is %0.4f \\newline" % dets.mu
puts "The variance $\\sigma^2$ is %0.4f \\newline" % dets.sigma_squared
puts "The standard deviation $\\sigma$ is %0.4f" % dets.sigma

# Generate 15 random 2x2 matrices consisting of only 1's and 0's
dets=[]
(0..14).each do |i|
  matrix = TwoByTwo.new(rand(16))
  puts "\\mathrm{det} #{matrix} = #{matrix.det}" + ((i % 3 == 2) ? "\\\\" : "&")
  dets << matrix.det
end
  
puts "The mean $\\bar{x}$ is %0.4f \\newline" % dets.x_bar
puts "The variance $s^2$ is %0.4f \\newline" % dets.s_squared
puts "The standard deviation $s$ is %0.4f" % dets.s
