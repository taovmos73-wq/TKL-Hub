--// SETTINGS
local RANGE = 10
local TICK_RATE = 0.1

local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local auraEnabled = true

--// AUTO CLICK (GAME TỰ TÍNH DAMAGE)
task.spawn(function()
    while true do
        task.wait(TICK_RATE)

        if not auraEnabled then continue end

        -- giả lập click chuột
        VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        VirtualUser:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)

--// OPTIONAL: CHỈ ĐÁNH KHI GẦN NPC
task.spawn(function()
    while true do
        task.wait(0.1)

        local char = player.Character
        if not char then continue end

        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then continue end

        local nearNPC = false

        for _, model in pairs(workspace:GetChildren()) do
            if model:IsA("Model")
            and model ~= char
            and model:FindFirstChild("HumanoidRootPart")
            and model:FindFirstChild("IsNPC") then

                local dist = (root.Position - model.HumanoidRootPart.Position).Magnitude

                if dist <= RANGE then
                    nearNPC = true
                    break
                end
            end
        end

        auraEnabled = nearNPC
    end
end)
