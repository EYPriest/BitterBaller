Level1 = Class {}

function Level1:init()
  
  grid = {}

  local gridWidth = 8
  local gridHeight = 8
  local worldWidth = 40
  local worldHeight = 30

  for col=1, worldWidth do
    grid[col] = {} 
    for row=1, worldHeight do 
      grid[col][row] = {x=(col-1)*gridWidth, y=(row-1)*gridHeight}
    end 
  end
  
  
  
  self.blocks = {}
  local block_1 = Block({x=0,y=0})
  table.insert(self.blocks, block_1)
  grid[1][1] = block_1
  
  local block_2 = Block({x=10*8,y=10*8})
  table.insert(self.blocks, block_2)
  grid[10][10] = block_2
  
  local block_3 = Block({x=11*8,y=10*8})
  table.insert(self.blocks, block_3)
  grid[11][10] = block_3
  
  --table.insert(self.blocks, Block({x=40,y=40}))
  --table.insert(self.blocks, Block({x=50,y=40}))
  --table.insert(self.blocks, Block({x=60,y=40}))
  --table.insert(self.blocks, Block({x=70,y=40}))
  --table.insert(self.blocks, Block({x=80,y=40}))
  --table.insert(self.blocks, Block({x=90,y=40}))
  
end

function Level1:draw()
  
  for i,block in ipairs( self.blocks ) do
    block:draw()
  end
  
end

