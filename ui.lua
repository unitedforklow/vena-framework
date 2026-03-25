local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local Library = {}
local Utility = {}

function Utility:Tween(object, properties, time, easingStyle, easingDirection)
    local info = TweenInfo.new(time or 0.25, easingStyle or Enum.EasingStyle.Quad, easingDirection or Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, info, properties)
    tween:Play()
    return tween
end

function Library:CreateWindow(options)
    options = options or {}
    local Title = options.Name or "VENICE"
    
    local VeniceGui = Instance.new("ScreenGui")
    VeniceGui.Name = "VenicePremiumUI_" .. math.random(1000, 9999)
    VeniceGui.Parent = (game:GetService("RunService"):IsStudio() and Players.LocalPlayer:WaitForChild("PlayerGui")) or CoreGui
    VeniceGui.ResetOnSpawn = false
    VeniceGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = VeniceGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
    MainFrame.BackgroundTransparency = 0.35
    MainFrame.Position = UDim2.new(0.5, -325, 0.5, -225)
    MainFrame.Size = UDim2.new(0, 650, 0, 450)
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 14)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(255, 255, 255)
    MainStroke.Transparency = 0.5
    MainStroke.Thickness = 1.2
    MainStroke.Parent = MainFrame
    
    local StrokeGradient = Instance.new("UIGradient")
    StrokeGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(50, 50, 60)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    })
    StrokeGradient.Rotation = 45
    StrokeGradient.Parent = MainStroke

    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Parent = MainFrame
    Topbar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Topbar.BackgroundTransparency = 1
    Topbar.Size = UDim2.new(1, 0, 0, 40)

    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Sidebar.BackgroundTransparency = 0.6
    Sidebar.Position = UDim2.new(0, 10, 0, 40)
    Sidebar.Size = UDim2.new(0, 50, 1, -50)
    
    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 12)
    SidebarCorner.Parent = Sidebar

    local SidebarStroke = Instance.new("UIStroke")
    SidebarStroke.Color = Color3.fromRGB(255, 255, 255)
    SidebarStroke.Transparency = 0.85
    SidebarStroke.Parent = Sidebar

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Parent = Sidebar
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 12)
    TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabListLayout.VerticalAlignment = Enum.VerticalAlignment.Top

    local Spacer = Instance.new("Frame")
    Spacer.Parent = Sidebar
    Spacer.BackgroundTransparency = 1
    Spacer.Size = UDim2.new(1, 0, 0, 5)

    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Parent = MainFrame
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 75, 0, 40)
    ContentContainer.Size = UDim2.new(1, -85, 1, -50)

    local dragging, dragInput, dragStart, startPos
    Topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    Topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Utility:Tween(MainFrame, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.1)
        end
    end)

    local isVisible = true
    UserInputService.InputBegan:Connect(function(input, gp)
        if not gp and input.KeyCode == Enum.KeyCode.Insert then
            isVisible = not isVisible
            VeniceGui.Enabled = isVisible
        end
    end)

    local Window = { CurrentTab = nil, Tabs = {} }

    function Window:CreateTab(options)
        local IconId = options.Icon or "rbxassetid://3926305904"
        local TabId = "Tab_" .. tostring(#self.Tabs + 1)

        local TabBtn = Instance.new("ImageButton")
        TabBtn.Parent = Sidebar
        TabBtn.Size = UDim2.new(0, 24, 0, 24)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Image = IconId
        TabBtn.ImageColor3 = Color3.fromRGB(120, 120, 130)
        TabBtn.ImageTransparency = 0.3

        local Indicator = Instance.new("Frame")
        Indicator.Parent = TabBtn
        Indicator.BackgroundColor3 = Color3.fromRGB(99, 102, 241)
        Indicator.Size = UDim2.new(0, 3, 0, 0)
        Indicator.Position = UDim2.new(0, -12, 0.5, 0)
        Indicator.AnchorPoint = Vector2.new(0, 0.5)
        local IndCorner = Instance.new("UICorner")
        IndCorner.CornerRadius = UDim.new(1, 0)
        IndCorner.Parent = Indicator

        local Page = Instance.new("ScrollingFrame")
        Page.Parent = ContentContainer
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 90)
        Page.Visible = false

        local PageLayout = Instance.new("UIGridLayout")
        PageLayout.Parent = Page
        PageLayout.CellSize = UDim2.new(0.5, -8, 0, 55)
        PageLayout.CellPadding = UDim2.new(0, 10, 0, 10)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder

        table.insert(self.Tabs, {Btn = TabBtn, Page = Page, Indicator = Indicator})

        if not self.CurrentTab then
            self.CurrentTab = TabBtn
            Page.Visible = true
            TabBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
            TabBtn.ImageTransparency = 0
            Indicator.Size = UDim2.new(0, 3, 0, 16)
        end

        TabBtn.MouseButton1Click:Connect(function()
            if self.CurrentTab == TabBtn then return end
            self.CurrentTab = TabBtn

            for _, tabData in pairs(self.Tabs) do
                tabData.Page.Visible = false
                Utility:Tween(tabData.Btn, {ImageColor3 = Color3.fromRGB(120, 120, 130), ImageTransparency = 0.3}, 0.2)
                Utility:Tween(tabData.Indicator, {Size = UDim2.new(0, 3, 0, 0)}, 0.2)
            end

            Page.Visible = true
            Utility:Tween(TabBtn, {ImageColor3 = Color3.fromRGB(255, 255, 255), ImageTransparency = 0}, 0.3)
            Utility:Tween(Indicator, {Size = UDim2.new(0, 3, 0, 16)}, 0.3, Enum.EasingStyle.Back)
        end)

        local Elements = {}

        function Elements:CreateToggle(options)
            local tName = options.Name or "Toggle"
            local state = options.Default or false
            local callback = options.Callback or function() end

            local ToggleCard = Instance.new("Frame")
            ToggleCard.Parent = Page
            ToggleCard.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            ToggleCard.BackgroundTransparency = 0.5
            
            local CardCorner = Instance.new("UICorner")
            CardCorner.CornerRadius = UDim.new(0, 10)
            CardCorner.Parent = ToggleCard

            local CardStroke = Instance.new("UIStroke")
            CardStroke.Color = Color3.fromRGB(255, 255, 255)
            CardStroke.Transparency = 0.88
            CardStroke.Parent = ToggleCard

            local Label = Instance.new("TextLabel")
            Label.Parent = ToggleCard
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 15, 0, 0)
            Label.Size = UDim2.new(1, -80, 1, 0)
            Label.Font = Enum.Font.GothamMedium
            Label.Text = tName
            Label.TextColor3 = Color3.fromRGB(230, 230, 235)
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local Track = Instance.new("Frame")
            Track.Parent = ToggleCard
            Track.AnchorPoint = Vector2.new(1, 0.5)
            Track.Position = UDim2.new(1, -15, 0.5, 0)
            Track.Size = UDim2.new(0, 42, 0, 22)
            Track.BackgroundColor3 = state and Color3.fromRGB(99, 102, 241) or Color3.fromRGB(15, 15, 18)
            
            local TrackCorner = Instance.new("UICorner")
            TrackCorner.CornerRadius = UDim.new(1, 0)
            TrackCorner.Parent = Track

            local TrackStroke = Instance.new("UIStroke")
            TrackStroke.Color = Color3.fromRGB(255, 255, 255)
            TrackStroke.Transparency = state and 1 or 0.85
            TrackStroke.Parent = Track

            local Thumb = Instance.new("Frame")
            Thumb.Parent = Track
            Thumb.AnchorPoint = Vector2.new(0, 0.5)
            Thumb.Position = state and UDim2.new(1, -19, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
            Thumb.Size = UDim2.new(0, 16, 0, 16)
            Thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            
            local ThumbCorner = Instance.new("UICorner")
            ThumbCorner.CornerRadius = UDim.new(1, 0)
            ThumbCorner.Parent = Thumb

            local ThumbShadow = Instance.new("ImageLabel")
            ThumbShadow.Parent = Thumb
            ThumbShadow.AnchorPoint = Vector2.new(0.5, 0.5)
            ThumbShadow.Position = UDim2.new(0.5, 0, 0.5, 2)
            ThumbShadow.Size = UDim2.new(1, 10, 1, 10)
            ThumbShadow.BackgroundTransparency = 1
            ThumbShadow.Image = "rbxassetid://5554831670"
            ThumbShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
            ThumbShadow.ImageTransparency = 0.6
            ThumbShadow.ZIndex = Thumb.ZIndex - 1

            local Button = Instance.new("TextButton")
            Button.Parent = ToggleCard
            Button.Size = UDim2.new(1, 0, 1, 0)
            Button.BackgroundTransparency = 1
            Button.Text = ""

            Button.MouseButton1Click:Connect(function()
                state = not state
                
                Utility:Tween(Track, {BackgroundColor3 = state and Color3.fromRGB(99, 102, 241) or Color3.fromRGB(15, 15, 18)}, 0.3)
                Utility:Tween(TrackStroke, {Transparency = state and 1 or 0.85}, 0.3)
                
                Utility:Tween(Thumb, {Size = UDim2.new(0, 22, 0, 14)}, 0.1)
                task.wait(0.1)
                Utility:Tween(Thumb, {
                    Position = state and UDim2.new(1, -19, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
                    Size = UDim2.new(0, 16, 0, 16)
                }, 0.3, Enum.EasingStyle.Back)

                callback(state)
            end)
        end

        return Elements
    end

    return Window
end

return Library
