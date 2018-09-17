DeathState = Class{__includes = StartState}

local deathMessages = {
	"It's 5 O'Clock Somewhere",
	'Is that you, Jimmy?',
	"Too bad there isn't some way of saving progress...",
	"Sweet Release",
	"You died.",
	"I hate Mondays",
	"Hello Darkness, My Old Friend",
	"I'm sorry, what's this?",
	"Maybe next time",
	"I thought there was nothing after the end...",
	"It's Honeydew's fault",
	"Stupid Honeydew.",
	"Honey-dew you want to try again?",
	"It's time for a Honeydew break anyway",
	"Look at all those chickens"
}

function DeathState:enter()
	self.deathMessage = deathMessages[love.math.random(#deathMessages)]
end

function DeathState:render()
	self.loadButton:render()
	self.newButton:render()
	love.graphics.setFont(TITLE_FONT)
	love.graphics.printf(self.deathMessage, 0, 200, WINDOW_WIDTH, 'center')
end