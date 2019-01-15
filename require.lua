--Required files which I did not make
Class = require 'libraries/class'
Serialize = require 'libraries/serialize'
Timer = require 'libraries/timer'
require 'libraries/StateMachine'

--Helper files
require 'params'
require 'helperFunctions'
require 'typeDefs'
require 'resources'

--Character Classes
require 'Player'
require 'Weapon'
require 'Enemy'
require 'Armor'

--GUI Classes
require 'Button'
require 'InventoryScreen'
require 'HUD'
require 'ProgressBar'
require 'SearchInterface'

--Map Classes
require 'Map'
require 'Ground'
require 'MapObject'
require 'TerrainObject'
require 'StoryPoint'

--State files
require 'BaseState'
require 'StartState'
require 'PlayState'
require 'LoadGameState'
require 'DeathState'