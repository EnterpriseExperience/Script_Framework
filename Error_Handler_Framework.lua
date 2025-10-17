getgenv().notify("Success", "Initializing error reporter...", 6)
local Players = getgenv().Players or cloneref(game:GetService("Players"))
local LocalPlayer = getgenv().LocalPlayer or Players.LocalPlayer
local Handle_Error = getgenv().Error_API and getgenv().Error_API.Handle_Error
getgenv().Currently_Handling_Errors = true

local function ReportError(msg, trace)
   if not Handle_Error then return end
   local fullMessage = tostring(msg) .. "\n" .. tostring(trace or debug.traceback())
   Handle_Error(LocalPlayer, fullMessage)
end

local function SafeWrap(fn)
   return function(...)
      return xpcall(fn, function(err)
         ReportError(err, debug.traceback())
         return nil
      end, ...)
   end
end

getgenv().ScriptContext.Error:Connect(function(message, stackTrace, scriptInstance)
   ReportError(message, stackTrace)
end)

task.spawn(function()
   while getgenv().Currently_Handling_Errors == true do
      task.wait(1)
      local ok, err = pcall(function()
         
      end)
      if not ok and err then
         ReportError(err, debug.traceback())
      end
   end
end)
