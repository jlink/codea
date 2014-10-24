SCDisplay = class()

function SCDisplay:init(timer)
    self.time = timer.currentTime
    self.running = false
    timer:registerDisplay(
        function (newTime, isRunning) 
            self:update(newTime, isRunning) 
        end
    )
end

function SCDisplay:update(newTime, isRunning)
    self.time = newTime
    self.running = isRunning
    self.timeIsUp = not(self.running) and self.time == 0
    if (self.timeIsUp) then 
        sound(DATA, "ZgBAGgBAQFNAQEBAHHS7PUC+SD9XJr47QABAf0BGQEBAQEBA") 
    end
end

function SCDisplay:draw()
    pushStyle()
    if self.timeIsUp then
        background(248, 19, 2, 255)
        fill(255, 255, 255)
    elseif self.running and self.time < 5 then
        background(233, 227, 77, 255)
        fill(0,0,0)
    elseif self.running then
        background(148, 219, 95, 255)
        fill(0,0,0)
    else
        background(255, 255, 255)
        fill(0,0,0)
    end
    local withDecimals = not(self.running) or self.time < 5
    self:drawTime(withDecimals)
    popStyle()
end

function SCDisplay:drawTime(withDecimal)
    local toShow = ""
    if withDecimal then
        toShow = string.format("%4.1f", self.time)
    else
        toShow = string.format("%2d  ", self.time)
    end
    self:drawText(toShow, WIDTH - 660, HEIGHT/2)
end

function SCDisplay:drawText(str, x, y)
    fontSize(450)
    font("HelveticaNeue")
    local xOffsets = {0, 240, 400, 510}
    local yOffsets = {0, 0, -75, -75}
    local fontSizes = {450, 450, 250, 250}
    for i = 1, #str do
        fontSize(fontSizes[i])
        local xOff = xOffsets[i]
        local yOff = yOffsets[i]
        text( str:sub(i,i), x+xOff, y+yOff)
    end 
end

function SCDisplay:isOnDecimals(touch)
    return touch.x > (WIDTH - 250) 
end
