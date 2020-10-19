Trophy = Class {}

local lg = love.graphics
local sprite = lg.newImage("res/Trophy.png")

function Trophy:init(pos)
  
  self.pos = pos
  self.pos.x = self.pos.x + 2
  self.pos.y = self.pos.y + 1
  self.width = 5
  self.height = 5
  
  self.type = Block.BLOCK_TYPE_TROPHY
  
end

function Trophy:draw()
  
  lg.draw(sprite,self.pos.x - 2,self.pos.y-1,0,SCALE,SCALE)
  
  --if (DEBUG_SHOW_CENTERPOINT) then
  if (false) then
    lg.setColor(0,0.5,0,1)
    lg.points(self.pos.x,self.pos.y)
    lg.setColor(1,1,1,1)
  end
  
end