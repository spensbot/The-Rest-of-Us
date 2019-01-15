--Fonts
TITLE_FONT = love.graphics.newFont("fonts/caviardreams.ttf", 60)
BUTTON_FONT = love.graphics.newFont("fonts/calibri.ttf", 18)
LABEL_FONT = love.graphics.newFont("fonts/BebasNeue Regular.otf", 24)
LABEL_FONT2 = love.graphics.newFont("fonts/BebasNeue Regular.otf", 20)
SMALL_FONT = love.graphics.setNewFont("fonts/calibri.ttf", 18)
TITLE2_FONT = love.graphics.newFont("fonts/caviardreams.ttf", 48)
TITLE3_FONT = love.graphics.newFont("fonts/caviardreams.ttf", 36)

--Images
IMAGES = {
	playerimage = love.graphics.newImage('images/player.png'),
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