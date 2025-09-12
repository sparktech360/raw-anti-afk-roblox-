wait(0.5)
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local vu = game:GetService("VirtualUser")
local lp = Players.LocalPlayer

-- Variables
local running = true
local hidden = false
local hotkey = Enum.KeyCode.H
local listeningForHotkey = false

-- Color scheme
local themeColor = Color3.fromRGB(25, 25, 112) -- Midnight Blue (buttons)
local bgColor = Color3.fromRGB(15, 15, 15) -- Black shade (background)
local textColor = Color3.fromRGB(30, 144, 255) -- Dodger Blue (status text)

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Page 1 (Main Bar)
local bar = Instance.new("Frame")
bar.Parent = gui
bar.Active = true
bar.BackgroundColor3 = bgColor
bar.Draggable = true
bar.Position = UDim2.new(0.5, -90, 0, 0)
bar.Size = UDim2.new(0, 180, 0, 30)

local status = Instance.new("TextLabel")
status.Parent = bar
status.BackgroundTransparency = 1
status.Size = UDim2.new(0.5, 0, 1, 0)
status.Font = Enum.Font.ArialBold
status.Text = "Anti AFK: Active"
status.TextColor3 = textColor
status.TextSize = 12
status.TextXAlignment = Enum.TextXAlignment.Left

local stopBtn = Instance.new("TextButton")
stopBtn.Parent = bar
stopBtn.Size = UDim2.new(0.2, 0, 1, 0)
stopBtn.Position = UDim2.new(0.8, 0, 0, 0)
stopBtn.BackgroundColor3 = themeColor
stopBtn.Font = Enum.Font.ArialBold
stopBtn.Text = "X"
stopBtn.TextColor3 = Color3.new(0, 0, 0)
stopBtn.TextSize = 14

local settingsBtn = Instance.new("TextButton")
settingsBtn.Parent = bar
settingsBtn.Size = UDim2.new(0.3, 0, 1, 0)
settingsBtn.Position = UDim2.new(0.5, 0, 0, 0)
settingsBtn.BackgroundColor3 = themeColor
settingsBtn.Font = Enum.Font.ArialBold
settingsBtn.Text = "⚙"
settingsBtn.TextColor3 = Color3.new(0, 0, 0)
settingsBtn.TextSize = 14

-- Page 2 (Settings)
local settingsPage = Instance.new("Frame")
settingsPage.Parent = gui
settingsPage.BackgroundColor3 = bgColor
settingsPage.Position = UDim2.new(0.7, 0, 0.15, 0)
settingsPage.Size = UDim2.new(0, 200, 0, 100)
settingsPage.Visible = false

local hotkeyLabel = Instance.new("TextLabel")
hotkeyLabel.Parent = settingsPage
hotkeyLabel.BackgroundTransparency = 1
hotkeyLabel.Size = UDim2.new(1, 0, 0.3, 0)
hotkeyLabel.Font = Enum.Font.ArialBold
hotkeyLabel.Text = "Hotkey: " .. hotkey.Name
hotkeyLabel.TextColor3 = textColor
hotkeyLabel.TextSize = 14

local changeBtn = Instance.new("TextButton")
changeBtn.Parent = settingsPage
changeBtn.Size = UDim2.new(1, 0, 0.3, 0)
changeBtn.Position = UDim2.new(0, 0, 0.3, 0)
changeBtn.BackgroundColor3 = themeColor
changeBtn.Font = Enum.Font.ArialBold
changeBtn.Text = "Change Hotkey"
changeBtn.TextColor3 = Color3.new(0, 0, 0)
changeBtn.TextSize = 14

local backBtn = Instance.new("TextButton")
backBtn.Parent = settingsPage
backBtn.Size = UDim2.new(1, 0, 0.3, 0)
backBtn.Position = UDim2.new(0, 0, 0.6, 0)
backBtn.BackgroundColor3 = themeColor
backBtn.Font = Enum.Font.ArialBold
backBtn.Text = "Back"
backBtn.TextColor3 = Color3.new(0, 0, 0)
backBtn.TextSize = 14

-- Anti AFK Logic
local conn
conn = lp.Idled:Connect(function()
    if running then
        vu:CaptureController()
        vu:ClickButton2(Vector2.new())
        status.Text = "Kick Blocked!"
        wait(2)
        status.Text = "Anti AFK: Active"
    end
end)

-- Buttons
stopBtn.MouseButton1Click:Connect(function()
    running = false
    if conn then conn:Disconnect() end
    gui:Destroy()
end)

settingsBtn.MouseButton1Click:Connect(function()
    bar.Visible = false
    settingsPage.Visible = true
end)

backBtn.MouseButton1Click:Connect(function()
    settingsPage.Visible = false
    bar.Visible = true
end)

changeBtn.MouseButton1Click:Connect(function()
    listeningForHotkey = true
    changeBtn.Text = "Press any key..."
end)

-- Hotkey detection
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end

    -- Listen for new hotkey
    if listeningForHotkey and input.KeyCode ~= Enum.KeyCode.Unknown then
        hotkey = input.KeyCode
        hotkeyLabel.Text = "Hotkey: " .. hotkey.Name
        changeBtn.Text = "Change Hotkey"
        listeningForHotkey = false
    elseif input.KeyCode == hotkey then
        -- Toggle hide/show
        hidden = not hidden
        bar.Visible = not hidden
        if not hidden then
            settingsPage.Visible = false
        end
    end
end)
