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

local function playSound()
  PlaySoundFile("Interface\\AddOns\\StayinAlive\\Sounds\\staying-alive.mp3")
end

-- Only for events
local eventFrame = CreateFrame("Frame", "SA_Frame")
local playerGUID = UnitGUID("player")

eventFrame:Show()
eventFrame:RegisterEvent("PLAYER_LEVEL_CHANGED")

local function eventHandler(self, event, ...)

  if (event == "PLAYER_LEVEL_CHANGED") then
    print("Stayin alive!")
    playSound()
  end

end

eventFrame:SetScript("OnEvent", eventHandler)

print("StayinAlive loaded - Stay alive out there.")


