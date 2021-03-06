Ball = Class {}

local lg = love.graphics
local SCALE = SCALE
local rad = math.rad
local floor = math.floor

function Ball:init(pos)
  
  self.pos = pos
  
  self.dog = lg.newImage("res/Dog1.png")
  self.ball = lg.newImage("res/Ball1.png")
  
  self.ball_width = self.ball:getWidth()
  self.ball_height = self.ball:getHeight()
  
  self.ball_rotation_ac = 0
  self.ball_rotation_upto = 0.2
  self.ball_rotation_state = 0
  
  self.thrust_amount = {x=0.16,y=0} -- I think y thrust isn't used
  self.thrust = {x=0,y=0}
  self.speed = {x=0,y=0}
  self.friction = {x=0.06,y=0.01}
  self.gravity = 0.16
  
  self.distance_moved = 0
  self.distance_to_spin = 6
  
  self.grounded = false
  self.jump_start_time = 0.2
  self.jump_start_time_ac = 0
  
  self.jump_boost = 2.6
  
  self.bob_ready = false
  self.must_release = true
  
  self.attached = true
end

-- Inputs

function Ball:keypressed(key)
  
  if ( key == 'space' ) then
    --self.speed.y = -6
  end
  
end

function Ball:keyreleased(key)
  if ( key == 'space' ) then
    self.must_release = false
  end
end

-- Update
function Ball:update(dt)
  
  -- X

  --[[
  local leftTouch = false
  local rightTouch = false
  local jumpTouch = false
  local touches = love.touch.getTouches( )

  for i, id in ipairs(touches) do
    local x, y = love.touch.getPosition(id) 
    if ( x >= 0 and x < lg.getWidth() / 12 ) then
      leftTouch = true
    elseif ( x >= lg.getWidth() / 12 and x < lg.getWidth() / 2 ) then
      rightTouch = true
    end 
    
    if ( x >= lg.getWidth() / 2 ) then
      jumpTouch = true
    end
  end
  --]]
  
  
  --if ( love.keyboard.isDown('a','left') or leftTouch ) then
  if ( love.keyboard.isDown('a','left') or (move_direction == -1) ) then
    self.thrust.x = -self.thrust_amount.x
  elseif ( love.keyboard.isDown('d','right') or (move_direction == 1) ) then
    --self.thrust = self.thrust + 0.1
    self.thrust.x = self.thrust_amount.x
  else
    self.thrust.x = 0
  end
  
  -- Make this not use grounded
  --if ( jumpTouch == false and self.jump_start_time_ac > 0 ) then
  if ( jump_touch == false and self.jump_start_time_ac > 0 ) then
    self.must_release = false
  end
  
  -- Y
  
  --if ( love.keyboard.isDown('space') or jumpTouch ) then
  if ( love.keyboard.isDown('space') or jump_touch ) then
    if ( self.attached ) then
      self.jump_start_time_ac = self.jump_start_time_ac + dt
      if ( self.jump_start_time_ac < self.jump_start_time and self.grounded == true ) then
        --self.speed.y = -6
        self.speed.y = -self.jump_boost
      else
        self.grounded = false
      end
    end
  else
    self.thrust.y = 0 --Thrust is never set to not be 0
    self.jump_start_time_ac = self.jump_start_time -- No more jumping after release
  end

  -- Add Thrust to Speed
  self.speed.x = (self.speed.x + self.thrust.x) * (1-self.friction.x)
  self.speed.y = (self.speed.y - self.thrust.y) * (1-self.friction.y)
  
  -- Add Gravity to Speed
  self.speed.y = self.speed.y + self.gravity
  
  -- Move Player
  -- Left/Right
  if ( self.speed.x < -0.0 or self.speed.x > 0.0 ) then
    self.pos.x = self.pos.x + self.speed.x
    --self.distance_moved = self.distance_moved + self.speed
  
  
    --Get 4 Closest blocks for collision detection
    -- Find Close Blocks
    
    local left =  floor(self.pos.x / 8)
    local right = floor((self.pos.x+self.ball_width) / 8)
    local top = floor(self.pos.y / 8)
    local bot = floor((self.pos.y+self.ball_height) / 8)

    local grid = scene.level.grid
    local blocks = {}
    if ( grid[left][top] ~= nil ) then table.insert(blocks,grid[left][top]) end
    if ( grid[left][bot] ~= nil ) then table.insert(blocks,grid[left][bot]) end
    if ( grid[right][top] ~= nil ) then table.insert(blocks,grid[right][top]) end
    if ( grid[right][bot] ~= nil ) then table.insert(blocks,grid[right][bot]) end

    -- Check for collision
    local did_collide_x = false
    local on_a_ramp = false
    for i,block in ipairs( blocks ) do
      local x1 = self.pos.x
      local y1 = self.pos.y
      local w1 = self.ball_width
      local h1 = self.ball_height
      local x2 = block.pos.x
      local y2 = block.pos.y
      local w2 = block.width
      local h2 = block.height
      if ( CheckCollision(x1,y1,w1,h1,x2,y2,w2,h2 ) ) then
        
        if ( block.type == Block.BLOCK_TYPE_SQUARE  ) then
          
          did_collide_x = true
          self.speed.x = 0
          
          local x_diff = x1 - x2
          if ( x_diff < 0 ) then
            self.pos.x = x2 - self.ball_width
          elseif ( x_diff > 0 ) then
            self.pos.x = x2 + w2
          end
        elseif ( block.type == Block.BLOCK_TYPE_RAMP_UP ) then

          local new_x = floor(x1+2)+w1/2
          if ( new_x == x2 + 0 ) then
            self.pos.y = y2 - 0
          elseif ( new_x == x2 + 1 ) then
            self.pos.y = y2 - 1 
          elseif ( new_x == x2 + 2 ) then
            self.pos.y = y2 - 2
          elseif ( new_x == x2 + 3 ) then
            self.pos.y = y2 - 3 
          elseif ( new_x == x2 + 4 ) then
            self.pos.y = y2 - 4 
          elseif ( new_x == x2 + 5 ) then
            self.pos.y = y2 - 5 
          elseif ( new_x == x2 + 6 ) then
            self.pos.y = y2 - 6
          elseif ( new_x == x2 + 7 ) then
            self.pos.y = y2 - 7
          elseif ( new_x == x2 + 8 ) then
            self.pos.y = y2 - 7
          elseif ( new_x == x2 + 9 ) then
            self.pos.y = y2 - 7
          end
          on_a_ramp = true
        elseif ( block.type == Block.BLOCK_TYPE_RAMP_DOWN ) then

          local new_x = floor(x1)+w1/2
          if ( new_x == x2 - 1 ) then
            self.pos.y = y2 - 7
          elseif ( new_x == x2 + 0 ) then
            self.pos.y = y2 - 7
          elseif ( new_x == x2 + 1 ) then
            self.pos.y = y2 - 7
          elseif ( new_x == x2 + 2 ) then
            self.pos.y = y2 - 6 
          elseif ( new_x == x2 + 3 ) then
            self.pos.y = y2 - 5
          elseif ( new_x == x2 + 4 ) then
            self.pos.y = y2 - 4 
          elseif ( new_x == x2 + 5 ) then
            self.pos.y = y2 - 3
          elseif ( new_x == x2 + 6 ) then
            self.pos.y = y2 - 2
          elseif ( new_x == x2 + 7 ) then
            self.pos.y = y2 - 1
          elseif ( new_x == x2 + 8 ) then
            self.pos.y = y2 - 0
          end
          on_a_ramp = true
        elseif ( block.type == Block.BLOCK_TYPE_SPIKE ) then
          scene.bob:die()
        end
      end
    end
    
    if ( did_collide_x == false ) then
      self.distance_moved = self.distance_moved + self.speed.x
      --TODO: Make this exact
    end
    
  end
  
  -- Move Player
  
  -- Add Thrust to Speed
  self.speed.y = (self.speed.y - self.thrust.y) * (1-self.friction.y)
  
  -- Up/Down
  self.pos.y = self.pos.y + self.speed.y
  
  --Get 4 Closest blocks for collision detection
  -- Find Close Blocks
  
  local left =  floor(self.pos.x / 8)
  local right = floor((self.pos.x+self.ball_width) / 8)
  local top = floor(self.pos.y / 8)
  local bot = floor((self.pos.y+self.ball_height) / 8)

  local grid = scene.level.grid
  local blocks = {}
  if ( grid[left][top] ~= nil ) then table.insert(blocks,grid[left][top]) end
  if ( grid[left][bot] ~= nil ) then table.insert(blocks,grid[left][bot]) end
  if ( grid[right][top] ~= nil ) then table.insert(blocks,grid[right][top]) end
  if ( grid[right][bot] ~= nil ) then table.insert(blocks,grid[right][bot]) end
  
  -- Check for collision
  for i,block in ipairs( blocks ) do
    local x1 = self.pos.x
    local y1 = self.pos.y
    local w1 = self.ball_width
    local h1 = self.ball_height
    local x2 = block.pos.x
    local y2 = block.pos.y
    local w2 = block.width
    local h2 = block.height
    if ( CheckCollision(x1,y1,w1,h1,x2,y2,w2,h2 ) ) then
      
      if ( block.type == Block.BLOCK_TYPE_SQUARE or block.type == Block.BLOCK_TYPE_TOP ) then
        did_collide_y = true
        
        self.speed.y = 0
        
        local y_diff = y1 - y2
        if ( y_diff < 0 ) then
          self.pos.y = y2 - self.ball_height
          self.grounded = true
          self.jump_start_time_ac = 0
          self.must_release = true
        elseif ( y_diff > 0 ) then
          self.pos.y = y2 + h2
        end
      elseif ( block.type == Block.BLOCK_TYPE_RAMP_UP ) then
        
        local new_x = floor(x1+2)+w1/2
        if ( new_x == x2 + 1 ) then
          self.pos.y = y2 - 1 
        elseif ( new_x == x2 + 2 ) then
          self.pos.y = y2 - 2
        elseif ( new_x == x2 + 3 ) then
          self.pos.y = y2 - 3 
        elseif ( new_x == x2 + 4 ) then
          self.pos.y = y2 - 4 
        elseif ( new_x == x2 + 5 ) then
          self.pos.y = y2 - 5 
        elseif ( new_x == x2 + 6 ) then
          self.pos.y = y2 - 6
        elseif ( new_x == x2 + 7 ) then
          self.pos.y = y2 - 7
        elseif ( new_x == x2 + 8 ) then
          self.pos.y = y2 - 7
        elseif ( new_x == x2 + 9 ) then
          self.pos.y = y2 - 7
        end
        on_a_ramp = true
        self.grounded = true
        self.jump_start_time_ac = 0
        self.must_release = true
      elseif ( block.type == Block.BLOCK_TYPE_RAMP_DOWN ) then
        
        local new_x = floor(x1)+w1/2
        if ( new_x == x2 - 1 ) then
          self.pos.y = y2 - 7
        elseif ( new_x == x2 + 0) then
          self.pos.y = y2 - 7 
        elseif ( new_x == x2 + 1 ) then
          self.pos.y = y2 - 7
        elseif ( new_x == x2 + 2 ) then
          self.pos.y = y2 - 6 
        elseif ( new_x == x2 + 3 ) then
          self.pos.y = y2 - 5 
        elseif ( new_x == x2 + 4 ) then
          self.pos.y = y2 - 4 
        elseif ( new_x == x2 + 5 ) then
          self.pos.y = y2 - 3
        elseif ( new_x == x2 + 6 ) then
          self.pos.y = y2 - 2
        elseif ( new_x == x2 + 7 ) then
          self.pos.y = y2 - 1
        elseif ( new_x == x2 + 8 ) then
          self.pos.y = y2 - 0
        end
        on_a_ramp = true
        self.grounded = true
        self.jump_start_time_ac = 0
        self.must_release = true
      elseif ( block.type == Block.BLOCK_TYPE_SPIKE ) then
        scene.bob:die()
      elseif ( block.type == Block.BLOCK_TYPE_TROPHY ) then
        scene.state = scene.STATE_WIN
      end
    end
  end

  -- Rotate Ball
  if ( self.distance_moved >= self.distance_to_spin ) then
    self.distance_moved = self.distance_moved - self.distance_to_spin * 2
    self.ball_rotation_state = self.ball_rotation_state + 1
    if ( self.ball_rotation_state > 3 ) then -- Rotate
      self.ball_rotation_state = 0
    end
  elseif ( self.distance_moved <= -self.distance_to_spin ) then
    self.distance_moved = self.distance_moved + self.distance_to_spin * 2
    self.ball_rotation_state = self.ball_rotation_state - 1
    if ( self.ball_rotation_state < 0 ) then -- Rotate
      self.ball_rotation_state = 3
    end
  end
  
end

-- Draw
function Ball:draw()
  
  local rads = rad(self.ball_rotation_state * 90)
  
  local offset_x = 0
  local offset_y = 0
  
  if ( self.ball_rotation_state == 1 or self.ball_rotation_state == 2 ) then
    offset_y = 1
  end
    if ( self.ball_rotation_state == 3 or self.ball_rotation_state == 2 ) then
    offset_x = 1
  end  
  
  lg.draw(self.ball
    ,self.pos.x+self.ball_width/2
    ,self.pos.y+self.ball_height/2
    ,rads,1,1,self.ball_width/2 + offset_x,self.ball_height/2 + offset_y)
  
  --if (DEBUG_SHOW_CENTERPOINT) then
  if (false) then
    lg.setColor(0,0.5,0,1)
    lg.points(self.pos.x,self.pos.y)
    lg.setColor(1,1,1,1)
  end
  
end
