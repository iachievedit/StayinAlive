--[[
  StayinAliveMain.lua

  Copyright 2024 iAchieved.it LLC

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.

]]--

local addonName, addon = ...
local StayinAlive = addon

local module = {}
local moduleName = "StayinAliveMain"
StayinAlive[moduleName] = module

local function playStayinAlive()
  PlaySoundFile("Interface\\AddOns\\StayinAlive\\Sounds\\staying-alive.mp3")
end

local function playStillAlive()
  PlaySoundFile("Interface\\AddOns\\StayinAlive\\Sounds\\still-alive.mp3")
end

-- Only for events
local eventFrame = CreateFrame("Frame", "SA_Frame")
local playerGUID = UnitGUID("player")

eventFrame:Show()
eventFrame:RegisterEvent("PLAYER_LEVEL_CHANGED")
eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")

local function eventHandler(self, event, ...)

  if (event == "PLAYER_LEVEL_CHANGED") then
    print("Stayin alive!")
    local level = UnitLevel("player")
    local name = UnitName("player")
    local percentOfSixty = math.floor((level / 60) * 100)
    SendChatMessage(name.." is stayin alive! Now level "..level..", "..percentOfSixty.."% to 60!","GUILD")
    playStayinAlive()
  end

  -- Best event for "out of combat"
  if (event == "PLAYER_REGEN_ENABLED") then
    local max_health = UnitHealthMax("player")
    local health = UnitHealth("player")
    local health_percent = math.floor((health / max_health) * 100)

    if health_percent == 0 then
      local name = UnitName("player")
      SendChatMessage(name.." has died!  F.  RIP.  Go agane!","GUILD")
    elseif health_percent < 20 then

      print("I'm still alive with only "..health_percent.."% health!")

      local name = UnitName("player")
      SendChatMessage(name.." narrowly escapes death with only "..health_percent..
                            "% health, but is still alive!",  "GUILD")
      playStillAlive()
    end
  end

end

eventFrame:SetScript("OnEvent", eventHandler)

print("StayinAlive loaded - Stay alive out there.")


