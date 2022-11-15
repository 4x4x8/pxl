# pxl
Lightweight pixel drawing library for ComputerCraft.

# How to use:
let's create a pxl object first.
```lua
local lib = require "pxl"
local canvas = lib.new(term, colors.black)
```

and then... plot the pixels!
```lua
canvas.canvas[y][x] = colors.red
-- or you wanna use this:
canvas:set_pixel(x,y, colors.red)
```

AND WE RENDER IT!
```
canvas:render()
```

and this is how to use library.

# API
# pxl.new(term, backgorund_color)
Basically jsut creates new pxl object.
```lua
local lib = require "pxl"
local obj = lib.new(term, colors.black)
```

# pxl.restore(PXL_OBJ, background_color)
Creates a new canvas for PXL_OBJ
```lua
local lib = require "pxl"
local obj = lib.new(term, colors.black)
lib.restore(obj, colors.yellow) -- this is replace our old canvas with black colors to new with yellow colors.
```

# pxl:set_pixel(x,y,color)
Plots pixel at x,y.
```lua
local lib = require "pxl"
local obj = lib.new(term, colors.black)
obj:set_pixel(10,10, colors.yellow)
```
or you can use
```lua
local lib = require "pxl"
local obj = lib.new(term, colors.black)
obj.canvas[10][10] = colors.yellow -- the important thing that coordinates are Y,X not X,Y
```

# pxl:render()
Just draws the pixels, thats it.
```lua
local lib = require "pxl"
local obj = lib.new(term, colors.black)
obj:render()
```
