--Window Parameters
WINDOW_WIDTH = 1080
WINDOW_HEIGHT = 720

--Fonts
TITLE_FONT = love.graphics.newFont("fonts/caviardreams.ttf", 60)
BUTTON_FONT = love.graphics.newFont("fonts/isocp3_IV50.ttf", 18)
TITLE2_FONT = love.graphics.newFont("fonts/caviardreams.ttf", 48)
TITLE3_FONT = love.graphics.newFont("fonts/caviardreams.ttf", 36)

--Graphic Parameters
PLAYER_SCALE = .2
BUTTON_COLOR = {.5,.5,.5, 1}
BUTTON_HOVER_COLOR = {.5, .5, .5, .5}
BUTTON_TEXT_COLOR = {1,1,1,1}
BUTTON_CORNER_RADIUS = 10
BUTTON_HEIGHT = 30
BUTTON_WIDTH = 150
OUTLINE_COLOR = {1,1,1,1}
PADDING = 20
PADDING2 = 10

--Game Parameters
NUM_SAVE_SLOTS = 5
WALK_SPEED = 150
SPRINT_SPEED = 300

--Strings
GAME_TITLE = 'The Rest of Us'

--Images
IMAGES = {
	playerimage = love.graphics.newImage('images/player.png')
}

--Sounds
SOUNDS = {
	
}

--Music
MUSIC = {
	song1 = love.audio.newSource('audio/The Rest of Us.wav', 'stream')
}

-- ********* Helper Functions **********

--loads all serialized save states into a single table.
function loadGame()
	for slot = 1, NUM_SAVE_SLOTS do
		if love.filesystem.exists('save'..tostring(slot)..'.lua') then 
			local chunk = love.filesystem.load('save'..tostring(slot)..'.lua')
			allSaveStates[slot] = chunk()
		end
	end
end

--Serializes 'saveState' and saves it to save_.lua file corresponding to the active save
function saveGame()
	local success = love.filesystem.write('save'..tostring(activeSave)..'.lua', Serialize(saveState))
	setErrorMessage('Game Saved in Slot: '..activeSave)
	return success
end

function createNewSaveState()
	saveState.inventory = {}
	saveState.weapon = 'fists'
	saveState.playTime = 0
	saveState.saveDate = os.date("%x", os.time())
	saveState.mapX = 0
	saveState.mapY = 0
	saveState.playerDirection = 0
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

function setErrorMessage(message)
	errorMessage = message
	Timer.after(1, function () errorMessage = '' end)
end

function setMouseXY()
	mouseX, mouseY = love.mouse.getPosition()
    mouseRelativeX = mouseX - WINDOW_WIDTH/2
    mouseRelativeY = mouseY - WINDOW_HEIGHT/2
end