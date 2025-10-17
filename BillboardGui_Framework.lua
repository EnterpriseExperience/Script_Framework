local LocalPlayer = Players.LocalPlayer
local API_URL = "https://flameshub-worker.flameshub.workers.dev/api/flameshub"
local httprequest = request or http_request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request)
local watchedUserIds = {
   [7712000520] = true,
   [7740121604] = true,
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
