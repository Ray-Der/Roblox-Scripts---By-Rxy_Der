-- Teletransporte Móvil/PC Compacto (Delta OK)
-- Ventana pequeña 280x320, burbuja arrastrable, lista TP SIEMPRE visible.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local points = {}

local sg = Instance.new("ScreenGui")
sg.Name = "TeleportHub"
sg.ResetOnSpawn = false
sg.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 320)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = sg

local mc = Instance.new("UICorner")
mc.CornerRadius = UDim.new(0, 12)
mc.Parent = mainFrame

-- Título (arrastrable)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
title.BorderSizePixel = 0
title.Text = "🚀 Teleport Hub - By Rxy_Der"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.ZIndex = 10
title.Parent = mainFrame

local tc = Instance.new("UICorner")
tc.CornerRadius = UDim.new(0, 12)
tc.Parent = title

-- Burbuja TP pequeña y ARRASTRABLE (siempre visible)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 55, 0, 55)
toggleBtn.Position = UDim2.new(0, 20, 0, 20)
toggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
toggleBtn.Text = "TP"
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.TextScaled = true
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Parent = sg

local tbc = Instance.new("UICorner")
tbc.CornerRadius = UDim.new(0, 28)
tbc.Parent = toggleBtn

-- Botón Guardar
local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(1, -20, 0, 40)
saveBtn.Position = UDim2.new(0, 10, 0, 60)
saveBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
saveBtn.Text = "💾 GUARDAR"
saveBtn.TextColor3 = Color3.new(1,1,1)
saveBtn.TextScaled = true
saveBtn.Font = Enum.Font.Gotham
saveBtn.Parent = mainFrame

local sbc = Instance.new("UICorner")
sbc.CornerRadius = UDim.new(0, 8)
sbc.Parent = saveBtn

-- Botón Borrar
local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(1, -20, 0, 40)
clearBtn.Position = UDim2.new(0, 10, 0, 105)
clearBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
clearBtn.Text = "🗑️ BORRAR TODO"
clearBtn.TextColor3 = Color3.new(1,1,1)
clearBtn.TextScaled = true
clearBtn.Font = Enum.Font.Gotham
clearBtn.Parent = mainFrame

local cbc = Instance.new("UICorner")
cbc.CornerRadius = UDim.new(0, 8)
cbc.Parent = clearBtn

-- Contador puntos
local countLabel = Instance.new("TextLabel")
countLabel.Size = UDim2.new(1, -20, 0, 25)
countLabel.Position = UDim2.new(0, 10, 0, 150)
countLabel.BackgroundTransparency = 1
countLabel.Text = "Puntos: 0/10"
countLabel.TextColor3 = Color3.new(1,1,1)
countLabel.TextScaled = true
countLabel.Font = Enum.Font.Gotham
countLabel.Parent = mainFrame

-- Scroll para TP (siempre algo visible)
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -180)
scroll.Position = UDim2.new(0, 10, 0, 178)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 6
scroll.ScrollBarImageColor3 = Color3.new(1,1,1)
scroll.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 6)
listLayout.Parent = scroll

-- Auto-ajuste canvas
listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
end)

local function getHRP()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        return char.HumanoidRootPart
    end
    return nil
end

local function savePoint()
    local hrp = getHRP()
    if hrp then
        table.insert(points, 1, hrp.CFrame)
        local pos = hrp.Position
        print(string.format("✅ Punto #%d: %.0f, %.0f, %.0f", #points, pos.X, pos.Y, pos.Z))
        if #points > 10 then
            table.remove(points)
            print("📝 Máx 10 puntos")
        end
        updateButtons()
    else
        print("❌ Sin personaje")
    end
end

local function teleportTo(index)
    local hrp = getHRP()
    if hrp and points[index] then
        hrp.CFrame = points[index]
        print("🚀 TP a #" .. index)
    else
        print("❌ Punto #" .. index .. " no existe")
    end
end

function updateButtons()
    -- Limpia botones TP
    for _, child in pairs(scroll:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end
    
    local count = #points
    countLabel.Text = "Puntos: " .. count .. "/10"
    
    if count == 0 then
        local noPoints = Instance.new("TextLabel")
        noPoints.Size = UDim2.new(1, 0, 0, 40)
        noPoints.BackgroundTransparency = 1
        noPoints.Text = "👆 Toca GUARDAR para añadir TP"
        noPoints.TextColor3 = Color3.fromRGB(200, 200, 200)
        noPoints.TextScaled = true
        noPoints.Font = Enum.Font.Gotham
        noPoints.Parent = scroll
    else
        for i = 1, count do
            local pos = points[i].Position
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 35)
            btn.BackgroundColor3 = Color3.fromRGB(60 - i*3, 60 + i*2, 70)  -- Gradiente sutil
            btn.Text = string.format("TP #%d\n(%.0f, %.0f, %.0f)", i, pos.X, pos.Y, pos.Z)
            btn.TextColor3 = Color3.new(1,1,1)
            btn.TextScaled = true
            btn.Font = Enum.Font.Gotham
            btn.Parent = scroll
            local bc = Instance.new("UICorner")
            bc.CornerRadius = UDim.new(0, 8)
            bc.Parent = btn
            btn.MouseButton1Click:Connect(function() teleportTo(i) end)
        end
    end
end

-- Conexiones GUI
saveBtn.MouseButton1Click:Connect(savePoint)
clearBtn.MouseButton1Click:Connect(function()
    points = {}
    updateButtons()
    print("🗑️ Borrado")
end)
toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- ARRASTRAR MAIN FRAME (título)
local draggingFrame = false
local dragStartFrame, startPosFrame
title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingFrame = true
        dragStartFrame = input.Position
        startPosFrame = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then draggingFrame = false end
        end)
    end
end)

-- ARRASTRAR BURBUJA TP
local draggingBubble = false
local dragStartBubble, startPosBubble
toggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingBubble = true
        dragStartBubble = input.Position
        startPosBubble = toggleBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then draggingBubble = false end
        end)
    end
end)

-- Manejador global de arrastre
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if draggingFrame then
            local delta = input.Position - dragStartFrame
            mainFrame.Position = UDim2.new(startPosFrame.X.Scale, startPosFrame.X.Offset + delta.X, startPosFrame.Y.Scale, startPosFrame.Y.Offset + delta.Y)
        elseif draggingBubble then
            local delta = input.Position - dragStartBubble
            toggleBtn.Position = UDim2.new(startPosBubble.X.Scale, startPosBubble.X.Offset + delta.X, startPosBubble.Y.Scale, startPosBubble.Y.Offset + delta.Y)
        end
    end
end)

-- Teclas PC (opcional)
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        savePoint()
        mainFrame.Visible = true
    elseif input.KeyCode == Enum.KeyCode.Delete then
        points = {}; updateButtons(); print("🗑️ Borrado"); mainFrame.Visible = true
    elseif input.KeyCode == Enum.KeyCode.One then teleportTo(1); mainFrame.Visible = true
    -- ... (resto igual, pero abre GUI)
    elseif input.KeyCode == Enum.KeyCode.Two then teleportTo(2); mainFrame.Visible = true
    elseif input.KeyCode == Enum.KeyCode.Three then teleportTo(3); mainFrame.Visible = true
    elseif input.KeyCode == Enum.KeyCode.Four then teleportTo(4); mainFrame.Visible = true
    elseif input.KeyCode == Enum.KeyCode.Five then teleportTo(5); mainFrame.Visible = true
    elseif input.KeyCode == Enum.KeyCode.Six then teleportTo(6); mainFrame.Visible = true
    elseif input.KeyCode == Enum.KeyCode.Seven then teleportTo(7); mainFrame.Visible = true
    elseif input.KeyCode == Enum.KeyCode.Eight then teleportTo(8); mainFrame.Visible = true
    elseif input.KeyCode == Enum.KeyCode.Nine then teleportTo(9); mainFrame.Visible = true
    elseif input.KeyCode == Enum.KeyCode.Zero then teleportTo(10); mainFrame.Visible = true
    end
end)

updateButtons()
print("🎮 ¡Hub Compacto cargado! Burbuja TP arrastrable. Toca GUARDAR > TP listos.")
