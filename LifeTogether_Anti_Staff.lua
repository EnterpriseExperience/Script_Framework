if not getgenv().Game then
    getgenv().Game = cloneref and cloneref(game) or game
end

local HttpService = cloneref and cloneref(game:GetService("HttpService")) or game:GetService("HttpService")
local players = game:GetService("Players")
local teleportservice = game:GetService("TeleportService")
local placeid = game.PlaceId
local jobid = game.JobId
local success, latestversioninfo = pcall(function()
   local vjson = game:HttpGet("https://raw.githubusercontent.com/EnterpriseExperience/MicUpSource/main/Script_Versions_JSON?cachebust=" .. tick())
   return HttpService:JSONDecode(vjson)
end)

function getmainraw(v)
   return string.split(v,"-")[1]
end

if success and latestversioninfo then
   local ver = latestversioninfo.LifeTogether_Admin_Version
   if ver ~= getgenv().Script_Version_GlobalGenv then
      getgenv().LifeTogetherRP_Admin = false
      wait(0.3)
      for i = 1,2 do
         task.wait(0.5)
         players.LocalPlayer.OnTeleport:Connect(function(state)
            if (not getgenv().TeleportCheck_Admin) and getgenv().queueteleport then
               getgenv().TeleportCheck_Admin = true
               queueteleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/EnterpriseExperience/MicUpSource/refs/heads/main/LifeTogether_RP_Admin.lua'))()")
            end
         end)
      end
      task.wait(0.1)
      if #players:GetPlayers() <= 1 then
         players.LocalPlayer:Kick("\nRejoining...")
         task.wait()
         teleportservice:Teleport(placeid, players.LocalPlayer)
      else
         teleportservice:TeleportToPlaceInstance(placeid, jobid, players.LocalPlayer)
      end
   end
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
