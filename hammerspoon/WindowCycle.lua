-- Use Ctrl+Shift+Command+Tab to cycle the active window among all screens.
-- Useful when an application opens on the "wrong" screen.

hs.window.animationDuration = 0.25

function nextScreen()
    local window = hs.window.focusedWindow()
    local full = window:isFullScreen()
    if full then
        window:setFullScreen(false)
    end
    window:moveToScreen(window:screen():next(), true, true)
    if full then
        hs.timer.doAfter(0.6, function()
            window:setFullScreen(true)
        end)
    end
end

hs.hotkey.bind({"cmd", "ctrl", "shift"}, "tab", nextScreen)

-- vim: set ts=4 sw=4 et:
