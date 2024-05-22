(fn new-upgrade [base-price total-activations effect]
  {
   :level 0
   :base-price base-price
   :total-activations total-activations
   :effect effect
   :do-upgrade (fn do-upgrade [self]
                 (set self.level (+ self.level 1))
                 (self.effect))
   :get-price (fn get-price [self]
                (* self.base-price (^ 2 self.level)))
   })
   
