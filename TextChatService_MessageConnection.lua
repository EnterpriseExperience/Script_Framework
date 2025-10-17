if not getgenv().Game then
    getgenv().Game = cloneref and cloneref(game) or game
end
wait(0.1)
local function Service_Wrap(service)
   if cloneref then
      return cloneref(getgenv().Game:GetService(service))
   else
      return getgenv().Game:GetService(service)
   end
end
wait(0.1)
if not getgenv().TextChatService then
    getgenv().TextChatService = Service_Wrap("TextChatService")
end
if not getgenv().Players then
    getgenv().Players = Service_Wrap("Players")
end

getgenv().ChatMessageHooks = getgenv().ChatMessageHooks or {}
wait(0.1)
if not getgenv().ChatMessageConnection then
   getgenv().ChatMessageConnection = getgenv().TextChatService.MessageReceived:Connect(function(msg)
      if not msg.TextSource then return end
      local sender = getgenv().Players:GetPlayerByUserId(msg.TextSource.UserId)
      if not (sender and msg.Text) then return end

      for _, fn in ipairs(getgenv().ChatMessageHooks) do
         local ok, err = pcall(fn, sender, msg)
         if not ok then
            getgenv().notify("Error", "[TextChatService_Message_Conn_Error]: "..tostring(err), 11)
         end
      end
   end)
end
