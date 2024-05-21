{
  :gen-quad-table (fn gen-quad-table [img tile-width tile-height first-tile num-tiles]
                   (let [img-width (img:getWidth)
                         img-height (img:getHeight)
                         quads []]
                     (for [i first-tile num-tiles]
                       (table.insert quads (love.graphics.newQuad (+ (* i tile-width) i)
                                                                  0
                                                                  tile-width
                                                                  tile-height
                                                                  img-width
                                                                  img-height)))
                     quads))

 :gen-animation-table (fn gen-animation-table [speed img quads]
                        {:curr-frame 1 :speed speed :img img :quads quads})

}
