{
 :init (fn init []
         (global frame-factory (require "frame.fnl"))
         (global frames [(frame-factory 10 30 120 120 5 )
                         (frame-factory 130 30 120 120 5 )
                         (frame-factory 250 30 120 120 5 )]))

 :update (fn update [dt]
           (when (love.keyboard.isDown "space")
             (each [_ frame (ipairs frames)]
               (frame:spin 2)))
             
           (each [_ frame (ipairs frames)]
             (frame:update dt)))


 :draw (fn draw []
         (love.graphics.print "STOLS" 10 10)
         (each [_ frame (ipairs frames)]
           (frame:draw)))

 
 :mousereleased (fn mousereleased [x y button modeset]
                  )

}
