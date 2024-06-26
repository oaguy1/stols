;; main game loop and mode changing logic

(var mode nil)

(fn set-mode [mode-name ...]
  (set mode (require mode-name))
  (when mode.init
    (mode.init ...)))

(fn love.load []
  (set-mode "stols.fnl"))

(fn love.update [dt]
  (mode.update dt set-mode))

(fn love.draw []
  (mode.draw))

(fn love.mousepressed [x y button]
  (mode.mousepressed x y button set-mode))

(fn love.mousereleased [x y button]
  (mode.mousereleased x y button set-mode))

(fn love.keyreleased [key scancode]
  (mode.keyreleased key scancode set-mode))
