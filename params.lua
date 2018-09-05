--Window Parameters
WINDOW_WIDTH = 1700
WINDOW_HEIGHT = 1000

--Game Parameters
NUM_SAVE_SLOTS = 5
WALK_SPEED = 300
SPRINT_SPEED = 500
STAMINA_DRAIN = 20 --per second, while sprinting
STAMINA_REGEN = 10 --per second, while not sprinting
PLAYER_HIT_RADIUS = 45
PLAYER_COLLISION_RADIUS = 45
MOVEMENT_CORRECTION_FACTOR = .35 --Lowers movement speed when player is looking opposite direction of movement

--Graphic Parameters
PLAYER_SCREEN_X = WINDOW_WIDTH/2
PLAYER_SCREEN_Y = WINDOW_HEIGHT/2
PLAYER_SCALE = .3
BUTTON_COLOR = {.5,.5,.5, 1}
BUTTON_HOVER_COLOR = {.5, .5, .5, .5}
BUTTON_TEXT_COLOR = {1,1,1,1}
BUTTON_CORNER_RADIUS = 5
BUTTON_HEIGHT = 30
BUTTON_WIDTH = 150
OUTLINE_COLOR = {1,1,1,1}
ITEM_BUTTON_WIDTH = 50
PADDING = 20
PADDING2 = 10

--Fonts
TITLE_FONT = love.graphics.newFont("fonts/caviardreams.ttf", 60)
BUTTON_FONT = love.graphics.newFont("fonts/BebasNeue Regular.otf", 18)
SMALL_FONT = love.graphics.setNewFont("fonts/calibri.ttf", 12)
TITLE2_FONT = love.graphics.newFont("fonts/caviardreams.ttf", 48)
TITLE3_FONT = love.graphics.newFont("fonts/caviardreams.ttf", 36)

--Colors
WHITE = {1,1,1,1}
BLACK = {0,0,0,1}

--Strings
GAME_TITLE = 'The Rest of Us'

--Images
IMAGES = {
	playerimage = love.graphics.newImage('images/player.png'),
	barrier = love.graphics.newImage('images/barrier.png'),
	heavyAmmo = love.graphics.newImage('images/heavyAmmo.png'),
	itemBackground = love.graphics.newImage('images/itemBackground.png')
}

--Sounds
SOUNDS = {
	enemySeesPlayer = {
		love.audio.newSource('audio/EnemySeesPlayer1.wav', 'stream'),
		love.audio.newSource('audio/EnemySeesPlayer2.wav', 'stream'),
		love.audio.newSource('audio/EnemySeesPlayer3.wav', 'stream'),
		love.audio.newSource('audio/EnemySeesPlayer4.wav', 'stream'),
		love.audio.newSource('audio/EnemySeesPlayer5.wav', 'stream')
	},
	enemyLoosesPlayer = {
		love.audio.newSource('audio/EnemyLoosesPlayer1.wav', 'stream'),
		love.audio.newSource('audio/EnemyLoosesPlayer2.wav', 'stream'),
		love.audio.newSource('audio/EnemyLoosesPlayer3.wav', 'stream')
	}
}

--Music
MUSIC = {
	song1 = love.audio.newSource('audio/The Rest of Us.wav', 'stream')
}