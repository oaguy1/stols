(fn new-button [x y width height text action]
  {:x x
   :y y
   :width width
   :height height
   :text text
   :action action
   :pressed false
   :inside-button? (fn inside-button? [self x y]
                     (and (<= self.x x)
                          (<= self.y y)
                          (<= x (+ self.x self.width))
                          (<= y (+ self.y self.height))))
   :draw (fn draw [self]
           (if self.pressed
             (love.graphics.setColor (/ 159 255) (/ 189 255) (/ 232 255))
             (love.graphics.setColor 1 1 1))
           (love.graphics.rectangle "fill" self.x self.y self.width self.height 5 5)
           (if self.pressed
             (love.graphics.setColor (/ 159 255) (/ 189 255) (/ 232 255))
             (love.graphics.setColor (/ 159 255) (/ 189 255) (/ 232 255)))
           (love.graphics.setLineWidth 5)
           (love.graphics.rectangle "line" self.x self.y self.width self.height 5 5)
           (love.graphics.setColor 0 0 0)
           (love.graphics.setLineWidth 1)
           (love.graphics.rectangle "line" self.x self.y self.width self.height 5 5)
           (love.graphics.printf self.text self.x (+ 10 self.y) self.width "center"))
   })
