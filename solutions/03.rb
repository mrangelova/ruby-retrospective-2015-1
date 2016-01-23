class Integer
  def prime?
    return false if self < 2
    2.upto(Math.sqrt(self)).all? { |divisor| (self % divisor).nonzero? }
  end
end

class RationalSequence
  include Enumerable

  def initialize(size)
    @size = size
  end

  def each_rational_number(&block)
    (2..Float::INFINITY).map { |number| rationals_with_equal_sum_of_fraction_parts(number, &block) }
  end

  def rationals_with_equal_sum_of_fraction_parts(sum, &block)
    sum.odd? ? (numerator, denominator = sum - 1, 1) : (numerator, denominator = 1, sum - 1)

    until numerator.zero? or denominator.zero?
      yield Rational(numerator, denominator) if numerator.gcd(denominator) == 1

      if sum.odd?
        numerator -= 1
        denominator += 1
      else
        numerator += 1
        denominator -= 1
      end
    end
  end

  def each
    enum_for(:each_rational_number).lazy.take(@size).each { |n| yield n }
  end
end

class FibonacciSequence
  include Enumerable

  def initialize(size, first: 1, second: 1)
    @size = size
    @first = first
    @second = second
  end

  def each_fibonacci_number
    previous, current = @first, @second
    yield previous

    loop do
      yield current
      previous, current = current, current + previous
    end
  end

  def each
    enum_for(:each_fibonacci_number).lazy.take(@size).each { |n| yield n }
  end
end

class PrimeSequence
  include Enumerable

  def initialize(size)
    @size = size
  end

  def each
    (1..Float::INFINITY).lazy.select(&:prime?).take(@size).each { |n| yield n }
  end
end

module DrunkenMathematician
  module_function

  def meaningless(n)
    RationalSequence.new(n).to_a
      .partition { |rational| rational.numerator.prime? or rational.denominator.prime? }
      .map { |n| n.reduce(1,:*) }.reduce(&:/)
  end

  def aimless(n)
    prime_sequence = n.even? ? PrimeSequence.new(n).to_a : PrimeSequence.new(n).to_a << 1
    prime_sequence.each_slice(2).map { |numerator, denominator| Rational(numerator, denominator) }
      .reduce(0,:+)
  end

  def first_n_rationals_sum(n)
    RationalSequence.new(n).reduce(0,:+)
  end

  def worthless(n)
    n_fibonacci_number = FibonacciSequence.new(n).to_a.last
    max_section_length = (1..Float::INFINITY).lazy
                           .take_while { |n| first_n_rationals_sum(n) <= n_fibonacci_number }
                           .to_a.last
    RationalSequence.new(max_section_length).to_a
  end
end