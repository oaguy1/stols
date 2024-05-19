{
 :init (fn init []
         (global frame-factory (require "frame.fnl"))
         (global frames [(frame-factory 10 30 120 120 5 )
                         (frame-factory 130 30 120 120 5 )
                         (frame-factory 250 30 120 120 5 )])

         (global money 100)
         (global bet 1)
         (global score-calculated false))

 :update (fn update [dt]
           (each [_ frame (ipairs frames)]
             (frame:update dt))

           ;; are we currently spinning?
           (var spinning false)
           (each [_ frame (ipairs frames)]
             (when frame.spinning
               (set spinning true)))

           ;; calculate score
           (when (and (not spinning) (not score-calculated))
             (var value (. (. frames 1) :value))
             (var won true)
             (each [_ frame (ipairs frames)]
               (when (not (= value frame.value))
                 (set won false)))

             (when won
               (set money (+ money (* value 10 bet))))

             (set score-calculated true)))


 :draw (fn draw []
         (love.graphics.print "STOLS" 10 10)
         (love.graphics.print (.. "Bet: $" (tostring bet)) 60 10)
         (love.graphics.print (.. "$" (tostring money)) 120 10)
         (each [_ frame (ipairs frames)]
           (frame:draw)))

 
 :mousereleased (fn mousereleased [x y button modeset]
                  )

 :keyreleased (fn keyreleased [key scancode modeset]
                (when (= key "up")
                  (set bet (+ bet 1)))

                (when (and (= key "down") (> bet 1))
                  (set bet (- bet 1)))

                (when (= key "space")
                  (set money (- money bet))
                  (set score-calculated false)
                  (each [_ frame (ipairs frames)]
                    (frame:spin 2))))

}
