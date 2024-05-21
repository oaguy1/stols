(global utils (require "utils.fnl"))

{
 :init (fn [self]
         (local background-img (love.graphics.newImage "assets/background.png"))
         (tset self :animation (utils.gen-animation-table
                                               16
                                               background-img
                                               (utils.gen-quad-table background-img 32 32 0 16))))

 :update (fn [self dt]
           (let [curr-frame self.animation.curr-frame
                 anim-speed self.animation.speed
                 total-frames (length self.animation.quads)]
             (var next-frame (+ (* anim-speed dt) curr-frame))
             (when (> next-frame total-frames)
               (set next-frame 1))
               (set self.animation.curr-frame next-frame)))

 :draw (fn [self]
         (love.graphics.setColor 1 1 1)
         (for [i 0 (/ (love.graphics.getWidth) 32)]
           (for [j 0 (/ (love.graphics.getHeight) 32)]
             (love.graphics.draw self.animation.img
                                 (. self.animation.quads
                                    (math.floor self.animation.curr-frame))
                                 (* i 32)
                                 (* j 32)))))

}
