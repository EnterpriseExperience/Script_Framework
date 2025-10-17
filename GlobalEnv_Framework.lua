if not getgenv().Game then
    getgenv().Game = cloneref and cloneref(game) or game
end
wait(0.1)
getgenv().AllClipboards = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)
getgenv().httprequest_Init = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
get_http = getgenv().httprequest_Init or (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
getgenv().queueteleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
getgenv().JobID = getgenv().Game.JobId
getgenv().PlaceID = getgenv().Game.PlaceId
queueteleport = getgenv().queueteleport
wait(0.1)
local function Service_Wrap(service)
   if cloneref then
      return cloneref(getgenv().Game:GetService(service))
   else
      return getgenv().Game:GetService(service)
   end
end
wait(0.1)
getgenv().Service_Wrap = Service_Wrap

local function init_services()
   local services = {
      "Players",
      "Workspace",
      "Lighting",
      "ReplicatedStorage",
      "TweenService",
      "RunService",
      "MaterialService",
      "ReplicatedFirst",
      "Teams",
      "StarterPack",
      "StarterPlayer",
      "VoiceChatInternal",
      "VoiceChatService",
      "CoreGui",
      "SoundService",
      "StarterGui",
      "MarketplaceService",
      "TeleportService",
      "Chat",
      "AssetService",
      "HttpService",
      "UserInputService",
      "TextChatService",
      "ContextActionService",
      "GuiService",
      "PhysicsService",
      "ScriptContext"
   }

   for _, serviceName in pairs(services) do
      getgenv()[serviceName] = cloneref and cloneref(getgenv().Game:GetService(serviceName)) or getgenv().Game:GetService(serviceName)
   end
   wait(0.1)
   if getgenv().StarterPlayer:FindFirstChildOfClass("StarterPlayerScripts") then
      getgenv().StarterPlayerScripts = getgenv().StarterPlayer:FindFirstChildOfClass("StarterPlayerScripts") or getgenv().StarterPlayer:FindFirstChildWhichIsA("StarterPlayerScripts")
   end
   if getgenv().StarterPlayer:FindFirstChildOfClass("StarterCharacterScripts") then
      getgenv().StarterCharacterScripts = getgenv().StarterPlayer:FindFirstChildOfClass("StarterCharacterScripts") or getgenv().StarterPlayer:FindFirstChildWhichIsA("StarterCharacterScripts")
   end
end
wait(0.1)
init_services()
wait(0.2)
local cmdp = cloneref and cloneref(getgenv().Game:GetService("Players")) or game:GetService("Players")
local cmdlp = cmdp.LocalPlayer

function getHum(char)
   if not char then return nil end

   local hum = char:FindFirstChildWhichIsA("Humanoid")

   if not hum then
      hum = char:WaitForChild("Humanoid", 5)
   end

   if hum and hum:IsDescendantOf(workspace) then
      return hum
   end

   return nil
end
wait(0.1)
getgenv().getHuman = getHum

function getRoot(char)
   rootPart = char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('Torso') or char:FindFirstChild('UpperTorso')
   return rootPart
end
wait(0.1)
getgenv().getRoot = getRoot
wait()
function findplr(args)
   local tbl = cmdp:GetPlayers()

   if args == "me" or args == cmdlp.Name or args == cmdlp.DisplayName or args == cmdlp then
      return 
   end

   if args == "random" then
      local validPlayers = {}
      for _, v in pairs(tbl) do
         if v ~= cmdlp then
            table.insert(validPlayers, v)
         end
      end
      return #validPlayers > 0 and validPlayers[math.random(1, #validPlayers)] or nil
   end

   if args == "new" then
      local vAges = {}
      for _, v in pairs(tbl) do
         if v.AccountAge < 30 and v ~= cmdlp then
            table.insert(vAges, v)
         end
      end
      return #vAges > 0 and vAges[math.random(1, #vAges)] or nil
   end

   if args == "old" then
      local vAges = {}
      for _, v in pairs(tbl) do
         if v.AccountAge > 30 and v ~= cmdlp then
            table.insert(vAges, v)
         end
      end
      return #vAges > 0 and vAges[math.random(1, #vAges)] or nil
   end

   if args == "bacon" then
      local vAges = {}
      for _, v in pairs(tbl) do
         if v ~= cmdlp and v.Character and (v.Character:FindFirstChild("Pal Hair") or v.Character:FindFirstChild("Kate Hair")) then
            table.insert(vAges, v)
         end
      end
      return #vAges > 0 and vAges[math.random(1, #vAges)] or nil
   end

   if args == "friend" then
      local friendList = {}
      for _, v in pairs(tbl) do
         if v:IsFriendsWith(cmdlp.UserId) and v ~= cmdlp then
            table.insert(friendList, v)
         end
      end
      return #friendList > 0 and friendList[math.random(1, #friendList)] or nil
   end

   if args == "notfriend" then
      local vAges = {}
      for _, v in pairs(tbl) do
         if not v:IsFriendsWith(cmdlp.UserId) and v ~= cmdlp then
            table.insert(vAges, v)
         end
      end
      return #vAges > 0 and vAges[math.random(1, #vAges)] or nil
   end

   if args == "ally" then
      local vAges = {}
      for _, v in pairs(tbl) do
         if v.Team == cmdlp.Team and v ~= cmdlp then
            table.insert(vAges, v)
         end
      end
      return #vAges > 0 and vAges[math.random(1, #vAges)] or nil
   end

   if args == "enemy" then
      local vAges = {}
      for _, v in pairs(tbl) do
         if v.Team ~= cmdlp.Team and v ~= cmdlp then
            table.insert(vAges, v)
         end
      end
      return #vAges > 0 and vAges[math.random(1, #vAges)] or nil
   end

   if args == "near" then
      local vAges = {}
      for _, v in pairs(tbl) do
         if v ~= cmdlp and v.Character and cmdlp.Character then
            local vRootPart = getgenv().getRoot(v.Character)
            local cmdlpRootPart = getgenv().getRoot(cmdlp.Character)
            if vRootPart and cmdlpRootPart then
               local distance = (vRootPart.Position - cmdlpRootPart.Position).magnitude
               if distance < 30 then
                  table.insert(vAges, v)
               end
            end
         end
      end
      return #vAges > 0 and vAges[math.random(1, #vAges)] or nil
   end

   if args == "far" then
      local vAges = {}
      for _, v in pairs(tbl) do
         if v ~= cmdlp and v.Character and cmdlp.Character then
            local vRootPart = getgenv().getRoot(v.Character)
            local cmdlpRootPart = getgenv().getRoot(cmdlp.Character)
            if vRootPart and cmdlpRootPart then
               local distance = (vRootPart.Position - cmdlpRootPart.Position).magnitude
               if distance > 30 then
                  table.insert(vAges, v)
               end
            end
         end
      end
      return #vAges > 0 and vAges[math.random(1, #vAges)] or nil
   end

   if typeof(args) ~= "string" or args == "" then
      return nil
   end

   for _, v in pairs(tbl) do
      if v ~= cmdlp then
         local name, display = v.Name:lower(), v.DisplayName:lower()
         if name:find(args:lower()) or display:find(args:lower()) then
            return v
         end
      end
   end
end
wait(0.1)
getgenv().findplr = findplr

getgenv().randomString = function()
   local length = math.random(10,20)
   local array = {}
   for i = 1, length do
      array[i] = string.char(math.random(32, 126))
   end
   return table.concat(array)
end

getgenv().warn_executor = function()
   local function retrieve_executor()
      local name
      if identifyexecutor then
         name = identifyexecutor()
      end
      return { Name = name or "Unknown Executor"}
   end

   local function identify_executor()
      local executorDetails = retrieve_executor()
      return string.format("%s", executorDetails.Name)
   end
   wait(0.1)
   local executor_string = identify_executor()

   return warn(executor_string)
end

getgenv().print_executor = function()
   local function retrieve_executor()
      local name
      if identifyexecutor then
         name = identifyexecutor()
      end
      return { Name = name or "Unknown Executor"}
   end

   local function identify_executor()
      local executorDetails = retrieve_executor()
      return string.format("%s", executorDetails.Name)
   end
   wait(0.1)
   local executor_string = identify_executor()

   return print(executor_string)
end

local function Get_Char(Player)
   if not Player or not Player.Character then
      local Char = nil
      local conn
      conn = Player.CharacterAdded:Connect(function(c)
         Char = c
      end)

      repeat task.wait() until Char or not Player.Parent
      if conn then conn:Disconnect() end
      return Char
   end
   return Player.Character
end

wait(0.1)
getgenv().Terrain = getgenv().Workspace.Terrain or getgenv().Workspace:FindFirstChild("Terrain")
getgenv().Camera = getgenv().Workspace.CurrentCamera
getgenv().LocalPlayer = getgenv().Players.LocalPlayer
getgenv().Backpack = getgenv().LocalPlayer:WaitForChild("Backpack") or getgenv().LocalPlayer:FindFirstChild("Backpack") or getgenv().LocalPlayer:FindFirstChildOfClass("Backpack") or getgenv().LocalPlayer:FindFirstChildWhichIsA("Backpack")
getgenv().PlayerGui = getgenv().LocalPlayer:WaitForChild("PlayerGui") or getgenv().LocalPlayer:FindFirstChild("PlayerGui") or getgenv().LocalPlayer:FindFirstChildOfClass("PlayerGui") or getgenv().LocalPlayer:FindFirstChildWhichIsA("PlayerGui")
getgenv().PlayerScripts = getgenv().LocalPlayer:WaitForChild("PlayerScripts") or getgenv().LocalPlayer:FindFirstChild("PlayerScripts")
getgenv().Character = Get_Char(getgenv().LocalPlayer) or getgenv().LocalPlayer.Character or getgenv().LocalPlayer.CharacterAdded:Wait()
wait(0.1)

local function Get_Char(Player)
   if not Player or not Player.Character then
      local Char = nil
      local conn
      conn = Player.CharacterAdded:Connect(function(c)
         Char = c
      end)

      repeat task.wait() until Char or not Player.Parent
      if conn then conn:Disconnect() end
      return Char
   end
   return Player.Character
end

local function SafeGetHumanoid(char)
	local hum = char:FindFirstChildWhichIsA("Humanoid")

	if hum and hum:IsA("Humanoid") then
		return hum
	else
		return char:WaitForChild("Humanoid", 5)
	end
end

local function SafeGetHead(char)
	local head = char:FindFirstChild("Head")
	if head and head:IsA("BasePart") then
		return head
	else
		return char:WaitForChild("Head", 5)
	end
end

local function SafeGetHRP(char)
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if hrp and hrp:IsA("BasePart") then
		return hrp
	else
		return char:WaitForChild("HumanoidRootPart", 5)
	end
end

if not getgenv().Anti_Idle_Controller_Loaded then
   if getconnections or get_signal_cons then
      getgenv().notify("Info", "Loading Anti-Idle controller...", 5)
      local GC = getconnections or get_signal_cons

      getgenv().Anti_Idle_Controller_Loaded = true
      getgenv().LocalPlayer.Idled:Connect(function()
         wait(2.5)
         for i,v in pairs(GC(getgenv().LocalPlayer.Idled)) do
            if v["Disable"] then
               v["Disable"](v)
            elseif v["Disconnect"] then
               v["Disconnect"](v)
            end
         end
      end)
    else
        getgenv().Anti_Idle_Controller_Loaded = true
   end
end

if not getgenv().Character then
    getgenv().Character = Get_Char(getgenv().LocalPlayer)
end
getgenv().HumanoidRootPart = SafeGetHRP(getgenv().Character)
getgenv().Humanoid = SafeGetHumanoid(getgenv().Character)
getgenv().Head = SafeGetHead(getgenv().Character)
wait(0.3)
local function Dynamic_Character_Updater(character)
	getgenv().Character = character or Get_Char(getgenv().LocalPlayer)
	wait(0.4)
   if getgenv().Character and getgenv().Character:FindFirstChild("Humanoid") then
      getgenv().HumanoidRootPart = SafeGetHRP(character)
      getgenv().Humanoid = SafeGetHumanoid(character)
      getgenv().Head = SafeGetHead(character)
   elseif not getgenv().Character then
      repeat task.wait() until character and character:FindFirstChild("Humanoid")
      getgenv().Character = character
   end
end

Dynamic_Character_Updater(getgenv().Character)
task.wait(0.2)
getgenv().LocalPlayer.CharacterAdded:Connect(function(newCharacter)
	task.wait(0.2)
	Dynamic_Character_Updater(newCharacter)
	repeat wait() until newCharacter:FindFirstChildWhichIsA("Humanoid") and newCharacter:FindFirstChild("HumanoidRootPart")
	wait(0.4)
    getgenv().Character = newCharacter or Get_Char(getgenv().LocalPlayer)
    wait(0.2)
	getgenv().HumanoidRootPart = SafeGetHRP(newCharacter or getgenv().Character)
	getgenv().Humanoid = SafeGetHumanoid(newCharacter or getgenv().Character)
	getgenv().Head = SafeGetHead(newCharacter or getgenv().Character)
	wait(0.2)
	Dynamic_Character_Updater(newCharacter or getgenv().Character)
end)
