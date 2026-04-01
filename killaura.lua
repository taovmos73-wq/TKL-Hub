--// SETTINGS
local RANGE = 10 -- bán kính đánh
local DAMAGE = 25
local TICK_RATE = 0.1 -- chậm lại để không bug

local Players = game:GetService("Players")
local player = Players.LocalPlayer

--// UI
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

--// AURA VISUAL
local function createAura(char)
    local root = char:WaitForChild("HumanoidRootPart")

    local part = Instance.new("Part")
    part.Shape = Enum.PartType.Ball
    part.Size = Vector3.new(RANGE*2, RANGE*2, RANGE*2)
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

--// EFFECT
local function slashEffect(pos)
    local p = Instance.new("Part")
    p.Size = Vector3.new(1,1,1)
    p.Anchored = true
    p.CanCollide = false
    p.Position = pos
    p.BrickColor = BrickColor.new("Bright blue")
    p.Parent = workspace

    game:GetService("Debris"):AddItem(p, 0.2)
end

--// ATTACK FUNCTION (KHÔNG XUYÊN TƯỜNG)
local function attack()
    local char = player.Character
    if not char then return end

    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for _, model in pairs(workspace:GetChildren()) do
        if model:IsA("Model")
        and model ~= char
        and model:FindFirstChild("Humanoid")
        and model:FindFirstChild("HumanoidRootPart")
        and model:FindFirstChild("IsNPC") then

            local targetRoot = model.HumanoidRootPart
            local dist = (root.Position - targetRoot.Position).Magnitude

            if dist <= RANGE then
                model.Humanoid:TakeDamage(DAMAGE)
                slashEffect(targetRoot.Position)
            end
        end
    end
end

--// MAIN LOOP
task.spawn(function()
    while true do
        task.wait(TICK_RATE)

        if auraEnabled then
            attack()
        end
    end
end)

--// LOAD AURA
if player.Character then
    createAura(player.Character)
end

player.CharacterAdded:Connect(function(char)
    task.wait(1)
    createAura(char)
end)
