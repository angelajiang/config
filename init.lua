local application = require "mjolnir.application"
local window = require "mjolnir.window"
local screen = require "mjolnir.screen"
local fnutils = require "mjolnir.fnutils"
local hotkey = require "mjolnir.hotkey"
local appfinder = require "mjolnir.cmsj.appfinder"
local alert = require "mjolnir.alert"
local grid = require "mjolnir.sd.grid"

grid.GRIDWIDTH = 4
grid.MARGINX = 0
grid.MARGINY = 0

local hyper = {"cmd", "alt", "ctrl"}
local mover = {"cmd", "alt"}
local ctrl  = {"ctrl"}


local gridset = function(x, y, w, h)
    return function()
        cur_window = window.focusedwindow()
        grid.set(
            cur_window,
            {x=x, y=y, w=w, h=h},
            cur_window:screen()
        )
    end
end


hotkey.bind(hyper, 'c', mjolnir.openconsole)
hotkey.bind(hyper, 'r', mjolnir.reload)

-- window positions
-- maximize
hotkey.bind(hyper, 'm', gridset(0, 0, 4, 2))
-- left half
hotkey.bind(hyper, 'h', gridset(0, 0, 2, 2))
-- right half
hotkey.bind(hyper, 'l', gridset(2, 0, 2, 2))
-- top half
hotkey.bind(hyper, 'k', gridset(0, 0, 4, 1))
-- bottom half
hotkey.bind(hyper, 'j', gridset(0, 1, 4, 1))

-- top-left
hotkey.bind(hyper, ';', gridset(0, 0, 2, 1))
-- top-right
hotkey.bind(hyper, '\'', gridset(2, 0, 2, 1))
-- bottom-left
hotkey.bind(hyper, '.', gridset(0, 1, 2, 1))
-- bottom-right
hotkey.bind(hyper, '/', gridset(2, 1, 2, 1))

-- window movement
-- hotkey.bind(mover, "h", function() window.focusedwindow():focuswindow_west() end)
-- hotkey.bind(mover, "l", function() window.focusedwindow():focuswindow_east() end)
-- hotkey.bind(mover, "j", function() window.focusedwindow():focuswindow_south() end)
-- hotkey.bind(mover, "k", function() window.focusedwindow():focuswindow_north() end)

-- application launching
hotkey.bind( hyper, '[', function() appfinder.app_from_name("iTerm"):activate() end)
hotkey.bind( hyper, 'p', function() appfinder.app_from_name("Google Chrome"):activate() end)
--hotkey.bind( hyper, 'l', function() appfinder.app_from_name("VLC"):activate() end)
hotkey.bind( hyper, ']', function() appfinder.app_from_name("HipChat"):activate() end)
--hotkey.bind( hyper, ';', function() appfinder.app_from_name("Dash"):activate() end)

-- send windows to different screens
hotkey.bind( hyper, '9', function() move_to_left(window.focusedwindow()) end)
hotkey.bind( hyper, '0', function() move_to_right(window.focusedwindow()) end)

function move_to_left(w)
    current_screen = w:screen()
    next_screen = current_screen:next()

    w:settopleft(
        {x=next_screen:frame()["x"], y=next_screen:frame()["y"]}
    )
end

function move_to_right(w)
    current_screen = w:screen()
    next_screen = current_screen:previous()

    w:settopleft(
        {x=next_screen:frame()["x"], y=next_screen:frame()["y"]}
    )
end

alert.show("Mjolnir config loaded")
