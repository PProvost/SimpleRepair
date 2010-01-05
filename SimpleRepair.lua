--[[
SimpleRepair/SimpleRepair.lua

Copyright 2008 Quaiche

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
]]

local L_GOLD = "g"
local L_SILVER = "s"
local L_COPPER = "c"
local function Print(...) print(string.join(" ", "|cFF33FF99SimpleRepair|r:", ...)) end

local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(self, event, ...) if self[event] then return self[event](self, event, ...) end end)

function f:PLAYER_LOGIN()
	LibStub("tekKonfig-AboutPanel").new(nil, "SimpleRepair")
	self:RegisterEvent("MERCHANT_SHOW")
end

function f:MERCHANT_SHOW()
	if CanMerchantRepair() then
		local cost = GetRepairAllCost()
		local gold = floor(cost / 10000)
		local silver = floor((cost - (gold * 10000)) / 100)
		local copper = mod(cost, 100)
		local formattedCost = format("%i|cffffd700%s|r %i|cffc7c7cf%s|r %i|cffeda55f%s|r", gold, L_GOLD, silver, L_SILVER, copper, L_COPPER)

		if GetMoney() > cost then
			RepairAllItems()
			Print("Repaired all equipment for " .. formattedCost)
		else
			Print("Total repair cost of " .. formattedCost .. " is more than you can afford")
		end
	end
end

if MerchantFrame:IsVisible() then f:MERCHANT_SHOW() end
if IsLoggedIn() then f:PLAYER_LOGIN() else f:RegisterEvent("PLAYER_LOGIN") end
