Spike = Class {}

local lg = love.graphics
local sprite = lg.newImage("res/Spike1.png")

function Spike:init(pos)
  
  self.pos = pos
  self.pos.x = self.pos.x + 2
  self.pos.y = self.pos.y + 1
  self.width = sprite:getWidth() - 4
  self.height = sprite:getHeight() - 4
  
  self.type = Block.BLOCK_TYPE_SPIKE
  
end

function Spike:draw()
  
  lg.draw(sprite,self.pos.x - 2,self.pos.y-1,0,SCALE,SCALE)
  
  --if (DEBUG_SHOW_CENTERPOINT) then
  if (false) then
    lg.setColor(0,0.5,0,1)
    lg.points(self.pos.x,self.pos.y)
    lg.setColor(1,1,1,1)
  end
  
end