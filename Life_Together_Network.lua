if not getgenv().Game then
   getgenv().Game = cloneref and cloneref(game) or game
end
wait(0.1)
local Network

local function retrieve_executor()
   local name
   if identifyexecutor then
      name = identifyexecutor()
   end
   return { Name = name or "Unknown Executor" }
end

local function identify_executor()
   local executorDetails = retrieve_executor()
   return tostring(executorDetails.Name)
end

wait(0.1)
local executor_string = identify_executor()

local function executor_contains(substr)
   if type(executor_string) ~= "string" then
      return false
   end

   return string.find(string.lower(executor_string), string.lower(substr), 1, true) ~= nil
end

wait(0.1)

if executor_contains("LX63") then
    local Net

    for _, obj in pairs(getgc(true)) do
        if typeof(obj) == "table" then
            if typeof(rawget(obj, "send")) == "function" and typeof(rawget(obj, "get")) == "function" then
                local info = debug.getinfo(obj.get)
                if info and info.source and info.source:find("Net") then
                    Net = obj
                    break
                end
            end
        end
    end

    if Net then
        Network = Net
    end
end

local HttpService = cloneref and cloneref(getgenv().Game:GetService("HttpService")) or getgenv().Game:GetService("HttpService")
local Players = cloneref and cloneref(getgenv().Game:GetService("Players")) or getgenv().Game:GetService("Players")
local RunService = cloneref and cloneref(getgenv().Game:GetService("RunService")) or getgenv().Game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = cloneref and cloneref(getgenv().Game:GetService("ReplicatedStorage")) or getgenv().Game:GetService("ReplicatedStorage")
local Workspace = cloneref and cloneref(getgenv().Game:GetService("Workspace")) or getgenv().Game:GetService("Workspace")
local Modules = ReplicatedStorage:WaitForChild("Modules")
getgenv().Modules = Modules
local Core = Modules:WaitForChild("Core")
local Game_Folder = Modules:WaitForChild("Game")
getgenv().Game_Folder = Game_Folder
wait(0.1)
if executor_contains("LX63") then
    -- thanks LifeTogether RP for storing these in memory so easily for me to find them! --
    local targets = {
        "InvisibleMode",
        "CharacterBillboardGui",
        "PlotMarker",
        "Data",
        "Phone",
        "Privacy",
        "Messages",
        "CCTV",
        "Tween",
        "Seat",
        "Blur",
        "RateLimiter",
        "Net" -- keep this included, the check from earlier doesn't store it globally, causing other areas to bug out.
    }

    for _, target in ipairs(targets) do
        for _, obj in pairs(getgc(true)) do
            if typeof(obj) == "table" then
                local info
                local anyFunc

                for _, v in pairs(obj) do
                    if typeof(v) == "function" then
                        info = debug.getinfo(v)
                        anyFunc = true
                        break
                    end
                end

                if anyFunc and info and info.source and info.source:find(target) then
                    getgenv()[target] = obj
                    break
                end
            end
        end
    end
else
    local Invisible_Module = require(Game_Folder:FindFirstChild("InvisibleMode"))
    getgenv().Invisible_Module = Invisible_Module
    local Billboard_GUI = require(Game_Folder:FindFirstChild("CharacterBillboardGui"))
    getgenv().Billboard_GUI = Billboard_GUI
    local PlotMarker = require(Game_Folder:FindFirstChild("PlotMarker"))
    getgenv().PlotMarker = PlotMarker
    local Data = require(Core:FindFirstChild("Data"))
    getgenv().Data = Data
    local Phone_Module = Game_Folder:FindFirstChild("Phone")
    getgenv().Phone_Module = Phone_Module
    local Phone = require(Game_Folder:FindFirstChild("Phone"))
    getgenv().Phone = Phone
    local Privacy = require(Core:FindFirstChild("Privacy"))
    getgenv().Privacy = Privacy
    local AppModules = Phone_Module:FindFirstChild("AppModules")
    getgenv().AppModules = AppModules
    local Messages = require(AppModules:FindFirstChild("Messages"))
    getgenv().Messages = Messages
    Network = require(Core:FindFirstChild("Net"))
    local CCTV = require(Game_Folder:FindFirstChild("CCTV"))
    getgenv().CCTV = CCTV
    local Tween = require(Core:FindFirstChild("Tween"))
    getgenv().Tween = Tween
    local Seat = require(Game_Folder:FindFirstChild("Seat"))
    getgenv().Seat = Seat
    local Blur = require(Core:FindFirstChild("Blur"))
    getgenv().Blur = Blur
    local RateLimiter = require(Core:FindFirstChild("RateLimiter"))
    getgenv().RateLimiter = RateLimiter
    local UI = require(Core:FindFirstChild("UI"))
    getgenv().UI = UI
    local Modules = ReplicatedStorage:FindFirstChild("Modules")
end
wait(0.4)
function show_notification(Title, Text, Method, Image)
    if Method == "Normal" and not Image then
        Phone.show_notification(tostring(Title), tostring(Text))
    elseif Method == "Warning" then
        Phone.show_notification(
            tostring(Title),
            tostring(Text),
            nil,
            "rbxassetid://13828984843"
        )
    elseif Method == "Error" then
        Phone.show_notification(
            tostring(Title),
            tostring(Text),
            nil,
            "rbxassetid://14930908086"
        )
    end
end
wait(0.1)
getgenv().show_notification = show_notification
getgenv().Modules = Modules
getgenv().Core = Core
getgenv().Game_Folder = Game_Folder
getgenv().Net = Network
wait(0.1)
function send_function(...)
   Network.get(...)
end

function send_remote(...)
   Network.send(...)
end
wait(0.1)
getgenv().send_remote = send_remote
getgenv().send_function = send_function
getgenv().Get = send_function
getgenv().Send = send_remote
