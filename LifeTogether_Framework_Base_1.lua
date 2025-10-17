local function get_vehicle()
   for i, v in pairs(getgenv().Workspace:FindFirstChild("Vehicles"):GetChildren()) do
      if v.owner.Value == getgenv().LocalPlayer then
         return v
      end
   end

   return nil
end
wait(0.1)
getgenv().get_vehicle = get_vehicle

function spawn_any_vehicle(Vehicle)
   getgenv().Get("spawn_vehicle", Vehicle)
end
wait(0.1)
getgenv().spawn_any_vehicle = spawn_any_vehicle

function change_vehicle_color(Color, Vehicle)
   send_remote("vehicle_color", Color, Vehicle)
end
wait(0.1)
getgenv().change_vehicle_color = change_vehicle_color

function sit_in_vehicle(Vehicle)
   if not Vehicle then return getgenv().notify("Error", "You do not have a Vehicle! spawn one.", 5) end

   getgenv().Get("sit", Vehicle)
   wait(0.1)
   if Vehicle:FindFirstChild("VehicleSeat") then
      Vehicle:FindFirstChild("VehicleSeat"):Sit(getgenv().Humanoid)
   else
      return getgenv().notify("Error", "Unable to sit in Vehicle, missing VehicleSeat!", 5)
   end
end
wait(0.1)
getgenv().sit_in_vehicle = sit_in_vehicle

function toggle_flash_priv_server_time(toggle)
   if toggle == true then
      getgenv().Send("time_toggle", true)
      task.wait(0.2)
      getgenv().ChangingTime_Fast_FE = true
      while getgenv().ChangingTime_Fast_FE == true do
      task.wait(0)
         getgenv().Send("change_time", 4.5)
         task.wait(0)
         getgenv().Send("change_time", 5.5)
         task.wait(0)
         getgenv().Send("change_time", 12)
         task.wait(0)
         getgenv().Send("change_time", 18.5)
         task.wait(0)
         getgenv().Send("change_time", 23)
      end
   elseif toggle == false then
      getgenv().ChangingTime_Fast_FE = false
      repeat task.wait() until getgenv().ChangingTime_Fast_FE == false
      getgenv().Send("time_toggle", false)
   end
end
wait(0.1)
getgenv().toggle_flash_priv_server_time = toggle_flash_priv_server_time

function create_void_part()
   if getgenv().Workspace:FindFirstChild("Void_Model_Script(KEEP)") then return end
   task.wait(0.1)
   local Kill_Model_Script = Instance.new("Model")
   Kill_Model_Script.Name = "Void_Model_Script(KEEP)"
   Kill_Model_Script.Parent = getgenv().Workspace
   task.wait(0.1)
   local Kill_Part = Instance.new("Part")
   Kill_Part.Name = "SCRIPT_VOIDPART_VOID"
   Kill_Part.Anchored = true
   Kill_Part.CanCollide = false
   Kill_Part.Size = Vector3.new(10, 10, 10)
   Kill_Part.CFrame = CFrame.new(9e9, 9e9, 9e9)
   Kill_Part.Parent = Kill_Model_Script
end

wait()
function create_kill_part()
   if getgenv().Workspace:FindFirstChild("Kill_Model_Script(KEEP)") then return end
   task.wait(0.1)
   local Kill_Model_Script = Instance.new("Model")
   Kill_Model_Script.Name = "Kill_Model_Script(KEEP)"
   Kill_Model_Script.Parent = getgenv().Workspace
   task.wait(0.1)
   local Kill_Part = Instance.new("Part")
   Kill_Part.Name = "SCRIPT_KILLPART_VOID"
   Kill_Part.Anchored = true
   Kill_Part.CanCollide = false
   Kill_Part.Size = Vector3.new(10, 10, 10)
   Kill_Part.CFrame = CFrame.new(0, -470, 0)
   Kill_Part.Parent = Kill_Model_Script
end
wait(0.1)
function vehicle_kill_player(TargetPlayer)
   if not TargetPlayer or not TargetPlayer.Character then return end
   local targetChar = TargetPlayer.Character
   local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
   if not targetHRP then return end

   local Old_CF = getgenv().Character:FindFirstChild("HumanoidRootPart").CFrame

   local voidPart = getgenv().Workspace:FindFirstChild("Kill_Model_Script(KEEP)")
   if not voidPart then create_kill_part() voidPart = getgenv().Workspace:FindFirstChild("Kill_Model_Script(KEEP)") end
   local voidCF = voidPart:FindFirstChild("SCRIPT_KILLPART_VOID") and voidPart:FindFirstChild("SCRIPT_KILLPART_VOID").CFrame
   if not voidCF then return end

   local MyPlayer = getgenv().LocalPlayer
   local MyChar = getgenv().Character or MyPlayer.Character
   local MyHumanoid = getgenv().Humanoid or MyChar:FindFirstChildWhichIsA("Humanoid")
   local MyBus = nil

   for _, v in ipairs(getgenv().Workspace.Vehicles:GetChildren()) do
      if v:IsA("Model") and v:FindFirstChild("owner") and v.owner.Value == MyPlayer then
         if v:FindFirstChild("VehicleSeat") then
            MyBus = v
            break
         end
      end
   end

   if not MyBus then return warn("No owned SchoolBus found") end
   local seat = MyBus:FindFirstChild("VehicleSeat")
   if seat and MyHumanoid then
      MyChar:PivotTo(seat.CFrame)
      task.wait(0.2)
      seat:Sit(MyHumanoid)
   end

   local maxTries = 40
   for i = 1, maxTries do
      local targetHumanoid = targetChar:FindFirstChildOfClass("Humanoid")
      local isSitting = targetHumanoid and targetHumanoid.Sit
      if isSitting then break end

      MyBus:PivotTo(targetHRP.CFrame + Vector3.new(0, 0.3, 0))
      task.wait(0.2)
   end
   wait(0.1)
   MyBus:PivotTo(voidCF)
   wait(0.4)
   local myHRP = getgenv().Character:FindFirstChild("HumanoidRootPart")
   if getgenv().Humanoid.Sit then
      getgenv().Humanoid:ChangeState(3)
      wait(0.1)
      myHRP.CFrame = Old_CF
      wait(0.5)
      if not get_vehicle() then return end

      spawn_any_vehicle(tostring(get_vehicle().Name))
   end
   if myHRP then
      myHRP.CFrame = Old_CF
      wait(0.5)
      if not get_vehicle() then return end

      spawn_any_vehicle(tostring(get_vehicle().Name))
   end
end

function vehicle_void_player(TargetPlayer)
   if not TargetPlayer or not TargetPlayer.Character then return end
   local targetChar = TargetPlayer.Character
   local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
   if not targetHRP then return end

   local Old_CF = getgenv().Character:FindFirstChild("HumanoidRootPart").CFrame

   local voidPart = getgenv().Workspace:FindFirstChild("Void_Model_Script(KEEP)")
   if not voidPart then create_kill_part() voidPart = getgenv().Workspace:FindFirstChild("Void_Model_Script(KEEP)") end
   local voidCF = voidPart:FindFirstChild("SCRIPT_VOIDPART_VOID") and voidPart:FindFirstChild("SCRIPT_VOIDPART_VOID").CFrame
   if not voidCF then return end

   local MyPlayer = getgenv().LocalPlayer
   local MyChar = getgenv().Character or MyPlayer.Character
   local MyHumanoid = getgenv().Humanoid or MyChar:FindFirstChildWhichIsA("Humanoid")
   local MyBus = nil

   for _, v in ipairs(getgenv().Workspace.Vehicles:GetChildren()) do
      if v:IsA("Model") and v:FindFirstChild("owner") and v.owner.Value == MyPlayer then
         if v:FindFirstChild("VehicleSeat") then
            MyBus = v
            break
         end
      end
   end

   if not MyBus then return warn("No owned SchoolBus found") end
   local seat = MyBus:FindFirstChild("VehicleSeat")
   if seat and MyHumanoid then
      MyChar:PivotTo(seat.CFrame)
      task.wait(0.2)
      seat:Sit(MyHumanoid)
   end

   local maxTries = 40
   for i = 1, maxTries do
      local targetHumanoid = targetChar:FindFirstChildOfClass("Humanoid")
      local isSitting = targetHumanoid and targetHumanoid.Sit
      if isSitting then break end

      MyBus:PivotTo(targetHRP.CFrame + Vector3.new(0, 0.1, 0))
      task.wait(0.2)
   end
   wait(0.1)
   MyBus:PivotTo(voidCF)
   wait(0.4)
   local myHRP = getgenv().Character:FindFirstChild("HumanoidRootPart")
   if getgenv().Humanoid.Sit then
      getgenv().Humanoid:ChangeState(3)
      wait(0.1)
      myHRP.CFrame = Old_CF
      wait(0.5)
      if not get_vehicle() then return end

      spawn_any_vehicle(tostring(get_vehicle().Name))
   end
   if myHRP then
      myHRP.CFrame = Old_CF
      wait(0.5)
      if not get_vehicle() then return end

      spawn_any_vehicle(tostring(get_vehicle().Name))
   end
end

function vehicle_skydive_player(TargetPlayer)
   if not TargetPlayer or not TargetPlayer.Character then return end
   local targetChar = TargetPlayer.Character
   local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
   if not targetHRP then return end

   local Old_CF = getgenv().Character:FindFirstChild("HumanoidRootPart").CFrame

   local skydive_pos = Vector3.new(-250.02537536621094, 4000.80411911010742, 194.1149139404297)
   local skydive_cf = CFrame.new(skydive_pos)

   local MyPlayer = game.Players.LocalPlayer
   local MyChar = getgenv().Character or MyPlayer.Character
   local MyHumanoid = getgenv().Humanoid or MyChar:FindFirstChildWhichIsA("Humanoid")
   local MyBus = nil

   for _, v in ipairs(getgenv().Workspace.Vehicles:GetChildren()) do
      if v:IsA("Model") and v:FindFirstChild("owner") and v.owner.Value == MyPlayer then
         if v:FindFirstChild("VehicleSeat") then
            MyBus = v
            break
         end
      end
   end

   if not MyBus then return warn("No owned SchoolBus found") end
   local seat = MyBus:FindFirstChild("VehicleSeat")
   if seat and MyHumanoid then
      MyChar:PivotTo(seat.CFrame)
      task.wait(0.2)
      seat:Sit(MyHumanoid)
   end

   local maxTries = 40
   for i = 1, maxTries do
      local targetHumanoid = targetChar:FindFirstChildOfClass("Humanoid")
      local isSitting = targetHumanoid and targetHumanoid.Sit
      if isSitting then break end

      MyBus:PivotTo(targetHRP.CFrame + Vector3.new(0, 0.3, 0))
      task.wait(0.2)
   end

   wait(0.1)
   MyBus:PivotTo(skydive_cf)
   wait(0.4)

   local myHRP = getgenv().Character:FindFirstChild("HumanoidRootPart")
   if getgenv().Humanoid.Sit then
      getgenv().Humanoid:ChangeState(3)
      wait(0.1)
      myHRP.CFrame = Old_CF
      wait(0.5)
      if not get_vehicle() then return end

      spawn_any_vehicle(tostring(get_vehicle().Name))
   end

   if myHRP then
      myHRP.CFrame = Old_CF
      wait(0.5)
      if not get_vehicle() then return end
      
      spawn_any_vehicle(tostring(get_vehicle().Name))
   end
end

function vehicle_bring_player(TargetPlayer)
   if not TargetPlayer or not TargetPlayer.Character then return end
   local targetChar = TargetPlayer.Character
   local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
   if not targetHRP then return end
   wait(0.2)
   local Old_CF = getgenv().Character:FindFirstChild("HumanoidRootPart").CFrame

   local MyPlayer = getgenv().LocalPlayer
   local MyChar = getgenv().Character or MyPlayer.Character
   local MyHumanoid = getgenv().Humanoid or MyChar:FindFirstChildWhichIsA("Humanoid")
   local MyBus = nil

   for _, v in ipairs(getgenv().Workspace.Vehicles:GetChildren()) do
      if v:IsA("Model") and v:FindFirstChild("owner") and v.owner.Value == MyPlayer then
         if v:FindFirstChild("VehicleSeat") then
            MyBus = v
            break
         end
      end
   end

   if not MyBus then return warn("No owned SchoolBus found") end
   local seat = MyBus:FindFirstChild("VehicleSeat")
   if seat and MyHumanoid then
      MyChar:PivotTo(seat.CFrame)
      task.wait(0.2)
      seat:Sit(MyHumanoid)
   end

   local maxTries = 40
   for i = 1, maxTries do
      local targetHumanoid = targetChar:FindFirstChildOfClass("Humanoid")
      local isSitting = targetHumanoid and targetHumanoid.Sit
      if isSitting then break end

      MyBus:PivotTo(targetHRP.CFrame + Vector3.new(0, 0.3, 0))
      task.wait(0.4)
   end
   wait(0.1)
   MyBus:PivotTo(Old_CF)
   wait(0.4)
   local myHRP = getgenv().Character:FindFirstChild("HumanoidRootPart")
   if getgenv().Humanoid.Sit then
      getgenv().Humanoid:ChangeState(3)
      wait(0.1)
      myHRP.CFrame = Old_CF
      wait(0.5)
      if not get_vehicle() then return end

      spawn_any_vehicle(tostring(get_vehicle().Name))
   end
   if myHRP then
      myHRP.CFrame = Old_CF
      wait(0.5)
      if not get_vehicle() then return end

      spawn_any_vehicle(tostring(get_vehicle().Name))
   end
end

if not getgenv().Workspace:FindFirstChild("Kill_Model_Script(KEEP)") then
   create_kill_part()
end
if not getgenv().Workspace:FindFirstChild("Void_Model_Script(KEEP)") then
   create_void_part()
end
if not getgenv().vehicle_void_player then
    getgenv().vehicle_void_player = vehicle_void_player
end
if not getgenv().vehicle_kill_player then
    getgenv().vehicle_kill_player = vehicle_kill_player
end
if not vehicle_skydive_player then
    getgenv().vehicle_skydive_player = vehicle_skydive_player
end
if not getgenv().vehicle_bring_player then
    getgenv().vehicle_bring_player = vehicle_bring_player
end

local Directories = {
   ["ReplicatedFirst"] = true,
   ["ReplicatedStorage"] = true,
   ["Workspace"] = true,
   ["TweenService"] = true,
   ["SoundService"] = true,
   ["Players"] = true,
   ["Lighting"] = true,
   ["MaterialService"] = true,
   ["Teams"] = true,
   ["StarterGui"] = true,
   ["StarterPack"] = true,
   ["Chat"] = true,
   ["TextChatService"] = true,
   ["StarterPlayer"] = true,
}

local playerScripts = getgenv().PlayerScripts
if playerScripts then
   local clientBase = playerScripts:FindFirstChild("ClientBase")
   if clientBase then
      local logsScript = clientBase:FindFirstChild("Logs")
      if logsScript and logsScript:IsA("LocalScript") then
         logsScript.Disabled = true
      end
   end
end

local sps = getgenv().StarterPlayerScripts
if sps then
   local package = sps:FindFirstChild("StarterPlayerScripts_Package")
   if package then
      local clientBase = package:FindFirstChild("ClientBase")
      if clientBase then
         local logsScript = clientBase:FindFirstChild("Logs")
         if logsScript and logsScript:IsA("LocalScript") then
            logsScript.Disabled = true
         end
      end
   end
end
