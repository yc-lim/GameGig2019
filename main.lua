--This is the simple map

function love.load()
   width = 20
   height = 20
   math.randomseed(os.time())
   maze = {{}}

   for i = 1,width do
      for j = 1, height do
         maze[i][j] = Cell
      end
   end
   
   Cell = {
      cellType = "",
      state = "",
      fromy = 0 ,
      fromx = 0 ,
      UnSetUserLocation = false,
      AddWall = function ( )
      local obj = {
      cellType = "wall",
      state = "solid",
      }
      return obj
      end,
      AddPassage = function ( )
      local obj = {
      cellType = "passage",
      state= "unvisited" ,
      }
      return obj
      end,
      SetVisited = function (self)
     self.state = "visited"
      end,
      SetFinished = function (self)
     self.state = "finished"
      end,
      BreakWall = function (self)
     self.state = "broken"
      end,
      SetStart = function (self)
      self.state= "start"
      end,
      SetEnd = function (self)
     self.state= "end"
      end,
      SetFrom = function (self, y , x )
     self.fromy = y
     self.fromx = x
      end,
      SetUserLocation= function (self)
     self.userLocation = true
      end,
      UnSetUserLocation = function (self)
     self.userLocation = false
      end
      }
end