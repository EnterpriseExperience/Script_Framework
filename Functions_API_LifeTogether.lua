if not getgenv().Game then
   getgenv().Game = cloneref and cloneref(game) or game
end

local RunTime_Functions_API = {}

local TextChatService = cloneref and cloneref(getgenv().Game:GetService("TextChatService")) or getgenv().Game:GetService("TextChatService")
wait(0.3)

local function isProperty(inst, prop)
	local s, r = pcall(function() return inst[prop] end)
	if not s then return nil end
	return r
end
wait(0.1)
getgenv().isProperty = isProperty

local function hasProp(inst, prop)
   return inst and isProperty(inst, prop) ~= nil
end

local function setProperty(inst, prop, v)
	local s, _ = pcall(function() inst[prop] = v end)
	return s
end

local function safeSet(inst, prop, val)
   if inst and hasProp(inst, prop) then setProperty(inst, prop, val) end
end
wait(0.1)
function toggle_chat_tabs(toggle)
   local Tabs = getgenv().TextChatService:FindFirstChildOfClass("ChannelTabsConfiguration")
   wait(0.1)
   if toggle == true then
      if Tabs then
         safeSet(Tabs, "Enabled", true)
      end
   elseif toggle == false then
      if Tabs then
         safeSet(Tabs, "Enabled", false)
      end
   else
      return 
   end
end
wait(0.1)
toggle_chat_tabs(true)

local function decodeHTMLEntities(str)
   return str:gsub("&gt;", ">")
            :gsub("&lt;", "<")
            :gsub("&amp;", "&")
            :gsub("&quot;", '"')
            :gsub("&#39;", "'")
end
wait(0.1)
getgenv().decodeHTMLEntities = decodeHTMLEntities

if getgenv().FireParticlesAdded then
   getgenv().notify("Warning", "Connection has already been loaded here.", 5)
else
   local folder = getgenv().StarterGui:FindFirstChild("FireTemporaryReparentFolder")
   if not folder then
      folder = Instance.new("Folder")
      folder.Name = "FireTemporaryReparentFolder"
      folder.Parent = getgenv().StarterGui
   end
   wait(0.1)
   getgenv().FireParticlesAdded = folder.ChildAdded:Connect(function(particle)
      particle:Destroy()
   end)
end
wait(0.2)
getgenv().SpamFire = false
getgenv().SpamFireLoop = nil
getgenv().DestroyFireConnection = nil
getgenv().HideFireConnection = nil
task.wait(0.1)
getgenv().CompletelyHideFlamesComingIn = function(toggle)
   if toggle == true then
      if getgenv().DestroyFireConnection then
         return 
      end
      wait()
      local function disableFire()
         for i, v in ipairs(workspace:GetChildren()) do
            if v:IsA("Model") and v.Name == "Fire" then
               local FireModel = v

               if FireModel:FindFirstChild("Fire") then
                  local FirePart = FireModel:FindFirstChildOfClass("Part")

                  if FirePart:FindFirstChildOfClass("ParticleEmitter") then
                     local FireParticles = FirePart:FindFirstChildOfClass("ParticleEmitter")
                     local Sound = FirePart:FindFirstChildOfClass("Sound")

                     FireParticles.Parent = getgenv().StarterGui:FindFirstChild("FireTemporaryReparentFolder")
                     Sound.Parent = getgenv().StarterGui:FindFirstChild("FireTemporaryReparentFolder")
                  end
               end
            end
         end
      end

      disableFire()

      getgenv().DestroyFireConnection = getgenv().Workspace.ChildAdded:Connect(function()
         disableFire()
      end)
   elseif toggle == false then
      if getgenv().DestroyFireConnection then
         getgenv().DestroyFireConnection:Disconnect()
         getgenv().DestroyFireConnection = nil
      end
      getgenv().SpamFire = false
   end
end

getgenv().spamming_flames = function(toggle)
   if toggle == true then
      if getgenv().SpamFire then
         return getgenv().notify and getgenv().notify("Error", "Flame spamming is already enabled! Disable it before trying it again.", 5)
      end

      getgenv().CompletelyHideFlamesComingIn(true)
      task.wait(0.2)
      getgenv().SpamFire = true

      if not getgenv().SpamFireLoop then
         getgenv().SpamFireLoop = task.spawn(function()
            while getgenv().SpamFire do
            task.wait(.1)
               pcall(function()
                  getgenv().Send("request_fire")
               end)
            end

            getgenv().SpamFireLoop = nil
         end)
      end
   elseif toggle == false then
      if not getgenv().SpamFire then
         return getgenv().notify("Error", "Flame spammer is not enabled!", 5)
      end

      getgenv().SpamFire = false
      getgenv().CompletelyHideFlamesComingIn(false)
      getgenv().SpamFire = false
   end
end

getgenv().fire_detection_amount = 50
getgenv().FireDetector_Enabled = false
getgenv().FireDetector_Conn = nil
local fire_triggered = false

if not getgenv().get_char then
   getgenv().get_char = function(Player)
      if not Player or typeof(Player) ~= "Instance" or not Player:IsA("Player") then
         getgenv().notify("Error", "That is not a Player, or Player entered isn't an actual player.", 5)
         return nil
      end

      local character = Player.Character
      local attempts = 0
      local max_attempts = 25

      while not character and attempts < max_attempts do
         task.wait(0.2)
         character = Player.Character
         attempts += 1
      end

      if not character then
         local ok, newChar = pcall(function()
            return Player.CharacterAdded:Wait()
         end)
         if ok and newChar then
            character = newChar
         end
      end

      if not character then
         getgenv().notify("Error", "Could not fetch Character for: "..tostring(Player or "???"), 6)
         return nil
      end

      return character
   end
end
wait(0.2)

local function get_human(Player)
   local character = getgenv().get_char(Player)
   if not character then
      return nil
   end

   local humanoid = character:FindFirstChildOfClass("Humanoid")
   local attempts = 0
   local max_attempts = 25

   while not humanoid and attempts < max_attempts do
      task.wait(0.2)
      humanoid = character:FindFirstChildOfClass("Humanoid")
      attempts += 1
   end

   if not humanoid then
      local ok, hum = pcall(function()
         return character:WaitForChild("Humanoid", 5)
      end)
      if ok and hum then
         humanoid = hum
      end
   end

   if not humanoid then
      return nil
   end

   return humanoid
end
wait(0.2)
local function get_animate_localscript(player)
   if not player then
      return nil
   end
   local character = getgenv().get_char(player)
   if not character then
      return nil
   end

   local animate = nil
   local attempts = 0
   local max_attempts = 30

   while not animate and attempts < max_attempts do
      for _, v in ipairs(character:GetDescendants()) do
         if v:IsA("LocalScript") and v.Name == "Animate" then
            animate = v
            break
         end
      end
      if not animate then
         task.wait(0.2)
         attempts += 1
      end
   end

   if not animate then
      local ok, found = pcall(function()
         return character:WaitForChild("Animate", 5)
      end)
      if ok and found then
         animate = found
      end
   end

   return animate
end

local function check_fire_count()
   if fire_triggered then return end
   local count = 0
   for _, obj in ipairs(getgenv().Workspace:GetChildren()) do
      if obj:IsA("Model") and obj.Name == "Fire" then
         count += 1
      end
   end
   if count >= getgenv().fire_detection_amount then
      fire_triggered = true
      getgenv().CompletelyHideFlamesComingIn(true)
   end
end

if not getgenv().EnableFireDetector then
   getgenv().EnableFireDetector = function()
      if getgenv().FireDetector_Enabled then return getgenv().notify("Warning", "Fire Spam detector is already enabled!", 5) end
      getgenv().FireDetector_Enabled = true
      check_fire_count()

      getgenv().FireDetector_Conn = getgenv().Workspace.ChildAdded:Connect(function(obj)
         if not getgenv().FireDetector_Enabled then return end
         if obj:IsA("Model") and obj.Name == "Fire" then
            check_fire_count()
         end
      end)
   end
end

if not getgenv().DisableFireDetector then
   getgenv().DisableFireDetector = function()
      if not getgenv().FireDetector_Enabled then return getgenv().notify("Warning", "Fire Spam detector is not enabled!", 5) end
      getgenv().FireDetector_Enabled = false
      if getgenv().FireDetector_Conn then
         getgenv().FireDetector_Conn:Disconnect()
         getgenv().FireDetector_Conn = nil
      end
   end
end
wait(0.2)
getgenv().EnableFireDetector()

local Players = getgenv().Players or cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")
local RunService = getgenv().RunService or cloneref and cloneref(game:GetService("RunService")) or game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
getgenv().AntiFling_Tracked = getgenv().AntiFling_Tracked or setmetatable({}, { __mode = "k" })
getgenv().AntiFling_Signals = getgenv().AntiFling_Signals or setmetatable({}, { __mode = "k" })
getgenv().AntiFling_Enabled = false
getgenv().AntiFling_SteppedConnection = getgenv().AntiFling_SteppedConnection or nil
getgenv().AntiFling_PlayerAddedConn = getgenv().AntiFling_PlayerAddedConn or nil
getgenv().AntiFling_PlayerRemovingConn = getgenv().AntiFling_PlayerRemovingConn or nil
local tracked = getgenv().AntiFling_Tracked
local signals = getgenv().AntiFling_Signals

if not getgenv().AntiFling_SafeSetCanCollide then
   getgenv().AntiFling_SafeSetCanCollide = function(part, value)
      if typeof(part) == "Instance" and part:IsA("BasePart") then
         pcall(function()
            if part.CanCollide ~= value then
               part.CanCollide = value
            end
         end)
      end
   end
end

if not getgenv().AntiFling_Apply then
   getgenv().AntiFling_Apply = function(part)
      if not (part and part:IsA("BasePart")) or tracked[part] then return end
      tracked[part] = true
      getgenv().AntiFling_SafeSetCanCollide(part, false)

      signals[part] = part:GetPropertyChangedSignal("CanCollide"):Connect(function()
         if part and part.Parent and part.CanCollide ~= false then
            getgenv().AntiFling_SafeSetCanCollide(part, false)
         end
      end)
   end
end

if not getgenv().AntiFling_ProtectCharacter then
   getgenv().AntiFling_ProtectCharacter = function(char)
      if not char then return end

      for _, inst in ipairs(char:GetDescendants()) do
         if inst:IsA("BasePart") then
            getgenv().AntiFling_Apply(inst)
         end
      end

      char.DescendantAdded:Connect(function(inst)
         if inst:IsA("BasePart") then
            getgenv().AntiFling_Apply(inst)
         end
      end)

      char.DescendantRemoving:Connect(function(inst)
         if tracked[inst] then
            if signals[inst] then
               signals[inst]:Disconnect()
               signals[inst] = nil
            end
            tracked[inst] = nil
         end
      end)
   end
end

if not getgenv().AntiFling_HookPlayer then
   getgenv().AntiFling_HookPlayer = function(plr)
      if plr == LocalPlayer then return end
      if plr.Character then
         getgenv().AntiFling_ProtectCharacter(plr.Character)
      end
      plr.CharacterAdded:Connect(getgenv().AntiFling_ProtectCharacter)
   end
end

if not getgenv().EnableAntiFling then
   getgenv().EnableAntiFling = function()
      if getgenv().AntiFling_Enabled then
         return getgenv().notify("Error", "Anti Fling is already enabled!", 5)
      end
      getgenv().AntiFling_Enabled = true

      for _, plr in ipairs(Players:GetPlayers()) do
         getgenv().AntiFling_HookPlayer(plr)
      end

      if not getgenv().AntiFling_PlayerAddedConn then
         getgenv().AntiFling_PlayerAddedConn = Players.PlayerAdded:Connect(getgenv().AntiFling_HookPlayer)
      end
      if not getgenv().AntiFling_PlayerRemovingConn then
         getgenv().AntiFling_PlayerRemovingConn = Players.PlayerRemoving:Connect(function(plr)
            if plr == LocalPlayer then return end
            local char = plr.Character
            if not char then return end

            for _, part in ipairs(char:GetDescendants()) do
               if tracked[part] then
                  if signals[part] then
                     signals[part]:Disconnect()
                     signals[part] = nil
                  end
                  tracked[part] = nil
               end
            end
         end)
      end

      if not getgenv().AntiFling_SteppedConnection then
         getgenv().AntiFling_SteppedConnection = RunService.Stepped:Connect(function()
            for part in pairs(tracked) do
               if typeof(part) == "Instance" and part:IsA("BasePart") and part.Parent then
                  if part.CanCollide ~= false then
                     getgenv().AntiFling_SafeSetCanCollide(part, false)
                  end
               end
            end
         end)
      end

      getgenv().notify("Success", "Anti Fling has been enabled.", 5)
   end
end

getgenv().Noclip_Enabled = getgenv().Noclip_Enabled or false
getgenv().Noclip_Connection = getgenv().Noclip_Connection or nil
local RunService = getgenv().RunService or game:GetService("RunService")

if not getgenv().ToggleNoclip then
   getgenv().ToggleNoclip = function(toggle)
      if toggle == true then
         if getgenv().Noclip_Enabled then
            return getgenv().notify("Error", "Noclip is already enabled!", 5)
         end
         if getgenv().Noclip_Connection then
            return getgenv().notify("Warning", "Noclip connection is active, disable Noclip and try again.", 6)
         end

         local function NoclipLoop()
            if getgenv().Character then
               for _, part in ipairs(getgenv().Character:GetDescendants()) do
                  if part:IsA("BasePart") and part.CanCollide then
                     part.CanCollide = false
                  end
               end
            end
         end

         if not getgenv().Noclip_Connection then
            getgenv().Noclip_Connection = RunService.Stepped:Connect(NoclipLoop)
         end
         getgenv().Noclip_Enabled = true
         getgenv().notify("Success", "Noclip has been enabled.", 5)
      elseif toggle == false then
         if not getgenv().Noclip_Enabled then
            return getgenv().notify("Error", "Noclip not enabled!", 5)
         end
         if getgenv().Noclip_Connection then
            getgenv().Noclip_Connection:Disconnect()
            getgenv().Noclip_Connection = nil
         end

         for _, part in pairs(getgenv().Character:GetDescendants()) do
            if part and part:IsA("BasePart") then
               part.CanCollide = true
            end
         end
         getgenv().Noclip_Enabled = false
         getgenv().notify("Success", "Noclip has been disabled.", 5)
      else
         return getgenv().notify("Error", "Invalid arg, expected true/false", 5)
      end
   end
end

if not getgenv().Toggleable_Noclip then
   getgenv().Toggleable_Noclip = ToggleNoclip
end

if not getgenv().DisableAntiFling then
   getgenv().DisableAntiFling = function()
      if not getgenv().AntiFling_Enabled then
         return getgenv().notify("Error", "Anti Fling is not enabled!", 5)
      end
      getgenv().AntiFling_Enabled = false

      if getgenv().AntiFling_SteppedConnection then
         getgenv().AntiFling_SteppedConnection:Disconnect()
         getgenv().AntiFling_SteppedConnection = nil
      end
      if getgenv().AntiFling_PlayerAddedConn then
         getgenv().AntiFling_PlayerAddedConn:Disconnect()
         getgenv().AntiFling_PlayerAddedConn = nil
      end
      if getgenv().AntiFling_PlayerRemovingConn then
         getgenv().AntiFling_PlayerRemovingConn:Disconnect()
         getgenv().AntiFling_PlayerRemovingConn = nil
      end

      for part, conn in pairs(signals) do
         if conn.Disconnect then
            pcall(conn.Disconnect, conn)
         end
      end

      table.clear(signals)
      table.clear(tracked)

      getgenv().notify("Success", "Anti Fling has been disabled.", 5)
   end
end

if not getgenv().Toggle_AntiFling_Boolean_Func then
   getgenv().Toggle_AntiFling_Boolean_Func = function(toggled)
      if toggled == true then
         getgenv().EnableAntiFling()
      elseif toggled == false then
         getgenv().DisableAntiFling()
      else
         return getgenv().notify("Warning", "[Invalid arguments]: Expected true/false brocaroni and cheese.", 5)
      end
   end
end

function anti_sit_func(toggle)
   local is_enabled = getgenv().Seat.enabled.get()
   
   if toggle == true then
      if is_enabled then
         show_notification("Failure:", "AntiSit is already enabled!", "Warning")
         return getgenv().notify("Error", "AntiSit is already enabled!", 5)
      end
      if getgenv().Not_Ever_Sitting then
         return getgenv().notify("Warning", "AntiSit is already enabled!", 5)
      end

      getgenv().notify("Success", "Anti-Sit is now enabled!", 5)
      show_notification("Success:", "Anti-Sit is now enabled!", "Normal")
      wait(0.2)
      getgenv().Not_Ever_Sitting = true

      while getgenv().Not_Ever_Sitting == true do
      task.wait()
         getgenv().Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
         getgenv().Seat.enabled.set(false)
      end
   elseif toggle == false then
      if not is_enabled then
         show_notification("Failure:", "AntiSit is not enabled!", "Warning")
         return notify("Error", "AntiSit is not enabled!", 5)
      end
      if not getgenv().Not_Ever_Sitting then
         return getgenv().notify("Warning", "AntiSit is not enabled!", 5)
      end

      getgenv().Not_Ever_Sitting = false
      wait(0.2)
      getgenv().Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
      getgenv().Seat.enabled.set(true)
      wait(0.1)
      getgenv().notify("Success", "Sitting is now enabled!", 5)
      Phone.show_notification("Success:", "Sitting is now enabled!", "Normal")
   end
end
wait(0.1)
if not getgenv().anti_sit_func then
   getgenv().anti_sit_func = anti_sit_func
end

function anti_void(toggle)
   if toggle == true then
      if not getgenv().originalFPDH then
         getgenv().originalFPDH = getgenv().Workspace.FallenPartsDestroyHeight
      end
      if getgenv().Anti_Void_Enabled_Bool then
         return getgenv().notify("Warning", "Anti-Void is already enabled!", 5)
      end

      getgenv().Workspace.FallenPartsDestroyHeight = -9e9
      getgenv().notify("Success", "Enabled anti-void.", 5)
      getgenv().Anti_Void_Enabled_Bool = true
   elseif toggle == false then
      if not getgenv().originalFPDH then
         getgenv().originalFPDH = -500
         return getgenv().notify("Error", "Original destroy height doesn't exist!", 5)
      end
      if not getgenv().Anti_Void_Enabled_Bool then
         return getgenv().notify("Warning", "Anti-Void has not been enabled!", 5)
      end

      getgenv().Workspace.FallenPartsDestroyHeight = getgenv().originalFPDH or -500
      getgenv().notify("Success", "Disabled anti-void.", 5)
   else
      return 
   end
end
wait(0.1)
if not getgenv().anti_void then
   getgenv().anti_void = anti_void
end

getgenv().VehicleDestroyer_Enabled = getgenv().VehicleDestroyer_Enabled or false
if not getgenv().VehicleDestroyer_Connections then
   getgenv().VehicleDestroyer_Connections = getgenv().VehicleDestroyer_Connections or {}
end

local function clearConnections()
	for _, conn in ipairs(getgenv().VehicleDestroyer_Connections) do
		if typeof(conn) == "RBXScriptConnection" then
			pcall(function() conn:Disconnect() end)
		end
	end
	table.clear(getgenv().VehicleDestroyer_Connections)

	local extra_conns = {
		"folderAddedConn",
		"vehiclesChildAddedConn",
		"vehiclesHeartBeatConnection"
	}

	for _, name in ipairs(extra_conns) do
		local conn = getgenv()[name]
		if typeof(conn) == "RBXScriptConnection" then
			pcall(function() conn:Disconnect() end)
		end
		getgenv()[name] = nil
	end
end

local function is_in_vehicle(obj, vehicle)
	if not vehicle then return false end
	return obj:IsDescendantOf(vehicle)
end

local function disableCollisionIn(folder)
	local my_vehicle = get_vehicle and get_vehicle()
	for _, obj in ipairs(folder:GetDescendants()) do
		if obj:IsA("BasePart") and obj.CanCollide and not is_in_vehicle(obj, my_vehicle) then
			obj.CanCollide = false
		end
	end
end

local function setupFolder(folder)
	disableCollisionIn(folder)
	getgenv().notify("Success", "Anti Vehicle Fling has been enabled.", 5)

   if not getgenv().vehiclesChildAddedConn then
      getgenv().vehiclesChildAddedConn = folder.ChildAdded:Connect(function(child)
         if not getgenv().VehicleDestroyer_Enabled then return end

         local my_vehicle = get_vehicle and get_vehicle()
         if is_in_vehicle(child, my_vehicle) then return end

         if child:IsA("BasePart") then
            child.CanCollide = false
         elseif child:IsA("Model") then
            child.DescendantAdded:Connect(function(desc)
               if desc:IsA("BasePart") and not is_in_vehicle(desc, my_vehicle) then
                  desc.CanCollide = false
               end
            end)
            disableCollisionIn(child)
         end
      end)
      table.insert(getgenv().VehicleDestroyer_Connections, getgenv().vehiclesChildAddedConn)
   end
end

if not getgenv().DisableVehicleDestroyer then
   getgenv().DisableVehicleDestroyer = function()
      if not getgenv().VehicleDestroyer_Enabled then
         return getgenv().notify("Warning", "Anti Vehicle Fling is not enabled!", 5)
      end
      wait(0.1)
      getgenv().VehicleDestroyer_Enabled = false
      clearConnections()
   end
end

function anti_car_fling(toggle)
	if toggle == true then
		if getgenv().VehicleDestroyer_Enabled then
			return getgenv().notify("Warning", "Anti Vehicle Fling is already enabled!", 5)
		end
		wait(0.1)
		getgenv().VehicleDestroyer_Enabled = true
		clearConnections()

		local vehiclesFolder = getgenv().Workspace:FindFirstChild("Vehicles") or getgenv().Workspace:WaitForChild("Vehicles", 5)
		if vehiclesFolder then
			setupFolder(vehiclesFolder)
		end

      if not getgenv().folderAddedConn then
         getgenv().folderAddedConn = getgenv().Workspace.ChildAdded:Connect(function(child)
            if child.Name == "Vehicles" and child:IsA("Folder") then
               setupFolder(child)
               vehiclesFolder = child
            end
         end)
         table.insert(getgenv().VehicleDestroyer_Connections, getgenv().folderAddedConn)
      end

      if not getgenv().vehiclesHeartBeatConnection then
         getgenv().vehiclesHeartBeatConnection = getgenv().RunService.Heartbeat:Connect(function()
            if not getgenv().VehicleDestroyer_Enabled then return end
            if vehiclesFolder and vehiclesFolder.Parent then
               disableCollisionIn(vehiclesFolder)
            else
               vehiclesFolder = getgenv().Workspace:FindFirstChild("Vehicles")
            end
         end)
         table.insert(getgenv().VehicleDestroyer_Connections, getgenv().vehiclesHeartBeatConnection)
      end
	elseif toggle == false then
		getgenv().DisableVehicleDestroyer()
		getgenv().notify("Success", "Anti Vehicle Fling has been disabled.", 5)
	else
		return
	end
end
wait(0.1)
if not getgenv().anti_car_fling then
   getgenv().anti_car_fling = anti_car_fling
end

getgenv().HD_FlyEnabled = false
local FlyConnection
local speed = 75
local FlyKeysDown = {}

function DisableFlyScript()
   if not getgenv().HD_FlyEnabled then
      return getgenv().notify("Warning", "Fly is not enabled!", 5)
   end

   getgenv().HD_FlyEnabled = false

   if FlyConnection then
      FlyConnection:Disconnect()
      FlyConnection = nil
   end

   if getgenv().PlayerGui:FindFirstChild("FlyControls") then
      getgenv().PlayerGui:FindFirstChild("FlyControls"):Destroy()
   end

   local hrp = getgenv().HumanoidRootPart
   if hrp:FindFirstChild("ExecutorFlyGyro") then
      hrp.ExecutorFlyGyro:Destroy()
   end
   if hrp:FindFirstChild("ExecutorFlyPosition") then
      hrp.ExecutorFlyPosition:Destroy()
   end

   if getgenv().Character:FindFirstChildWhichIsA("Humanoid") and getgenv().Humanoid then
      getgenv().Humanoid.PlatformStand = false
   end
end

local Emotes = {
   griddy = {
      129149402922241,
      116150478424136,
      91878676494639,
      98318847394332,
   },
   scenario = {110013053670989},
   worm = {
      132950274861655,
      127882676467351,
      77625642316480,
      127068135887882,
      102075861555461,
   },
   zen = {84943987730610},
   glitching = {131961970776128},
   superman = {
      134861929761233,
      93202303625509,
      75684443936987,
      71498318840551,

   },
   aura = {
      121547391421211,
      78755795767408,
      88425531063616,
      111426928948833,
      111499780397123,
      88553023837929,
      120398163328092,
      95412133796590,
      132887675877488,
      95483853291380,
      70921452128720,
      86617727183442,
      135502214162191,
      124656572577172,
      107282826166809,
      107357050902519,
      83771892938118,
      84052327668385,
      124573843932871,
      83502723504906,
      77605999050017,
      116826272832592, -- like flippin sexy
      116520353469867,
      103040723950430,
      111474274315212,
      85452015445985,
	   124094170750791,
	   110511723808460,
      106383862917130,
      119895570354822,
      89740608652762,
      138488768673643,
      110077386833639,
      85092320680319,
      89841968488285,
      110559530726888,
      133016747050476,
      108635834286627,
   },
   orangejustice = {
      133160900449608,
      110064349530772,
      117638432093760,
      76494145762351,
      84419755287539,
      98578127060782,
   },
   default = {
      80877772569772,
      99818263438846,
      121094705979021,
      128801735413980,
      83559276301867,
      100099256371667,
   },
   koto = {
      91927498467600,
      130655908439646,
      108129969514208,
      121962822800440,
      105003458897417,
   },
   popular = {
      71302743123422,
      100531085354441,
      113815442881930,
      115719203985051,
      77201116105359,
   },
   billybounce = {
      126516908191316,
      93450937830334,
      131013364061967,
   },
   billyjean = {
      98915045016286
   },
   michaelmyers = {
      103115491327846,
      99068367180942,
      135204931182370,
      84555531182471,
      123102740029981,
      126102210823846,
      78250036534439,
      101439065941822,
   },
   sturdy = {
      122687759897103,
      133826541787717,
      85608190427964,
   },
   louisiana_jigg = {
      75625820126017,
   },
   takethel = {
      112884830175040,
      73593666217037,
      120292213172333,
      133545170540942,
      107451871815376,
      82405492529515,
      71490439912804,
      113855231967763
   },
   electroshuffle = {
      102699471013529,
      96426537876059,
      140499299581464,
   },
   laughitup = {
      139879794862714,
      90599528248903,
   },
   reanimated = {
      88624941199927,
      112989413190899,
   },
   jabba = {
      103538719480738,
      81074563419184,
      116936259925650,
      91111622942605,
      97502008524120,
      78000690242935,
      97263887198327,
      126450121068943,
   },
   freaky = {
      71014156366577, -- a fucking bang Emote on Roblox, we're cooked bro, I'm telling you.
      135404588651407,
   },
   motion = {
      116986761294290,
   }
}
wait(0.1)
if not getgenv().Emotes then
   getgenv().Emotes = Emotes
end

local Aliases = {
   ["orange justice"] = "orangejustice",
   ["orange_justice"] = "orangejustice",
   ["orangej"] = "orangejustice",
   ["default dance"] = "default",
   ["defaultdance"] = "default",
   ["kotonai"] = "koto",
   ["pop"] = "popular",
   ["glitch"] = "glitching",
   ["buggingout"] = "glitching",
   ["glitchingout"] = "glitching",
   ["glitched"] = "glitching",
   ["vibrating"] = "glitching",
   ["shaking"] = "glitching",
   ["aurafarming"] = "aura",
   ["aurafloating"] = "aura",
   ["aurafloat"] = "aura",
   ["aurafarm"] = "aura",
   ["billyb"] = "billybounce",
   ["billybouncing"] = "billybounce",
   ["bbounce"] = "billybounce",
   ["michaelmyer"] = "michaelmyers",
   ["michaelbounce"] = "michaelmyers",
   ["nysturdy"] = "sturdy",
   ["newyorksturdy"] = "sturdy",
   ["jiggy"] = "louisiana_jigg",
   ["takel"] = "takethel",
   ["takeanl"] = "takethel",
   ["ldance"] = "takethel",
   ["elecshuffle"] = "electroshuffle",
   ["eshuffle"] = "electroshuffle",
   ["reanimate"] = "reanimated",
   ["donkeylaugh"] = "laughitup",
   ["laughing"] = "laughitup",
   ["fnlaugh"] = "laughitup",
   ["fortnitelaugh"] = "laughitup",
   ["sus"] = "freaky",
   ["bang"] = "freaky",
   ["suspicious"] = "freaky",
   ["weird"] = "freaky",
   ["hellamotion"] = "motion"
}
wait(0.1)
if not getgenv().Aliases then
   getgenv().Aliases = Aliases
end
wait(0.2)
function disable_emoting()
   local Humanoid = getgenv().Humanoid
   if not Humanoid then return getgenv().notify("Error", "Humanoid not found, try resetting.", 5) end

   Humanoid.WalkSpeed = 0
   task.wait(1.1)
   pcall(function()
      for _, v in ipairs(Humanoid:GetPlayingAnimationTracks()) do
         v:Stop()
      end
   end)

   task.wait(0.3)

   local animate = get_animate_localscript(game.Players.LocalPlayer)
   if animate and animate.Disabled then
      animate.Disabled = false
   end

   task.wait(0.5)
   Humanoid.WalkSpeed = 16
   if getgenv().Is_Currently_Emoting then
      getgenv().Is_Currently_Emoting = false
   end
end
wait(0.1)
if not getgenv().disable_emoting_script then
   getgenv().disable_emoting_script = disable_emoting
end

wait(0.1)
local lastEmoteTime = 0
wait()
function do_emote(input)
   if tick() - lastEmoteTime < 2 then
      return getgenv().notify("Warning", "Hold On! Emoting is on cooldown, wait a second (literally).", 5)
   end
   lastEmoteTime = tick()

   local Humanoid = getgenv().Humanoid
   if not Humanoid then
      disable_emoting()
      return getgenv().notify("Error", "Humanoid doesn't exist? (Try resetting)", 5)
   end

   local key = input:lower():gsub("%s+", "")
   if Aliases[key] then key = Aliases[key] end

   if getgenv().Is_Currently_Emoting then
      disable_emoting()
   end
   wait(0.3)
   local emoteList = Emotes[key]
   if emoteList then
      getgenv().Is_Currently_Emoting = true
      local choice = emoteList[math.random(1, #emoteList)]
      if not getgenv().Character:FindFirstChild("Animate") then
         getgenv().Is_Currently_Emoting = false
         return getgenv().notify("Error", "Something unexpected happened while trying to emote, try again.", 5)
      end
      if getgenv().Character:FindFirstChild("Animate").Disabled then
         getgenv().notify("Warning", "For some reason, the Animate LocalScript was still disabled, we enabled it (will disable in a second).", 10)
         getgenv().Character:WaitForChild("Animate").Disabled = false
      end
      local ok, track = Humanoid:PlayEmoteAndGetAnimTrackById(choice)
      wait(.1)
      for _, v in ipairs(getgenv().Humanoid:GetPlayingAnimationTracks(getgenv().Humanoid)) do
         v.Looped = true
      end
      local animate = getgenv().Character:FindFirstChild("Animate", true) or getgenv().Character:WaitForChild("Animate", 5)
      if animate then
         animate.Disabled = true
      end

      if ok and track then
         -- [[ Some emotes don't like to loop, so let's force that. ]] --
         for _, v in ipairs(getgenv().Humanoid:GetPlayingAnimationTracks(getgenv().Humanoid)) do
            v.Looped = true
         end
         task.spawn(function()
            local conn
            conn = track.Stopped:Connect(function()
               if conn then conn:Disconnect() end
               if getgenv().Character and getgenv().Character:FindFirstChild("Animate") then
                  local animate = getgenv().Character:WaitForChild("Animate", 3)
                  if animate.Disabled then
                     animate.Disabled = false
                  end
               end
               getgenv().Is_Currently_Emoting = false
            end)
         end)
      else
         if animate and animate.Parent then
            if animate.Disabled then
               getgenv().Character:WaitForChild("Animate", 10).Disabled = false
            end
         end
         getgenv().Is_Currently_Emoting = false
      end
   end
end
wait(0.1)
getgenv().do_emote = do_emote
