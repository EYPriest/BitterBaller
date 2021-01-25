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

local store_dt = 0
local dt_per_frame = 1/60

--Store on Finger Release
--last_move_touch = lg.getWidth() / 12
--last_move_direction = 1 -- -1 for left, 1 for right
movement_touch_line = lg.getWidth() / 12
--print(movement_touch_line)

--Current Stuff
move_direction = 0
jump_touch = false
move_touch = -1

--previous_release_move_direction = 0
last_move_direction = 1


function Game:restart()

  dead_countdown = dead_countdown_time
  
  self.ball = {}
  self.ball = {}
  self.level = {}
  
  Game.init(self)
end

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
  end
  
  self.ball = Ball(spawn_position)
  
  self.bob = Bob(self.ball)
  camera:lookAt(self.ball.pos.x,self.ball.pos.y-16)
  
  self.level = Level2()
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
  
  store_dt = store_dt + dt
  
  while ( store_dt >= dt_per_frame ) do
    store_dt = store_dt - dt_per_frame
    Game.DoATick(self,dt_per_frame)
  end
  
end

function Game:DoATick(dt)
  
  camera.scale = love.graphics.getHeight() / 240
  
  --debug_time_t1 = love.timer.getTime()
  
  --print(last_move_touch)
  
  --print(movement_touch_line)
  
  if ( self.state == self.STATE_ALIVE ) then
    
    -- Player Movement
    
    --[[
    --local jumpTouch = false
    local touches = love.touch.getTouches( )
    local new_move_direction = 0
    move_direction = 0
    last_jump_touch = false
    
    for i, id in ipairs(touches) do
      local x, y = love.touch.getPosition(id) 

      if ( x >= 0 and x < lg.getWidth() / 2 ) then
        leftTouch = true
      elseif ( x >= lg.getWidth() / 12 and x < lg.getWidth() / 2 ) then
        rightTouch = true
      end

      if ( x < lg.getWidth() / 2 ) then
        
        local offset = 0
        if ( last_move_direction == -1 ) then
          offset = 10
        elseif ( last_move_direction == 1 ) then
          offset = -10
        end
        
        if ( x == last_move_touch + offset ) then
          new_move_direction = last_move_direction
        elseif ( x <= last_move_touch + offset ) then
          new_move_direction = -1
        elseif ( x >= last_move_touch + offset ) then
          new_move_direction = 1
        end
        last_move_touch = x
        last_move_direction = new_move_direction
        move_direction = new_move_direction
      end
      
      if ( x >= lg.getWidth() / 2 ) then
        --jumpTouch = true
        last_jump_touch = true
      end
    end
    --]]
    
    
    local new_move_touch = -1
    
    local previous_move_direction = move_direction
    move_direction = 0
    jump_touch = false
    local touches = love.touch.getTouches( )
    for i, id in ipairs(touches) do
      local x, y = love.touch.getPosition(id) 
      
      if ( x < lg.getWidth() / 2 ) then
        new_move_touch = x
        if ( x == movement_touch_line ) then
          move_direction = last_move_direction
        elseif ( x < movement_touch_line ) then
          move_direction = -1
        elseif ( x > movement_touch_line ) then
          move_direction = 1
        end
        last_move_direction = move_direction
      elseif ( x >= lg.getWidth() / 2 ) then
        --jumpTouch = true
        jump_touch = true
      end
    end
    
    --[[
    if ( move_touch ~= -1 and new_move_touch == -1 ) then -- finger release
      movement_touch_line = move_touch - (20*previous_move_direction)
    elseif ( move_touch == -1 and new_move_touch ~= -1 ) then -- finger press
      movement_touch_line = new_move_touch - (20*move_direction)
    end
    move_touch = new_move_touch
    --]]
    
    local offset = 20
    if ( new_move_touch ~= -1 ) then
      if ( new_move_touch > movement_touch_line + offset ) then
        movement_touch_line = new_move_touch - offset
      elseif ( new_move_touch < movement_touch_line - offset ) then
        movement_touch_line = new_move_touch + offset
      end
    end
    
    self.ball:update(dt)
    self.bob:update(dt)
    
    camera:lookAt(self.ball.pos.x,self.ball.pos.y-16)
    
    if ( checkpoint == 0 and self.ball.pos.x >= 800 ) then
      checkpoint = 1
    elseif ( checkpoint == 1 and self.ball.pos.y > 340 ) then
      checkpoint = 2
    elseif ( checkpoint == 2 and self.ball.pos.x >= 900 and self.ball.pos.y > 340 ) then
      checkpoint = 3
    elseif ( checkpoint == 3 and self.ball.pos.x >= 1020 and self.ball.pos.y < 216 ) then
      checkpoint = 4
    end
    
  elseif ( self.state == self.STATE_DEAD ) then
    dead_countdown = dead_countdown -1
    if ( dead_countdown < 0 ) then
      dead_countdown = dead_countdown_time
      Game.restart(self)
    end
  elseif ( self.state == self.STATE_WIN ) then
    camera:lookAt(0,-120)
  end
  
  --debug_time_t2 = love.timer.getTime()
end

-- Draw
function Game:draw()
  
  --debug_time_t3 = love.timer.getTime()
  
  camera:attach()

  self.ball:draw()
  --debug_time_t4 = love.timer.getTime()
  self.bob:draw()
  --debug_time_t5 = love.timer.getTime()
  self.level:draw()
  --lg.draw(sb)
  --debug_time_t6 = love.timer.getTime()
  

 
 if ( self.state == self.STATE_WIN ) then
 
    if (true) then
      for w = -60,59 do
        for h = -30,-26 do
          lg.draw(dog_sprite,w*8,h*8,0,SCALE,SCALE)
        end
      end
    end
    
    if (true) then
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
  
  
  
  --wb,hb = love.window.getMode()
  
  camera:detach()
  
  --lg.line(movement_touch_line,0,movement_touch_line,lg.getHeight())
  
  --[[
  lg.print(string.format("Get W, H: %dx%d", lg.getWidth(), lg.getHeight()),4,3, 0,1,1)
  if ( mobile ) then
    xa,ya,wa,ha = love.window.getSafeArea()
    lg.print(string.format("SafeArea: %dx%d", wa, ha),4,16, 0)
  end
  lg.print(string.format("Get Mode: %dx%d", wb, hb),4,29, 0)
  --]]
  
end
