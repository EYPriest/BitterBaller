Class = require "hump.class"
Camera = require "hump.camera"

--local ProFi = require "ProFi"

local lg = love.graphics
lg.setDefaultFilter("nearest","nearest")

--SCALE = love.graphics.getHeight() / 240
SCALE = 1

--require "player"
require "ball"
require "title"
require "game"
require "block"
require "level1"
require "level2"
require "ramp"
require "top_block"
require "fake_block"
require "bob"
require "spike"
require "trophy"

scene = nil
local game = nil
local title = nil

local block_sprite = lg.newImage("res/Block1.png")
--sb = lg.newSpriteBatch(block_sprite,2000)

--Load
function love.load()
  
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  
  mobile = false
  if love.system.getOS() == 'iOS' or love.system.getOS() == 'Android' then
    mobile = true
  end
  
  --ProFi:start()
  
  camera = Camera(0,0)
  --camera.scale = 3
  camera.scale = love.graphics.getHeight() / 240
  
  game = Game()
  scene = game
  
end


--Inputs
function love.keypressed(key)
  if key == 'escape' then
    love.event.quit( 0 )
  else
    game:keypressed(key)
  end
end

--function love.keyboard.isDown

function love.keyreleased(key)
  --Player:keyreleased(key)
  game:keyreleased(key)
end

--[[
function love.mousepressed(x,y,button,istouch)
    --scene:mousepressed(x,y,button,isTouch)
    local id
    game:touchpressed(id,x,y,0,0,1)
end

function love.mousereleased(x,y,button,istouch)
    --scene:mousereleased(x,y,button,isTouch)
    local id
    game:touchreleased(id,x,y,0,0,1)
end

function love.touchpressed(id,x,y,dx,dy,pressure)
  game:touchpressed(id,x,y,dx,dy,pressure)
end

function love.touchreleased(id,x,y,dx,dy,pressure)
  game:touchreleased(id,x,y,dx,dy,pressure)
end
--]]

function love.update(dt)

  scene:update(dt)
  
end

function love.draw()

  scene:draw()

end

function love.quit()
  --ProFi:stop()
  --ProFi:writeReport()
end

--AABB to AABB
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  -- Collision detection function;
  -- Returns true if two boxes overlap, false if they don't;
  -- x1,y1 are the top-left coords of the first box, while w1,h1 are its width and height;
  -- x2,y2,w2 & h2 are the same, but for the second box.
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end