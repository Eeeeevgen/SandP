# Просьба указать версию Ruby, для которой приведены решения
# ruby 2.4.1p111 (2017-03-22 revision 58053) [x86_64-linux]

# По всем зачачам: Ruby при выполнении методов и блоков возвращает последнее вычисленное значение и использование
# ключевого слова return не является обязательным и обычно используется для преждевременного выхода и блока с
# возвращением какого-то значения
# Просьба убрать из всех задачек лишние return'ы

# Так же просьба ознакомиться со style guide'ом https://github.com/bbatsov/ruby-style-guide и постараться поправить код
# задач в соответствии с рекомендациями данного гайда

class WrongNumberOfPlayersError < StandardError; end
class NoSuchStrategyError < StandardError; end
class WrongCurrencyValueError < StandardError; end

# 1 task
# Тут все верно, единственное что можно поправить соединить методы gsub и downcase в одну цепочку

def palindrome?(string)
  string = string.gsub(/[[:punct:][:blank:]]/, '').downcase
  string == string.reverse
end

# 2 task
# Тут часть методов можно соединить в pipe, также просьба подумать, как решить эту задачу короче (Подсказка, можно
# создать хэш с дефолтным значением для любого ключа)

def count_words(string)
  string = string.gsub(/[[:punct:]]/, '').downcase
  words = string.split(' ')
  counter = Hash.new(0)
  words.each { |word| counter[word] += 1 }
  counter
end

# 3 task
# Зачем подключается модуль Set и почему не используется обычный массив?
# В Ruby условный оператор может быть как префиксным так и постфиксным и вторая строчка переписывается в следующую:
# raise WrongNumberOfPlayersError, 'Wrong number of players' if inp.length > 2 - что намного проще ситается и воспринимается глазами

def rps_game_winner(inp)
  raise WrongNumberOfPlayersError, 'Wrong number of players' if inp.length > 2
  turns = %w(R S P)
# Попробовать переписать следующую строчку в более удобочитаемой форме (возможно в несколько строк)
  inp.each do |turn|
    raise NoSuchStrategyError, 'No such strategy' unless turns.include?(turn[1])
  end

  if inp[0][1] == inp[1][1] then return inp[0] end

  case inp[0][1]
  when 'P'
    case inp[1][1]
    when 'S' then inp[1]
    when 'R' then inp[0]
    end
  when 'S'
    case inp[1][1]
    when 'R' then inp[1]
    when 'P' then inp[0]
    end
  when 'R'
    case inp[1][1]
    when 'P' then inp[1]
    when 'S' then inp[0]
    end
  end
end

# 4 task
# Существует более короткое решение. Попробовать решить задачу в использованием методов группировки.

def combine_anagrams(words)
  words.map! { |x| x.downcase }
  anagrams = words.group_by { |word| word.chars.sort }
  anagrams.values
end

# 5 task
# Все ОК (кроме лишних return'ов)

class Dessert
  attr_accessor :name, :calories

  def initialize(name, calories)
    @name = name
    @calories = calories
  end

  def healthy?
    @calories < 200
  end

  def delicious?
    true
  end
end

# 6 task
class JellyBean < Dessert
  attr_accessor :flavor

  def delicious?
    @flavor != 'black licorice'
  end
end

# 7 task
# Отличное ООП-решение
# Просьба переписать избегая дублирования кода с использованием алисов методов, а также избегая переменных класса, заменив их на константы

class Numeric
  def dollar
    NumericCurrency.new(self, :dollars)
  end
  alias_method :dollars, :dollar

  def ruble
    NumericCurrency.new(self, :rubles)
  end
  alias_method :rubles, :ruble

  def euro
    NumericCurrency.new(self, :euro)
  end

  # currencies = %w(dollar dollars ruble rubles euro)
  # currencies.each do |c|
  #   define_method("#{c}") do
  #     NumericCurrency.new(self, :"#{c}")
  #   end
  # end
end

class NumericCurrency
  Dollar = 32.26
  Euro = 43.61

  def initialize(value, currency)
    @value = value
    @currency = currency
  end

  def in(currency)
    case @currency
    when :dollars, :dollar
      case currency
      when :rubles then @value * Dollar
      when :euro then @value * Dollar / Euro
      when :dollars then @value
      end
    when :rubles, :ruble
      case currency
      when :rubles then @value
      when :euro then @value / Euro
      when :dollars then @value / Dollar
      end
    when :euro
      case currency
      when :rubles then @value * Euro
      when :euro then @value
      when :dollars then @value * Euro / Dollar
      end
    end
  end
end

# 8 task
# Решение верное, но просьба переписать используя медот define_method, а не интерпретируя строку в код - это медленно и крайне не безопасно

class Class
  def attr_accessor_with_history(*args)
    args.each do |arg|
      # getter
      define_method("#{arg}") do
        instance_variable_get("@#{arg}")
      end

      # setter
      define_method("#{arg}=") do |val|
        instance_variable_set("@#{arg}", val)
        history = instance_variable_get("@#{arg}_history")
        history ||= [nil]
        history << val
        instance_variable_set("@#{arg}_history", history)
      end

      # history extractor
      define_method("#{arg}_history") do
        instance_variable_get("@#{arg}_history")
      end
    end
  end
end

# 9 task
# Вешение рабочее, но просьба найти решение, в котором не расширяются базовые String, а тем более основной класс Object
# Попробовать реализовать одним методом

class String
  def palindrome?
    string = self.gsub(/[[:punct:][:blank:]]/, '').downcase
    string == string.reverse
  end
end

module Enumerable
  def palindrome?
    forward = self.collect { |i| i }
    forward == forward.reverse
  end
end

# 10 task
# Верное решение. Существует более простое и короткое решение (Подсказка: не создавать лишнюю переменную и метод который
# возвращает всевозможные комбинации перемножаемых массивов)

class CartesianProduct
  def initialize(a, b)
    @a = a
    @b = b
  end

  def each
    @a.each do |x|
      @b.each do |y|
        yield [x, y]
      end
    end
  end
end