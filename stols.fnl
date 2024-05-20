(global frame-factory (require "frame.fnl"))
(global button-factory (require "button.fnl"))
(global wild-value -1)
(local frame-start-x 10)
(local frame-start-y 10)
(local frame-end-x 610)
(local frame-end-y 520)


(fn create-frames [width height total-symbols]
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
                              total-symbols))))
    frames))

(fn get-index [i j width]
  (+ i (* width (- j 1))))


(fn get-intervals [width height]
  (let [intervals []
        interval-length 3
        dirs {:right [1 0] :down [0 1] :diag-down [1 1] :diag-up [1 -1]}]
    (for [j 1 height]
      (for [i 1 width]
        (each [_ [di dj] (pairs dirs)]
          (when (and (<= (+ i (* di (- interval-length 1))) width)
                     (<= (+ j (* dj (- interval-length 1))) height)
                     (>= (+ j (* dj (- interval-length 1))) 1)
                     (>= (+ j (* dj (- interval-length 1))) 1))
            (local interval [])
            (for [curr-interval 0 (- interval-length 1)]
              (table.insert interval (get-index (+ i (* curr-interval di)) (+ j (* curr-interval dj)) width)))
            (table.insert intervals interval)))))
    intervals))

{
 :init (fn init []
         (global background-img (love.graphics.newImage "assets/background.png"))
         (global logo-img (love.graphics.newImage "assets/logo.png"))
         (global money-font (love.graphics.newFont 36))
         (global bet-font (love.graphics.newFont 24))

         (global money 100)
         (global bet 1)
         (global spinning false)
         (global score-calculated false)

         (global frames-wide 3)
         (global frames-tall 1)
         (global max-symbols 8)
         (global frames (create-frames frames-wide frames-tall max-symbols))

         (global buttons [(button-factory
                           80
                           530
                           400
                           60
                           "Spin"
                           (lambda []
                             (when (and (not spinning) (>= money bet))
                               (set money (- money bet))
                               (set score-calculated false)
                               (each [_ frame (ipairs frames)]
                                 (set frame.won false)
                                 (frame:spin 2)))))
                          (button-factory
                           10
                           530
                           60
                           60
                           "Bet\nUp"
                           (lambda []
                             (set bet (+ bet 1))))
                          (button-factory
                           490
                           530
                           60
                           60
                           "Bet\nDown"
                           (lambda []
                             (when (> bet 1)
                               (set bet (- bet 1)))))
                          (button-factory
                           620
                           110
                           150
                           80
                           "Add Column\n($50)"
                           (lambda []
                             (when (< frames-wide 5)
                               (set money (- money 50))
                               (set frames-wide (+ frames-wide 1))
                               (set frames (create-frames frames-wide frames-tall max-symbols)))))
                          (button-factory
                           620
                           200
                           150
                           80
                           "Add 2 Rows\n($100)"
                           (lambda []
                             (when (< frames-tall 5)
                               (set money (- money 100))
                               (set frames-tall (+ frames-tall 2))
                               (set frames (create-frames frames-wide frames-tall max-symbols)))))
                          (button-factory
                           620
                           290
                           150
                           80
                           "Add High Symbol\n($10)"
                           (lambda []
                             (when (< max-symbols 12)
                               (set money (- money 10))
                               (set max-symbols (+ max-symbols 1))
                               (set frames (create-frames frames-wide frames-tall max-symbols)))))
                          (button-factory
                           620
                           380
                           150
                           80
                           "Joker is Wild\n($500)"
                           (lambda []
                             (when (= wild-value -1)
                               (set money (- money 500))
                               (set wild-value 12))))])

         (global user-won-strategies [(lambda []
                                        ;; all match, highest payout
                                        ;; only used when an upgrade has been purchased
                                        (var winnings 0)
                                        (when (or (> frames-wide 3) (> frames-tall 1))
                                          (var value (. (. frames 1) :value))
                                          (var won true)
                                          (each [_ frame (ipairs frames)]
                                            (when (not (= value frame.value))
                                              (set won false)))
                                          (when won
                                            (set winnings (* value 100 bet))))
                                        winnings)
                                      (lambda []
                                        ;; three in a row
                                        (var winnings 0)
                                        (each [_ interval (ipairs (get-intervals frames-wide frames-tall))]
                                          (var won true)

                                          ;; find first non-wild value, messy but works
                                          (var value (. (. frames (. interval 1)) :value))
                                          (when (= value wild-value)
                                            (set value (. (. frames (. interval 2)) :value)))
                                          (when (= value wild-value)
                                            (set value (. (. frames (. interval 3)) :value)))

                                          ;; search interval for winning set
                                          (each [_ idx (ipairs interval)]
                                            (let [frame (. frames idx)]
                                              (when (and (not (= value frame.value))
                                                         (not (= wild-value frame.value)))
                                                (set won false))))

                                          ;; handle winning
                                          (when won
                                            (set winnings (+ winnings (* value 10 bet)))
                                            (each [_ idx (ipairs interval)]
                                              (let [frame (. frames idx)]
                                                (set frame.won true)))))
                                        winnings)
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
             (each [_ strategy (ipairs user-won-strategies)]
               (set money (+ money (strategy))))
             (set score-calculated true)))


 :draw (fn draw []
         ;; tiled background
         (love.graphics.setColor 1 1 1)
         (for [i 0 (/ (love.graphics.getWidth) (background-img:getWidth))]
           (for [j 0 (/ (love.graphics.getHeight) (background-img:getHeight))]
             (love.graphics.draw background-img (* i (background-img:getWidth)) (* j (background-img:getHeight)))))

         (love.graphics.setColor 1 1 1)
         (love.graphics.draw logo-img 620 10 0 .10 .10)
         (love.graphics.setFont money-font)
         (love.graphics.print (.. "$" (tostring money)) 620 520)
         (love.graphics.setFont bet-font)
         (love.graphics.print (.. "Bet: $" (tostring bet)) 620 560)
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

                (when (and (= key "space") (not spinning) (>= money bet))
                  (set money (- money bet))
                  (set score-calculated false)
                  (each [_ frame (ipairs frames)]
                    (set frame.won false)
                    (frame:spin 2))))

}
