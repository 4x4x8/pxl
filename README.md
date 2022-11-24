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

we also can draw some text:
```lua
canvas:write_text(1,1,"hello usr!", true, colors.black, colors.white)
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
Creates a new buffer canvas for PXL_OBJ
```lua
local lib = require "pxl"
local obj = lib.new(term, colors.black)
lib.restore(obj, colors.yellow) -- this is replace our old buffer with black colors to new with yellow colors.
```

# pxl.restore_chars(PXL_OBJ, char, fg, bg)
```lua
local lib = require "pxl"
local obj = lib.new(term, colors.black)
lib.restore_chars(obj, "", colors.white, colors.black) -- this will clear chars buffer because chars with zero(like "") length just ignored.
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

# pxl:write_text(x,y, text, bounds_check, bg, fg)
Just writes text instead of pixels, may cause issues because text draws over the pixels
```lua
local lib = require "pxl"
local obj = lib.new(term, colors.black)
obj:write_text(5,5, "hello my friend :)", true, colors.black, colors.white)
obj:render()
```

# pxl:is_in_bounds(x,y)
Just checks if x and y is in bounds
```lua
local lib = require "pxl"
local obj = lib.new(term, colors.black)
if obj:is_in_bounds(1000,1000) then
    obj.canvas[1000][1000] = colors.pink
end
obj:render()
```

# pxl:render()
Just draws the pixels, thats it.
```lua
local lib = require "pxl"
local obj = lib.new(term, colors.black)
obj:render()
```

# BIG THANKS TO:
9551-Dev for explaining me all this shit.
