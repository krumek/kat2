local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local TweenService = game:GetService("TweenService")

-- Settings
local Settings = {
    AimBot = { Enabled = false, FOV = 90, Smoothness = 0.1, Key = Enum.KeyCode.R, Rainbow = true },
    Visuals = { ESPEnabled = false, Box = true, Tracer = true, RainbowESP = true, Animation = true },
    Rage = { SpinBotEnabled = false, SpinSpeed = 50, WallShotEnabled = false, BunnyHopEnabled = false },
    Funny = { Enabled = false, Key = Enum.KeyCode.F, SoundId = "rbxassetid://1842809352" },
    Binds = { ToggleMenu = {Enum.KeyCode.RightShift, Enum.KeyCode.Home} }
}

-- Instances
local Instances = { ESP = {}, Tracers = {}, DeathSounds = {}, KillBanners = {} }
local isRightMouseDown = false
local spinAngle = 0
local lastShot = tick()
local lastKill = tick()

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "KATXoneNeverLose"
ScreenGui.Enabled = false

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 300, 0, 400)
Frame.Position = UDim2.new(0.5, -150, 0.5, -200)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = Frame
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 255, 255)
UIStroke.Thickness = 1
UIStroke.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "NeverLose KAT"
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16

-- Femboy Image
local FemboyImage = Instance.new("ImageLabel")
FemboyImage.Parent = Frame
FemboyImage.Size = UDim2.new(0, 100, 0, 150)
FemboyImage.Position = UDim2.new(0.5, -50, 0, 40)
FemboyImage.BackgroundTransparency = 1
FemboyImage.Image = "rbxassetid://1842809352" -- Placeholder ID; replace with actual image ID

-- Tabs Setup
local TabContainer = Instance.new("Frame")
TabContainer.Parent = Frame
TabContainer.Size = UDim2.new(1, 0, 0, 30)
TabContainer.Position = UDim2.new(0, 0, 0, 30)
TabContainer.BackgroundTransparency = 1

local ESPTabButton = Instance.new("TextButton")
ESPTabButton.Parent = TabContainer
ESPTabButton.Size = UDim2.new(0.25, 0, 1, 0)
ESPTabButton.Position = UDim2.new(0, 0, 0, 0)
ESPTabButton.Text = "ESP"
ESPTabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ESPTabButton.TextColor3 = Color3.fromRGB(0, 255, 255)
ESPTabButton.Font = Enum.Font.SourceSans

local AimBotTabButton = Instance.new("TextButton")
AimBotTabButton.Parent = TabContainer
AimBotTabButton.Size = UDim2.new(0.25, 0, 1, 0)
AimBotTabButton.Position = UDim2.new(0.25, 0, 0, 0)
AimBotTabButton.Text = "AimBot"
AimBotTabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
AimBotTabButton.TextColor3 = Color3.fromRGB(0, 255, 255)
AimBotTabButton.Font = Enum.Font.SourceSans

local RageTabButton = Instance.new("TextButton")
RageTabButton.Parent = TabContainer
RageTabButton.Size = UDim2.new(0.25, 0, 1, 0)
RageTabButton.Position = UDim2.new(0.5, 0, 0, 0)
RageTabButton.Text = "Rage"
RageTabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
RageTabButton.TextColor3 = Color3.fromRGB(0, 255, 255)
RageTabButton.Font = Enum.Font.SourceSans

local FunnyTabButton = Instance.new("TextButton")
FunnyTabButton.Parent = TabContainer
FunnyTabButton.Size = UDim2.new(0.25, 0, 1, 0)
FunnyTabButton.Position = UDim2.new(0.75, 0, 0, 0)
FunnyTabButton.Text = "Funny"
FunnyTabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
FunnyTabButton.TextColor3 = Color3.fromRGB(0, 255, 255)
FunnyTabButton.Font = Enum.Font.SourceSans

-- Tab Content Frames
local ESPTab = Instance.new("Frame")
ESPTab.Parent = Frame
ESPTab.Size = UDim2.new(1, 0, 0, 200)
ESPTab.Position = UDim2.new(0, 0, 0, 190)
ESPTab.BackgroundTransparency = 1
ESPTab.Visible = true

local AimBotTab = Instance.new("Frame")
AimBotTab.Parent = Frame
AimBotTab.Size = UDim2.new(1, 0, 0, 200)
AimBotTab.Position = UDim2.new(0, 0, 0, 190)
AimBotTab.BackgroundTransparency = 1
AimBotTab.Visible = false

local RageTab = Instance.new("Frame")
RageTab.Parent = Frame
RageTab.Size = UDim2.new(1, 0, 0, 200)
RageTab.Position = UDim2.new(0, 0, 0, 190)
RageTab.BackgroundTransparency = 1
RageTab.Visible = false

local FunnyTab = Instance.new("Frame")
FunnyTab.Parent = Frame
FunnyTab.Size = UDim2.new(1, 0, 0, 200)
FunnyTab.Position = UDim2.new(0, 0, 0, 190)
FunnyTab.BackgroundTransparency = 1
FunnyTab.Visible = false

-- ESP Tab Content
local ESPToggleButton = Instance.new("TextButton")
ESPToggleButton.Parent = ESPTab
ESPToggleButton.Size = UDim2.new(0, 100, 0, 30)
ESPToggleButton.Position = UDim2.new(0, 10, 0, 10)
ESPToggleButton.Text = "ESP OFF"
ESPToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ESPToggleButton.TextColor3 = Color3.fromRGB(0, 255, 255)
ESPToggleButton.Font = Enum.Font.SourceSans

-- AimBot Tab Content
local AimBotToggleButton = Instance.new("TextButton")
AimBotToggleButton.Parent = AimBotTab
AimBotToggleButton.Size = UDim2.new(0, 100, 0, 30)
AimBotToggleButton.Position = UDim2.new(0, 10, 0, 10)
AimBotToggleButton.Text = "AimBot OFF"
AimBotToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
AimBotToggleButton.TextColor3 = Color3.fromRGB(0, 255, 255)
AimBotToggleButton.Font = Enum.Font.SourceSans

-- Rage Tab Content
local SpinBotToggleButton = Instance.new("TextButton")
SpinBotToggleButton.Parent = RageTab
SpinBotToggleButton.Size = UDim2.new(0, 100, 0, 30)
SpinBotToggleButton.Position = UDim2.new(0, 10, 0, 10)
SpinBotToggleButton.Text = "SpinBot OFF"
SpinBotToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SpinBotToggleButton.TextColor3 = Color3.fromRGB(0, 255, 255)
SpinBotToggleButton.Font = Enum.Font.SourceSans

-- Funny Tab Content
local FunnyToggleButton = Instance.new("TextButton")
FunnyToggleButton.Parent = FunnyTab
FunnyToggleButton.Size = UDim2.new(0, 100, 0, 30)
FunnyToggleButton.Position = UDim2.new(0, 10, 0, 10)
FunnyToggleButton.Text = "Funny OFF"
FunnyToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
FunnyToggleButton.TextColor3 = Color3.fromRGB(0, 255, 255)
FunnyToggleButton.Font = Enum.Font.SourceSans

-- Tab Switching Logic
local function switchTab(tab)
    ESPTab.Visible = false
    AimBotTab.Visible = false
    RageTab.Visible = false
    FunnyTab.Visible = false
    tab.Visible = true
end

ESPTabButton.MouseButton1Click:Connect(function() switchTab(ESPTab) end)
AimBotTabButton.MouseButton1Click:Connect(function() switchTab(AimBotTab) end)
RageTabButton.MouseButton1Click:Connect(function() switchTab(RageTab) end)
FunnyTabButton.MouseButton1Click:Connect(function() switchTab(FunnyTab) end)

-- Kill Banner (Valorant Style)
local function createKillBanner(victimName, headshot)
    local banner = Instance.new("Frame")
    banner.Parent = ScreenGui
    banner.Size = UDim2.new(0, 300, 0, 80)
    banner.Position = UDim2.new(0.5, -150, 0, 50)
    banner.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    banner.BackgroundTransparency = 0.2
    local bannerCorner = Instance.new("UICorner")
    bannerCorner.CornerRadius = UDim.new(0, 8)
    bannerCorner.Parent = banner
    local bannerStroke = Instance.new("UIStroke")
    bannerStroke.Color = Color3.fromRGB(255, 255, 255)
    bannerStroke.Thickness = 1
    bannerStroke.Parent = banner

    local killText = Instance.new("TextLabel")
    killText.Parent = banner
    killText.Size = UDim2.new(1, 0, 0.5, 0)
    killText.Position = UDim2.new(0, 0, 0, 0)
    killText.BackgroundTransparency = 1
    killText.Text = headshot and "HEADSHOT" or "ELIMINATED"
    killText.TextColor3 = Color3.fromRGB(255, 255, 255)
    killText.Font = Enum.Font.SourceSansBold
    killText.TextSize = 20

    local victimText = Instance.new("TextLabel")
    victimText.Parent = banner
    victimText.Size = UDim2.new(1, 0, 0.5, 0)
    victimText.Position = UDim2.new(0, 0, 0.5, 0)
    victimText.BackgroundTransparency = 1
    victimText.Text = victimName
    victimText.TextColor3 = Color3.fromRGB(255, 255, 255)
    victimText.Font = Enum.Font.SourceSans
    victimText.TextSize = 16

    local soundId = headshot and "rbxassetid://9119643780" or "rbxassetid://9120251711"
    local sound = Instance.new("Sound")
    sound.Parent = SoundService
    sound.SoundId = soundId
    sound.Volume = 1
    sound:Play()
    sound.Ended:Connect(function() sound:Destroy() end)

    TweenService:Create(banner, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
    wait(2)
    TweenService:Create(banner, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    wait(0.5)
    banner:Destroy()
end

-- Monitor Kills
RunService.RenderStepped:Connect(function()
    if tick() - lastKill < 0.5 then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health <= 0 then
            if Instances.DeathSounds[player] and not Instances.KillBanners[player] then
                lastKill = tick()
                Instances.KillBanners[player] = true
                local headshot = math.random(1, 2) == 1
                createKillBanner(player.Name, headshot)
                player.CharacterAdded:Connect(function()
                    Instances.KillBanners[player] = nil
                end)
            end
        end
    end
end)

-- ESP Logic
local function createESP(player)
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.fromRGB(0, 255, 0)
    box.Thickness = 1
    box.Filled = false

    local tracer = Drawing.new("Line")
    tracer.Visible = false
    tracer.Color = Color3.fromRGB(255, 0, 0)
    tracer.Thickness = 2

    Instances.ESP[player] = { box = box, tracer = tracer }
    player.CharacterAdded:Connect(function()
        if Instances.ESP[player] then
            box.Visible = false
            tracer.Visible = false
        end
    end)
end

RunService.RenderStepped:Connect(function()
    if Settings.Visuals.ESPEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if not Instances.ESP[player] and player ~= LocalPlayer then
                createESP(player)
            end
            local esp = Instances.ESP[player]
            if esp and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                local rootPart = player.Character.HumanoidRootPart
                local head = player.Character:FindFirstChild("Head")
                local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)

                if onScreen and player ~= LocalPlayer then
                    local pos = Camera:WorldToViewportPoint(head.Position)
                    local size = (Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0)) - pos).Y
                    local width = size / 2

                    if Settings.Visuals.Box then
                        esp.box.Size = Vector2.new(width, size)
                        esp.box.Position = Vector2.new(pos.X - width / 2, pos.Y - size)
                        esp.box.Visible = true
                        if Settings.Visuals.RainbowESP then
                            esp.box.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                        end
                    else
                        esp.box.Visible = false
                    end

                    if Settings.Visuals.Tracer then
                        esp.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        esp.tracer.To = Vector2.new(pos.X, pos.Y + size / 2)
                        esp.tracer.Visible = true
                        if Settings.Visuals.RainbowESP then
                            esp.tracer.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                        end
                    else
                        esp.tracer.Visible = false
                    end
                else
                    esp.box.Visible = false
                    esp.tracer.Visible = false
                end
            end
        end
    else
        for _, esp in pairs(Instances.ESP) do
            esp.box.Visible = false
            esp.tracer.Visible = false
        end
    end

    if Settings.AimBot.Enabled and isRightMouseDown and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local target = nil
        local minDistance = Settings.AimBot.FOV

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") and player.Character.Humanoid.Health > 0 then
                local headPos = Camera:WorldToViewportPoint(player.Character.Head.Position)
                local distance = (Vector2.new(headPos.X, headPos.Y) - Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)).Magnitude
                if distance < minDistance then
                    minDistance = distance
                    target = player.Character.Head
                end
            end
        end

        if target and Settings.AimBot.Rainbow then
            local color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position) * CFrame.Angles(0, math.rad(math.random(-5, 5)), 0)
            TweenService:Create(Camera, TweenInfo.new(Settings.AimBot.Smoothness), {CFrame = CFrame.new(Camera.CFrame.Position, target.Position) * CFrame.Angles(0, 0, math.random(-0.1, 0.1))}):Play()
        elseif target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position) * CFrame.Angles(0, 0, 0)
            TweenService:Create(Camera, TweenInfo.new(Settings.AimBot.Smoothness), {CFrame = CFrame.new(Camera.CFrame.Position, target.Position)}):Play()
        end
    end

    if Settings.Rage.SpinBotEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = LocalPlayer.Character.HumanoidRootPart
        spinAngle = spinAngle + math.rad(Settings.Rage.SpinSpeed)
        rootPart.CFrame = CFrame.new(rootPart.Position) * CFrame.Angles(0, spinAngle, 0)
        if Camera.CameraType ~= Enum.CameraType.FirstPerson then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position) * CFrame.Angles(0, spinAngle, 0)
        end
    end
end)

-- Bullet Tracers
local function createBulletTracer(startPos, endPos)
    local arrow = Instance.new("Part")
    arrow.Parent = workspace
    arrow.Size = Vector3.new(0.2, 0.2, (startPos - endPos).Magnitude)
    arrow.CFrame = CFrame.lookAt(startPos, endPos) * CFrame.new(0, 0, -arrow.Size.Z / 2)
    arrow.Material = Enum.Material.Neon
    arrow.Color = Color3.fromRGB(255, 0, 0)
    arrow.Anchored = true
    spawn(function()
        for i = 0, 1, 0.1 do
            arrow.Transparency = i
            wait(0.05)
        end
        arrow:Destroy()
    end)
end

RunService.RenderStepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Tool") then
        local tool = LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
        local fireSound = tool:FindFirstChild("Fire", true)
        if fireSound and fireSound.IsPlaying and tick() - lastShot > 0.1 then
            lastShot = tick()
            local startPos = tool:FindFirstChild("Handle") and tool.Handle.Position or LocalPlayer.Character.HumanoidRootPart.Position
            local ray = Ray.new(startPos, Camera.CFrame.LookVector * 1000)
            local hit, endPos = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character})
            local sound = Instance.new("Sound")
            sound.Parent = tool
            sound.SoundId = "rbxassetid://136752129"
            sound.Volume = 1
            sound:Play()
            sound.Ended:Connect(function() sound:Destroy() end)
            if hit then
                createBulletTracer(startPos, endPos)
            else
                createBulletTracer(startPos, startPos + Camera.CFrame.LookVector * 1000)
            end
        end
    end
end)

-- Death Sound
local function setupDeathSound(player)
    if Instances.DeathSounds[player] then
        Instances.DeathSounds[player]:Destroy()
    end
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end

    local deathSound = Instance.new("Sound")
    deathSound.Parent = humanoid
    deathSound.SoundId = "rbxassetid://1837829147"
    deathSound.Volume = 1
    deathSound.Name = "DeathMoan"

    humanoid.HealthChanged:Connect(function(health)
        if health <= 0 and not deathSound.IsPlaying then
            deathSound:Play()
            wait(2)
            deathSound:Destroy()
            Instances.DeathSounds[player] = nil
        end
    end)

    Instances.DeathSounds[player] = deathSound

    player.CharacterAdded:Connect(function(newCharacter)
        setupDeathSound(player)
    end)
end

for _, player in ipairs(Players:GetPlayers()) do
    setupDeathSound(player)
end
Players.PlayerAdded:Connect(setupDeathSound)

-- Funny Function
local function toggleFunny()
    Settings.Funny.Enabled = not Settings.Funny.Enabled
    FunnyToggleButton.Text = Settings.Funny.Enabled and "Funny ON" or "Funny OFF"
    if Settings.Funny.Enabled then
        local funnySound = Instance.new("Sound")
        funnySound.Parent = SoundService
        funnySound.SoundId = Settings.Funny.SoundId
        funnySound.Volume = 1
        funnySound:Play()
        funnySound.Ended:Connect(function()
            funnySound:Destroy()
            Settings.Funny.Enabled = false
            FunnyToggleButton.Text = "Funny OFF"
        end)
    end
end

-- Input Handling
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        isRightMouseDown = true
    elseif table.find(Settings.Binds.ToggleMenu, input.KeyCode) then
        ScreenGui.Enabled = not ScreenGui.Enabled
    elseif input.KeyCode == Settings.AimBot.Key then
        Settings.AimBot.Enabled = not Settings.AimBot.Enabled
        AimBotToggleButton.Text = Settings.AimBot.Enabled and "AimBot ON" or "AimBot OFF"
    elseif input.KeyCode == Settings.Funny.Key then
        toggleFunny()
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        isRightMouseDown = false
    end
end)

-- Toggle Buttons
ESPToggleButton.MouseButton1Click:Connect(function()
    Settings.Visuals.ESPEnabled = not Settings.Visuals.ESPEnabled
    ESPToggleButton.Text = Settings.Visuals.ESPEnabled and "ESP ON" or "ESP OFF"
    if Settings.Visuals.Animation then
        local tween = TweenService:Create(ESPToggleButton, TweenInfo.new(0.3), {BackgroundColor3 = Settings.Visuals.ESPEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(30, 30,  tween:Play()
    end)
end)

AimBotToggleButton.MouseClick:1ButtonClick(function()
    Settings.AimBotEnabled = not Settings.AimBot
    AimBotToggleButton.Text = Settings.AimBotEnabled and "AimBot ON" or "AimBot OFF"
end)

SpinBotToggleButton.MouseButton1Click(function()
    Settings.Rage.SpinBotEnabled = not settings.Rage.SpinBotEnabled
    SpinBotToggleButton.Text = Settings.Rage.SpinBotEnabled and "SpinBot ON" or "SpinBot OFF"
end)

FunnyToggleButton.MouseButton1Click:Connect(function()
    toggleFunny()
end)

-- Watermark
local Watermark = Instance.new("TextLabel")
Watermark.Parent = ScreenGui
Watermark.Size = UDim2.new(0, 200, 0, 20)
Watermark.Position = UDim2.new(1, -210, 1, 0)
Watermark.BackgroundTransparency = 1
Watermark.TextColor3 Color3.fromRGB(0, 255, 255)
Watermark.Text = "NeverLose KAT - 05/06/2025"
Watermark.Font = Enum.Font.SourceSans
Watermark.TextSize = 14
