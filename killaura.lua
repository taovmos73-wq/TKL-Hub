--// SETTINGS
local BASE_DELAY = 0.12
local RANDOM_DELAY = 0.05

local Players = game:GetService("Players")
local player = Players.LocalPlayer

--// UI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local button = Instance.new("TextButton", gui)

button.Size = UDim2.new(0,140,0,45)
button.Position = UDim2.new(0,20,0,200)
button.Text = "AUTO ATTACK: OFF"
button.Active = true
button.Draggable = true

local enabled = false

button.MouseButton1Click:Connect(function()
    enabled = not enabled
    button.Text = enabled and "AUTO ATTACK: ON" or "AUTO ATTACK: OFF"
end)

--// AUTO SPAM ATTACK (ĐÁNH ALL)
task.spawn(function()
    while true do
        task.wait(BASE_DELAY + math.random() * RANDOM_DELAY)

        if not enabled then continue end

        local char = player.Character
        if not char then continue end

        local tool = char:FindFirstChildOfClass("Tool")

        if tool then
            tool:Activate()
        end
    end
end)
