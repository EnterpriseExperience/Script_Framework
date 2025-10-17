if not getgenv().Game then
   getgenv().Game = cloneref and cloneref(game) or game
end
wait(0.1)
if not getgenv().Players then
   getgenv().Players = cloneref and cloneref(getgenv().Game:GetService("Players")) or getgenv().Game:GetService("Players")
end
if not getgenv().HttpService then
   getgenv().HttpService = cloneref and cloneref(getgenv().Game:GetService("HttpService")) or getgenv().Game:GetService("HttpService")
end
wait(0.1)
local LocalPlayer = getgenv().LocalPlayer or Players.LocalPlayer
local API_URL = "https://flameshub-worker.flameshub.workers.dev/api/flameshub"
local httprequest = request or http_request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request)
local watchedUserIds = {
   [7712000520] = true,
   [7740121604] = true,
}
local Owners = {
   ["L0CKED_1N1"] = true,
   ["CHEATING_B0SS"] = true,
}

local function httpRequestSafe(opts)
   if not httprequest then return end
   local ok, res = pcall(function()
      return httprequest({
         Url = opts.url,
         Method = opts.method or "GET",
         Headers = opts.headers,
         Body = opts.body,
      })
   end)
   if not ok or not res then return nil end
   res.Body = res.Body or res.body
   res.StatusCode = res.StatusCode or res.status_code

   return res
end

local function safeJsonDecode(body)
   if not body or type(body) ~= "string" then return {} end
   local ok, decoded = pcall(HttpService.JSONDecode, HttpService, body)
   return ok and decoded or {}
end

local function apiList()
   local res = httpRequestSafe({ url = API_URL .. "/list" })
   return res and safeJsonDecode(res.Body) or {}
end

local function apiSet(payload)
   return httpRequestSafe({
      url = API_URL .. "/set",
      method = "POST",
      headers = { ["Content-Type"] = "application/json" },
      body = HttpService:JSONEncode(payload),
   })
end

local function apiDelete(userId)
   return httpRequestSafe({
      url = API_URL .. "/delete",
      method = "POST",
      headers = { ["Content-Type"] = "application/json" },
      body = HttpService:JSONEncode({ userId = userId }),
   })
end

local function createBillboard(player)
   if not player or not player.Character then return end
   local head = player.Character:FindFirstChild("Head") or player.Character:WaitForChild("Head", 5)
   if not head then return end

   local existing = head:FindFirstChild("FlamesHubBillboard")
   if existing then existing:Destroy() end

   local billboard = Instance.new("BillboardGui")
   billboard.Name = "FlamesHubBillboard"
   billboard.Adornee = head
   billboard.Size = UDim2.new(0, 200, 0, 50)
   billboard.StudsOffset = Vector3.new(0, 2.5, 0)
   billboard.AlwaysOnTop = true
   billboard.Parent = head

   local label = Instance.new("TextLabel")
   label.Size = UDim2.new(1, 0, 1, 0)
   label.BackgroundTransparency = 0.2
   label.TextScaled = true
   label.Font = Enum.Font.GothamBold
   label.TextStrokeTransparency = 0
   label.Parent = billboard

   local corner = Instance.new("UICorner")
   corner.CornerRadius = UDim.new(0, 8)
   corner.Parent = label

   if watchedUserIds[player.UserId] then
      label.Text = "🔥 FLAMES HUB | OWNER 🔥"
      label.TextColor3 = Color3.fromRGB(255, 255, 255)
      label.BackgroundColor3 = Color3.fromRGB(0, 16, 176)
   else
      label.Text = "🔥 FLAMES HUB | CLIENT 🔥"
      label.TextColor3 = Color3.fromRGB(0, 0, 0)
      label.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
      if label and label.Visible then
         label.Visible = false
      end
   end
end

task.spawn(function()
   apiSet({ userId = LocalPlayer.UserId, state = "enable" })
   while task.wait(10) do
      apiSet({ userId = LocalPlayer.UserId, state = "enable" })
   end
end)

Players.PlayerRemoving:Connect(function(plr)
   if plr == LocalPlayer then
      apiDelete(LocalPlayer.UserId)
   end
end)

task.spawn(function()
   while task.wait(5) do
      local list = apiList()
      for uid, payload in pairs(list) do
         local userId = tonumber(uid)
         if userId then
            local player = getgenv().Players:GetPlayerByUserId(userId)
            if player then
               task.spawn(createBillboard, player)
            end
         end
      end
   end
end)

Players.PlayerAdded:Connect(function(plr)
   plr.CharacterAdded:Connect(function()
      task.wait(1)
      createBillboard(plr)
   end)
end)

LocalPlayer.CharacterAdded:Connect(function(char)
   task.wait(1)
   createBillboard(LocalPlayer)
end)

task.spawn(function()
   while task.wait(3) do
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
         local head = LocalPlayer.Character:WaitForChild("Head", 3)

         if not head:FindFirstChild("FlamesHubBillboard") then
            createBillboard(LocalPlayer)
         end
      end
   end
end)

getgenv().ShowTitle = getgenv().ShowTitle or true
local TITLE_TEXT = "🔥 Flames Hub | Owner 🔥"
local TITLE_COLOR = Color3.fromRGB(196, 40, 28)
local NOTE_TEXT = "If you ever need support with the script, I can help you. 👍."
local NOTE_COLOR = Color3.fromRGB(255, 255, 255)

local function createBillboard_Support(player)
   if player == LocalPlayer then return end
   if not Owners[player.Name] then return end

   local character = player.Character or player.CharacterAdded:Wait()
   local head = character:WaitForChild("Head", 3)
   if not head then return end

   if head:FindFirstChild("CustomTitle") then
      head.CustomTitle:Destroy()
   end

   local billboard = Instance.new("BillboardGui")
   billboard.Name = "CustomTitle"
   billboard.Adornee = head
   billboard.Size = UDim2.new(0, 300, 0, 110)
   billboard.StudsOffset = Vector3.new(0, 6, 0)
   billboard.AlwaysOnTop = true
   billboard.Parent = head

   local noteBox = Instance.new("Frame")
   noteBox.Size = UDim2.new(1, 0, 0.4, 0)
   noteBox.Position = UDim2.new(0, 0, 0, 0)
   noteBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
   noteBox.BackgroundTransparency = 0.3
   noteBox.Parent = billboard

   local noteCorner = Instance.new("UICorner")
   noteCorner.CornerRadius = UDim.new(0, 8)
   noteCorner.Parent = noteBox

   local note = Instance.new("TextLabel")
   note.Size = UDim2.new(1, -10, 1, -4)
   note.Position = UDim2.new(0, 5, 0, 2)
   note.BackgroundTransparency = 1
   note.Text = NOTE_TEXT
   note.TextColor3 = NOTE_COLOR
   note.Font = Enum.Font.GothamSemibold
   note.TextScaled = true
   note.TextWrapped = true
   note.Parent = noteBox

   local titleBox = Instance.new("Frame")
   titleBox.Size = UDim2.new(1, 0, 0.6, 0)
   titleBox.Position = UDim2.new(0, 0, 0.4, 0)
   titleBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
   titleBox.BackgroundTransparency = 0.2
   titleBox.Parent = billboard

   local titleCorner = Instance.new("UICorner")
   titleCorner.CornerRadius = UDim.new(0, 10)
   titleCorner.Parent = titleBox

   local title = Instance.new("TextLabel")
   title.Size = UDim2.new(1, -10, 1, -4)
   title.Position = UDim2.new(0, 5, 0, 2)
   title.BackgroundTransparency = 1
   title.Text = TITLE_TEXT
   title.TextColor3 = TITLE_COLOR
   title.Font = Enum.Font.GothamBold
   title.TextScaled = true
   title.TextWrapped = true
   title.Parent = titleBox
   title.Name = "ToggleTitle"

   billboard.Enabled = true
   title.Visible = getgenv().ShowTitle
end

local function refreshTitles()
   for _, player in ipairs(Players:GetPlayers()) do
      createBillboard_Support(player)
   end
end

refreshTitles()

Players.PlayerAdded:Connect(function(p)
   p.CharacterAdded:Connect(function()
      p.CharacterAdded:Wait()
      createBillboard_Support(p)
   end)
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TitleToggleUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
if gethui then ScreenGui.Parent = gethui() else ScreenGui.Parent = getgenv().Game.CoreGui end

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0, 140, 0, 40)
Button.Position = UDim2.new(1, -150, 1, -50)
Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.Font = Enum.Font.GothamBold
Button.TextSize = 16
Button.TextScaled = true
Button.Text = "Hide Owner Title"
Button.Parent = ScreenGui
Button.AutoButtonColor = true
if Button.Visible then
   Button.Visible = false
end

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Button

Button.MouseButton1Click:Connect(function()
   getgenv().ShowTitle = not getgenv().ShowTitle
   Button.Text = getgenv().ShowTitle and "Hide Owner Title" or "Show Owner Title"

   for _, player in ipairs(Players:GetPlayers()) do
      local char = player.Character
      if char and char:FindFirstChild("Head") then
         local gui = char.Head:FindFirstChild("CustomTitle")
         if gui then
            local toggleTitle = gui:FindFirstChild("ToggleTitle")
            if toggleTitle then
               toggleTitle.Visible = getgenv().ShowTitle
            end
         end
      end
   end
end)
