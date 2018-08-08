require 'require'

function love.load()
    --Setup the window
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
    love.window.setTitle(GAME_TITLE)

    --Seed lua's random number generator
    math.randomseed(os.time())

    --Initialize user input variables
    keysPressed = {}
    buttonsPressed = {}
    mouseX = 0
    mouseY = 0

    --Initialize save data
    love.filesystem.setIdentity(GAME_TITLE)
    saveState = {}
    activeSave = 0
    allSaveStates = {}
    loadGame()
    newGame = true

    --Initialize movement variables
    playerDx = 0
    playerDy = 0

    --Initialize state machine
    stateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['load'] = function() return LoadGameState() end,
        ['play'] = function() return PlayState() end
    }
    stateMachine:change('start')

    errorMessage = ''
end

function love.update(dt)
    setMouseXY()
    
    stateMachine:update(dt)
    Timer.update(dt)

    keysPressed, buttonsPressed = {}, {}
end

function love.draw()
    stateMachine:render()
    displayErrorMessage()
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