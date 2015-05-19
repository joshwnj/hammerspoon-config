-- disable animation
hs.window.animationDuration = 0

local cac = {"cmd", "alt", "ctrl"}

----
-- source: https://github.com/cmsj/hammerspoon-config/blob/master/init.lua#L137

-- Toggle Skype between muted/unmuted, whether it is focused or not
function toggleSkypeMute()
  local skype = hs.appfinder.appFromName("Skype")
  if not skype then
    return
  end

  local lastapp = nil
  if not skype:isFrontmost() then
    lastapp = hs.application.frontmostApplication()
    skype:activate()
  end

  if not skype:selectMenuItem({"Conversations", "Mute Microphone"}) then
    skype:selectMenuItem({"Conversations", "Unmute Microphone"})
  end

  if lastapp then
    lastapp:activate()
  end
end

hotkey.bind(cac, 'M', toggleSkypeMute)

----
