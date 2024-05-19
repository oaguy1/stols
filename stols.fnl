(global frame-factory (require "frame.fnl"))
(global button-factory (require "button.fnl"))
(local frame-start-x 10)
(local frame-start-y 30)
(local frame-end-x 610)
(local frame-end-y 520)


(fn create-frames [width height]
  (let [frames []
        frame-offset 10
        frame-height (/ (- frame-end-y frame-start-y (* frame-offset height)) height)
        frame-width (/ (- frame-end-x frame-start-x (* frame-offset width)) width)]
    (for [j 1 height]
      (for [i 1 width]
        (table.insert frames (frame-factory
                              (+ frame-start-x (* frame-width (- i 1)) (* frame-offset (- i 1)))
                              (+ frame-start-y (* frame-height (- j 1)) (* frame-offset (- j 1)))
                              frame-width
                              frame-height
                              10))))
    frames))


{
 :init (fn init []
         (global money 100)
         (global bet 1)
         (global spinning false)
         (global score-calculated false)

         (global frames-wide 3)
         (global frames-tall 1)
         (global frames (create-frames frames-wide frames-tall))

         (global buttons [(button-factory
                           80
                           530
                           400
                           60
                           "Spin"
                           (lambda []
                             (when (not spinning)
                               (set money (- money bet))
                               (set score-calculated false)
                               (each [_ frame (ipairs frames)]
                                 (frame:spin 2)))))
                          (button-factory
                           10
                           530
                           60
                           60
                           "Up Bet"
                           (lambda []
                             (set bet (+ bet 1))))
                          (button-factory
                           490
                           530
                           60
                           60
                           "Down Bet"
                           (lambda []
                             (when (> bet 1)
                               (set bet (- bet 1)))))
                          (button-factory
                           620
                           30
                           150
                           100
                           "Add Column\n($50)"
                           (lambda []
                             (when (< frames-wide 5)
                               (set money (- money 50))
                               (set frames-wide (+ frames-wide 1))
                               (set frames (create-frames frames-wide frames-tall)))))
                          (button-factory
                           620
                           140
                           150
                           100
                           "Add 2 Rows\n($100)"
                           (lambda []
                             (when (< frames-tall 5)
                               (set money (- money 100))
                               (set frames-tall (+ frames-tall 2))
                               (set frames (create-frames frames-wide frames-tall)))))
                          ]))



 :update (fn update [dt]
           (each [_ frame (ipairs frames)]
             (frame:update dt))

           ;; are we currently spinning?
           (set spinning false)
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
         (love.graphics.setColor 1 1 1)
         (love.graphics.print "STOLS" 10 10)
         (love.graphics.print (.. "Bet: $" (tostring bet)) 60 10)
         (love.graphics.print (.. "$" (tostring money)) 120 10)
         (each [_ frame (ipairs frames)]
           (frame:draw))

         (each [_ button (ipairs buttons)]
           (button:draw)))

 
 :mousepressed (fn mousereleased [x y button modeset]
                 (each [_ button (ipairs buttons)]
                   (when (button:inside-button? x y)
                     (set button.pressed true))))


 :mousereleased (fn mousereleased [x y button modeset]
                  (each [_ button (ipairs buttons)]
                    (set button.pressed false)
                    (when (button:inside-button? x y)
                      (button.action))))


 :keyreleased (fn keyreleased [key scancode modeset]
                (when (= key "up")
                  (set bet (+ bet 1)))

                (when (and (= key "down") (> bet 1))
                  (set bet (- bet 1)))

                (when (and (= key "space") (not spinning))
                  (set money (- money bet))
                  (set score-calculated false)
                  (each [_ frame (ipairs frames)]
                    (frame:spin 2))))

}
