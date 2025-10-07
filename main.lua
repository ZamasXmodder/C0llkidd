-- Procedural Neon Playground GUI
-- Every spawn rebuilds a completely new interactive control surface with randomized aesthetics

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local randomizer = Random.new(tick())

local adjectives = {"Quantum", "Neon", "Cyber", "Retro", "Liquid", "Plasma", "Hypno", "Astro", "Flux"}
local nouns = {"Cascade", "Pulse", "Orbit", "Bloom", "Drift", "Glyph", "Storm", "Echo", "Spiral"}

local function randomColor()
        return Color3.fromHSV(randomizer:NextNumber(), 0.7 + randomizer:NextNumber() * 0.3, 0.6 + randomizer:NextNumber() * 0.4)
end

local function randomChoice(array)
        return array[randomizer:NextInteger(1, #array)]
end

local function emitBillboardBurst(screenGui)
        local character = player.Character or player.CharacterAdded:Wait()
        local root = character:FindFirstChild("HumanoidRootPart")
        if not root then return end

        local attachment = Instance.new("Attachment")
        attachment.Parent = root

        local emitter = Instance.new("ParticleEmitter")
        emitter.Name = "BurstEmitter"
        emitter.Texture = "rbxassetid://7482231478"
        emitter.Color = ColorSequence.new(randomColor(), randomColor())
        emitter.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1.5),
                NumberSequenceKeypoint.new(0.5, 3),
                NumberSequenceKeypoint.new(1, 0.5)
        })
        emitter.Lifetime = NumberRange.new(0.6, 1.2)
        emitter.Speed = NumberRange.new(4, 8)
        emitter.Rate = 200
        emitter.RotSpeed = NumberRange.new(-120, 120)
        emitter.SpreadAngle = Vector2.new(360, 360)
        emitter.EmissionDirection = Enum.NormalId.Top
        emitter.Parent = attachment

        Debris:AddItem(attachment, 2)
        emitter:Emit(80)
end

local function createNeonTotems()
        local origin = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not origin then return end

        for _ = 1, randomizer:NextInteger(6, 10) do
                local part = Instance.new("Part")
                part.Size = Vector3.new(1, randomizer:NextNumber(10, 20), 1)
                part.Anchored = true
                part.CanCollide = false
                part.Material = Enum.Material.Neon
                part.Color = randomColor()

                local radius = randomizer:NextNumber(12, 24)
                local angle = randomizer:NextNumber() * math.pi * 2
                part.CFrame = origin.CFrame * CFrame.new(math.cos(angle) * radius, -origin.Size.Y / 2, math.sin(angle) * radius)
                part.Parent = workspace
                Debris:AddItem(part, 12)

                TweenService:Create(part, TweenInfo.new(randomizer:NextNumber(4, 6), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
                        CFrame = part.CFrame * CFrame.new(0, randomizer:NextNumber(4, 10), 0)
                }):Play()
        end
end

local function summonEchoClones()
        local character = player.Character or player.CharacterAdded:Wait()
        if not character then return end

        for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                        local ghost = Instance.new("Part")
                        ghost.Size = part.Size
                        ghost.CFrame = part.CFrame
                        ghost.Anchored = true
                        ghost.CanCollide = false
                        ghost.Transparency = 0.5
                        ghost.Material = Enum.Material.Neon
                        ghost.Color = randomColor()
                        ghost.Parent = workspace
                        Debris:AddItem(ghost, 6)

                        TweenService:Create(ghost, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                                Transparency = 1,
                                Size = ghost.Size + Vector3.new(1, 1, 1)
                        }):Play()
                end
        end
end

local function synthPulse()
        local sound = Instance.new("Sound")
        sound.SoundId = randomChoice({
                "rbxassetid://1843521233",
                "rbxassetid://1837635164",
                "rbxassetid://1837637854"
        })
        sound.Volume = 0.5
        sound.PlaybackSpeed = randomizer:NextNumber(0.8, 1.2)
        sound.Parent = workspace
        sound:Play()
        Debris:AddItem(sound, 5)
end

local function spawnOrbitingRings()
        local character = player.Character or player.CharacterAdded:Wait()
        local root = character:FindFirstChild("HumanoidRootPart")
        if not root then return end

        for i = 1, 3 do
                local ring = Instance.new("Part")
                ring.Shape = Enum.PartType.Cylinder
                ring.Size = Vector3.new(0.2, randomizer:NextNumber(8, 12), randomizer:NextNumber(8, 12))
                ring.Color = randomColor()
                ring.Material = Enum.Material.Neon
                ring.Anchored = true
                ring.CanCollide = false
                ring.CFrame = root.CFrame * CFrame.Angles(math.pi / 2, 0, 0)
                ring.Parent = workspace
                Debris:AddItem(ring, 10)

                spawn(function()
                        local angle = randomizer:NextNumber() * math.pi * 2
                        local tilt = randomizer:NextNumber(-0.5, 0.5)
                        while ring.Parent do
                                angle += RunService.Heartbeat:Wait() * randomizer:NextNumber(1.5, 3.5)
                                local offset = CFrame.Angles(tilt, angle, 0)
                                ring.CFrame = root.CFrame * CFrame.new(0, i * 0.6, 0) * offset
                        end
                end)
        end
end

local function scatterPlasmaSprites(screenGui)
        for _ = 1, randomizer:NextInteger(6, 12) do
                local sprite = Instance.new("ImageLabel")
                sprite.Image = "rbxassetid://7485086786"
                sprite.BackgroundTransparency = 1
                sprite.Size = UDim2.new(0, randomizer:NextInteger(60, 120), 0, randomizer:NextInteger(60, 120))
                sprite.Position = UDim2.new(randomizer:NextNumber(), -60, randomizer:NextNumber(), -60)
                sprite.ImageColor3 = randomColor()
                sprite.ImageTransparency = 0.6
                sprite.ZIndex = 50
                sprite.Parent = screenGui

                Debris:AddItem(sprite, 5)

                TweenService:Create(sprite, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                        ImageTransparency = 1,
                        Position = sprite.Position + UDim2.new(randomizer:NextNumber(-0.05, 0.05), 0, randomizer:NextNumber(-0.05, 0.05), 0)
                }):Play()
        end
end

local effects -- forward declaration

local function buildInterface()
        local existingGui = playerGui:FindFirstChild("NeonPlaygroundGui")
        if existingGui then
                existingGui:Destroy()
        end

        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "NeonPlaygroundGui"
        screenGui.ResetOnSpawn = false
        screenGui.IgnoreGuiInset = true
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui.Parent = playerGui

        local stageFrame = Instance.new("Frame")
        stageFrame.Name = "Stage"
        stageFrame.Size = UDim2.new(0.5, randomizer:NextInteger(-40, 60), 0.55, randomizer:NextInteger(-40, 80))
        stageFrame.Position = UDim2.new(0.25, randomizer:NextInteger(-60, 60), 0.2, randomizer:NextInteger(-40, 40))
        stageFrame.BackgroundColor3 = randomColor()
        stageFrame.BorderSizePixel = 0
        stageFrame.BackgroundTransparency = 0.05
        stageFrame.Parent = screenGui

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 22)
        corner.Parent = stageFrame

        local stageGradient = Instance.new("UIGradient")
        stageGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, randomColor()),
                ColorSequenceKeypoint.new(0.5, randomColor()),
                ColorSequenceKeypoint.new(1, randomColor()),
        })
        stageGradient.Rotation = randomizer:NextInteger(0, 360)
        stageGradient.Parent = stageFrame

        spawn(function()
                local rotation = stageGradient.Rotation
                while stageFrame.Parent do
                        rotation += 0.25
                        stageGradient.Rotation = rotation
                        RunService.Heartbeat:Wait()
                end
        end)

        local header = Instance.new("TextLabel")
        header.Name = "Title"
        header.Size = UDim2.new(1, -40, 0, 48)
        header.Position = UDim2.new(0, 20, 0, 16)
        header.BackgroundTransparency = 1
        header.TextColor3 = Color3.new(1, 1, 1)
        header.Font = Enum.Font.GothamBlack
        header.TextScaled = true
        header.TextWrapped = true
        header.Text = randomChoice({
                "NEON PLAYGROUND",
                "CHAOS PATCHER",
                "STOCHASTIC SUITE",
                "GLITCH ALCHEMY",
                "RANDOMIZER 5000"
        })
        header.Parent = stageFrame

        local wobbleConnection
        wobbleConnection = RunService.Heartbeat:Connect(function()
                if not header.Parent then
                        wobbleConnection:Disconnect()
                        return
                end
                local t = tick()
                header.Rotation = math.sin(t * 2.5) * 2.5
                header.Position = UDim2.new(0, 20 + math.sin(t * 1.8) * 8, 0, 16 + math.cos(t * 1.5) * 6)
        end)

        local buttonHolder = Instance.new("Frame")
        buttonHolder.Name = "ButtonHolder"
        buttonHolder.BackgroundTransparency = 1
        buttonHolder.Size = UDim2.new(1, -40, 1, -120)
        buttonHolder.Position = UDim2.new(0, 20, 0, 80)
        buttonHolder.Parent = stageFrame

        local grid = Instance.new("UIGridLayout")
        grid.CellPadding = UDim2.new(0, 8, 0, 8)
        grid.CellSize = UDim2.new(0.3, 0, 0, randomizer:NextInteger(56, 72))
        grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
        grid.VerticalAlignment = Enum.VerticalAlignment.Top
        grid.SortOrder = Enum.SortOrder.LayoutOrder
        grid.Parent = buttonHolder

        local shimmer = Instance.new("Frame")
        shimmer.Name = "Shimmer"
        shimmer.AnchorPoint = Vector2.new(0.5, 0.5)
        shimmer.Size = UDim2.new(1.3, 0, 1.3, 0)
        shimmer.Position = UDim2.new(0.5, 0, 0.5, 0)
        shimmer.BackgroundColor3 = Color3.new(1, 1, 1)
        shimmer.BackgroundTransparency = 0.8
        shimmer.ZIndex = stageFrame.ZIndex - 1
        shimmer.Parent = stageFrame

        local shimmerGradient = Instance.new("UIGradient")
        shimmerGradient.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.2, 0.1),
                NumberSequenceKeypoint.new(0.8, 0.1),
                NumberSequenceKeypoint.new(1, 1)
        })
        shimmerGradient.Parent = shimmer

        spawn(function()
                local sizePulse = 0
                while shimmer.Parent do
                        sizePulse += RunService.Heartbeat:Wait()
                        shimmer.Rotation = shimmer.Rotation + 0.5
                        local scale = 1.1 + math.sin(sizePulse) * 0.15
                        shimmer.Size = UDim2.new(scale, 0, scale, 0)
                end
        end)

        local usedLabels = {}
        local function uniqueButtonLabel(base)
                        local label = base
                        local counter = 2
                        while usedLabels[label] do
                                label = base .. " " .. counter
                                counter += 1
                        end
                        usedLabels[label] = true
                        return label
        end

        local function createButton(text, callback)
                local button = Instance.new("TextButton")
                button.Name = text
                button.Text = text
                button.Size = UDim2.new(0, 120, 0, 60)
                button.TextScaled = true
                button.Font = Enum.Font.GothamBold
                button.BackgroundColor3 = randomColor()
                button.TextColor3 = Color3.new(0, 0, 0)
                button.AutoButtonColor = false
                button.Parent = buttonHolder

                local uiCorner = Instance.new("UICorner")
                uiCorner.CornerRadius = UDim.new(0, 12)
                uiCorner.Parent = button

                local shadow = Instance.new("ImageLabel")
                shadow.Name = "Shadow"
                shadow.ZIndex = button.ZIndex - 1
                shadow.Size = UDim2.new(1, 12, 1, 12)
                shadow.Position = UDim2.new(0, -6, 0, -4)
                shadow.BackgroundTransparency = 1
                shadow.Image = "rbxassetid://1316045217"
                shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
                shadow.ImageTransparency = 0.45
                shadow.ScaleType = Enum.ScaleType.Slice
                shadow.SliceCenter = Rect.new(10, 10, 118, 118)
                shadow.Parent = button

                button.MouseEnter:Connect(function()
                        TweenService:Create(button, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                                BackgroundColor3 = randomColor(),
                                TextColor3 = Color3.new(1, 1, 1)
                        }):Play()
                end)

                button.MouseLeave:Connect(function()
                        TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                                BackgroundColor3 = randomColor(),
                                TextColor3 = Color3.new(0, 0, 0)
                        }):Play()
                end)

                button.MouseButton1Click:Connect(function()
                        callback()
                        TweenService:Create(button, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                                Rotation = randomizer:NextInteger(-6, 6),
                                Size = UDim2.new(button.Size.X.Scale, button.Size.X.Offset + randomizer:NextInteger(-6, 6), button.Size.Y.Scale, button.Size.Y.Offset + randomizer:NextInteger(-6, 6))
                        }):Play()
                end)

                return button
        end

        for _, effect in ipairs(effects) do
                if randomizer:NextBoolean() then
                        local label = uniqueButtonLabel(randomChoice(adjectives) .. " " .. randomChoice(nouns))
                        createButton(label, function()
                                effect.action(screenGui)
                        end)
                end
        end

        local function hasEffectButton()
                for _, child in ipairs(buttonHolder:GetChildren()) do
                        if child:IsA("TextButton") then
                                return true
                        end
                end
                return false
        end

        if not hasEffectButton() then
                createButton(uniqueButtonLabel("Quantum Pulse"), function()
                        emitBillboardBurst(screenGui)
                        scatterPlasmaSprites(screenGui)
                        synthPulse()
                end)
        end

        createButton("Regenerate", function()
                buildInterface()
        end)

        local keyboardConnection
        keyboardConnection = player:GetMouse().KeyDown:Connect(function(key)
                if key:lower() == "f" then
                        for _, effect in ipairs(effects) do
                                effect.action(screenGui)
                        end
                end
        end)

        screenGui.AncestryChanged:Connect(function(_, parent)
                if not parent and keyboardConnection then
                        keyboardConnection:Disconnect()
                end
        end)

        spawn(function()
                local originalAmbient = Lighting.Ambient
                local originalOutdoor = Lighting.OutdoorAmbient
                while screenGui.Parent do
                        Lighting.Ambient = randomColor()
                        Lighting.OutdoorAmbient = randomColor()
                        wait(3)
                end
                Lighting.Ambient = originalAmbient
                Lighting.OutdoorAmbient = originalOutdoor
        end)

        return screenGui
end

effects = {
        { name = "Emit Echo", action = function(gui)
                        summonEchoClones()
                        synthPulse()
                end },
        { name = "Totem Rain", action = function(gui)
                        createNeonTotems()
                        synthPulse()
                end },
        { name = "Orbit Flux", action = function(gui)
                        spawnOrbitingRings()
                        synthPulse()
                end },
        { name = "Particle Bloom", action = function(gui)
                        emitBillboardBurst(gui)
                        scatterPlasmaSprites(gui)
                end },
        { name = "Plasma Scatter", action = function(gui)
                        scatterPlasmaSprites(gui)
                        synthPulse()
                end }
}

return buildInterface()
