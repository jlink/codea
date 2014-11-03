SCTimer = class()

function SCTimer:init()
    self.fullTime = 24.0
    self.reducedTime = 14.0
    self.currentTime = self.fullTime
    self.running = false
    self.display = null
    self.ticker = null
end

function SCTimer:registerDisplay(func)
    self.display = func
end

function SCTimer:registerTicker(func)
    self.ticker = func
end

function SCTimer:update()
    if self.running then
        self:updateTime()
    end
end

function SCTimer:start()
    if not(self.running) then
        self.running = true
        self.refTime = ElapsedTime
        self:updateDisplay()
    end
end

function SCTimer:stop()
    if self.running then
        self.running = false
        self:updateDisplay()
    end
end

function SCTimer:changeTime(amount)
    self.currentTime = self.currentTime + amount
    self.currentTime = math.max(self.currentTime, 0.4)
    self.currentTime = math.min(self.currentTime, self.fullTime)
    self:updateDisplay() 
end

function SCTimer:resetFull()
    self.currentTime = self.fullTime
    self.refTime = ElapsedTime
    self:updateDisplay() 
end

function SCTimer:reset14()
    self.currentTime = self.reducedTime
    self.refTime = ElapsedTime
    self:updateDisplay() 
end

function SCTimer:updateTime()
    local diff = ElapsedTime - self.refTime
    if (diff > 0.1) then
        local before = math.floor(self.currentTime)
        if (self.currentTime <= diff) then
            self.currentTime = 0
            self.running = false
        else
            self.currentTime = self.currentTime - diff
            self.refTime = ElapsedTime
        end
        self:updateDisplay()
        if before > math.floor(self.currentTime) then
            self:tick()
        end
    end
end

function SCTimer:updateDisplay()
    if self.display then
        self.display(self.currentTime, self.running)
    end
end

function SCTimer:tick()
    if self.ticker then
        local secs = math.floor(self.fullTime - self.currentTime)
        self.ticker(secs)
    end
end

function SCTimer:touched(touch)
    -- Codea does not automatically call this method
end

