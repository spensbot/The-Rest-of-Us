--Window Parameters
WINDOW_WIDTH = 1800
WINDOW_HEIGHT = WINDOW_WIDTH*.53

--Game Parameters
WALK_SPEED = 300
SPRINT_SPEED = WALK_SPEED * 2
STAMINA_DRAIN = 20 --per second, while sprinting
STAMINA_REGEN = 100 --per second, while not sprinting
PLAYER_HIT_RADIUS = 45
PLAYER_COLLISION_RADIUS = 45
MOVEMENT_CORRECTION_FACTOR = .6 --Lowers movement speed when player is looking opposite direction of movement
LEVEL_CAP = 50
NUM_SAVE_SLOTS = 5

--Graphic Parameters
PLAYER_SCREEN_X = WINDOW_WIDTH/2
PLAYER_SCREEN_Y = WINDOW_HEIGHT/2
PLAYER_SCALE = .3
PADDING = 20
PADDING2 = 10

--Colors
WHITE = {1,1,1,1}
BLACK = {0,0,0,1}

--Strings
GAME_TITLE = 'The Rest of Us'