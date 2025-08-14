local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local lplr = Players.LocalPlayer


local Sundown = require(lplr.PlayerScripts.AI.Sunfish)


local Settings = {
    BotMode = "Smart",
    Delay = 3,
    PlayMode = "Auto",
}


local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KiopiAutoPlay"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = lplr:WaitForChild("PlayerGui")


local SettingsButton = Instance.new("TextButton")
SettingsButton.Size = UDim2.new(0, 100, 0, 35)
SettingsButton.Position = UDim2.new(0.9, 0, 0.85, 0)
SettingsButton.AnchorPoint = Vector2.new(0.5, 0.5)
SettingsButton.Text = "⚙ Settings"
SettingsButton.Font = Enum.Font.GothamBold
SettingsButton.TextColor3 = Color3.fromRGB(240, 240, 240)
SettingsButton.TextSize = 16
SettingsButton.BackgroundColor3 = Color3.fromRGB(130, 0, 0)
SettingsButton.BorderSizePixel = 0
SettingsButton.Parent = ScreenGui


local function makeDraggable(button)
    local dragging = false
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local startPos = input.Position
            local framePos = button.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
            UserInputService.InputChanged:Connect(function(changed)
                if changed == input and dragging then
                    local delta = changed.Position - startPos
                    local newX = math.clamp(framePos.X.Offset + delta.X, 20, 1900)
                    local newY = math.clamp(framePos.Y.Offset + delta.Y, 20, 1040)
                    button.Position = UDim2.new(framePos.X.Scale, newX, framePos.Y.Scale, newY)
                end
            end)
        end
    end)
end

makeDraggable(SettingsButton)


local Menu = Instance.new("Frame")
Menu.Size = UDim2.new(0, 240, 0, 280)  
Menu.Position = UDim2.new(0.5, -120, 0.35, -140)  
Menu.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Menu.BackgroundTransparency = 0
Menu.BorderSizePixel = 2
Menu.BorderColor3 = Color3.fromRGB(60, 60, 60)
Menu.Visible = false
Menu.ZIndex = 10
Menu.Parent = ScreenGui


local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.BorderSizePixel = 0
Title.Text = "TG: @kiopifan"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(240, 240, 240)
Title.TextSize = 18
Title.ZIndex = 10
Title.Parent = Menu


local ModeLabel = Instance.new("TextLabel")
ModeLabel.Size = UDim2.new(1, 0, 0, 25)
ModeLabel.Position = UDim2.new(0, 0, 0, 50)
ModeLabel.BackgroundTransparency = 1
ModeLabel.Text = "Bot Mode:"
ModeLabel.Font = Enum.Font.GothamBold
ModeLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
ModeLabel.TextSize = 16
ModeLabel.ZIndex = 10
ModeLabel.Parent = Menu

local BotModes = {"Off", "Easy", "Medium", "Smart"}
local ModeColors = {
    Off = Color3.fromRGB(220, 50, 50),
    Easy = Color3.fromRGB(220, 80, 80),
    Medium = Color3.fromRGB(200, 70, 70),
    Smart = Color3.fromRGB(180, 60, 60),
}

for i, mode in ipairs(BotModes) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, 0, 80 + (i-1)*32)  -- Компактнее
    btn.Text = mode
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = ModeColors[mode]
    btn.BorderSizePixel = 0
    btn.ZIndex = 10
    btn.Parent = Menu

    btn.MouseButton1Click:Connect(function()
        Settings.BotMode = mode
        SettingsButton.Text = mode == "Off" and "⚙ Settings" or mode
    end)
end


local PlayModeLabel = Instance.new("TextLabel")
PlayModeLabel.Size = UDim2.new(1, 0, 0, 25)
PlayModeLabel.Position = UDim2.new(0, 0, 0, 210)
PlayModeLabel.BackgroundTransparency = 1
PlayModeLabel.Text = "Play Mode:"
PlayModeLabel.Font = Enum.Font.GothamBold
PlayModeLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
PlayModeLabel.TextSize = 16
PlayModeLabel.ZIndex = 10
PlayModeLabel.Parent = Menu

local AutoBtn = Instance.new("TextButton")
AutoBtn.Size = UDim2.new(0.45, 0, 0, 28)
AutoBtn.Position = UDim2.new(0.05, 0, 0, 240)
AutoBtn.Text = "Auto"
AutoBtn.Font = Enum.Font.GothamBold
AutoBtn.TextColor3 = Color3.new(1, 1, 1)
AutoBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
AutoBtn.BorderSizePixel = 0
AutoBtn.ZIndex = 10
AutoBtn.Parent = Menu

local ClickBtn = Instance.new("TextButton")
ClickBtn.Size = UDim2.new(0.45, 0, 0, 28)
ClickBtn.Position = UDim2.new(0.52, 0, 0, 240)
ClickBtn.Text = "Click"
ClickBtn.Font = Enum.Font.GothamBold
ClickBtn.TextColor3 = Color3.new(1, 1, 1)
ClickBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
ClickBtn.BorderSizePixel = 0
ClickBtn.ZIndex = 10
ClickBtn.Parent = Menu


local function updatePlayMode()
    AutoBtn.BackgroundColor3 = Settings.PlayMode == "Auto" and Color3.fromRGB(0, 180, 220) or Color3.fromRGB(0, 130, 180)
    ClickBtn.BackgroundColor3 = Settings.PlayMode == "Click" and Color3.fromRGB(0, 180, 220) or Color3.fromRGB(0, 130, 180)
end

AutoBtn.MouseButton1Click:Connect(function()
    Settings.PlayMode = "Auto"
    updatePlayMode()
end)

ClickBtn.MouseButton1Click:Connect(function()
    Settings.PlayMode = "Click"
    updatePlayMode()
end)

updatePlayMode()


local DelayLabel = Instance.new("TextLabel")
DelayLabel.Size = UDim2.new(1, 0, 0, 25)
DelayLabel.Position = UDim2.new(0, 0, 0, 275)
DelayLabel.BackgroundTransparency = 1
DelayLabel.Text = "Delay:"
DelayLabel.Font = Enum.Font.GothamBold
DelayLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
DelayLabel.TextSize = 16
DelayLabel.ZIndex = 10
DelayLabel.Parent = Menu


for i = 1, 5 do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.18, 0, 0, 25)
    btn.Position = UDim2.new(0.05 + (i-1)*0.19, 0, 0, 305)
    btn.Text = i .. "s"
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = i == Settings.Delay and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(130, 0, 0)
    btn.BorderSizePixel = 0
    btn.ZIndex = 10
    btn.Parent = Menu

    btn.MouseButton1Click:Connect(function()
        Settings.Delay = i
        for _, b in ipairs(Menu:GetChildren()) do
            if b:IsA("TextButton") and tonumber(b.Text:match("%d+")) then
                b.BackgroundColor3 = tonumber(b.Text:match("%d+")) == i and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(130, 0, 0)
            end
        end
    end)
end


SettingsButton.MouseButton1Click:Connect(function()
    Menu.Visible = not Menu.Visible
end)


local MainButton = Instance.new("TextButton")
MainButton.Size = UDim2.new(0, 100, 0, 40)
MainButton.Position = UDim2.new(0.1, 0, 0.85, 0)
MainButton.AnchorPoint = Vector2.new(0.5, 0.5)
MainButton.Text = "Kiopi OFF"
MainButton.Font = Enum.Font.GothamBold
MainButton.TextColor3 = Color3.fromRGB(240, 240, 240)
MainButton.TextSize = 16
MainButton.BackgroundColor3 = Color3.fromRGB(130, 0, 0)
MainButton.BorderSizePixel = 0
MainButton.Parent = ScreenGui

makeDraggable(MainButton)


MainButton.MouseEnter:Connect(function()
    if not MainButton.Text:find("Wait") then
        TweenService:Create(MainButton, TweenInfo.new(0.3), {
            BackgroundColor3 = Color3.fromRGB(200, 0, 0);
            Size = UDim2.new(0, 110, 0, 44);
        }):Play()
    end
end)

MainButton.MouseLeave:Connect(function()
    if not MainButton.Text:find("Wait") then
        TweenService:Create(MainButton, TweenInfo.new(0.3), {
            BackgroundColor3 = Color3.fromRGB(130, 0, 0);
            Size = UDim2.new(0, 100, 0, 40);
        }):Play()
    end
end)


local isAutoRunning = false

MainButton.MouseButton1Click:Connect(function()
    if Settings.BotMode == "Off" then
        MainButton.Text = "OFF"
        isAutoRunning = false
        return
    end

    if Settings.PlayMode == "Auto" then
        if isAutoRunning then
            isAutoRunning = false
            MainButton.Text = "Kiopi OFF"
            TweenService:Create(MainButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(130, 0, 0);
            }):Play()
            return
        end

        isAutoRunning = true
        MainButton.Text = "ON"
        TweenService:Create(MainButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(0, 180, 100);
        }):Play()

        spawn(function()
            while isAutoRunning do
                for timeLeft = Settings.Delay, 1, -1 do
                    if not isAutoRunning then break end
                    MainButton.Text = "Wait " .. timeLeft
                    wait(1)
                end

                if not isAutoRunning then break end

                local analysisTime = 500
                if Settings.BotMode == "Medium" then analysisTime = 1500 end
                if Settings.BotMode == "Smart" then analysisTime = 3000 end

                local success, move = pcall(function()
                    local tableset = ReplicatedStorage.InternalClientEvents.GetActiveTableset:Invoke()
                    return Sundown:GetBestMove(tableset.FEN.Value, analysisTime)
                end)

                if success and move then
                    pcall(function()
                        ReplicatedStorage:WaitForChild("Chess"):WaitForChild("SubmitMove"):InvokeServer(tostring(move))
                    end)
                end

                MainButton.Text = "ON"
            end
        end)
    elseif Settings.PlayMode == "Click" then
        MainButton.Text = "Thinking..."
        spawn(function()
            local analysisTime = 500
            if Settings.BotMode == "Medium" then analysisTime = 1500 end
            if Settings.BotMode == "Smart" then analysisTime = 3000 end

            local success, move = pcall(function()
                local tableset = ReplicatedStorage.InternalClientEvents.GetActiveTableset:Invoke()
                return Sundown:GetBestMove(tableset.FEN.Value, analysisTime)
            end)

            if success and move then
                pcall(function()
                    ReplicatedStorage:WaitForChild("Chess"):WaitForChild("SubmitMove"):InvokeServer(tostring(move))
                end)
                MainButton.Text = "Click!"
                wait(0.8)
                MainButton.Text = "Kiopi ON"
            else
                MainButton.Text = "Error"
                wait(0.8)
                MainButton.Text = "Kiopi ON"
            end
        end)
    end
end)


spawn(function()
    while true do
        if Settings.PlayMode == "Click" and Settings.BotMode ~= "Off" then
            MainButton.Text = "Kiopi ON"
        elseif Settings.BotMode == "Off" then
            MainButton.Text = "Kiopi OFF"
        end
        wait(0.5)
    end
end)
