getgenv().API_URL = "https://script.google.com/macros/s/AKfycbwHivaX-A1EkhvEVHX8-aYz59Kp3dL-TpfHzFjkHCIaTWItiF2drpQRT5LB8YUf-0re/exec"
getgenv().HeartbeatInterval = 10
local Http = game:FindService("HttpService")
local Players = game:FindService("Players")
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
    getgenv().get_char = function(Player)
        if not Player or typeof(Player) ~= "Instance" or not Player:IsA("Player") then
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
            return nil
        end

        return character
    end
end
wait(0.2)
local Character = getgenv().get_char(LocalPlayer)
local char = Character or getgenv().get_char(LocalPlayer)
if not getgenv().Character then
    getgenv().Character = Character
end

local function sendRequest(data)
    local ok, res = pcall(function()
        return Http:PostAsync(getgenv().API_URL, Http:JSONEncode(data))
    end)
    if not ok then return nil end
    local s, decoded = pcall(function()
        return Http:JSONDecode(res)
    end)
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

        local existing = getgenv().Billboards[plr]
        if existing and existing.Parent and existing.Parent.Parent then
            return 
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
        else
            if getgenv().Billboards[plr] then
                getgenv().Billboards[plr]:Destroy()
                getgenv().Billboards[plr] = nil
            end
        end
    end
end

local function createSelfBillboard()
    if not char then return end
    local head = char:WaitForChild("Head", 1)
    if not head then return end
    if getgenv().Billboards[LocalPlayer] then return end

    local bb = Instance.new("BillboardGui")
    bb.Name = "FlamesHubTitleSelf"
    bb.Size = UDim2.new(0,200,0,50)
    bb.StudsOffset = Vector3.new(0,2.5,0)
    bb.AlwaysOnTop = true
    bb.Parent = head

    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1,0,1,0)
    txt.BackgroundTransparency = 1
    txt.TextScaled = true
    txt.Font = Enum.Font.GothamBold
    txt.TextStrokeTransparency = 0.2

    if Owners[LocalPlayer.Name] then
        return 
    else
        txt.Text = "🔥 FLAMES HUB | CLIENT 🔥"
        txt.TextColor3 = Color3.fromRGB(255, 100, 0)
    end

    txt.Parent = bb
    Billboards[LocalPlayer] = bb
end

sendRequest({
    clientId = ClientId,
    userId = UserId,
    username = LocalPlayer.Name,
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
            clientId = ClientId,
            userId = UserId,
            heartbeat = true,
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
    if Billboards[plr] then
        Billboards[plr]:Destroy()
        Billboards[plr] = nil
    end
end)

LocalPlayer.OnTeleport:Connect(function()
    sendRequest({
        clientId = ClientId,
        userId = UserId,
        disconnect = true,
    })
end)
