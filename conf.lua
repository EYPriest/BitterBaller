-- Configuration
function love.conf(t)
  t.title = "BitterBaller"
  --t.version = "11.2"
  
  t.window.width = 320 * 3
  t.window.height = 240 * 2
  
  t.window.fullscreen = love._os == "Android" or love._os == "iOS"
  
end