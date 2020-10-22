Block = Class {}

Block.BLOCK_TYPE_SQUARE = 1
Block.BLOCK_TYPE_RAMP_UP = 2
Block.BLOCK_TYPE_RAMP_DOWN = 3
Block.BLOCK_TYPE_TOP = 4
Block.BLOCK_TYPE_FAKE = 5
Block.BLOCK_TYPE_SPIKE = 6
Block.BLOCK_TYPE_TROPHY = 7

local lg = love.graphics
local sprite = lg.newImage("res/Block1.png")

function Block:init(pos)
  
  self.pos = pos
  self.width = sprite:getWidth()
  self.height = sprite:getHeight()
  
  self.type = Block.BLOCK_TYPE_SQUARE
  
  --sb:add(self.pos.x,self.pos.y,0,SCALE,SCALE)
end

function Block:draw()
  
  lg.draw(sprite,self.pos.x,self.pos.y,0,SCALE,SCALE)
  
  --if (DEBUG_SHOW_CENTERPOINT) then
  if (false) then
    lg.setColor(0,0.5,0,1)
    lg.points(self.pos.x,self.pos.y)
    lg.setColor(1,1,1,1)
  end
  
end