require 'require'

DEBUG = false
--DEBUG = true

function love.load()
    setupWindow()
    --Seed lua's random number generator
    math.randomseed(os.time())
    initializeStateMachine()
    initializeGlobals()
end

function love.update(dt)
    lMouseDown = love.mouse.isDown(1)
    setMouseXY()
    stateMachine:update(dt)
    Timer.update(dt)
    keysPressed, buttonsPressed = {}, {}
end

function love.draw()
    stateMachine:render()
    displayErrorMessage()
    printDebugMessages()
end

function love.keypressed(key)
    if key == 'escape' then 
        love.event.quit()
    end
    keysPressed[key] = true
end

function love.mousepressed(x, y, button)
    buttonsPressed[button] = true
end


--*************** HELPER FUNCTIONS FOR MAIN.LUA *********************


function setupWindow()
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true,
        msaa = 0
    })
    love.window.setTitle(GAME_TITLE)
    love.graphics.setDefaultFilter( "nearest", "nearest", 1 )
    love.filesystem.setIdentity(GAME_TITLE)
end

function setErrorMessage(message)
    errorMessage = message
    Timer.after(1, function () errorMessage = '' end)
end

function displayErrorMessage()
    local messageBoxWidth = WINDOW_WIDTH/2
    local messageBoxHeight = WINDOW_HEIGHT/6
    local messageBoxX = WINDOW_WIDTH/2 - messageBoxWidth/2
    local messageBoxY = PADDING
    if #errorMessage > 0 then 
        love.graphics.setFont(TITLE3_FONT)
        love.graphics.setColor(.1, .1, .1, .95)
        love.graphics.rectangle('fill', messageBoxX, messageBoxY, messageBoxWidth, messageBoxHeight)
        love.graphics.setColor(1,1,1,1)
        love.graphics.printf(errorMessage, messageBoxX, messageBoxY+PADDING, messageBoxWidth, 'center')
    end
end

function addDebug(name, value)
    debugMessages[name] = value
end

function printDebugMessages()
    if DEBUG then
        --Initialize debug window
        local debugString = ""
        local debugX = 10
        local debugY = 10
        local debugWidth = 300
        local debugSpacing = 18
        local debugHeight = 300
        local debugBackgroundColor = {.2,.2,.2,.5}
        local line = 0
        love.graphics.setColor(debugBackgroundColor)
        love.graphics.rectangle('fill', debugX, debugY, debugWidth, debugHeight)
        love.graphics.setColor(1,1,1,1)
        love.graphics.setFont(BUTTON_FONT)

        --Permanent Debug Messages
        permanentDebugMessages = {
            ['Map X:'] = saveState.mapX,
            ['Map Y:'] = saveState.mapY,
            ['Player Direction'] = saveState.playerDirection
        }
        for name, value in pairs(permanentDebugMessages) do
            love.graphics.printf(name..": "..tostring(value), debugX+PADDING2, debugY + PADDING2 + debugSpacing*line, debugWidth, 'left')
            line = line + 1
        end
        line = line + 1

        --Temporary Debug Messages
        for name, value in pairs(debugMessages) do
            local valueString = ''
            local ok, err = pcall(string.format,"%.2f", value)
            if ok then
                valueString = string.format("%.2f", value)
            else
                valueString = tostring(value)
            end
            love.graphics.printf(name..": "..valueString, debugX+PADDING2, debugY + PADDING2 + debugSpacing*line, debugWidth, 'left')
            line = line + 1
        end

        --Debug Graphics
        local originX, originY = transformMapToScreen(0, 0)
        love.graphics.circle('line', originX, originY, 10)
        local testCoordX, testCoordY = transformMapToScreen(200,200)
        love.graphics.circle('fill', testCoordX, testCoordY, 5)
        love.graphics.print('200, 200', testCoordX, testCoordY)
    end
end
    

function setMouseXY()
    mouseX, mouseY = love.mouse.getPosition()
    mouseRelativeX = mouseX - WINDOW_WIDTH/2
    mouseRelativeY = mouseY - WINDOW_HEIGHT/2
end

function initializeGlobals()
    --User input variables
    keysPressed = {}
    buttonsPressed = {}
    mouseX = 0
    mouseY = 0
    lMouseDown = false

    --Messages
    errorMessage = ''
    debugMessages = {}

    --Globals
    createNewSaveState()
    global = {
        activeSave = 0,
        obstacles = {},
        obstacleData = {}, --{x,y}
        level = 0,
        xpToNextLevel = 0,
        xpFromLastLevel = 0,
        multipliers = {
            ['Damage Dealt'] = {},
            ['Damage Taken'] = {},
            ['Travel Speed'] = {}
        },
        playerDirection = 0,
        maxHealth = 0,
        maxStamina = 0,
        weight = 0,
        categoryWeights = {},
    }

end

function initializeStateMachine()
    stateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['load'] = function() return LoadGameState() end,
        ['play'] = function() return PlayState() end,
        ['death'] = function() return DeathState() end
    }
    stateMachine:change('start')
end