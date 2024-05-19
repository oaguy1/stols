(fn new-frame [x y width height top-range]
  {:x x
   :y y
   :width width
   :height height
   :top-range top-range
   :slots [(love.graphics.newImage "assets/club.png")
           (love.graphics.newImage "assets/spade.png")
           (love.graphics.newImage "assets/diamond.png")
           (love.graphics.newImage "assets/heart.png")
           (love.graphics.newImage "assets/grapes.png")
           (love.graphics.newImage "assets/lemon.png")
           (love.graphics.newImage "assets/orange.png")
           (love.graphics.newImage "assets/strawberry.png")
           (love.graphics.newImage "assets/watermelon.png")
           (love.graphics.newImage "assets/clover.png")
           (love.graphics.newImage "assets/horseshoe.png")
           (love.graphics.newImage "assets/joker.png")]
   :value (love.math.random 1 top-range)
   :spinning false
   :dt 0
   :spin (fn spin [self duration]
           (when (not self.spinning)
             (set self.spinning true)
             (set self.dt duration)))

   :update (fn update [self dt]
             (when self.spinning
               (set self.dt (- self.dt dt))
               (set self.value (love.math.random 1 top-range))
               (when (<= self.dt 0)
                 (set self.spinning false))))

   :draw (fn draw [self]
           (love.graphics.setColor 1 1 1)
           (love.graphics.rectangle "fill" self.x self.y self.width self.height)
           (let [curr-graphic (. self.slots self.value)
                 scale-target (- (math.min self.width self.height) 10)
                 scale-factor (/ scale-target (math.max (curr-graphic:getWidth) (curr-graphic:getHeight)))
                 scaled-width (* scale-factor (curr-graphic:getWidth))
                 scaled-height (* scale-factor (curr-graphic:getHeight))
                 x-offset (- (/ self.width 2) (/ scaled-width 2))
                 y-offset (- (/ self.height 2) (/ scaled-height 2))]
             
             (love.graphics.draw curr-graphic (+ self.x x-offset) (+ self.y y-offset) 0 scale-factor scale-factor))) 
  })
