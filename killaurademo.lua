--// SETTINGS
local HITBOX_SIZE = Vector3.new(12,6,12)
local DAMAGE = 25
local TICK_RATE = 0.05

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- UI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local button = Instance.new("TextButton", gui)

button.Size = UDim2.new(0,120,0,40)
button.Position = UDim2.new(0,20,0,200)
button.Text = "Aura: OFF"
button.Active = true
button.Draggable = true

local auraEnabled = false

button.MouseButton1Click:Connect(function()
    auraEnabled = not auraEnabled
    button.Text = auraEnabled and "Aura: ON" or "Aura: OFF"
end)

-- Aura visual
local function createAura(char)
    local root = char:WaitForChild("HumanoidRootPart")

    local part = Instance.new("Part")
    part.Shape = Enum.PartType.Ball
    part.Size = Vector3.new(12,12,12)
    part.Transparency = 0.7
    part.Anchored = false
    part.CanCollide = false
    part.Color = Color3.fromRGB(0,255,255)
    part.Parent = char

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = root
    weld.Part1 = part
    weld.Parent = part
end

-- Effect
local function slashEffect(pos)
    local p = Instance.new("Part")
    p.Size = Vector3.new(1,1,1)
    p.Anchored = true
    p.CanCollide = false
    p.Position = pos
    p.Parent = workspace

    game.Debris:AddItem(p, 0.2)
end

-- Main loop
task.spawn(function()
    while true do
        task.wait(TICK_RATE)

        if not auraEnabled then continue end

        local char = player.Character
        if not char then continue end

        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then continue end

        local region = Region3.new(
            root.Position - (HITBOX_SIZE/2),
            root.Position + (HITBOX_SIZE/2)
        )

        local parts = workspace:FindPartsInRegion3(region, char, math.huge)

        for _, part in pairs(parts) do
            local model = part:FindFirstAncestorOfClass("Model")

            if model
            and model ~= char
            and model:FindFirstChild("Humanoid")
            and model:FindFirstChild("IsNPC") then

                model.Humanoid:TakeDamage(DAMAGE)
                slashEffect(model.HumanoidRootPart.Position)
            end
        end
    end
end)

if player.Character then
    createAura(player.Character)
end

player.CharacterAdded:Connect(function(char)
    task.wait(1)
    createAura(char)
end)
