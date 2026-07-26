-- Lunar Tech Hub [Custom Optimized Build]
-- Native ScreenGui | Supports Mouse & Touch Dragging | Delta Compatible

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- ==========================================
-- SETTINGS & STATE
-- ==========================================
local Settings = {
    WalkSpeed = false,
    NoDashCooldown = false,
    KittyDash = false,
    OreoTech = false,
    SupaTech = false,
    KibaTech = false,
    K1ngTech = false,
    ReflexTech = false,
    InstantLethal = false,
    
    TechDistance = 4,
    ReflexRange = 15,
    SpeedValue = 25 -- Speed applied when WalkSpeed is toggled ON
}

-- Clean up old UI
if CoreGui:FindFirstChild("LunarTechHub") then
    CoreGui.LunarTechHub:Destroy()
end

-- ==========================================
-- UI CONSTRUCTION
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LunarTechHub"
ScreenGui.ResetOnSpawn = false
local success = pcall(function() ScreenGui.Parent = CoreGui end)
if not success then ScreenGui.Parent = player:WaitForChild("PlayerGui") end

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 420)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(60, 60, 80)
UIStroke.Thickness = 1
UIStroke.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = Header

local HeaderSquare = Instance.new("Frame")
HeaderSquare.Size = UDim2.new(1, 0, 0, 10)
HeaderSquare.Position = UDim2.new(0, 0, 1, -10)
HeaderSquare.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
HeaderSquare.BorderSizePixel = 0
HeaderSquare.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🌙 Lunar Tech Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Smooth Dragging Logic
local dragging, dragInput, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Scrolling Container
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -55)
Scroll.Position = UDim2.new(0, 10, 0, 45)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 2
Scroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 130)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Scroll

-- Toggle UI Function
local function CreateToggle(name, settingKey)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.Text = ""
    btn.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = btn
    
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 12, 0, 12)
    indicator.Position = UDim2.new(1, -25, 0.5, -6)
    indicator.BackgroundColor3 = Color3.fromRGB(255, 60, 60) -- Default Red
    
    local indCorner = Instance.new("UICorner")
    indCorner.CornerRadius = UDim.new(1, 0)
    indCorner.Parent = indicator
    indicator.Parent = btn

    btn.MouseButton1Click:Connect(function()
        Settings[settingKey] = not Settings[settingKey]
        local targetColor = Settings[settingKey] and Color3.fromRGB(60, 255, 100) or Color3.fromRGB(255, 60, 60)
        TweenService:Create(indicator, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
    end)
    
    btn.Parent = Scroll
end

-- Populate Toggles
CreateToggle("Speed Boost (25)", "WalkSpeed")
CreateToggle("Bypass Dash Cooldown", "NoDashCooldown")
CreateToggle("Kitty Dash (Q)", "KittyDash")
CreateToggle("Oreo Tech (Q)", "OreoTech")
CreateToggle("Supa Tech (Q)", "SupaTech")
CreateToggle("Kiba Tech (Q)", "KibaTech")
CreateToggle("K1ng Tech (Q)", "K1ngTech")
CreateToggle("Reflex Auto-Dodge", "ReflexTech")
CreateToggle("Boomy / Instant Lethal", "InstantLethal")


-- ==========================================
-- CORE TECH LOGIC
-- ==========================================

-- Bypass Dash Cooldown
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if Settings.NoDashCooldown and method == "FireServer" and tostring(self) == "Dash" then
        return -- Intercept and drop the remote to prevent server cooldown triggers
    end
    return oldNamecall(self, ...)
end)

-- Utility: Get closest enemy
local function getClosestEnemy()
    local closestDist = math.huge
    local closestTarget = nil
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (char.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
            if dist < closestDist then
                closestDist = dist
                closestTarget = v.Character
            end
        end
    end
    return closestTarget, closestDist
end

-- Main Combat Loop (Heartbeat for max efficiency)
RunService.Heartbeat:Connect(function()
    local char = player.Character
    if not char or not char:FindFirstChild("Humanoid") or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hum = char.Humanoid
    local hrp = char.HumanoidRootPart

    -- Speed Modifier
    if Settings.WalkSpeed then
        hum.WalkSpeed = Settings.SpeedValue
    end

    -- Reflex Tech (Passive Dodge)
    if Settings.ReflexTech then
        local enemy, dist = getClosestEnemy()
        if enemy and dist <= Settings.ReflexRange then
            local enemyHRP = enemy:FindFirstChild("HumanoidRootPart")
            if enemyHRP and enemyHRP.AssemblyLinearVelocity.Magnitude > 25 then
                -- Snap 5 studs to the right of current vector to dodge
                hrp.CFrame = hrp.CFrame * CFrame.new(-5, 0, 0)
            end
        end
    end

    -- Instant Lethal Targeting (Passive Lock)
    if Settings.InstantLethal then
        local target = mouse.Target
        if target and target.Parent:FindFirstChild("Humanoid") then
            local enemyHRP = target.Parent:FindFirstChild("HumanoidRootPart")
            if enemyHRP then
                -- Glue to their back
                hrp.CFrame = enemyHRP.CFrame * CFrame.new(0, 0, 3) 
            end
        end
    end
end)

-- Active Techs (Fired on Dash Input)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Q then
        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hrp = char.HumanoidRootPart

        if Settings.KittyDash then
            hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -Settings.TechDistance)
        end
        
        if Settings.OreoTech then
            hrp.CFrame = hrp.CFrame * CFrame.new(-3, 0, -3)
        end

        if Settings.SupaTech then
            hrp.CFrame = hrp.CFrame * CFrame.new(0, 1.5, -4)
            hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 30, hrp.AssemblyLinearVelocity.Z)
        end

        if Settings.K1ngTech then
            local enemy, dist = getClosestEnemy()
            if enemy and dist < 20 then
                local enemyHRP = enemy:FindFirstChild("HumanoidRootPart")
                if enemyHRP then
                    hrp.CFrame = enemyHRP.CFrame * CFrame.new(2, 0, 2)
                end
            end
        end

        if Settings.KibaTech then
            -- Fake forward dash into rapid retreat
            hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, 2)
            task.delay(0.05, function()
                if char and hrp then
                    hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -5)
                end
            end)
        end
    end
end)
