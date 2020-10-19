TopBlock = Class {}

local lg = love.graphics
local sprite = lg.newImage("res/Block1.png")

function TopBlock:init(pos)
  
  self.pos = pos
  self.width = sprite:getWidth()
  self.height = sprite:getHeight()
  
  self.type = Block.BLOCK_TYPE_TOP
  
end

function TopBlock:draw()
  
  lg.draw(sprite,self.pos.x,self.pos.y,0,SCALE,SCALE)
  
  --if (DEBUG_SHOW_CENTERPOINT) then
  if (false) then
    lg.setColor(0,0.5,0,1)
    lg.points(self.pos.x,self.pos.y)
    lg.setColor(1,1,1,1)
  end
  
end