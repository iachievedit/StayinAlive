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
local moduleName = "StayinAlive"
StayinAlive[moduleName] = module

local addonVersion = GetAddOnMetadata("StayinAlive", "Version")

local function InitializeUI()

  configFrame = CreateFrame("Frame", "StayInAliveConfigFrame", UIParent, "BasicFrameTemplateWithInset")
  configFrame:SetSize(400, 240)  -- Width, Height
  configFrame:SetPoint("CENTER") 
  configFrame:EnableMouse(true)
  configFrame:SetMovable(true)
  configFrame:RegisterForDrag("LeftButton")
  configFrame:SetScript("OnDragStart", configFrame.StartMoving)
  configFrame:SetScript("OnDragStop", configFrame.StopMovingOrSizing)
  configFrame:Hide()

  configFrame.title = configFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  configFrame.title:SetPoint("TOPLEFT", configFrame, "TOPLEFT", 10, -4)
  configFrame.title:SetText("Stayin' Alive" .. " v" .. addonVersion)

  local sendToGuildCheckbox = CreateFrame("CheckButton", nil, configFrame, "UICheckButtonTemplate")
  sendToGuildCheckbox:SetPoint("TOPLEFT", configFrame, "TOPLEFT", 20, -40)
  sendToGuildCheckbox.Text:SetText("Send StayinAlive notifications to guild chat")
  sendToGuildCheckbox:SetChecked(StayinAlive_CharacterDB.sendToGuildChat)

  local stillAliveLabel = configFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  stillAliveLabel:SetPoint("TOPLEFT", configFrame, "TOPLEFT", 20, -80)
  stillAliveLabel:SetText("Play Pearl Jam's 'Alive' if you escape combat with less than")

  -- Create a slider for setting the health percentage threshold
  local healthThresholdSlider = CreateFrame("Slider", "HealthThresholdSlider", configFrame, "OptionsSliderTemplate")
  healthThresholdSlider:SetPoint("TOPLEFT", configFrame, "TOPLEFT", 20, -100)
  healthThresholdSlider:SetMinMaxValues(10, 80)
  healthThresholdSlider:SetValueStep(1)
  healthThresholdSlider:SetObeyStepOnDrag(true)
  healthThresholdSlider:SetWidth(200)
  healthThresholdSlider:SetValue(StayinAlive_CharacterDB.healthThreshold)
  -- Remove the Low and High labels
  _G[healthThresholdSlider:GetName() .. 'Low']:SetText('')
  _G[healthThresholdSlider:GetName() .. 'High']:SetText('')

  healthThresholdSlider.Text = healthThresholdSlider:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  healthThresholdSlider.Text:SetPoint("RIGHT", healthThresholdSlider, "RIGHT", 100, 0)
  healthThresholdSlider.Text:SetText(healthThresholdSlider:GetValue() .. "%".. " health")

  local copyrightLabel = configFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  copyrightLabel:SetPoint("TOPLEFT", configFrame, "TOPLEFT", 20, -120)
  copyrightLabel:SetText("Song clips used under fair use, 17 U.S. Code § 107.")

  local debug = CreateFrame("CheckButton", nil, configFrame, "UICheckButtonTemplate")
  debug:SetPoint("TOPLEFT", configFrame, "TOPLEFT", 20, -140)
  debug.Text:SetText("Debug notifications")
  debug:SetChecked(StayinAlive_CharacterDB.debugMessages)
  debug:SetScript("OnClick", function(self)
    StayinAlive_CharacterDB.debugMessages = self:GetChecked()
    if self:GetChecked() then
      print("StayinAlive debug messages enabled.")
    else
      print("StayinAlive debug messages disabled.")
    end
  end)

  healthThresholdSlider:SetScript("OnValueChanged", function(self, value)
    self.Text:SetText(math.floor(value) .. "% health")
    StayinAlive_CharacterDB.healthThreshold = math.floor(value)
  end)

  sendToGuildCheckbox:SetScript("OnClick", function(self)
    StayinAlive_CharacterDB.sendToGuildChat = self:GetChecked()
      if self:GetChecked() then
          print("StayinAlive notifications to guild chat enabled.")
      else
          print("StayinAlive notifications to guild chat disabled.")
      end
  end)

  local closeButton = CreateFrame("Button", nil, configFrame, "UIPanelButtonTemplate")
  closeButton:SetSize(100, 30)
  closeButton:SetPoint("BOTTOM", configFrame, "BOTTOM", 0, 20)
  closeButton:SetText("Close")
  closeButton:SetScript("OnClick", function()
      configFrame:Hide()
  end)
end -- InitializeUI

local function playStayinAlive()
  PlaySoundFile("Interface\\AddOns\\StayinAlive\\Sounds\\staying-alive.mp3")
end

local function playStillAlive()
  PlaySoundFile("Interface\\AddOns\\StayinAlive\\Sounds\\still-alive.mp3")
end

local function playBitesDust()
  PlaySoundFile("Interface\\AddOns\\StayinAlive\\Sounds\\bites-dust.mp3")
end

-- Only for events
local eventFrame = CreateFrame("Frame", "SA_Frame")
local playerGUID = UnitGUID("player")

eventFrame:Show()
eventFrame:RegisterEvent("PLAYER_LEVEL_CHANGED")
eventFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
eventFrame:RegisterEvent("ADDON_LOADED")

target = ""

local function eventHandler(self, event, ...)

  if (event == "ADDON_LOADED") then
    local addonName = ...
    if addonName == "StayinAlive" then
      print("StayinAlive loaded - Stay alive out there.")
      print("For options, type /stayinalive")

      if StayinAlive_CharacterDB == nil then
        StayinAlive_CharacterDB = {
          sendToGuildChat = false,
          healthThreshold = 20,
          debugMessages   = false
        }
      end
      InitializeUI()

      SLASH_STAYINALIVE1 = "/stayinalive"
      SlashCmdList["STAYINALIVE"] = function()
        if configFrame:IsShown() then
          configFrame:Hide()
        else
          configFrame:Show()
        end
      end
    end
  end

  if (event == "PLAYER_LEVEL_CHANGED") then
    
    local level          = UnitLevel("player")
    local name           = UnitName("player")
    local percentOfSixty = math.floor((level / 60) * 100)
    local eventString    = name.." is stayin alive! Now level "..level.." ("..percentOfSixty.."% to 60!)."

    if StayinAlive_CharacterDB.sendToGuildChat then
      SendChatMessage(eventString,"GUILD")
    else
      print(eventString)
    end

    playStayinAlive()

  end

  -- Best event for "in combat"
  if (event == "PLAYER_REGEN_DISABLED") then
    target = UnitName("target")
    
    if StayinAlive_CharacterDB.debugMessages then
      print("StayinAlive Debug:  Combat started with "..target..".")
    end
  end

  -- Best event for "out of combat"
  if (event == "PLAYER_REGEN_ENABLED") then

    local max_health = UnitHealthMax("player")
    local health = UnitHealth("player")
    local health_percent = math.floor((health / max_health) * 100)
    local name = UnitName("player")

    -- debug
    if StayinAlive_CharacterDB.debugMessages then
      print("StayinAlive Debug:  Combat ended with "..target.." with "..health_percent.."% health.")
    end

    if health_percent == 0 then  

      local eventString = name.." has died at the hands of a "..target.."!  F.  RIP.  Go agane!"
      if StayinAlive_CharacterDB.sendToGuildChat then
        SendChatMessage(eventString,"GUILD")
      else
        print(eventString)
      end
      
      playBitesDust()

    elseif health_percent < StayinAlive_CharacterDB.healthThreshold then

      local eventString = name.." escaped death from a "..target.." with "..health_percent.."% health."
      
      if StayinAlive_CharacterDB.sendToGuildChat then
        SendChatMessage(eventString,"GUILD")
      else
        print(eventString)
      end

      playStillAlive()
    end
  end

end

eventFrame:SetScript("OnEvent", eventHandler)


