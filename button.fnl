(global button-font (love.graphics.getFont 18))

(fn new-button [x y width height text text-size color active? action]
  {:x x
   :y y
   :width width
   :height height
   :text text
   :textbox (love.graphics.newText button-font text)
   :text-size text-size
   :active? active?
   :action action
   :pressed false
   :background-color (case color
                       :xp [1 1 1]
                       :yellow [1 .775 0]
                       :green [.227 .652 .251])
   :background-color-pressed (case color
                               :xp [(/ 159 255) (/ 189 255) (/ 232 255)]
                               :yellow [1 .775 0]
                               :green [.064 .506 .0899])
   :inside-button? (fn inside-button? [self x y]
                     (and (<= self.x x)
                          (<= self.y y)
                          (<= x (+ self.x self.width))
                          (<= y (+ self.y self.height))))

   :set-text (fn set-text [self new-text]
               ;; set font and centering
               (local font (love.graphics.newFont self.text-size))
               (self.textbox:setf new-text self.width "center")
               (self.textbox:setFont font))

   :init (fn init [self]
           (self:set-text self.text))

   :draw (fn draw [self]

           ;; actual button drawing
           (if (and self.pressed (self.active?))
               (love.graphics.setColor (. self.background-color-pressed 1)
                                       (. self.background-color-pressed 2)
                                       (. self.background-color-pressed 3))
               (love.graphics.setColor (. self.background-color 1)
                                       (. self.background-color 2)
                                       (. self.background-color 3)))
           (love.graphics.rectangle "fill" self.x self.y self.width self.height 5 5)
           (love.graphics.setColor (. self.background-color-pressed 1)
                                   (. self.background-color-pressed 2)
                                   (. self.background-color-pressed 3))
           (love.graphics.setLineWidth 5)
           (love.graphics.rectangle "line" self.x self.y self.width self.height 5 5)
           (love.graphics.setColor 0 0 0)
           (love.graphics.setLineWidth 1)
           (love.graphics.rectangle "line" self.x self.y self.width self.height 5 5)

           (if (self.active?)
               (love.graphics.setColor 0 0 0)
               (love.graphics.setColor .7 .7 .7))
           (let [y-offset (- (/ self.height 2) (/ (self.textbox:getHeight) 2))]
             (love.graphics.draw self.textbox self.x (+ self.y y-offset))))
   })
