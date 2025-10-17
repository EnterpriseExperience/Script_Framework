local FireReparented_Folder
task.wait(0.3)
function create_script_fire_folder()
   if not getgenv().StarterGui:FindFirstChild("FireTemporaryReparentFolder") then
      FireReparented_Folder = Instance.new("Folder")
      FireReparented_Folder.Name = "FireTemporaryReparentFolder"
      FireReparented_Folder.Parent = getgenv().StarterGui
   else
      FireReparented_Folder = getgenv().StarterGui:FindFirstChild("FireTemporaryReparentFolder")
   end
end
task.wait(0.2)
create_script_fire_folder()
getgenv().FireReparented_Folder = FireReparented_Folder
wait(0.1)
for _, v in ipairs(getgenv().PlayerGui:GetDescendants()) do
   if v:IsA("Frame") and v.Name == "SidebarButtonHolder" and string.find(v.Parent.Name, "OpenPhone") then
      v.Position = UDim2.new(0.925, 0, 0.35, 0)
   end
end
wait()
for _, v in ipairs(getgenv().PlayerGui:GetDescendants()) do
   if v:IsA("Frame") and v.Name == "VehicleSpeedFrame" then
      if v:FindFirstChild("Slider"):FindFirstChild("Title") then
         local Title = v:FindFirstChild("Slider"):FindFirstChild("Title")

         Title.TextScaled = false
         Title.TextSize = 21
         Title.TextColor3 = Color3.fromRGB(0, 255, 0)
         Title.Text = "SPEED (Hello from: Flames Hub)!"
      end
   end
end
wait()
getgenv().notify("Success", "SPOOFING NOTIFICATION COUNTERS...", 5)

local gui = getgenv().PlayerGui
local TweenService = getgenv().TweenService
getgenv().RainbowTopBar = true
local PhoneClock = gui:FindFirstChild("PhoneClock", true)
local TopBar_Icons = PhoneClock and PhoneClock.Parent:FindFirstChildOfClass("Frame")
local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)

getgenv().notify("Success", "STARTING RGB HUE COLOR CYCLE ON PHONE...", 5)

local function cycle_color()
   local hue = 0
   while getgenv().RainbowTopBar do
      if not PhoneClock or not TopBar_Icons then break end

      if hue > 1 then hue = 0 end
      local color = Color3.fromHSV(hue, 1, 1)

      if PhoneClock:IsA("TextLabel") then
         TweenService:Create(PhoneClock, tweenInfo, {TextColor3 = color}):Play()
      end

      for _, obj in ipairs(TopBar_Icons:GetChildren()) do
         if obj:IsA("ImageLabel") then
            TweenService:Create(obj, tweenInfo, {ImageColor3 = color}):Play()
         end
      end

      hue = hue + 0.02
      task.wait(0.05)
   end
end

task.spawn(cycle_color)

function update_counter_notif_label(label, input_number)
   local Inputted_Number = tostring(input_number)
   label.Text = Inputted_Number

   if label.Parent and label.Parent:IsA("Frame") then
      if not label.Parent.Visible then
         label.Parent.Visible = true
      end
   end

   label.TextScaled = true

   if not label.Visible then
      label.Visible = true
   end
end

local function setup_label(label, targetText)
   label.Text = targetText

   if label.Parent and label.Parent:IsA("Frame") then
      label.Parent.Visible = true

      if label.Parent.Name == "SumNotificationCount" then
         label.Parent.Size = UDim2.new(0.4, 0, 0.4, 0)
      end
   end

   local connection = label:GetPropertyChangedSignal("Text"):Connect(function()
      if label.Text ~= targetText then
         update_counter_notif_label(label, targetText)
      end
   end)

   return connection
end

local function wait_for_single(name)
   local label
   repeat
      label = gui:FindFirstChild(name, true)
      task.wait()
   until label and label:IsA("TextLabel")
   return label
end

getgenv().notify("Success", "STARTED RGB HUE COLOR CYCLE.", 5)

local function wait_for_multiple(name)
   local results = {}
   repeat
      results = {}
      for _, v in ipairs(gui:GetDescendants()) do
         if v:IsA("TextLabel") and v.Name == name then
            table.insert(results, v)
         end
      end
      task.wait()
   until #results > 0
   return results
end

local counter_label = wait_for_single("SumNotificationCountLabel")
getgenv().ActivelyChanging_CounterLabel = setup_label(counter_label, "999+")

local notif_labels = wait_for_multiple("AppNotificationCountLabel")
getgenv().ActivelyChanging_NotifCountingLabel = {}
for _, label in ipairs(notif_labels) do
   table.insert(getgenv().ActivelyChanging_NotifCountingLabel, setup_label(label, "999+"))
end

gui.DescendantAdded:Connect(function(obj)
   if obj:IsA("TextLabel") then
      if obj.Name == "SumNotificationCountLabel" then
         if getgenv().ActivelyChanging_CounterLabel then
            getgenv().ActivelyChanging_CounterLabel:Disconnect()
         end
         getgenv().ActivelyChanging_CounterLabel = setup_label(obj, "999+")
      elseif obj.Name == "AppNotificationCountLabel" then
         table.insert(getgenv().ActivelyChanging_NotifCountingLabel, setup_label(obj, "999+"))
      end
   end
end)
wait(0.1)
getgenv().notify("Success", "Spoofed notification counter numbers.", 5)
