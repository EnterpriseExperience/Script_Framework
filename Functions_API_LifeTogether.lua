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
         getgenv().DestroyFireConnection:Disconnect()
         getgenv().DestroyFireConnection = nil
      end
      task.wait()
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
               task.wait(.2)
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

local function check_fire_count()
   local count = 0
   for _, obj in ipairs(getgenv().Workspace:GetChildren()) do
      if obj:IsA("Model") and obj.Name == "Fire" then
         count += 1
      end
   end
   if count >= getgenv().fire_detection_amount then
      getgenv().CompletelyHideFlamesComingIn(true)
      return getgenv().notify("Info", "Enabled auto-hide flames, flames limit threshold reached (50+ fires found (spam), you're welcome).", 10)
   end
end

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

getgenv().DisableFireDetector = function()
   if not getgenv().FireDetector_Enabled then return getgenv().notify("Warning", "Fire Spam detector is not enabled!", 5) end
   getgenv().FireDetector_Enabled = false
   if getgenv().FireDetector_Conn then
      getgenv().FireDetector_Conn:Disconnect()
      getgenv().FireDetector_Conn = nil
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

getgenv().AntiFling_SafeSetCanCollide = function(part, value)
   if typeof(part) == "Instance" and part:IsA("BasePart") then
      pcall(function()
         if part.CanCollide ~= value then
            part.CanCollide = value
         end
      end)
   end
end

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

getgenv().AntiFling_HookPlayer = function(plr)
   if plr == LocalPlayer then return end
   if plr.Character then
      getgenv().AntiFling_ProtectCharacter(plr.Character)
   end
   plr.CharacterAdded:Connect(getgenv().AntiFling_ProtectCharacter)
end

getgenv().EnableAntiFling = function()
   if getgenv().AntiFling_Enabled then
      return getgenv().notify("Error", "Anti Fling is already enabled!", 5)
   end
   getgenv().AntiFling_Enabled = true

   for _, plr in ipairs(Players:GetPlayers()) do
      getgenv().AntiFling_HookPlayer(plr)
   end

   getgenv().AntiFling_PlayerAddedConn = Players.PlayerAdded:Connect(getgenv().AntiFling_HookPlayer)
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

   getgenv().AntiFling_SteppedConnection = RunService.Stepped:Connect(function()
      for part in pairs(tracked) do
         if typeof(part) == "Instance" and part:IsA("BasePart") and part.Parent then
            if part.CanCollide ~= false then
               getgenv().AntiFling_SafeSetCanCollide(part, false)
            end
         end
      end
   end)

   getgenv().notify("Success", "Anti Fling has been enabled.", 5)
end

getgenv().Noclip_Enabled = getgenv().Noclip_Enabled or false
getgenv().Noclip_Connection = getgenv().Noclip_Connection or nil
local RunService = getgenv().RunService or game:GetService("RunService")

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

      getgenv().Noclip_Connection = RunService.Stepped:Connect(NoclipLoop)
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

getgenv().Toggleable_Noclip = ToggleNoclip

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

getgenv().Toggle_AntiFling_Boolean_Func = function(toggled)
   if toggled == true then
      getgenv().EnableAntiFling()
   elseif toggled == false then
      getgenv().DisableAntiFling()
   else
      return getgenv().notify("Warning", "[Invalid arguments]: Expected true/false brocaroni and cheese.", 5)
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
getgenv().anti_sit_func = anti_sit_func

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
getgenv().anti_void = anti_void

getgenv().VehicleDestroyer_Enabled = getgenv().VehicleDestroyer_Enabled or false
getgenv().VehicleDestroyer_Connections = getgenv().VehicleDestroyer_Connections or {}

local function clearConnections()
	for _, conn in ipairs(getgenv().VehicleDestroyer_Connections) do
		if typeof(conn) == "RBXScriptConnection" then
			pcall(function() conn:Disconnect() end)
		end
	end
	table.clear(getgenv().VehicleDestroyer_Connections)
	getgenv().folderAddedConn = nil
	getgenv().vehiclesChildAddedConn = nil
	getgenv().vehiclesHeartBeatConnection = nil
end

local function disableCollisionIn(folder)
	for _, obj in ipairs(folder:GetDescendants()) do
		if obj:IsA("BasePart") and obj.CanCollide then
			obj.CanCollide = false
		end
	end
end

local function setupFolder(folder)
   disableCollisionIn(folder)

   getgenv().notify("Success", "Anti Vehicle Fling has been enabled.", 5)
   getgenv().vehiclesChildAddedConn = folder.ChildAdded:Connect(function(child)
      if not getgenv().VehicleDestroyer_Enabled then return end

      if child:IsA("BasePart") then
         child.CanCollide = false
      elseif child:IsA("Model") then
         child.DescendantAdded:Connect(function(desc)
            if desc:IsA("BasePart") then
               desc.CanCollide = false
            end
         end)
         disableCollisionIn(child)
      end
   end)
   table.insert(getgenv().VehicleDestroyer_Connections, getgenv().vehiclesChildAddedConn)
end

getgenv().DisableVehicleDestroyer = function()
   if not getgenv().VehicleDestroyer_Enabled then
      return getgenv().notify("Warning", "Anti Vehicle Fling is not enabled!", 5)
   end
   wait(0.1)
   getgenv().VehicleDestroyer_Enabled = false
   clearConnections()
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

		getgenv().folderAddedConn = getgenv().Workspace.ChildAdded:Connect(function(child)
			if child.Name == "Vehicles" and child:IsA("Folder") then
				setupFolder(child)
				vehiclesFolder = child
			end
		end)
		table.insert(getgenv().VehicleDestroyer_Connections, getgenv().folderAddedConn)

		getgenv().vehiclesHeartBeatConnection = getgenv().RunService.Heartbeat:Connect(function()
			if not getgenv().VehicleDestroyer_Enabled then return end
			if vehiclesFolder and vehiclesFolder.Parent then
				disableCollisionIn(vehiclesFolder)
			else
				vehiclesFolder = getgenv().Workspace:FindFirstChild("Vehicles")
			end
		end)
		table.insert(getgenv().VehicleDestroyer_Connections, getgenv().vehiclesHeartBeatConnection)
	elseif toggle == false then
		getgenv().DisableVehicleDestroyer()
      getgenv().notify("Success", "Anti Vehicle Fling has been disabled.", 5)
   else
      return 
	end
end
wait(0.1)
getgenv().anti_car_fling = anti_car_fling

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

   if getgenv().Character:FindFirstChildWhichIsA("Humanoid") then
      getgenv().Humanoid.PlatformStand = false
   end
end
wait(0.1)
getgenv().DisableFlyScript = DisableFlyScript

function disable_emoting()
   local Humanoid = getgenv().Humanoid
   if not Humanoid then return end

   Humanoid.WalkSpeed = 0
   task.wait(1.1)
   pcall(function()
      for _, v in ipairs(Humanoid:GetPlayingAnimationTracks()) do
         v:Stop()
      end
   end)

   task.wait(0.3)

   local animate = getgenv().Character:FindFirstChild("Animate") or getgenv().Character:WaitForChild("Animate", 1)
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
getgenv().disable_emoting_script = disable_emoting

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
