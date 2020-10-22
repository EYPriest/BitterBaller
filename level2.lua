Level2 = Class {}

local lg = love.graphics

function Level2:init()
  
  local level_image_data = love.image.newImageData("res/LevelTest8.png")
  local level_image = lg.newImage(level_image_data)
  
  self.grid = {}
  
  local gridWidth = 8
  local gridHeight = 8
  local worldWidth = level_image:getWidth()
  local worldHeight = level_image:getHeight()
  
  for col=1, worldWidth do
    self.grid[col] = {} 
    for row=1, worldHeight do 
      --self.grid[col][row] = {x=(col-1)*gridWidth, y=(row-1)*gridHeight}
      self.grid[col][row] = nil
    end 
  end
  
  self.blocks = {}
  
  for col=1,worldWidth do
    for row=1,worldHeight do
      local r,g,b,a = level_image_data:getPixel(col-1,row-1)
      --print ( "rgba: " .. r .. g .. b .. a )
      if ( r == 1 and b == 0 and g == 0 ) then
        local block = Block({x=col*8,y=row*8})
        self.grid[col][row] = block
        table.insert(self.blocks,block)
      elseif ( r == 0 and g == 0 and b == 1 ) then
        local ramp = Ramp({x=col*8,y=row*8},true)
        self.grid[col][row] = ramp
        table.insert(self.blocks,ramp)
      elseif ( r == 0 and g == 1 and b == 1 ) then
        local ramp = Ramp({x=col*8,y=row*8},false)
        self.grid[col][row] = ramp
        table.insert(self.blocks,ramp)
      elseif ( r == 0 and g == 1 and b == 0 ) then
        local top_block = TopBlock({x=col*8,y=row*8})
        self.grid[col][row] = top_block
        table.insert(self.blocks,top_block)
      elseif ( r == 1 and g == 1 and b == 0 ) then
        local fake_block = FakeBlock({x=col*8,y=row*8})
        self.grid[col][row] = fake_block
        table.insert(self.blocks,fake_block)
      elseif ( r == 1 and g == 0 and b == 1 ) then
        local spike = Spike({x=col*8,y=row*8})
        self.grid[col][row] = spike
        table.insert(self.blocks,spike)
      elseif ( r == 1 and g == 1 and b == 1 ) then
        local trophy = Trophy({x=col*8,y=row*8})
        self.grid[col][row] = trophy
        table.insert(self.blocks,trophy)
      end
    end
  end
  
end

function Level2:draw()
  
  local gw = lg.getWidth() / camera.scale
  local gh = lg.getHeight() / camera.scale
  
  for i,block in ipairs( self.blocks ) do
    if ( block.pos.x > camera.x-gw/2-10 and block.pos.x < camera.x+gw/2 and block.pos.y > camera.y-gh/2 - 10 and block.pos.y < camera.y+gh/2 ) then
      block:draw()
    end
  end
  
  --[[
  --Testing screen sized rectangle
  lg.setColor(0.5, 0.5, 0,0.5)
  lg.rectangle("fill",camera.x-gw/2,camera.y-gh/2,gw,gh)
  lg.setColor(1,1,1,1)
  --]]
  
  if ( false ) then --Show Chechpoint squares
    lg.setColor(0.5, 0.5, 0,0.5)
    lg.rectangle("fill",800,0,50,50)
    
     lg.setColor(0.0, 0.5, 0.5,0.5)
    lg.rectangle("fill",0,340,100,100)
    
    lg.setColor(0.5, 0.0, 0.5,0.5)
    lg.rectangle("fill",900,340,50,50)
    
    lg.setColor(0.5, 0.5, 0.5,0.5)
    lg.rectangle("fill",1020,206,50,10)
    
    lg.setColor(0.8, 0.5, 0.8,0.5)
    lg.rectangle("fill",980,220,10,10)
    
    lg.setColor(1,1,1,1)
  end
  
end