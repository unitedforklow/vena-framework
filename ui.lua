local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local Library = {}
local Utility = {}

function Utility:Tween(object, properties, time, easingStyle, easingDirection)
    local info = TweenInfo.new(time or 0.2, easingStyle or Enum.EasingStyle.Quad, easingDirection or Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, info, properties)
    tween:Play()
    return tween
end

function Library:CreateWindow(options)
    options = options or {}
    local Title = options.Name or "Venice Framework"
    local IconId = options.Icon or "rbxassetid://6031265976"
    
    local VeniceGui = Instance.new("ScreenGui")
    VeniceGui.Name = "VeniceUI_" .. tostring(math.random(1000, 9999))
    VeniceGui.Parent = (game:GetService("RunService"):IsStudio() and Players.LocalPlayer:WaitForChild("PlayerGui")) or CoreGui
    VeniceGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    VeniceGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = VeniceGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    MainFrame.BackgroundTransparency = 0.25
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.ClipsDescendants = true

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(255, 255, 255)
    MainStroke.Transparency = 0.85
    MainStroke.Thickness = 1
    MainStroke.Parent = MainFrame

    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Parent = MainFrame
    Topbar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Topbar.BackgroundTransparency = 1
    Topbar.Size = UDim2.new(1, 0, 0, 40)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = Topbar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 45, 0, 0)
    TitleLabel.Size = UDim2.new(1, -45, 1, 0)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = Title
    TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local Icon = Instance.new("ImageLabel")
    Icon.Parent = Topbar
    Icon.BackgroundTransparency = 1
    Icon.Position = UDim2.new(0, 15, 0.5, -10)
    Icon.Size = UDim2.new(0, 20, 0, 20)
    Icon.Image = IconId
    Icon.ImageColor3 = Color3.fromRGB(240, 240, 240)

    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Parent = MainFrame
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 150, 0, 40)
    ContentContainer.Size = UDim2.new(1, -160, 1, -50)

    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = MainFrame
    TabContainer.BackgroundTransparency = 1
    TabContainer.Position = UDim2.new(0, 10, 0, 40)
    TabContainer.Size = UDim2.new(0, 130, 1, -50)

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Parent = TabContainer
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 5)

    local dragging, dragInput, dragStart, startPos
    Topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    Topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local WindowVisible = true
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.KeyCode == Enum.KeyCode.Insert then
            WindowVisible = not WindowVisible
            Utility:Tween(MainFrame, {Size = WindowVisible and UDim2.new(0, 600, 0, 400) or UDim2.new(0, 0, 0, 0), BackgroundTransparency = WindowVisible and 0.25 or 1}, 0.3, Enum.EasingStyle.Exponential)
            for _, child in pairs(MainFrame:GetDescendants()) do
                if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("ImageLabel") then
                    Utility:Tween(child, {TextTransparency = WindowVisible and 0 or 1, ImageTransparency = WindowVisible and 0 or 1}, 0.2)
                elseif child:IsA("Frame") and child ~= MainFrame then
                    Utility:Tween(child, {BackgroundTransparency = WindowVisible and (child:GetAttribute("TargetTransparency") or 0.8) or 1}, 0.2)
                end
            end
        end
    end)

    local Window = {
        CurrentTab = nil
    }

    function Window:CreateTab(tabName)
        local TabButton = Instance.new("TextButton")
        TabButton.Parent = TabContainer
        TabButton.Size = UDim2.new(1, 0, 0, 35)
        TabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.BackgroundTransparency = 1
        TabButton.Text = tabName
        TabButton.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabButton.Font = Enum.Font.GothamMedium
        TabButton.TextSize = 14
        TabButton.AutoButtonColor = false

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabButton

        local Page = Instance.new("ScrollingFrame")
        Page.Name = tabName.."_Page"
        Page.Parent = ContentContainer
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 0
        Page.Visible = false

        local PageLayout = Instance.new("UIGridLayout")
        PageLayout.Parent = Page
        PageLayout.CellSize = UDim2.new(0.5, -5, 0, 50)
        PageLayout.CellPadding = UDim2.new(0, 10, 0, 10)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder

        if not self.CurrentTab then
            self.CurrentTab = TabButton
            Page.Visible = true
            TabButton.BackgroundTransparency = 0.9
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        end

        TabButton.MouseButton1Click:Connect(function()
            for _, child in pairs(ContentContainer:GetChildren()) do
                if child:IsA("ScrollingFrame") then child.Visible = false end
            end
            for _, child in pairs(TabContainer:GetChildren()) do
                if child:IsA("TextButton") then
                    Utility:Tween(child, {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(150, 150, 150)}, 0.2)
                end
            end
            Page.Visible = true
            Utility:Tween(TabButton, {BackgroundTransparency = 0.9, TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
        end)

        local Elements = {}

        function Elements:CreateToggle(options)
            local tName = options.Name or "Toggle"
            local callback = options.Callback or function() end
            local state = options.Default or false

            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Parent = Page
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            ToggleFrame.BackgroundTransparency = 0.6
            ToggleFrame:SetAttribute("TargetTransparency", 0.6)
            
            local TCorner = Instance.new("UICorner")
            TCorner.CornerRadius = UDim.new(0, 8)
            TCorner.Parent = ToggleFrame

            local TStroke = Instance.new("UIStroke")
            TStroke.Color = Color3.fromRGB(255, 255, 255)
            TStroke.Transparency = 0.9
            TStroke.Parent = ToggleFrame

            local Label = Instance.new("TextLabel")
            Label.Parent = ToggleFrame
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 15, 0, 0)
            Label.Size = UDim2.new(1, -70, 1, 0)
            Label.Font = Enum.Font.Gotham
            Label.Text = tName
            Label.TextColor3 = Color3.fromRGB(220, 220, 220)
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local SwitchBG = Instance.new("Frame")
            SwitchBG.Parent = ToggleFrame
            SwitchBG.AnchorPoint = Vector2.new(1, 0.5)
            SwitchBG.Position = UDim2.new(1, -15, 0.5, 0)
            SwitchBG.Size = UDim2.new(0, 36, 0, 18)
            SwitchBG.BackgroundColor3 = state and Color3.fromRGB(80, 120, 255) or Color3.fromRGB(40, 40, 45)
            
            local SCorner = Instance.new("UICorner")
            SCorner.CornerRadius = UDim.new(1, 0)
            SCorner.Parent = SwitchBG

            local Circle = Instance.new("Frame")
            Circle.Parent = SwitchBG
            Circle.AnchorPoint = Vector2.new(0, 0.5)
            Circle.Position = state and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
            Circle.Size = UDim2.new(0, 14, 0, 14)
            Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            
            local CCorner = Instance.new("UICorner")
            CCorner.CornerRadius = UDim.new(1, 0)
            CCorner.Parent = Circle

            local Button = Instance.new("TextButton")
            Button.Parent = ToggleFrame
            Button.Size = UDim2.new(1, 0, 1, 0)
            Button.BackgroundTransparency = 1
            Button.Text = ""

            Button.MouseButton1Click:Connect(function()
                state = not state
                Utility:Tween(SwitchBG, {BackgroundColor3 = state and Color3.fromRGB(80, 120, 255) or Color3.fromRGB(40, 40, 45)}, 0.2)
                Utility:Tween(Circle, {Position = state and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)}, 0.2, Enum.EasingStyle.Back)
                callback(state)
            end)
        end

        return Elements
    end

    return Window
end

return Library
