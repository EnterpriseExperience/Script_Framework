local AllCars = {
   "Magic Carpet", "EClass", "TowTruck", "Bicycle", "Fiat500", "Cayenne", "Jetski", "LuggageScooter",
   "MiniCooper", "GarbageTruck", "EScooter", "Monster Truck", "Yacht", "Stingray", "FireTruck", "VespaPizza",
   "VespaPolice", "F150", "Police SUV", "Chiron", "Humvee", "Wrangler", "Box Van", "Ambulance", "Urus", "Tesla",
   "Cybertruck", "RollsRoyce", "GClass", "SVJ", "MX5", "SF90", "Charger SRT", "Evoque", "IceCream Truck",
   "Vespa", "ATV", "Limo", "Tank", "Smart Car", "Beauford", "SchoolBus", "Sprinter", "GolfKart", "TrackHawk",
   "Helicopter", "SnowPlow", "Camper Van", "SWAT Van"
}
local CarMap = {}

for _, name in ipairs(AllCars) do
   CarMap[name:lower()] = name
end
wait(0.1)
getgenv().CarMap = CarMap
wait(0.2)
function car_listing_gui()
   local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
   if CoreGui:FindFirstChild("CarListUI") then return end

   local ScreenGui = Instance.new("ScreenGui")
   ScreenGui.Name = "CarListUI"
   ScreenGui.ResetOnSpawn = false
   ScreenGui.IgnoreGuiInset = true
   ScreenGui.Parent = CoreGui

   local isMobile = getgenv().UserInputService.TouchEnabled

   local MainFrame = Instance.new("Frame")
   MainFrame.Size = isMobile and UDim2.new(0, 280, 0, 350) or UDim2.new(0, 350, 0, 450)
   MainFrame.Position = UDim2.new(0.5, -MainFrame.Size.X.Offset/2, 0.5, -MainFrame.Size.Y.Offset/2)
   MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
   MainFrame.BorderSizePixel = 0
   MainFrame.Active = true
   MainFrame.Parent = ScreenGui

   local UICorner = Instance.new("UICorner")
   UICorner.CornerRadius = UDim.new(0, 15)
   UICorner.Parent = MainFrame

   local Title = Instance.new("TextLabel")
   Title.Size = UDim2.new(1, -40, 0, 40)
   Title.Position = UDim2.new(0, 10, 0, 0)
   Title.BackgroundTransparency = 1
   Title.Text = "Made by: "..tostring(Script_Creator)
   Title.Font = Enum.Font.GothamBold
   Title.TextSize = 18
   Title.TextColor3 = Color3.fromRGB(255, 255, 255)
   Title.TextXAlignment = Enum.TextXAlignment.Left
   Title.Parent = MainFrame

   local CloseButton = Instance.new("TextButton")
   CloseButton.Size = UDim2.new(0, 30, 0, 30)
   CloseButton.Position = UDim2.new(1, -35, 0, 5)
   CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
   CloseButton.Text = "X"
   CloseButton.Font = Enum.Font.GothamBold
   CloseButton.TextSize = 16
   CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
   CloseButton.Parent = MainFrame

   local CloseCorner = Instance.new("UICorner")
   CloseCorner.CornerRadius = UDim.new(0, 8)
   CloseCorner.Parent = CloseButton

   CloseButton.MouseButton1Click:Connect(function()
      ScreenGui:Destroy()
   end)

   local ScrollingFrame = Instance.new("ScrollingFrame")
   ScrollingFrame.Size = UDim2.new(1, -20, 1, -60)
   ScrollingFrame.Position = UDim2.new(0, 10, 0, 50)
   ScrollingFrame.BackgroundTransparency = 1
   ScrollingFrame.BorderSizePixel = 0
   ScrollingFrame.ScrollBarThickness = 6
   ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
   ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
   ScrollingFrame.Parent = MainFrame

   local UIListLayout = Instance.new("UIListLayout")
   UIListLayout.Parent = ScrollingFrame
   UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
   UIListLayout.Padding = UDim.new(0, 5)

   local UIPadding = Instance.new("UIPadding")
   UIPadding.Parent = ScrollingFrame
   UIPadding.PaddingLeft = UDim.new(0, 5)
   UIPadding.PaddingTop = UDim.new(0, 5)

   for _, name in ipairs(AllCars) do
      local CarButton = Instance.new("TextButton")
      CarButton.Size = UDim2.new(1, -10, 0, 30)
      CarButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
      CarButton.Text = name
      CarButton.Font = Enum.Font.Gotham
      CarButton.TextSize = 16
      CarButton.TextColor3 = Color3.fromRGB(220, 220, 220)
      CarButton.Parent = ScrollingFrame

      local CarCorner = Instance.new("UICorner")
      CarCorner.CornerRadius = UDim.new(0, 10)
      CarCorner.Parent = CarButton

      CarButton.MouseButton1Click:Connect(function()
         if not getgenv().Get then return end
         getgenv().Get("spawn_vehicle", name)
      end)
   end

   local dragging, dragInput, dragStart, startPos

   local function update(input)
      local delta = input.Position - dragStart
      local goal = UDim2.new(
         startPos.X.Scale,
         startPos.X.Offset + delta.X,
         startPos.Y.Scale,
         startPos.Y.Offset + delta.Y
      )
      TweenService:Create(MainFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = goal}):Play()
   end

   MainFrame.InputBegan:Connect(function(input)
      if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
         dragging = true
         dragStart = input.Position
         startPos = MainFrame.Position

         input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
               dragging = false
            end
         end)
      end
   end)

   MainFrame.InputChanged:Connect(function(input)
      if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
         dragInput = input
      end
   end)

   UserInputService.InputChanged:Connect(function(input)
      if input == dragInput and dragging then
         update(input)
      end
   end)
end
wait(0.1)
if not getgenv().car_listing_gui then
    getgenv().car_listing_gui = car_listing_gui
end
