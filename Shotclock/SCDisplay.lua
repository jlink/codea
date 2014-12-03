SCDisplay = class()

LightScreenColours = {
    Text = 1,  color(0, 0, 0, 0),
    InverseText = color(255, 255, 255, 255),
    RunningBg = color(148, 219, 95, 255),
    StoppedBg = color(255, 255, 255),
    Running5Bg = color(233, 227, 77, 255),
    TimeUpBg = color(248, 19, 2, 255)
}

DarkScreenColours = {
    InverseText = 1,  color(0, 0, 0, 0),
    Text = color(255, 255, 255, 255),
    RunningBg = color(71, 94, 55, 255),
    StoppedBg = color(63, 51, 51, 0),
    Running5Bg = color(88, 86, 37, 255),
    TimeUpBg = color(255, 62, 0, 255)
}

ColourScheme = LightScreenColours

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
        background(ColourScheme.TimeUpBg)
        fill(ColourScheme.InverseText)
    elseif self.running and self.time < 5 then
        background(ColourScheme.Running5Bg)
        fill(ColourScheme.Text)
    elseif self.running then
        background(ColourScheme.RunningBg)
        fill(ColourScheme.Text)
    else
        background(ColourScheme.StoppedBg)
        fill(ColourScheme.Text)
    end
    local withDecimals = not(self.running) or self.time < 5 or AlwaysDecimals
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
    self:drawText(toShow, WIDTH - 690, HEIGHT/2)
end

function SCDisplay:drawText(str, x, y)

    font("HelveticaNeue")
    local xOffsets = {0, 260, 440, 550}
    local yOffsets = {0, 0, -50, -50}
    local fontSizes = {500, 500, 250, 250}
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
