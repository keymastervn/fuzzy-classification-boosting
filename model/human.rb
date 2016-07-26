require './fuzzy_rule/height'
require './fuzzy_rule/weight'

class Human
  include Comparable
  attr_accessor :name, :sex, :height, :weight
  attr_accessor :fuzzy_dom, :cls

  APPLIED_FUZZY_RULES = [Height, Weight]

  def initialize(name, height, weight, sex)
    @name = name
    @height = height
    @weight = weight
    @sex = sex

    @fuzzy_dom = {}
  end

  def <=>(anOther)
    self.name <=> anOther.name
  end

  def get_fuzzy_info
    APPLIED_FUZZY_RULES.each {|cls|
      cls.list.each {|method|
        self.fuzzy_dom[method] = cls.send(method).get(self)
      }
    }

    self
  end

  def of_class classs
    @cls = classs
  end
end