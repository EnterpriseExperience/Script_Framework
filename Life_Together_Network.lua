if not getgenv().Game then
   getgenv().Game = cloneref and cloneref(game) or game
end
wait(0.1)
local HttpService = cloneref and cloneref(getgenv().Game:GetService("HttpService")) or getgenv().Game:GetService("HttpService")
local Players = cloneref and cloneref(getgenv().Game:GetService("Players")) or getgenv().Game:GetService("Players")
local RunService = cloneref and cloneref(getgenv().Game:GetService("RunService")) or getgenv().Game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = cloneref and cloneref(getgenv().Game:GetService("ReplicatedStorage")) or getgenv().Game:GetService("ReplicatedStorage")
local Workspace = cloneref and cloneref(getgenv().Game:GetService("Workspace")) or getgenv().Game:GetService("Workspace")
local Modules = ReplicatedStorage:WaitForChild("Modules")
getgenv().Modules = Modules
local Core = Modules:WaitForChild("Core")
local Game = Modules:WaitForChild("Game")
local Invisible_Module = require(Game:FindFirstChild("InvisibleMode"))
getgenv().Invisible_Module = Invisible_Module
local Billboard_GUI = require(Game:FindFirstChild("CharacterBillboardGui"))
getgenv().Billboard_GUI = Billboard_GUI
local PlotMarker = require(Game:FindFirstChild("PlotMarker"))
getgenv().PlotMarker = PlotMarker
local Data = require(Core:FindFirstChild("Data"))
getgenv().Data = Data
local Phone_Module = Game:FindFirstChild("Phone")
getgenv().Phone_Module = Phone_Module
local Phone = require(Game:FindFirstChild("Phone"))
getgenv().Phone = Phone
local Privacy = require(Core:FindFirstChild("Privacy"))
getgenv().Privacy = Privacy
local AppModules = Phone_Module:FindFirstChild("AppModules")
getgenv().AppModules = AppModules
local Messages = require(AppModules:FindFirstChild("Messages"))
getgenv().Messages = Messages
local Network = require(Core:FindFirstChild("Net"))
local CCTV = require(Game:FindFirstChild("CCTV"))
getgenv().CCTV = CCTV
local Tween = require(Core:FindFirstChild("Tween"))
getgenv().Tween = Tween
local Modules = ReplicatedStorage:FindFirstChild("Modules")
wait(0.2)
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
getgenv().Game_Folder = Game
getgenv().Net = Network
wait(0.1)
function send_function(...)
   Network.get(...)
end

function send_remote(...)
   Network.send(...)
end
wait(0.1)
getgenv().Get = send_function
getgenv().Send = send_remote
