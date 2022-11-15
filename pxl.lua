local pxl = {}

local t_sort, t_cat, s_char = table.sort, table.concat, string.char
local function sort(a,b) return a[2] > b[2] end

local distances = {
    {5,256,16,8,64,32},
    {4,16,16384,256,128},
    [4]    ={4,64,1024,256,128},
    [8]    ={4,512,2048,256,1},
    [16]   ={4,2,16384,256,1},
    [32]   ={4,8192,4096,256,1},
    [64]   ={4,4,1024,256,1},
    [128]  ={6,32768,256,1024,2048,4096,16384},
    [256]  ={6,1,128,2,512,4,8192},
    [512]  ={4,8,2048,256,128},
    [1024] ={4,4,64,128,32768},
    [2048] ={4,512,8,128,32768},
    [4096] ={4,8192,32,128,32768},
    [8192] ={3,32,4096,256128},
    [16384]={4,2,16,128,32768},
    [32768]={5,128,1024,2048,4096,16384}
}

local to_blit = {}
for i = 0, 15 do
    to_blit[2^i] = ("%x"):format(i)
end

local function build_drawing_char(a,b,c,d,e,f)
    local array = {a,b,c,d,e,f}
    local cols = {}
    local sorted = {}
    local index = 0
    for i=1, 6 do
        local c = array[i]
        if not cols[c] then
            index = index + 1
            cols[c] = {0, index}
        end
        local t = cols[c]
        local t1 = t[1] + 1
        t[1] = t1
        sorted[t[2]] = {c, t1}
    end
    local n = #sorted
    while n > 2 do
        t_sort(sorted,sort)
        local bit6 = distances[sorted[n][1]]
        local index,run = 1,false
        local nm1 = n - 1
        for i=2,bit6[1] do
            if run then break end
            local tab = bit6[i]
            for j=1,nm1 do
                if sorted[j][1] == tab then
                    index = j
                    run = true
                    break
                end
            end
        end
        local from,to = sorted[n][1],sorted[index][1]
        for i=1,6 do
            if array[i] == from then
                array[i] = to
                local sindex = sorted[index]
                sindex[2] = sindex[2] + 1
            end
        end
        sorted[n] = nil
        n = n - 1
    end
    n = 128
    local a6 = array[6]
    if array[1] ~= a6 then n = n + 1 end
    if array[2] ~= a6 then n = n + 2 end
    if array[3] ~= a6 then n = n + 4 end
    if array[4] ~= a6 then n = n + 8 end
    if array[5] ~= a6 then n = n + 16 end
    if sorted[1][1] == array[6] then
        return s_char(n), sorted[2][1], array[6]
    end
    return s_char(n), sorted[1][1], array[6]
end

function pxl.restore(PXL, bg)
    local c = {}
    for _y=1, PXL.s_height do
        for _x=1, PXL.s_width do
            if not c[_y] then c[_y] = {} end
            c[_y][_x] = bg
        end
    end
    PXL.canvas = c
end


function pxl.new(term, background)
    local self = setmetatable({},{__index = pxl})
    self.term = term
    self.background = background
    self.width, self.height = term.getSize()
    self.s_width, self.s_height = self.width*2, self.height*3
    pxl.restore(self, self.background)

    return self
end

function pxl:set_pixel(x, y, color)
    self.canvas[y][x] = color
end

function pxl:render()
    local t = self.term
    local t_blit, t_setcursor = t.blit, t.setCursorPos
    local canvas = self.canvas
    local y_line = 0
    for y=1, self.s_height, 3 do
        y_line = y_line + 1

        local char_string = {}
        local fg_string = {}
        local bg_string = {}
        local n = 0

        local layer1 = canvas[y]
        local layer2 = canvas[y+1]
        local layer3 = canvas[y+2]
        for x=1, self.s_width, 2 do
            local xp1 = x+1
            local b11,b21,b12,b22,b13,b23 =
            layer1[x],layer1[xp1],
            layer2[x],layer2[xp1],
            layer3[x],layer3[xp1]

            local char, fg, bg = " ",1,b11
            if not (b21 == b11
                and b12 == b11
                and b22 == b11
                and b13 == b11
                and b23 == b11) then
                char,fg,bg = build_drawing_char(b11,b21,b12,b22,b13,b23)
            end
            n = n+1
            char_string[n] = char
            fg_string  [n] = to_blit[fg]
            bg_string  [n] = to_blit[bg]
        end
        t_setcursor(1,y_line)
        t_blit(
            t_cat(char_string, ""),
            t_cat(fg_string, ""),
            t_cat(bg_string, "")
        )
    end
end

return pxl