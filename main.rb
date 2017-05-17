require 'set'

class WrongNumberOfPlayersError < StandardError; end
class NoSuchStrategyError < StandardError; end
class WrongCurrencyValueError < StandardError; end

# 1 task
def palindrome?(string)
  string.gsub!(/[[:punct:][:blank:]]/, '')
  string.downcase!
  return string == string.reverse
end


# 2 task
def count_words(string)
  string.gsub!(/[[:punct:]]/, '')
  string.downcase!
  words = string.split(' ')
  counter = Hash.new()
  words.each do |word|
    if counter.key?(word)
      counter[word] += 1
    else
      counter[word] = 1
    end
  end
  return counter
end


# 3 task
def rps_game_winner(inp)
  if inp.length > 2 then raise WrongNumberOfPlayersError, 'Wrong number of players' end
  turns = Set.new ['R', 'S', 'P']
  inp.each {|turn| unless turns.include?(turn[1]) then raise NoSuchStrategyError, 'No such strategy' end}

  if inp[0][1] == inp[1][1] then return inp[0] end

  case inp[0][1]
    when 'P'
      return case inp[1][1]
               when 'S' then inp[1]
               when 'R' then inp[0]
             end
    when 'S'
      return case inp[1][1]
               when 'R' then inp[1]
               when 'P' then inp[0]
             end
    when 'R'
      return case inp[1][1]
               when 'P' then inp[1]
               when 'S' then inp[0]
             end
  end
end


# 4 task
def combine_anagrams(words)
  words.map! {|x| x.downcase}
  anagrams = Hash.new()
  words.each do |word|
    sorted = word.chars.sort
    if anagrams.key?(sorted)
      anagrams[sorted] += [word]
    else
      anagrams[sorted] = [word]
    end
  end
  return anagrams.values
end


# 5 task
class Dessert
  attr_accessor :name, :calories

  def initialize(name, calories)
    @name = name
    @calories = calories
  end

  def healthy?
    return @calories < 200
  end

  def delicious?
    return true
  end
end


# 6 task
class JellyBean < Dessert
  attr_accessor :flavor

  def delicious?
    return @flavor != 'black licorice'
  end
end


# 7 task
class Numeric
  def dollar
    return NumericCurrency.new(self, :dollars)
    # if self == 1 then return NumericCurrency.new(self, :dollars) else raise WrongCurrencyValueError, 'Wrong currency value' end
  end

  def dollars
    return NumericCurrency.new(self, :dollars)
    # if self != 1 then return NumericCurrency.new(self, :dollars) else raise WrongCurrencyValueError, 'Wrong currency value' end
  end

  def ruble
    return NumericCurrency.new(self, :rubles)
    # if self == 1 then return NumericCurrency.new(self, :rubles) else raise WrongCurrencyValueError, 'Wrong currency value' end
  end

  def rubles
    return NumericCurrency.new(self, :rubles)
    # if self != 1 then return NumericCurrency.new(self, :rubles) else raise WrongCurrencyValueError, 'Wrong currency value' end
  end

  def euro
    return NumericCurrency.new(self, :euro)
  end
end


class NumericCurrency
  @@dollar = 32.26
  @@euro = 43.61

  def initialize(value, currency)
    @value = value
    @currency = currency
  end

  def in(currency)
    return case @currency
             when :dollars then case currency
                                  when :rubles then return @value*@@dollar
                                  when :euro then return @value*@@dollar/@@euro
                                  when :dollars then return @value
                                end
             when :rubles then case currency
                                 when :rubles then return @value
                                 when :euro then return @value/@@euro
                                 when :dollars then return @value/@@dollar
                               end
             when :euro then case currency
                               when :rubles then return @value*@@uero
                               when :euro then return @value
                               when :dollars then return @value*@@euro/@@dollar
                             end
           end
  end
end


# 8 task
class Class
  def attr_accessor_with_history(*args)
    args.each do |arg|
      # getter
      self.class_eval("def #{arg}; @#{arg}; end")

      # setter
      self.class_eval("def #{arg}=(val); @#{arg}=val; @#{arg}_history ||= [nil]; @#{arg}_history << val; end")

      # history extractor
      self.class_eval("def #{arg}_history; @#{arg}_history; end")
    end
  end
end


# 9 task
class String
  def palindrome?
    string = self
    string.gsub!(/[[:punct:][:blank:]]/, '')
    string.downcase!
    return string == string.reverse
  end
end


class Object
  def palindrome?
    if self.is_a? Enumerable
      forward = []
      self.each do |x|
        forward << x
      end
      reversed = forward.reverse
      return forward == reversed
    end
  end
end


# 10 task
class CartesianProduct
  attr_accessor :c
  def initialize(a, b)
    @a = a
    @b = b
    @c = []
    a.each do |x|
      b.each do |y|
        @c << [x, y]
      end
    end
  end

  def each(&block)
    @c.each(&block)
  end
end
