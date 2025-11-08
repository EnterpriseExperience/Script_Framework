getgenv().API_URL = "https://script.google.com/macros/s/AKfycbwwduM8W2Qx9XltPyD1526giFCcl9qXeks4tnqkGEDrTnUjumQ-RyL2ojSlvJk8XXjc/exec"
getgenv().HeartbeatInterval = 10

local Http = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ClientId = tostring(math.random(100000, 999999)) .. tostring(os.clock())
local UserId = LocalPlayer.UserId

getgenv().Billboards = getgenv().Billboards or {}

local Owners = {
    ["L0CKED_1N1"] = true,
    ["CHEATING_B0SS"] = true,
    ["Bobmcjoejoebob"] = true,
    ["CleanestAuraEv3r"] = true
}

if not getgenv().get_char then
    getgenv().get_char = function(player)
        if not player or typeof(player) ~= "Instance" or not player:IsA("Player") then
            return nil
        end
        local character = player.Character
        local attempts = 0
        while not character and attempts < 25 do
            task.wait(0.2)
            character = player.Character
            attempts += 1
        end
        if not character then
            local ok, newChar = pcall(function()
                return player.CharacterAdded:Wait()
            end)
            if ok then character = newChar end
        end
        return character
    end
end

task.wait(0.2)
local Character = getgenv().get_char(LocalPlayer)
if not getgenv().Character then getgenv().Character = Character end

local function sendRequest(data)
    local json = Http:JSONEncode(data)
    print("[FlamesHub] Sending POST:", json)

    local ok, res = pcall(function()
        return Http:PostAsync(getgenv().API_URL, json, Enum.HttpContentType.ApplicationJson)
    end)

    if not ok then
        warn("[FlamesHub] Request failed:", res)
        return nil
    end

    print("[FlamesHub] Raw response:", res)

    local s, decoded = pcall(function()
        return Http:JSONDecode(res)
    end)

    if not s then
        warn("[FlamesHub] JSON decode error:", decoded)
    else
        print("[FlamesHub] Decoded:", decoded)
    end

    return s and decoded or nil
end

local function getClients()
    local ok, res = pcall(function()
        return Http:GetAsync(getgenv().API_URL)
    end)
    if not ok then return {} end
    local s, decoded = pcall(function()
        return Http:JSONDecode(res)
    end)
    return (s and decoded and decoded.clients) or {}
end

local function createBillboard(plr)
    if not plr or not plr:IsA("Player") then return end

    local function attachBillboard()
        local char = getgenv().get_char(plr)
        if not char then return end
        local head = char:FindFirstChild("Head")
        if not head then return end

        if getgenv().Billboards[plr] then
            local bb = getgenv().Billboards[plr]
            if bb.Parent and bb.Parent.Parent then return end
        end

        local bb = Instance.new("BillboardGui")
        bb.Name = "FlamesHubTitle"
        bb.Size = UDim2.new(0, 200, 0, 50)
        bb.StudsOffset = Vector3.new(0, 2.5, 0)
        bb.AlwaysOnTop = true
        bb.Parent = head

        local txt = Instance.new("TextLabel")
        txt.Size = UDim2.new(1, 0, 1, 0)
        txt.BackgroundTransparency = 1
        txt.TextScaled = true
        txt.Font = Enum.Font.GothamBold
        txt.TextStrokeTransparency = 0.2

        if not Owners[plr.Name] then
            txt.Text = "🔥 FLAMES HUB | CLIENT 🔥"
            txt.TextColor3 = Color3.fromRGB(255, 100, 0)
        else
            return
        end

        txt.Parent = bb
        getgenv().Billboards[plr] = bb
    end

    attachBillboard()

    if not plr.CharacterAddedConn then
        plr.CharacterAddedConn = plr.CharacterAdded:Connect(function()
            task.wait(1)
            attachBillboard()
        end)
    end
end

local function updateBillboards()
    local clients = getClients()
    local active = {}
    for _, c in ipairs(clients) do
        active[c.userId] = true
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if active[plr.UserId] then
            createBillboard(plr)
        elseif getgenv().Billboards[plr] then
            getgenv().Billboards[plr]:Destroy()
            getgenv().Billboards[plr] = nil
        end
    end
end

local function createSelfBillboard()
    local char = getgenv().get_char(LocalPlayer)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    if getgenv().Billboards[LocalPlayer] then return end

    local bb = Instance.new("BillboardGui")
    bb.Name = "FlamesHubTitleSelf"
    bb.Size = UDim2.new(0, 200, 0, 50)
    bb.StudsOffset = Vector3.new(0, 2.5, 0)
    bb.AlwaysOnTop = true
    bb.Parent = head

    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.TextScaled = true
    txt.Font = Enum.Font.GothamBold
    txt.TextStrokeTransparency = 0.2

    if not Owners[LocalPlayer.Name] then
        txt.Text = "🔥 FLAMES HUB | CLIENT 🔥"
        txt.TextColor3 = Color3.fromRGB(255, 100, 0)
    else
        return
    end

    txt.Parent = bb
    getgenv().Billboards[LocalPlayer] = bb
end

-- Connect to API
sendRequest({
    action = "connect",
    clientId = ClientId,
    userId = UserId,
    username = LocalPlayer.Name
})

task.spawn(function()
    task.wait(1)
    createSelfBillboard()
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    createSelfBillboard()
end)

task.spawn(function()
    while task.wait(getgenv().HeartbeatInterval) do
        sendRequest({
            action = "heartbeat",
            clientId = ClientId,
            userId = UserId
        })
        updateBillboards()
    end
end)

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(1)
        updateBillboards()
    end)
end)

Players.PlayerRemoving:Connect(function(plr)
    if getgenv().Billboards[plr] then
        getgenv().Billboards[plr]:Destroy()
        getgenv().Billboards[plr] = nil
    end
end)

LocalPlayer.OnTeleport:Connect(function()
    sendRequest({
        action = "disconnect",
        clientId = ClientId,
        userId = UserId
    })
end)
