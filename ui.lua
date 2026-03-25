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

        -- Премиум Тоггл (Оставляем как было, он идеален)
        function Elements:CreateToggle(options)
            local tName = options.Name or "Toggle"
            local state = options.Default or false
            local callback = options.Callback or function() end

            local ToggleCard = Instance.new("Frame")
            ToggleCard.Parent = Page
            ToggleCard.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            ToggleCard.BackgroundTransparency = 0.5
            local CardCorner = Instance.new("UICorner") CardCorner.CornerRadius = UDim.new(0, 10) CardCorner.Parent = ToggleCard
            local CardStroke = Instance.new("UIStroke") CardStroke.Color = Color3.fromRGB(255, 255, 255) CardStroke.Transparency = 0.88 CardStroke.Parent = ToggleCard

            local Label = Instance.new("TextLabel")
            Label.Parent = ToggleCard Label.BackgroundTransparency = 1 Label.Position = UDim2.new(0, 15, 0, 0) Label.Size = UDim2.new(1, -80, 1, 0)
            Label.Font = Enum.Font.GothamMedium Label.Text = tName Label.TextColor3 = Color3.fromRGB(230, 230, 235) Label.TextSize = 14 Label.TextXAlignment = Enum.TextXAlignment.Left

            local Track = Instance.new("Frame")
            Track.Parent = ToggleCard Track.AnchorPoint = Vector2.new(1, 0.5) Track.Position = UDim2.new(1, -15, 0.5, 0) Track.Size = UDim2.new(0, 42, 0, 22)
            Track.BackgroundColor3 = state and Color3.fromRGB(99, 102, 241) or Color3.fromRGB(15, 15, 18)
            local TrackCorner = Instance.new("UICorner") TrackCorner.CornerRadius = UDim.new(1, 0) TrackCorner.Parent = Track
            local TrackStroke = Instance.new("UIStroke") TrackStroke.Color = Color3.fromRGB(255, 255, 255) TrackStroke.Transparency = state and 1 or 0.85 TrackStroke.Parent = Track

            local Thumb = Instance.new("Frame")
            Thumb.Parent = Track Thumb.AnchorPoint = Vector2.new(0, 0.5) Thumb.Position = state and UDim2.new(1, -19, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
            Thumb.Size = UDim2.new(0, 16, 0, 16) Thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            local ThumbCorner = Instance.new("UICorner") ThumbCorner.CornerRadius = UDim.new(1, 0) ThumbCorner.Parent = Thumb

            local ThumbShadow = Instance.new("ImageLabel")
            ThumbShadow.Parent = Thumb ThumbShadow.AnchorPoint = Vector2.new(0.5, 0.5) ThumbShadow.Position = UDim2.new(0.5, 0, 0.5, 2)
            ThumbShadow.Size = UDim2.new(1, 10, 1, 10) ThumbShadow.BackgroundTransparency = 1 ThumbShadow.Image = "rbxassetid://5554831670" ThumbShadow.ImageColor3 = Color3.fromRGB(0, 0, 0) ThumbShadow.ImageTransparency = 0.6 ThumbShadow.ZIndex = Thumb.ZIndex - 1

            local Button = Instance.new("TextButton")
            Button.Parent = ToggleCard Button.Size = UDim2.new(1, 0, 1, 0) Button.BackgroundTransparency = 1 Button.Text = ""

            Button.MouseButton1Click:Connect(function()
                state = not state
                Utility:Tween(Track, {BackgroundColor3 = state and Color3.fromRGB(99, 102, 241) or Color3.fromRGB(15, 15, 18)}, 0.3)
                Utility:Tween(TrackStroke, {Transparency = state and 1 or 0.85}, 0.3)
                Utility:Tween(Thumb, {Size = UDim2.new(0, 22, 0, 14)}, 0.1)
                task.wait(0.1)
                Utility:Tween(Thumb, {Position = state and UDim2.new(1, -19, 0.5, 0) or UDim2.new(0, 3, 0.5, 0), Size = UDim2.new(0, 16, 0, 16)}, 0.3, Enum.EasingStyle.Back)
                callback(state)
            end)
        end

        -- Слайдер (Ползунок)
        function Elements:CreateSlider(options)
            local sName = options.Name or "Slider"
            local min = options.Min or 0
            local max = options.Max or 100
            local default = options.Default or min
            local callback = options.Callback or function() end
            local currentValue = default

            local SliderCard = Instance.new("Frame")
            SliderCard.Parent = Page
            SliderCard.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            SliderCard.BackgroundTransparency = 0.5
            local CardCorner = Instance.new("UICorner") CardCorner.CornerRadius = UDim.new(0, 10) CardCorner.Parent = SliderCard
            local CardStroke = Instance.new("UIStroke") CardStroke.Color = Color3.fromRGB(255, 255, 255) CardStroke.Transparency = 0.88 CardStroke.Parent = SliderCard

            local Label = Instance.new("TextLabel")
            Label.Parent = SliderCard Label.BackgroundTransparency = 1 Label.Position = UDim2.new(0, 15, 0, 5) Label.Size = UDim2.new(1, -30, 0, 20)
            Label.Font = Enum.Font.GothamMedium Label.Text = sName Label.TextColor3 = Color3.fromRGB(230, 230, 235) Label.TextSize = 13 Label.TextXAlignment = Enum.TextXAlignment.Left

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Parent = SliderCard ValueLabel.BackgroundTransparency = 1 ValueLabel.Position = UDim2.new(0, 15, 0, 5) ValueLabel.Size = UDim2.new(1, -30, 0, 20)
            ValueLabel.Font = Enum.Font.GothamMedium ValueLabel.Text = tostring(default) ValueLabel.TextColor3 = Color3.fromRGB(99, 102, 241) ValueLabel.TextSize = 13 ValueLabel.TextXAlignment = Enum.TextXAlignment.Right

            local Track = Instance.new("Frame")
            Track.Parent = SliderCard Track.BackgroundColor3 = Color3.fromRGB(15, 15, 18) Track.Position = UDim2.new(0, 15, 0, 32) Track.Size = UDim2.new(1, -30, 0, 6)
            local TrackCorner = Instance.new("UICorner") TrackCorner.CornerRadius = UDim.new(1, 0) TrackCorner.Parent = Track
            local TrackStroke = Instance.new("UIStroke") TrackStroke.Color = Color3.fromRGB(255, 255, 255) TrackStroke.Transparency = 0.85 TrackStroke.Parent = Track

            local Fill = Instance.new("Frame")
            Fill.Parent = Track Fill.BackgroundColor3 = Color3.fromRGB(99, 102, 241) Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            local FillCorner = Instance.new("UICorner") FillCorner.CornerRadius = UDim.new(1, 0) FillCorner.Parent = Fill

            local Thumb = Instance.new("Frame")
            Thumb.Parent = Fill Thumb.AnchorPoint = Vector2.new(0.5, 0.5) Thumb.Position = UDim2.new(1, 0, 0.5, 0) Thumb.Size = UDim2.new(0, 12, 0, 12)
            Thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            local ThumbCorner = Instance.new("UICorner") ThumbCorner.CornerRadius = UDim.new(1, 0) ThumbCorner.Parent = Thumb
            
            -- Тень ползунка
            local ThumbShadow = Instance.new("ImageLabel")
            ThumbShadow.Parent = Thumb ThumbShadow.AnchorPoint = Vector2.new(0.5, 0.5) ThumbShadow.Position = UDim2.new(0.5, 0, 0.5, 2)
            ThumbShadow.Size = UDim2.new(1, 8, 1, 8) ThumbShadow.BackgroundTransparency = 1 ThumbShadow.Image = "rbxassetid://5554831670" ThumbShadow.ImageColor3 = Color3.fromRGB(0, 0, 0) ThumbShadow.ImageTransparency = 0.5 ThumbShadow.ZIndex = Thumb.ZIndex - 1

            local SliderBtn = Instance.new("TextButton")
            SliderBtn.Parent = SliderCard SliderBtn.Size = UDim2.new(1, 0, 1, 0) SliderBtn.BackgroundTransparency = 1 SliderBtn.Text = ""

            local dragging = false
            local function updateSlider(input)
                local mathHelper = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + ((max - min) * mathHelper))
                Utility:Tween(Fill, {Size = UDim2.new(mathHelper, 0, 1, 0)}, 0.05, Enum.EasingStyle.Linear)
                ValueLabel.Text = tostring(value)
                if currentValue ~= value then
                    currentValue = value
                    callback(value)
                end
            end

            SliderBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    Utility:Tween(Thumb, {Size = UDim2.new(0, 16, 0, 16)}, 0.2) -- Увеличение при захвате
                    updateSlider(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
                    dragging = false
                    Utility:Tween(Thumb, {Size = UDim2.new(0, 12, 0, 12)}, 0.2)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input)
                end
            end)
        end

        -- Выпадающий список (Dropdown)
        function Elements:CreateDropdown(options)
            local dName = options.Name or "Dropdown"
            local list = options.List or {}
            local default = options.Default or "Select..."
            local callback = options.Callback or function() end
            local isOpen = false

            local DropCard = Instance.new("Frame")
            DropCard.Parent = Page DropCard.BackgroundColor3 = Color3.fromRGB(25, 25, 30) DropCard.BackgroundTransparency = 0.5
            local CardCorner = Instance.new("UICorner") CardCorner.CornerRadius = UDim.new(0, 10) CardCorner.Parent = DropCard
            local CardStroke = Instance.new("UIStroke") CardStroke.Color = Color3.fromRGB(255, 255, 255) CardStroke.Transparency = 0.88 CardStroke.Parent = DropCard

            local Label = Instance.new("TextLabel")
            Label.Parent = DropCard Label.BackgroundTransparency = 1 Label.Position = UDim2.new(0, 15, 0, 0) Label.Size = UDim2.new(1, -40, 1, 0)
            Label.Font = Enum.Font.GothamMedium Label.Text = dName Label.TextColor3 = Color3.fromRGB(230, 230, 235) Label.TextSize = 14 Label.TextXAlignment = Enum.TextXAlignment.Left

            local SelectedText = Instance.new("TextLabel")
            SelectedText.Parent = DropCard SelectedText.BackgroundTransparency = 1 SelectedText.Position = UDim2.new(0, 15, 0, 0) SelectedText.Size = UDim2.new(1, -45, 1, 0)
            SelectedText.Font = Enum.Font.Gotham SelectedText.Text = default SelectedText.TextColor3 = Color3.fromRGB(150, 150, 160) SelectedText.TextSize = 12 SelectedText.TextXAlignment = Enum.TextXAlignment.Right

            local ArrowIcon = Instance.new("ImageLabel")
            ArrowIcon.Parent = DropCard ArrowIcon.BackgroundTransparency = 1 ArrowIcon.AnchorPoint = Vector2.new(1, 0.5) ArrowIcon.Position = UDim2.new(1, -10, 0.5, 0)
            ArrowIcon.Size = UDim2.new(0, 16, 0, 16) ArrowIcon.Image = "rbxassetid://6031091004" -- Иконка стрелочки вниз
            ArrowIcon.ImageColor3 = Color3.fromRGB(150, 150, 160)

            local DropBtn = Instance.new("TextButton")
            DropBtn.Parent = DropCard DropBtn.Size = UDim2.new(1, 0, 1, 0) DropBtn.BackgroundTransparency = 1 DropBtn.Text = ""

            -- Плавающий контейнер списка (Parented to VeniceGui чтобы избежать обрезания сеткой Bento Grid)
            local DropListPanel = Instance.new("Frame")
            DropListPanel.Parent = VeniceGui DropListPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 25) DropListPanel.BackgroundTransparency = 0.2
            DropListPanel.Size = UDim2.new(0, 0, 0, 0) -- Изначально скрыт
            DropListPanel.Visible = false DropListPanel.ZIndex = 10 -- Поверх всего
            DropListPanel.ClipsDescendants = true
            local ListCorner = Instance.new("UICorner") ListCorner.CornerRadius = UDim.new(0, 8) ListCorner.Parent = DropListPanel
            local ListStroke = Instance.new("UIStroke") ListStroke.Color = Color3.fromRGB(255, 255, 255) ListStroke.Transparency = 0.85 ListStroke.Parent = DropListPanel

            local ListLayout = Instance.new("UIListLayout")
            ListLayout.Parent = DropListPanel ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

            local function UpdateListPosition()
                if isOpen then
                    -- Привязываем список точно под карточку Dropdown
                    DropListPanel.Position = UDim2.new(0, DropCard.AbsolutePosition.X, 0, DropCard.AbsolutePosition.Y + DropCard.AbsoluteSize.Y + 5)
                    DropListPanel.Size = UDim2.new(0, DropCard.AbsoluteSize.X, 0, math.clamp(#list * 30, 0, 150))
                end
            end

            for i, option in ipairs(list) do
                local OptionBtn = Instance.new("TextButton")
                OptionBtn.Parent = DropListPanel OptionBtn.Size = UDim2.new(1, 0, 0, 30) OptionBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                OptionBtn.BackgroundTransparency = 1 OptionBtn.Font = Enum.Font.Gotham OptionBtn.Text = "  " .. option
                OptionBtn.TextColor3 = Color3.fromRGB(200, 200, 205) OptionBtn.TextSize = 13 OptionBtn.TextXAlignment = Enum.TextXAlignment.Left OptionBtn.ZIndex = 11

                OptionBtn.MouseEnter:Connect(function() Utility:Tween(OptionBtn, {BackgroundTransparency = 0.95}, 0.2) end)
                OptionBtn.MouseLeave:Connect(function() Utility:Tween(OptionBtn, {BackgroundTransparency = 1}, 0.2) end)

                OptionBtn.MouseButton1Click:Connect(function()
                    isOpen = false
                    SelectedText.Text = option
                    Utility:Tween(ArrowIcon, {Rotation = 0}, 0.3, Enum.EasingStyle.Quart)
                    Utility:Tween(DropListPanel, {Size = UDim2.new(0, DropCard.AbsoluteSize.X, 0, 0)}, 0.2, Enum.EasingStyle.Quart)
                    task.wait(0.2) DropListPanel.Visible = false
                    callback(option)
                end)
            end

            DropBtn.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                if isOpen then
                    DropListPanel.Visible = true
                    UpdateListPosition()
                    DropListPanel.Size = UDim2.new(0, DropCard.AbsoluteSize.X, 0, 0)
                    Utility:Tween(ArrowIcon, {Rotation = 180}, 0.3, Enum.EasingStyle.Quart)
                    Utility:Tween(DropListPanel, {Size = UDim2.new(0, DropCard.AbsoluteSize.X, 0, math.clamp(#list * 30, 0, 150))}, 0.3, Enum.EasingStyle.Quart)
                else
                    Utility:Tween(ArrowIcon, {Rotation = 0}, 0.3, Enum.EasingStyle.Quart)
                    Utility:Tween(DropListPanel, {Size = UDim2.new(0, DropCard.AbsoluteSize.X, 0, 0)}, 0.2, Enum.EasingStyle.Quart)
                    task.wait(0.2) DropListPanel.Visible = false
                end
            end)
            
            -- Обновляем позицию плавающего списка при движении окна
            MainFrame:GetPropertyChangedSignal("Position"):Connect(function()
                if isOpen then UpdateListPosition() end
            end)
            Page:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
                if isOpen then UpdateListPosition() end
            end)
        end

        return Elements
    return Window
end

return Library
