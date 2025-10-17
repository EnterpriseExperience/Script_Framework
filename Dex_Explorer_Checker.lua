if not getgenv().Game then
    getgenv().Game = cloneref and cloneref(game) or game
end

local Loaded_Prefix = loadPrefix()
local CoreGui = getgenv().CoreGui or cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
local HiddenUI = get_hidden_gui and get_hidden_gui() or gethui and gethui()

if HiddenUI then
   for _, v in ipairs(HiddenUI:GetDescendants()) do
      if v:IsA("Frame") and v.Name == "ResizeControls" and v.Parent.Name == "Main" then
         if v.Parent.Parent:IsA("ScreenGui") then
            getgenv().notify("Warning", "Are you using Dex Explorer with our script? I surely hope not, seems like you are... the script is literally open source.", 15)
         end
      end
   end
else
   for _, v in ipairs(CoreGui:GetDescendants()) do
      if v:IsA("Frame") and v.Name == "ResizeControls" and v.Parent.Name == "Main" then
         getgenv().notify("Warning", "Are you using Dex Explorer with our script? I surely hope not, seems like you are... the script is literally open source.", 15)
      end
   end
end
