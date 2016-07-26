require 'fuzzy-logic'
require './helper'

class Height
  MALE = 'm'
  FEMALE = 'f'

  def self.list
    self.methods.keep_if {|meth| meth.to_s.start_with? "fuzzy"}
  end

  def self.fuzzy_short
    return FuzzyLogic::Set.new(1) { |human|
      # default output is zero
      dom = 0.0
      case human.sex
      when MALE
        left = 160
        top = 160
        right = 170
      when FEMALE
        left = 152
        top = 152
        right = 160
      end

      if human.height <= left
        dom = 1.0
      end

      if human.height > left && human.height < right
        dom = 1.0 - (top - human.height)/(top - right).to_f
      end

      dom.round(3)
    }
  end

  def self.fuzzy_average
    return FuzzyLogic::Set.new(1) { |human|
      dom = 0.0

      case human.sex
      when MALE
        left = 160
        top = 170
        right = 180
      when FEMALE
        left = 152
        top = 160
        right = 168
      end

      if human.height > left && human.height < right
        dom = Helper.triangle_calculate_membership(left,top,right,human.height)
      end

      dom.round(3)
    }
  end

  def self.fuzzy_tall
    return FuzzyLogic::Set.new(1) { |human|
      dom = 0.0
      case human.sex
      when MALE
        left = 170
        top = 180
        right = 180
      when FEMALE
        left = 160
        top = 168
        right = 168
      end

      if human.height >= right
        dom = 1.0
      end

      if human.height > left && human.height < right
        dom = 1.0 - (top - human.height)/(top - left).to_f
      end

      dom.round(3)
    }
  end
end