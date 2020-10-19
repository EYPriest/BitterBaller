Ramp = Class {}

local lg = love.graphics
local sprite = lg.newImage("res/Ramp2.png")

function Ramp:init(pos,flip)
  
  self.pos = pos
  self.width = sprite:getWidth()
  self.height = sprite:getHeight()
  
  self.flip = flip
  
  if ( flip ) then
    self.type = Block.BLOCK_TYPE_RAMP_DOWN
  else
    self.type = Block.BLOCK_TYPE_RAMP_UP
  end
  
end

function Ramp:draw()
  
  if ( self.flip ) then
    lg.draw(sprite,self.pos.x,self.pos.y,0,-SCALE,SCALE,self.width,0)
  else 
    lg.draw(sprite,self.pos.x,self.pos.y,0,SCALE,SCALE,0,0)
  end
  
  --if (DEBUG_SHOW_CENTERPOINT) then
  if (false) then
    lg.setColor(0,0.5,0,1)
    lg.points(self.pos.x,self.pos.y)
    lg.setColor(1,1,1,1)
  end
  
end
  