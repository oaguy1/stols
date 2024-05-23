(global button-factory (require "button.fnl"))
(global background (require "background.fnl"))


{
 :init (fn init [...]
         (local mode-set ...)

         (global logo-img (love.graphics.newImage "assets/logo.png"))
         (global money-font (love.graphics.newFont 36))
         
         (background:init)

         (global buttons [(button-factory
                           200
                           320
                           400
                           60
                           "Play Again"
                           28
                           :green
                           (lambda [] true)
                           (lambda []
                             (mode-set "stols.fnl")))
                          ;; (button-factory
                          ;; 300
                          ;; 390
                          ;; 200
                          ;; 60
                          ;; "Quit to Menu"
                          ;; 18
                          ;; :green
                          ;; (lambda [] true)
                          ;; (lambda []
                          ;;   (mode-set "menu.fnl")))])
                          ])

         (each [_ button (ipairs buttons)]
           (button:init)))




 :update (fn update [dt mode-set]
           (background:update dt))
             


 :draw (fn draw []
         (background:draw)

         (love.graphics.setColor 1 1 1)
         (love.graphics.draw logo-img 250 70 0 .20 .20)
         (love.graphics.setFont money-font)
         (love.graphics.printf "You're a Millionaire!" 0 250 800 "center")

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
                )

}
