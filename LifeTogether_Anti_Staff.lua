if not getgenv().Game then
    getgenv().Game = cloneref and cloneref(game) or game
end

local http = cloneref and cloneref(game:GetService("HttpService")) or game:GetService("HttpService")
local players = game:GetService("Players")
local teleportservice = game:GetService("TeleportService")
local placeid = game.PlaceId
local jobid = game.JobId

local success, latest = pcall(function()
    local vjson = game:HttpGet("https://raw.githubusercontent.com/EnterpriseExperience/MicUpSource/main/Script_Versions_JSON?cachebust=" .. tick())
    return http:JSONDecode(vjson)
end)

if success and latest then
    local latestver = latest.LifeTogether_Admin_Version

    if not getgenv().Script_Version_GlobalGenv then
        getgenv().Script_Version_GlobalGenv = latestver
    end

    if latestver ~= getgenv().Script_Version_GlobalGenv then
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

local plrs = cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")
local lp = plrs.LocalPlayer
local groupid = getgenv().Game.CreatorId

local staffroles = {
    "Admin","Technical Assistance","Developer A","Technical Lead","Finance","Owner","QA Lead","Creator"
}

local function isstaffrole(role)
    for _,v in ipairs(staffroles) do
        if role:lower():find(v:lower()) then
            return true
        end
    end
    return false
end

if groupid and groupid > 0 and lp:IsInGroup(groupid) then
    local role = lp:GetRoleInGroup(groupid)
    if isstaffrole(role) then
        lp:Kick("\n\nRolewatch\nYou are in the group with a staff role: \"" .. role .. "\"")
        wait(0.4)
        while true do end
    end
end
