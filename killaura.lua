local remote = game.ReplicatedStorage:WaitForChild("AttackEvent")

local RANGE = 15
local BASE_DELAY = 0.1
local RANDOM_DELAY = 0.03

local player = game.Players.LocalPlayer

-- UI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local btn = Instance.new("TextButton", gui)

btn.Size = UDim2.new(0,150,0,45)
btn.Position = UDim2.new(0,20,0,200)
btn.Text = "AUTO FARM: OFF"
btn.Draggable = true

local enabled = false

btn.MouseButton1Click:Connect(function()
    enabled = not enabled
    btn.Text = enabled and "AUTO FARM: ON" or "AUTO FARM: OFF"
end)

-- Auto attack
task.spawn(function()
    while true do
        task.wait(BASE_DELAY + math.random() * RANDOM_DELAY)

        if not enabled then continue end

        local char = player.Character
        if not char then continue end

        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then continue end

        for _, npc in pairs(workspace:GetChildren()) do
            if npc:FindFirstChild("Humanoid")
            and npc:FindFirstChild("HumanoidRootPart")
            and npc:FindFirstChild("IsNPC") then

                local dist = (root.Position - npc.HumanoidRootPart.Position).Magnitude

                if dist <= RANGE then
                    remote:FireServer(npc)
                end
            end
        end
    end
end)
