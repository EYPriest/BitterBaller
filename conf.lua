-- Configuration
function love.conf(t)
  t.title = "BitterBaller"
  --t.version = "11.2"
  
  --t.window.usedpiscale = false

  t.window.width = 320 * 2
  t.window.height = 240 * 2
  
  t.window.width = 800
  t.window.height = 600
  
  t.window.fullscreen = love._os == "Android" or love._os == "iOS"
  
  t.window.vsync = false
  
end