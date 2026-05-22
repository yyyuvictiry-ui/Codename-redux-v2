-- Fast Stamina + ESP for Codename: Redux
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Fast Stamina Regen
spawn(function()
    while wait(0.1) do
        pcall(function()
            local stamina = LocalPlayer:FindFirstChild("Stamina") 
                or LocalPlayer.Character:FindFirstChild("Stamina")
                or LocalPlayer.Character:FindFirstChild("StaminaValue")
            
            if stamina and stamina.Value < stamina.MaxValue then
                stamina.Value = math.min(stamina.Value + 10, stamina.MaxValue)
            end
        end)
    end
end)

-- ESP Player
local function createESP(player)
    if player == LocalPlayer then return end
    
    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Filled = false
    
    local function updateColor()
        local role = player:GetAttribute("Role") or "Neutral"
        
        if role == "Killer" then
            box.Color = Color3.fromRGB(255, 0, 0) -- Merah
        elseif role == "Survivor" then
            box.Color = Color3.fromRGB(0, 170, 255) -- Biru
        else
            box.Color = Color3.fromRGB(255, 165, 0) -- Orange
        end
    end
    
    updateColor()
    player.AttributeChanged:Connect(updateColor)
    
    game:GetService("RunService").RenderStepped:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
            if player.Character.Humanoid.Health > 0 then
                local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                if onScreen then
                    box.Visible = true
                    box.Size = Vector2.new(50, 70)
                    box.Position = Vector2.new(pos.X - 25, pos.Y - 35)
                else
                    box.Visible = false
                end
            else
                box.Visible = false
            end
        else
            box.Visible = false
        end
    end)
end

for _, player in pairs(Players:GetPlayers()) do
    createESP(player)
end

Players.PlayerAdded:Connect(createESP)
