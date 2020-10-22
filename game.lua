Game = Class {}

local lg = love.graphics
local trophy_sprite = lg.newImage("res/Trophy.png")
local dog_sprite = lg.newImage("res/Dog1.png")
local block_sprite = lg.newImage("res/Block1.png")

local checkpoint = 0

local dead_countdown_time = 20
local dead_countdown = dead_countdown_time

debug_time_t1 = 0
debug_time_t2 = 0
debug_time_t3 = 0
debug_time_t4 = 0
debug_time_t5 = 0
debug_time_t6 = 0

function Game:init()
  
  local spawn_position
  
  if ( checkpoint == 4 ) then
    spawn_position = {x=980,y=220}
  elseif ( checkpoint == 3 ) then
    spawn_position = {x=900,y=400}
  elseif ( checkpoint == 2 ) then
    spawn_position = {x=30,y=340}
  elseif ( checkpoint == 1 ) then
    spawn_position = {x=920,y=40}
  else
    spawn_position = {x=30,y=40}
    --spawn_position = {x=900,y=340}
  end
    
  --self.ball = Ball({x=30,y=40})
  
  self.ball = Ball(spawn_position)
  
  --self.ball = Ball({x=920,y=40})
  --self.ball = Ball({x=30,y=340})
  --self.ball = Ball({x=900,y=400})
  
  --self.ball = Ball({x=900,y=400})
  --self.ball = Ball({x=1170,y=150})
  --self.ball = Ball({x=1110,y=150})
  self.bob = Bob(self.ball)
  camera:lookAt(self.ball.pos.x,self.ball.pos.y)
  
  self.level = Level2()
  --Level2()
  self.STATE_ALIVE = 1
  self.STATE_DEAD = 2
  self.STATE_WIN = 3
  self.state = self.STATE_ALIVE
end

-- Inputs
function Game:keypressed(key)
  --self.ball:keypressed(key)
  self.bob:keypressed(key)
end
function Game:keyreleased(key)
  --Player:keyreleased(key)
  self.ball:keyreleased(key)
end

--[[
function Game:touchpressed(id,x,y,dx,dy,pressure)
  --self.ball:touchpressed(id,x,y,dx,dy,pressure)
  self.bob:touchpressed(id,x,y,dx,dy,pressure)
end

function Game:touchreleased(id,x,y,dx,dy,pressure)
  self.ball:touchreleased(id,x,y,dx,dy,pressure)
end
--]]

-- Update
function Game:update(dt)
  
  debug_time_t1 = love.timer.getTime()
  
  if ( self.state == self.STATE_ALIVE ) then
    
    self.ball:update(dt)
    self.bob:update(dt)
    
    camera:lookAt(self.ball.pos.x,self.ball.pos.y-16)
    
    if ( checkpoint == 0 and self.ball.pos.x >= 800 ) then
      checkpoint = 1
      --print("1")
    elseif ( checkpoint == 1 and self.ball.pos.y > 340 ) then
      checkpoint = 2
      --print("2")
    elseif ( checkpoint == 2 and self.ball.pos.x >= 900 and self.ball.pos.y > 340 ) then
      checkpoint = 3
      --print("3")
    elseif ( checkpoint == 3 and self.ball.pos.x >= 1020 and self.ball.pos.y < 216 ) then
      checkpoint = 4
      --print("3")
    end
    
  elseif ( self.state == self.STATE_DEAD ) then
    --Game:init()
    dead_countdown = dead_countdown -1
    if ( dead_countdown < 0 ) then
      dead_countdown = dead_countdown_time
      love.load()
    end
  elseif ( self.state == self.STATE_WIN ) then
    camera:lookAt(0,-120)
  end
  
  --TODO: look at Bob centerpoint
  
  --local dx,dy = self.player.pos.x - camera.x, self.player.pos.y - camera.y
  --camera:move(dx/2,dy/2)
  
  debug_time_t2 = love.timer.getTime()
  
end

-- Draw
function Game:draw()
  
  debug_time_t3 = love.timer.getTime()
  
  camera:attach()

  self.ball:draw()
  debug_time_t4 = love.timer.getTime()
  self.bob:draw()
  debug_time_t5 = love.timer.getTime()
  self.level:draw()
  --lg.draw(sb)
  debug_time_t6 = love.timer.getTime()
  

 
 if ( self.state == self.STATE_WIN ) then
 
    --[[
    --local cx,cy = camera:position()
    if (true) then
    --if( self.state == self.STATE_WIN ) then
      for w = 60,180 do
        for h = -20,40 do
          lg.draw(dog_sprite,w*8,h*8,0,SCALE,SCALE)
        end
      end
    end
    --]]
    
      --local cx,cy = camera:position()
    if (true) then
    --if( self.state == self.STATE_WIN ) then
      for w = -60,59 do
        for h = -30,-26 do
          lg.draw(dog_sprite,w*8,h*8,0,SCALE,SCALE)
        end
      end
    end
    
        --local cx,cy = camera:position()
    if (true) then
    --if( self.state == self.STATE_WIN ) then
      for w = -60,59 do
        for h = -5,-1 do
          lg.draw(dog_sprite,w*8,h*8,0,SCALE,SCALE)
        end
      end
    end
    
    local drawX = {-17,-17,-16,-16,-15,-15,-15,-15,-15,-14,-14,-14,-13,-13, -11,-11,-11,-11,-11,-10,-10, -9, -9, -8, -8, -7, -7, -7, -7, -7, -5, -5, -5, -5, -5, -5, -4, -3, -2, -1, -1, -1, -1, -1, -1 }
    local drawY = {-18,-17,-17,-16,-16,-15,-14,-13,-12,-16,-16,-17,-17,-18, -17,-16,-15,-14,-13,-18,-12,-18,-12,-18,-12,-17,-16,-15,-14,-13,-18,-17,-16,-15,-14,-13,-12,-12,-12,-18,-17,-16,-15,-14,-13 }
    
    for i = 1, #drawX do
      lg.draw(block_sprite,drawX[i]*8,drawY[i]*8,0,SCALE,SCALE)
    end
    
    --local drawX2 = {  2,  2,  2,  3,  3,  3,  4,  5,  5,  6,  7,  7,  7,  8,  8,  8        }
    --local drawY2 = {-18,-17,-16,-15,-14,-13,-12,-13,-14,-12,-13,-14,-15,-16,-17,-18          }
    
    local drawX2 = {  3,  3,  3,  3,  3,  3,  4,  4,  5,  5,  5,  6,  6,  7,  7,  7,  7,  7,  7,   9,  9,  9,  9,  9,  9,  9 }
    local drawY2 = {-18,-17,-16,-15,-14,-13,-13,-12,-15,-14,-13,-12,-13,-13,-14,-15,-16,-17,-18, -18,-17,-16,-15,-14,-13,-12 }
    
    for i = 1, #drawX2 do
      lg.draw(block_sprite,drawX2[i]*8,drawY2[i]*8,0,SCALE,SCALE)
    end
    
    local drawX3 = { 11, 11, 11, 11, 11, 11, 11, 12, 12, 13, 13, 14, 14, 14, 14, 14, 14, 14, 16, 16, 16, 16, 16, 16 }
    local drawY3 = {-18,-17,-16,-15,-14,-13,-12,-16,-15,-15,-14,-18,-17,-16,-15,-14,-13,-12,-18,-17,-16,-15,-14,-12 }
    
    for i = 1, #drawX3 do
      lg.draw(block_sprite,drawX3[i]*8,drawY3[i]*8,0,SCALE,SCALE)
    end
    
  end
  
  
  
  lg.print( "update: " .. (debug_time_t2 - debug_time_t1)*60, -230 + camera.x, -120 + camera.y, 0, 1,1 )
  lg.print( "draw: " .. (debug_time_t6 - debug_time_t3)*60, -230 + camera.x, -105 + camera.y, 0, 1,1 )
  lg.print( "ball: " .. (debug_time_t4 - debug_time_t3)*60, -230 + camera.x, -90 + camera.y, 0, 1,1 )
  lg.print( "bob: " .. (debug_time_t5 - debug_time_t4)*60, -230 + camera.x, -75 + camera.y, 0, 1,1 )
  lg.print( "level: " .. (debug_time_t6 - debug_time_t5)*60, -230 + camera.x, -60 + camera.y, 0, 1,1 )
  
  camera:detach()
  
end

