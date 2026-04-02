--// SETTINGS
local RANGE = 15
local BASE_DELAY = 0.12
local RANDOM_DELAY = 0.05

local Players = game:GetService("Players")
local player = Players.LocalPlayer

--// UI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ProAura"

local button = Instance.new("TextButton", gui)
button.Size = UDim2.new(0,140,0,45)
button.Position = UDim2.new(0,20,0,200)
button.Text = "AUTO FARM: OFF"
button.Active = true
button.Draggable = true

local enabled = false

button.MouseButton1Click:Connect(function()
    enabled = not enabled
    button.Text = enabled and "AUTO FARM: ON" or "AUTO FARM: OFF"
end)

--// FIND NEAREST NPC
local function getNearestNPC()
    local char = player.Character
    if not char then return nil end

    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    local closest = nil
    local shortest = RANGE

    for _, model in pairs(workspace:GetChildren()) do
        if model:IsA("Model")
        and model ~= char
        and model:FindFirstChild("Humanoid")
        and model:FindFirstChild("HumanoidRootPart")
        and model:FindFirstChild("IsNPC") then

            local dist = (root.Position - model.HumanoidRootPart.Position).Magnitude

            if dist < shortest then
                shortest = dist
                closest = model
            end
        end
    end

    return closest
end

--// AUTO ATTACK
task.spawn(function()
    while true do
        task.wait(BASE_DELAY + math.random() * RANDOM_DELAY)

        if not enabled then continue end

        local char = player.Character
        if not char then continue end

        local tool = char:FindFirstChildOfClass("Tool")
        local target = getNearestNPC()

        if tool and target then
            tool:Activate()
        end
    end
end)
