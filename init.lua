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

local muteCircle = nil
function removeCircle(circle)
  if circle then
    circle:delete()
  end
end

function createMuteCircle()
  muteCircle = hs.drawing.circle(hs.geometry.rect(20, 40, 80, 80))
  muteCircle:setFillColor({["red"]=0, ["green"]=0, ["blue"]=0, ["alpha"]=0.5})
  muteCircle:setFill(true)
  muteCircle:setStroke(true)
end

function drawMuteCircle()
  removeCircle(muteCircle)
  createMuteCircle()
  muteCircle:show()
end

----
-- source: https://github.com/squaresurf/hammerspoon-castle/blob/master/home/.hammerspoon/init.lua#L70-L95

function micIsMuted()
    status, volume = hs.applescript.applescript('get volume settings')
    if status then
        invl = volume:match("invl':(%d+)")
        if invl == '0' then
            return true
        else
            return false
        end
    end
end

function displayIfMicIsMuted()
    muted = micIsMuted()
    if muted == nil then
        hs.alert.show("Not sure if the Mic is muted.")
    elseif muted then
      drawMuteCircle()
    else
      removeCircle(muteCircle)
    end
end

-- Toggle mic mute
function muteMic()
  hs.applescript.applescript('set volume input volume 0')
end

function unmuteMic()
  hs.applescript.applescript('set volume input volume 75')
end

function toggleMicMute()
    muted = micIsMuted()
    if muted then
      unmuteMic()
    else
      muteMic()
    end
    displayIfMicIsMuted()
end

-- enable the mic by default
unmuteMic()
