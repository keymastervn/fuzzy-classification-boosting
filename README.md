# Fuzzy Classification Boosting

Fuzzy rule-based classification system. Aim to apply boosting algorithm.

# Reference to paper

A Boosting Algorithm with Subset Selection of Training Patterns by Tomoham Nakashima, Gaku Nakai, and Hisao Ishibuchi / Department of Industrial Engineering, Osaka Prefecture University.

# Example description

The current example is about set of human with two main attributes _height_ and _weight_.
Based on the attributes, a human can be classified into 4 predefined Classes on following:

```
      "fuzzy_short|fuzzy_light"=>ShouldEatMore,
      "fuzzy_short|fuzzy_medium"=>ShouldDoExcercise,
      "fuzzy_short|fuzzy_heavy"=>ShouldEatLess,
      "fuzzy_average|fuzzy_light"=>ShouldDoExcercise,
      "fuzzy_average|fuzzy_medium"=>Fine,
      "fuzzy_average|fuzzy_heavy"=>ShouldEatLess,
      "fuzzy_tall|fuzzy_light"=>ShouldEatMore,
      "fuzzy_tall|fuzzy_medium"=>Fine,
      "fuzzy_tall|fuzzy_heavy"=>ShouldDoExcercise
```

In this example I use three anteccedent fuzzy sets for each attribute.

In Boosting Algorithm, see `training_patterns` for input, each of the input is treated as a subset with dp = 0. If the subsets is classify-able, then they are done. The remaining subsets called weak-learner will gradually joined and re-classify until they are all classified or meet `T` in recursion count. The final output which show "Terminated: xx xx" is the strong-learner.

There is a C_final class for each output but yet to be implemented.

# Example run

1. Install ruby
2. `$ gem install bundler`
3. `$ bundle install` for dependencies installing
4. `$ ruby main.rb`
