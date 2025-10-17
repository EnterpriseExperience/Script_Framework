if not getgenv().Game then
    getgenv().Game = cloneref and cloneref(game) or game
end
if not getgenv().TextChatService then
    getgenv().TextChatService = cloneref and cloneref(game:GetService("TextChatService")) or game:GetService("TextChatService")
end
if not getgenv().StarterGui then
    getgenv().StarterGui = cloneref and cloneref(game:GetService("StarterGui")) or game:GetService("StarterGui")
end

local function make_input_normal(str)
   if type(str) ~= "string" then
      str = tostring(str or "")
   end

   local okLower, lowered = pcall(string.lower, str)
   if not okLower then
      lowered = tostring(str)
   end

   local cleaned = {}
   for i = 1, #lowered do
      local c = lowered:sub(i, i)
      if c:match("[%w]") then
         table.insert(cleaned, c)
      end
   end

   return table.concat(cleaned)
end

task.defer(function()
   local ok, name = pcall(function()
      return identifyexecutor and identifyexecutor() or "Unknown Executor"
   end)
   executor_Name = ok and tostring(name) or "Unknown Executor"

   task.wait(0.1)

   executor_Name = make_input_normal(executor_Name)
end)

local Allowed_Executors = {
   ["Volcano"] = true,
   ["Wave"] = false,
   ["Zenith"] = true,
   ["Delta"] = false,
   ["CodeX"] = false,
   ["Velocity"] = false,
   ["Bunni"] = true,
   ["Swift"] = true,
   ["Sirhurt"] = true,
   ["KRNL"] = false,
   ["Potassium"] = true,
   ["Macsploit"] = false,
   ["Seliware"] = true,
   ["Hydrogen"] = false,
   ["Lx63"] = false,
   ["Cryptic"] = false,
   ["Arceus"] = false,
   ["Vega"] = false,
   ["Synapse"] = false,
   ["Valex"] = false,
   ["Nucleus"] = false,
   ["Opiumware"] = false,
}

local function allowed_executor()
   local normalizedExec = make_input_normal(executor_Name or "")
   for allowedName, isAllowed in pairs(Allowed_Executors) do
      if isAllowed and normalizedExec:find(make_input_normal(allowedName), 1, true) then
         return true
      end
   end
   return false
end

function startCooldownSystem()
   if getgenv().TextChatAntiBanApplied then
      local CooldownTime = 10
      local Chat = Enum.CoreGuiType.Chat
      getgenv().CooldownActive = getgenv().CooldownActive or false
      getgenv().HashtagCount = getgenv().HashtagCount or 0

      local function startCooldown(duration)
         if getgenv().CooldownActive then
            return getgenv().notify("Warning", "Your TextChat cooldown is still currently active.", 6)
         end
         getgenv().CooldownActive = true
         getgenv().notify("Info", "Cooldown has now started for: " .. duration .. " seconds.", 8)

         task.delay(duration, function()
            getgenv().CooldownActive = false
            getgenv().HashtagCount = 0
            if not replicatesignal then
               getgenv().notify("Error", "Your executor does not (unfortunately) support 'replicatesignal', cannot unsuspend Chat.", 10)
            else
               replicatesignal(getgenv().TextChatService.UpdateChatTimeout, getgenv().LocalPlayer.UserId, 0, 10)
            end
            getgenv().StarterGui:SetCoreGuiEnabled(Chat, true)
            getgenv().notify("Success", "Chat is now re-enabled, cooldown has stopped.", 7)
         end)
      end

      getgenv().TextChatService.MessageReceived:Connect(function(msg)
         local source = msg.TextSource
         if not source then return end
         local player = getgenv().Players:GetPlayerByUserId(source.UserId)
         if player ~= getgenv().LocalPlayer then return end

         local text = msg.Text
         if text and text:match("^#+$") then
            getgenv().HashtagCount += 1
            if getgenv().HashtagCount >= 4 then
               getgenv().StarterGui:SetCoreGuiEnabled(Chat, false)
               startCooldown(CooldownTime)
               getgenv().notify("Warning", "Chat disabled temporarily, too many filtered messages have been sent (possible risk of ban).", 10)
            end
         end
      end)
   else
      getgenv().notify("Info", "Skipping this part, hook not applied.", 3)
   end
end

local function safe_chat_hookin()
	if not hookmetamethod or not getnamecallmethod then
		return getgenv().notify("Warning", "Your executor does not support hookmetamethod or getnamecallmethod.", 5)
	end
	if not allowed_executor() then
		return getgenv().notify("Warning", "Executor not allowed for chat protection hook.", 5)
	end
	if getgenv().TextChatAntiBanApplied then
		return getgenv().notify("Info", "TextChatAntiBan hook already applied.", 5)
	end

	local okService, TextChatService = pcall(function()
		return cloneref and cloneref(game:GetService("TextChatService")) or game:GetService("TextChatService")
	end)
	if not okService or not TextChatService then
		return getgenv().notify("Warning", "TextChatService not found; cannot apply hook.", 5)
	end

	local oldNamecall, oldIndex

	local function hookMetatable()
		local ok, err = pcall(function()
			oldNamecall = hookmetamethod(TextChatService, "__namecall", newcclosure(function(self, ...)
				local method = getnamecallmethod()
				if method == "SendAsync" and getgenv().CooldownActive then
					getgenv().notify("Warning", "You cannot send messages during cooldown.", 6)
					return nil
				end
				return oldNamecall(self, ...)
			end))

			oldIndex = hookmetamethod(TextChatService, "__index", newcclosure(function(self, key)
				if key == "SendAsync" and getgenv().CooldownActive then
					return function()
						getgenv().notify("Warning", "Chat disabled during cooldown.", 6)
						return nil
					end
				end
				return oldIndex(self, key)
			end))
		end)

		if not ok then
			getgenv().notify("Error", "Failed to hook metatable safely: " .. tostring(err), 8)
			return false
		end
		return true
	end

   local hookApplied = hookMetatable()
   if hookApplied then
      getgenv().TextChatAntiBanApplied = true
      getgenv().notify("Success", "TextChatService hook successfully applied.", 6)
      startCooldownSystem()
   else
      getgenv().notify("Warning", "Hook attempt failed or blocked by executor sandbox.", 6)
   end
end

task.defer(function()
	if allowed_executor() then
		safe_chat_hookin()
	else
		getgenv().notify("Warning", "Executor not allowed to apply SendAsync hook.", 6)
	end
end)
