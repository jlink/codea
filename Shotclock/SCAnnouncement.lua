SCAnnouncement = class()

function SCAnnouncement:init(timer)
    self.timer = timer
    timer:registerTicker(
        function(secs)
            self:tick(secs)
        end
    )
    self:clear()
end

function SCAnnouncement:clear()
    self.text = ""
end

function SCAnnouncement:tick(secs)
    if secs < 15 then
        self.text = ""
    else
        self.text = secs
    end
end
function SCAnnouncement:draw()
    if not(self.timer.running) or not(Count15Up) then
        return
    end
    pushStyle()
    fontSize(48)
    font("Arial-BoldMT")
    print(self.text)
    text(self.text, WIDTH - 48, 32)
    popStyle()
end
