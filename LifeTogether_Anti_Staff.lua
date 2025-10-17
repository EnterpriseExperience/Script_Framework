if not getgenv().Game then
    getgenv().Game = cloneref and cloneref(game) or game
end

local Players = cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local GroupId = getgenv().Game.CreatorId
local staffRoles = {
   "Admin", "Technical Assistance", "Developer A", "Technical Lead", "Finance", "Owner", "QA Lead", "Creator"
}

local function isStaffRole(role)
	for _, staff in ipairs(staffRoles) do
		if role:lower():find(staff) then
			return true
		end
	end
	return false
end

if GroupId and GroupId > 0 and LocalPlayer:IsInGroup(GroupId) then
	local role = LocalPlayer:GetRoleInGroup(GroupId)
	if isStaffRole(role) then
		LocalPlayer:Kick("\n\nRolewatch\nYou are in the group with a staff role: \"" .. role .. "\"")
      wait(0.4)
      while true do end
	end
end
