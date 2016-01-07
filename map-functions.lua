function loadMap(path)
  -- love.filesystem.load doesnt invoke a lua file. I returns just a function declaration
  local f = love.filesystem.load(path) -- obtain a function
  f() -- run a function
end

function newMap(tileW, tileH, tilesetPath, tileString, quadInfo)
  
  TileW = tileW
  TileH = tileH
  Tileset = love.graphics.newImage(tilesetPath)
  
  local tilesetW, tilesetH = Tileset:getWidth(), Tileset:getHeight()
  Quads = {}
  
  for _,info in ipairs(quadInfo) do
    -- info[1] = the character, info[2] = x, info[3] = y
    Quads[info[1]] = love.graphics.newQuad(info[2], info[3], TileW,  TileH, tilesetW, tilesetH)
  end
  
  TileTable = {}
  
  local width = #(tileString:match("[^\n]+"))

  for x = 1,width,1 do TileTable[x] = {} end

  local rowIndex,columnIndex = 1,1
  for row in tileString:gmatch("[^\n]+") do
    assert(#row == width, 'Map is not aligned: width of row ' .. tostring(rowIndex) .. ' should be ' .. tostring(width) .. ', but it is ' .. tostring(#row))
    columnIndex = 1
    for character in row:gmatch(".") do
      TileTable[columnIndex][rowIndex] = character
      columnIndex = columnIndex + 1
    end
    rowIndex=rowIndex+1
  end
end

function drawMap()
  -- Remember that uses ipars it demands more computer machine, so if you are experimenting
  -- performance issues, it should be better remove the ipairs and call the element inside manually
  for columnIndex,column in ipairs(TileTable) do
    for rowIndex,char in ipairs(column) do
      local x,y = (columnIndex-1)*TileW, (rowIndex-1)*TileH
      love.graphics.draw(Tileset, Quads[char], x, y)
    end
  end
end