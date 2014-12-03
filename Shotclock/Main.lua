
displayMode(FULLSCREEN)
supportedOrientations(LANDSCAPE_ANY)
hideKeyboard()

function setup()
    timer = SCTimer()
    display = SCDisplay(timer)
    announcement = SCAnnouncement(timer)
    verticalMoves = {}
    parameter.boolean("AlwaysDecimals", false)
    parameter.boolean("Count12Up", true)
    parameter.boolean("LightScreen", true, function(light)
        if light then
            ColourScheme = LightScreenColours
        else
            ColourScheme = DarkScreenColours
        end
    end)
end

function draw()
    timer:update()
    display:draw()
    announcement:draw()
end

function touched(touch)
    if not(timer.running) and isVerticalMove(touch) then
        local deltaY = updateDeltaY(touch)
        local adjustment = getTimeAdjustment(deltaY, display:isOnDecimals(touch))
        if math.abs(adjustment) > 0 then
            timer:changeTime(adjustment)
            announcement:clear()
            clearDeltaY(touch)
        end
    elseif isLeftSwipe(touch) then
        timer:resetFull()
        announcement:clear()
    elseif isRightSwipe(touch) then
        timer:reset14()
        announcement:clear()
    elseif touch.state == ENDED then
        if verticalMoves[touch.id] then
            verticalMoves[touch.id] = nil
        elseif touch.tapCount > 0 then
            handleTap()
        end
    end
end

function getTimeAdjustment(deltaY, onDecimals)
    local adjustment = 0
    if math.abs(deltaY) < 25 then
        return adjustment
    end
    if deltaY > 0 then
        adjustment = 1
    elseif deltaY < 0 then
        adjustment = -1
    end
    if onDecimals then
        adjustment = adjustment * 0.1
    end
    return adjustment
end

function updateDeltaY(touch)
    if verticalMoves[touch.id] == nil then
        verticalMoves[touch.id] = 0
    end
    verticalMoves[touch.id] = verticalMoves[touch.id] + touch.deltaY
    return verticalMoves[touch.id]
end

function clearDeltaY(touch)
    verticalMoves[touch.id] = 0
end

function handleTap()
    if timer.running then
        timer:stop()
    elseif timer.currentTime > 0 then
        timer:start()
    else
        timer:resetFull()
        announcement:clear()
        timer:start()
    end
end

function isTap(touch)
    return touch.state == ENDED and touch.tapCount > 0
end

function isLeftSwipe(touch)
    return isHorizontalSwipe(touch) and touch.deltaX < 0
end

function isRightSwipe(touch)
    return isHorizontalSwipe(touch) and touch.deltaX > 0
end


function isHorizontalSwipe(touch)
    return touch.state == MOVING and math.abs(touch.deltaX) > math.abs(touch.deltaY) and math.abs(touch.deltaX) > 10
end

function isVerticalMove(touch)
    return touch.state == MOVING and math.abs(touch.deltaX) < math.abs(touch.deltaY)
end
