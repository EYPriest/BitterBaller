Bob = Class {}

local lg = love.graphics
local alive_sprite = lg.newImage("res/Dog1.png")
local ded_sprite = lg.newImage("res/DedBob1.png")

local floor = math.floor

function Bob:init(ball)
  
  self.sprite = alive_sprite
  
  self.ball = ball
  
  self.width = self.sprite:getWidth()
  self.height = self.sprite:getHeight()
  
  self.pos = {x=self.ball.pos.x + 1,y=self.ball.pos.y-self.height + 1}
  
  self.attached = true
  
  self.jump_start_time = 0.2
  self.jump_start_time_ac = 0
  
  self.jump_boost = 1
  
  self.speed_y = 0
  
  self.friction = {x=0.06,y=0.01}
  self.gravity = 0.16
  
  self.can_start_jump = false
  
end

function Bob:keypressed(key)
  
  if ( key == 'space' ) then
    if ( self.ball.must_release == false and self.attached ) then
      self.can_start_jump = true
      self.attached = false
      self.ball.attached = false
      self.jump_start_time_ac = 0
      if ( self.ball.speed.y < 0 ) then
        self.ball.speed.y = 0
      end
    end
  end
  
end

function Bob:update(dt)
  
  --[[
  local jumpTouch = false
  local touches = love.touch.getTouches( )
  
  for i, id in ipairs(touches) do
    local x, y = love.touch.getPosition(id) 
    if ( x >= lg.getWidth() / 2 ) then
      jumpTouch = true
    end
  end
  --]]
  
  --if ( jumpTouch == true ) then
  if ( jump_touch ) then
    if ( self.ball.must_release == false and self.attached ) then
      self.can_start_jump = true
      self.attached = false
      self.ball.attached = false
      self.jump_start_time_ac = 0
    end
  end
  
  -- This lets you hold the button down to jump higher
  --if ( love.keyboard.isDown('space') or jumpTouch ) then
  if ( love.keyboard.isDown('space') or jump_touch ) then
    if ( self.can_start_jump ) then
      self.jump_start_time_ac = self.jump_start_time_ac + dt
      if ( self.jump_start_time_ac < self.jump_start_time ) then
        self.speed_y = -self.jump_boost
      end
    end

  else
    self.can_start_jump = false
  end
  
  
  self.pos.x = self.ball.pos.x + 1
  
  if ( self.attached ) then
    self.pos.y = self.ball.pos.y - self.height + 1
  else
    self.speed_y = (self.speed_y) * (1-self.friction.y)
  
    -- Add Gravity to Speed
    self.speed_y = self.speed_y + self.gravity
    
    self.pos.y = self.pos.y + self.speed_y
    -- Did collide?
    if ( self.pos.y >= self.ball.pos.y - self.height + 1 ) then
      self.pos.y = self.ball.pos.y - self.height + 1
      self.attached = true
      self.ball.attached = true
      self.can_start_jump = false
    end
  end
  
  --Collisions
  --Get 4 Closest blocks for collision detection
  -- Find Close Blocks
    
  local left =  floor(self.pos.x / 8)
  local right = floor((self.pos.x+self.width) / 8)
  local top = floor(self.pos.y / 8)
  local bot = floor((self.pos.y+self.height) / 8)

  local grid = scene.level.grid
  local blocks = {}
  if ( grid[left][top] ~= nil ) then table.insert(blocks,grid[left][top]) end
  if ( grid[left][bot] ~= nil ) then table.insert(blocks,grid[left][bot]) end
  if ( grid[right][top] ~= nil ) then table.insert(blocks,grid[right][top]) end
  if ( grid[right][bot] ~= nil ) then table.insert(blocks,grid[right][bot]) end
  
  for i,block in ipairs( blocks ) do
    local x1 = self.pos.x
    local y1 = self.pos.y
    local w1 = self.width - 1
    local h1 = self.height
    local x2 = block.pos.x
    local y2 = block.pos.y
    local w2 = block.width
    local h2 = block.height
    if ( CheckCollision(x1,y1,w1,h1,x2,y2,w2,h2 ) ) then
      
      if ( block.type == Block.BLOCK_TYPE_SQUARE or block.type == Block.BLOCK_TYPE_SPIKE ) then
      
        self:die()
      end
    end
  end

end

function Bob:die()
  scene.state=scene.STATE_DEAD
  self.sprite = ded_sprite
end

function Bob:draw()
  
  lg.draw(self.sprite,self.pos.x,self.pos.y,0)
  
end