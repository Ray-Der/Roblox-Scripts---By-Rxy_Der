-- Multi Tool FINAL: Spectator + Teleport + MINIMIZAR A BURBUJA
-- Ventana pequeña → Toca "−" para minimizar a burbuja
-- Toca la burbuja "👁" para abrir de nuevo (arrastra la burbuja también)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Cache avatares
local thumbCache = {}
local function getThumb(id)
    if not thumbCache[id] then
        local content = Players:GetUserThumbnailAsync(id, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
        thumbCache[id] = content
    end
    return thumbCache[id]
end

-- GUI principal
local gui = Instance.new("ScreenGui")
gui.Name = "MultiTool"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Burbuja minimizada (extremadamente pequeña y arrastrable)
local bubble = Instance.new("TextButton")
bubble.Size = UDim2.new(0, 45, 0, 45)
bubble.Position = UDim2.new(0, 20, 0, 20)
bubble.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
bubble.Text = "👁"
bubble.TextColor3 = Color3.new(1,1,1)
bubble.TextScaled = true
bubble.Font = Enum.Font.GothamBold
bubble.Visible = false
bubble.Parent = gui

local bubbleCorner = Instance.new("UICorner", bubble)
bubbleCorner.CornerRadius = UDim.new(0, 23)

-- Ventana principal
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 260)
frame.Position = UDim2.new(0.5, -100, 0.5, -130)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -35, 0, 30)
title.Text = "Multi Tool"
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Center
title.Parent = frame

-- Botón minimizar (antes era cerrar)
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -33, 0, 0)
minimizeBtn.Text = "−"
minimizeBtn.BackgroundColor3 = Color3.fromRGB(220, 140, 0)
minimizeBtn.TextColor3 = Color3.new(1,1,1)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 20
minimizeBtn.Parent = frame

-- Pestañas
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, 0, 0, 30)
tabFrame.Position = UDim2.new(0, 0, 0, 30)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = frame

local tabSpec = Instance.new("TextButton")
tabSpec.Size = UDim2.new(0.5, 0, 1, 0)
tabSpec.Text = "Spectator"
tabSpec.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
tabSpec.TextColor3 = Color3.new(1,1,1)
tabSpec.Font = Enum.Font.GothamBold
tabSpec.TextSize = 12
tabSpec.Parent = tabFrame

local tabTP = Instance.new("TextButton")
tabTP.Size = UDim2.new(0.5, 0, 1, 0)
tabTP.Position = UDim2.new(0.5, 0, 0, 0)
tabTP.Text = "Teleport"
tabTP.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
tabTP.TextColor3 = Color3.new(1,1,1)
tabTP.Font = Enum.Font.GothamBold
tabTP.TextSize = 12
tabTP.Parent = tabFrame

-- Secciones
local sectionSpec = Instance.new("Frame")
sectionSpec.Size = UDim2.new(1, -20, 1, -70)
sectionSpec.Position = UDim2.new(0, 10, 0, 65)
sectionSpec.BackgroundTransparency = 1
sectionSpec.Visible = true
sectionSpec.Parent = frame

local sectionTP = Instance.new("Frame")
sectionTP.Size = UDim2.new(1, -20, 1, -70)
sectionTP.Position = UDim2.new(0, 10, 0, 65)
sectionTP.BackgroundTransparency = 1
sectionTP.Visible = false
sectionTP.Parent = frame

tabSpec.Activated:Connect(function()
    sectionSpec.Visible = true
    sectionTP.Visible = false
    tabSpec.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    tabTP.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
end)

tabTP.Activated:Connect(function()
    sectionSpec.Visible = false
    sectionTP.Visible = true
    tabSpec.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    tabTP.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
end)

-- ====================== SPECTATOR ======================
local specInput = Instance.new("TextBox")
specInput.Size = UDim2.new(1, 0, 0, 25)
specInput.Position = UDim2.new(0, 0, 0, 0)
specInput.PlaceholderText = "Buscar..."
specInput.PlaceholderColor3 = Color3.fromRGB(140,140,140)
specInput.BackgroundColor3 = Color3.fromRGB(45,45,45)
specInput.TextColor3 = Color3.new(1,1,1)
specInput.TextSize = 12
specInput.Parent = sectionSpec

local specStop = Instance.new("TextButton")
specStop.Size = UDim2.new(1, 0, 0, 25)
specStop.Position = UDim2.new(0, 0, 0, 30)
specStop.Text = "Stop"
specStop.BackgroundColor3 = Color3.fromRGB(220,80,0)
specStop.TextColor3 = Color3.new(1,1,1)
specStop.TextSize = 12
specStop.Parent = sectionSpec

local specCurrent = Instance.new("Frame")
specCurrent.Size = UDim2.new(1, 0, 0, 45)
specCurrent.Position = UDim2.new(0, 0, 0, 60)
specCurrent.BackgroundTransparency = 1
specCurrent.Parent = sectionSpec

local specLeft = Instance.new("TextButton")
specLeft.Size = UDim2.new(0, 20, 1, 0)
specLeft.Text = "<"
specLeft.BackgroundColor3 = Color3.fromRGB(60,60,60)
specLeft.TextColor3 = Color3.new(1,1,1)
specLeft.TextSize = 14
specLeft.Parent = specCurrent

local specAvatar = Instance.new("ImageLabel")
specAvatar.Size = UDim2.new(0, 38, 0, 38)
specAvatar.Position = UDim2.new(0, 23, 0, 4)
specAvatar.BackgroundTransparency = 1
specAvatar.Parent = specCurrent

local specName = Instance.new("TextLabel")
specName.Size = UDim2.new(0, 90, 1, 0)
specName.Position = UDim2.new(0, 65, 0, 0)
specName.Text = "Ninguno"
specName.TextColor3 = Color3.new(1,1,1)
specName.BackgroundTransparency = 1
specName.TextSize = 9
specName.TextWrapped = true
specName.Parent = specCurrent

local specRight = Instance.new("TextButton")
specRight.Size = UDim2.new(0, 20, 1, 0)
specRight.Position = UDim2.new(1, -20, 0, 0)
specRight.Text = ">"
specRight.BackgroundColor3 = Color3.fromRGB(60,60,60)
specRight.TextColor3 = Color3.new(1,1,1)
specRight.TextSize = 14
specRight.Parent = specCurrent

local specList = Instance.new("ScrollingFrame")
specList.Size = UDim2.new(1, 0, 0, 85)
specList.Position = UDim2.new(0, 0, 0, 110)
specList.BackgroundColor3 = Color3.fromRGB(40,40,40)
specList.ScrollBarThickness = 4
specList.Parent = sectionSpec

local specLayout = Instance.new("UIListLayout")
specLayout.Padding = UDim.new(0, 3)
specLayout.Parent = specList

specLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    specList.CanvasSize = UDim2.new(0, 0, 0, specLayout.AbsoluteContentSize.Y + 6)
end)

-- Lógica Spectator
local specPlayers = {}
local specIndex = 1
local specTarget = nil

local function updateSpecList()
    specPlayers = {}
    local friends = {}
    local others = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            if LocalPlayer:IsFriendsWith(p.UserId) then table.insert(friends, p)
            else table.insert(others, p) end
        end
    end
    for _, p in ipairs(friends) do table.insert(specPlayers, p) end
    for _, p in ipairs(others) do table.insert(specPlayers, p) end
    
    for _, child in ipairs(specList:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    for i, p in ipairs(specPlayers) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 32)
        btn.BackgroundColor3 = Color3.fromRGB(55,55,55)
        btn.Text = ""
        btn.AutoButtonColor = true
        btn.Parent = specList
        
        local img = Instance.new("ImageLabel")
        img.Size = UDim2.new(0, 28, 0, 28)
        img.Position = UDim2.new(0, 5, 0.5, 0)
        img.AnchorPoint = Vector2.new(0, 0.5)
        img.Image = getThumb(p.UserId)
        img.BackgroundTransparency = 1
        img.Parent = btn
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -40, 1, 0)
        label.Position = UDim2.new(0, 38, 0, 0)
        label.Text = p.DisplayName .. "\n@" .. p.Name
        label.TextColor3 = Color3.new(1,1,1)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.Gotham
        label.TextSize = 10
        label.TextWrapped = true
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextYAlignment = Enum.TextYAlignment.Center
        label.Parent = btn
        
        btn.Activated:Connect(function() specSpectate(p) end)
        btn.MouseButton1Click:Connect(function() specSpectate(p) end)
    end
end

local function specUpdateDisplay()
    if #specPlayers == 0 then
        specName.Text = "Ninguno"
        specAvatar.Image = ""
        return
    end
    local p = specPlayers[specIndex]
    specAvatar.Image = getThumb(p.UserId)
    specName.Text = p.DisplayName .. "\n@" .. p.Name
end

local function specSpectate(p)
    if not p or p == LocalPlayer then return end
    specTarget = p
    specIndex = table.find(specPlayers, p) or 1
    specUpdateDisplay()
    if p.Character and p.Character:FindFirstChild("Humanoid") then
        workspace.CurrentCamera.CameraSubject = p.Character.Humanoid
    end
    local conn
    conn = p.CharacterAdded:Connect(function(char)
        if specTarget == p then
            task.delay(0.1, function()
                local hum = char:FindFirstChild("Humanoid")
                if hum then workspace.CurrentCamera.CameraSubject = hum end
            end)
        else
            conn:Disconnect()
        end
    end)
end

specStop.Activated:Connect(function()
    specTarget = nil
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        workspace.CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
    end
end)

specLeft.Activated:Connect(function()
    if #specPlayers > 0 then
        specIndex = (specIndex - 2) % #specPlayers + 1
        specSpectate(specPlayers[specIndex])
    end
end)

specRight.Activated:Connect(function()
    if #specPlayers > 0 then
        specIndex = specIndex % #specPlayers + 1
        specSpectate(specPlayers[specIndex])
    end
end)

local function specSearch()
    local text = specInput.Text:lower():gsub("^%s*(.-)%s*$", "%1")
    if text == "" then return end
    for _, p in ipairs(specPlayers) do
        if p.DisplayName:lower():find(text) or p.Name:lower():find(text) then
            specSpectate(p)
            specInput.Text = ""
            return
        end
    end
end

specInput.FocusLost:Connect(specSearch)

Players.PlayerAdded:Connect(updateSpecList)
Players.PlayerRemoving:Connect(updateSpecList)
updateSpecList()

-- ====================== TELEPORT ======================
local tpPoints = {}

local tpSave = Instance.new("TextButton")
tpSave.Size = UDim2.new(1, 0, 0, 30)
tpSave.Position = UDim2.new(0, 0, 0, 0)
tpSave.Text = "💾 GUARDAR"
tpSave.BackgroundColor3 = Color3.fromRGB(0,170,0)
tpSave.TextColor3 = Color3.new(1,1,1)
tpSave.TextSize = 12
tpSave.Parent = sectionTP

local tpClear = Instance.new("TextButton")
tpClear.Size = UDim2.new(1, 0, 0, 30)
tpClear.Position = UDim2.new(0, 0, 0, 35)
tpClear.Text = "🗑️ BORRAR TODO"
tpClear.BackgroundColor3 = Color3.fromRGB(170,0,0)
tpClear.TextColor3 = Color3.new(1,1,1)
tpClear.TextSize = 12
tpClear.Parent = sectionTP

local tpCount = Instance.new("TextLabel")
tpCount.Size = UDim2.new(1, 0, 0, 20)
tpCount.Position = UDim2.new(0, 0, 0, 70)
tpCount.BackgroundTransparency = 1
tpCount.Text = "Puntos: 0/10"
tpCount.TextColor3 = Color3.new(1,1,1)
tpCount.TextSize = 11
tpCount.Parent = sectionTP

local tpList = Instance.new("ScrollingFrame")
tpList.Size = UDim2.new(1, 0, 0, 105)
tpList.Position = UDim2.new(0, 0, 0, 95)
tpList.BackgroundTransparency = 1
tpList.ScrollBarThickness = 4
tpList.Parent = sectionTP

local tpLayout = Instance.new("UIListLayout")
tpLayout.Padding = UDim.new(0, 4)
tpLayout.Parent = tpList

tpLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    tpList.CanvasSize = UDim2.new(0, 0, 0, tpLayout.AbsoluteContentSize.Y + 8)
end)

local function getHRP()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function tpSavePoint()
    local hrp = getHRP()
    if hrp then
        table.insert(tpPoints, 1, hrp.CFrame)
        if #tpPoints > 10 then table.remove(tpPoints) end
        tpUpdate()
    end
end

local function tpTo(index)
    local hrp = getHRP()
    if hrp and tpPoints[index] then
        hrp.CFrame = tpPoints[index]
    end
end

function tpUpdate()
    for _, child in ipairs(tpList:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end
    
    tpCount.Text = "Puntos: " .. #tpPoints .. "/10"
    
    if #tpPoints == 0 then
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 0, 30)
        lbl.BackgroundTransparency = 1
        lbl.Text = "No hay puntos guardados"
        lbl.TextColor3 = Color3.fromRGB(180,180,180)
        lbl.TextSize = 11
        lbl.Parent = tpList
    else
        for i = 1, #tpPoints do
            local pos = tpPoints[i].Position
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.BackgroundColor3 = Color3.fromRGB(55,55,55)
            btn.Text = string.format("#%d (%.0f, %.0f, %.0f)", i, pos.X, pos.Y, pos.Z)
            btn.TextColor3 = Color3.new(1,1,1)
            btn.TextSize = 10
            btn.Parent = tpList
            btn.Activated:Connect(function() tpTo(i) end)
        end
    end
end

tpSave.Activated:Connect(tpSavePoint)
tpClear.Activated:Connect(function()
    tpPoints = {}
    tpUpdate()
end)

tpUpdate()

-- ====================== MINIMIZAR / MAXIMIZAR ======================
local isMinimized = false

local function minimize()
    isMinimized = true
    frame.Visible = false
    bubble.Visible = true
end

local function maximize()
    isMinimized = false
    frame.Visible = true
    bubble.Visible = false
end

minimizeBtn.Activated:Connect(minimize)
bubble.Activated:Connect(maximize)

-- Arrastrar burbuja
local draggingBubble = false
local dragStartBubble, startPosBubble

bubble.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingBubble = true
        dragStartBubble = input.Position
        startPosBubble = bubble.Position
    end
end)

bubble.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingBubble = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingBubble and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartBubble
        bubble.Position = UDim2.new(startPosBubble.X.Scale, startPosBubble.X.Offset + delta.X, startPosBubble.Y.Scale, startPosBubble.Y.Offset + delta.Y)
    end
end)

-- Iniciar con ventana abierta
maximize()
