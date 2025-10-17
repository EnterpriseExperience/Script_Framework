if not getgenv().Game then
    getgenv().Game = cloneref and cloneref(game) or game
end
getgenv().AllClipboards = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)
getgenv().httprequest_Init = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
get_http = getgenv().httprequest_Init or (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
getgenv().queueteleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
queueteleport = getgenv().queueteleport

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
