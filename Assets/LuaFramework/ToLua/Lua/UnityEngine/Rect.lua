 Rect = {}
                       
function Rect.New(x,y,w,h)
    local rt = {x = x, y = y, w = w, h = h}
    setmetatable(rt, Rect)                
    return rt
end

function Rect:Get()                       
    return self.x, self.y, self.w, self.h
end

Rect.__tostring = function(self)
    return '(x:'..self.x..', y:'..self.y..', width:'..self.w..', height:'..self.h..')'
end

setmetatable(Rect, Rect)
AddValueType(Rect, 13)
return Rect;