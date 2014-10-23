
-- displayMode(FULLSCREEN)
supportedOrientations(LANDSCAPE_ANY)
hideKeyboard()

function setup()
    timer = SCTimer()
    display = SCDisplay(timer)
    horizontalMoves = {}
end

function draw() 
    timer:update()
    display:draw()
end

function touched(touch)
    if not(timer.running) and isHorizontalMove(touch) then
        local deltaX = updateDeltaX(touch)
        local adjustment = getTimeAdjustment(deltaX)
        if math.abs(adjustment) > 0 then
            timer:changeTime(adjustment)
            clearDeltaX(touch)
        end
    elseif isUpSwipe(touch) then
        timer:resetFull()
    elseif isDownSwipe(touch) then
        timer:reset14()
    elseif touch.state == ENDED then
        if horizontalMoves[touch.id] then
            horizontalMoves[touch.id] = nil
        elseif touch.tapCount > 0 then
            handleTap()
        end
    end
end

function getTimeAdjustment(deltaX)
    if deltaX > 30 then
        return 1
    elseif deltaX > 10 then
        return 0.1
    elseif deltaX < -30 then
        return -1
    elseif deltaX < -10 then
        return -0.1
    else
        return 0
    end
end

function updateDeltaX(touch)
    if horizontalMoves[touch.id] == nil then
        horizontalMoves[touch.id] = 0
    end
    horizontalMoves[touch.id] = horizontalMoves[touch.id] + touch.deltaX
    return horizontalMoves[touch.id]
end

function clearDeltaX(touch)
    horizontalMoves[touch.id] = 0
end

function handleTap()
    if timer.running then
        timer:stop()
    elseif timer.currentTime > 0 then
        timer:start()
    else
        timer:resetFull()
        timer:start()
    end
end

function isHorizontalMove(touch)
    return touch.state == ENDED and touch.tapCount > 0
end

function isTap(touch)
    return touch.state == ENDED and touch.tapCount > 0
end

function isUpSwipe(touch)
    return isVerticalSwipe(touch) and touch.deltaY > 0
end

function isDownSwipe(touch)
    return isVerticalSwipe(touch) and touch.deltaY < 0
end


function isVerticalSwipe(touch)
    return touch.state == MOVING and math.abs(touch.deltaY) > math.abs(touch.deltaX) and math.abs(touch.deltaY) > 10
end

function isHorizontalMove(touch)
    return touch.state == MOVING and math.abs(touch.deltaY) < math.abs(touch.deltaX)
end


