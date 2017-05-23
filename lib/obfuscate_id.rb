module ScatterSwap
  class Hasher
    attr_accessor :working_array

    DIGITS_COUNT = 8

    def initialize(original_integer, spin = 0)
      @original_integer = original_integer
      @spin = spin
      zero_pad = original_integer.to_s.rjust(DIGITS_COUNT, '0')
      @working_array = zero_pad.split('').map(&:to_i)
    end

    # obfuscates an integer up to 10 digits in length
    def hash
      swap
      scatter
      completed_string
    end

    # de-obfuscates an integer
    def reverse_hash
      unscatter
      unswap
      completed_string
    end

    def completed_string
      @working_array.join
    end

    # We want a unique map for each place in the original number
    def swapper_map(index)
      array = (0..9).to_a
      10.times.collect.with_index do |i|
        array.rotate!(index + i ^ spin).pop
      end
    end

    # Using a unique map for each of the ten places,
    # we swap out one number for another
    def swap
      @working_array = @working_array.collect.with_index do |digit, index|
        swapper_map(index)[digit]
      end
    end

    # Reverse swap
    def unswap
      @working_array = @working_array.collect.with_index do |digit, index|
        swapper_map(index).rindex(digit)
      end
    end

    # Rearrange the order of each digit in a reversable way by using the
    # sum of the digits (which doesn't change regardless of order)
    # as a key to record how they were scattered
    def scatter
      sum_of_digits = @working_array.inject(:+).to_i
      @working_array = Array.new(DIGITS_COUNT) do
        @working_array.rotate!(spin ^ sum_of_digits).pop
      end
    end

    # Reverse the scatter
    def unscatter
      scattered_array = @working_array
      sum_of_digits = scattered_array.inject(:+).to_i
      @working_array = []
      @working_array.tap do |unscatter|
        DIGITS_COUNT.times do
          unscatter.push scattered_array.pop
          unscatter.rotate!((sum_of_digits ^ spin) * -1)
        end
      end
    end

    # Add some spice so that different apps can have differently mapped hashes
    def spin
      @spin || 0
    end
  end

  def self.hash(plain_integer, spin = 0)
    Hasher.new(plain_integer, spin).hash
  end

  def self.reverse_hash(hashed_integer, spin = 0)
    Hasher.new(hashed_integer, spin).reverse_hash
  end
end

module ObfuscateId
  def obfuscate_id(options = {})
    extend ClassMethods
    include InstanceMethods
    cattr_accessor :obfuscate_id_spin
    self.obfuscate_id_spin = (options[:spin] || obfuscate_id_default_spin)
  end

  def self.hide(id, spin)
    ScatterSwap.hash(id, spin)
  end

  def self.show(id, spin)
    ScatterSwap.reverse_hash(id, spin)
  end

  module ClassMethods
    def deobfuscate_id(obfuscated_id)
      ObfuscateId.show(obfuscated_id, obfuscate_id_spin)
    end

    # Generate a default spin from the Model name
    # This makes it easy to drop obfuscate_id onto any model
    # and produce different obfuscated ids for different models
    def obfuscate_id_default_spin
      alphabet = Array('a'..'z')
      number = name.split('').map do |char|
        alphabet.index(char)
      end

      number.shift(12).join.to_i
    end
  end

  module InstanceMethods
    def obfuscated_id
      ObfuscateId.hide(id, self.class.obfuscate_id_spin)
    end

    def deobfuscate(obfuscated_id)
      self.class.deobfuscate_id(obfuscated_id)
    end
  end
end
