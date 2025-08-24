

local startTime = tick()

local repo = "https://raw.githubusercontent.com/xXnikotosYTXx/ObsidianUi/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = false -- Forces AddToggle to AddCheckbox
Library.ShowToggleFrameInKeybinds = true -- Make toggle keybinds work inside the keybinds UI (aka adds a toggle to the UI). Good for mobile users (Default value = true)


local Workspace, RunService, Players, CoreGui, Lighting = cloneref(game:GetService("Workspace")), cloneref(game:GetService("RunService")), cloneref(game:GetService("Players")), game:GetService("CoreGui"), cloneref(game:GetService("Lighting"))







Library:Notify("Loading Esp", 0.5)






--ESP---
local ESP = {
    Enabled = true,
    TeamCheck = true,
    MaxDistance = 10000,
    FontSize = 11,
    FadeOut = {
        OnDistance = true,
        OnDeath = false,
        OnLeave = false,
    },
    Options = { 
        LockColor = Color3.fromRGB(255, 0, 0), -- цвет цели аимбота
        AimbotLocked = true, -- включение/отключение изменения цвета при блоке аимбота
        Teamcheck = false, TeamcheckRGB = Color3.fromRGB(0, 255, 0),
        Friendcheck = false, FriendcheckRGB = Color3.fromRGB(0, 255, 0),
        Highlight = false, HighlightRGB = Color3.fromRGB(255, 0, 0),
    },
    Drawing = {
        Chams = {
              Enabled = false,
            -- Visual Effects
             Thermal = false,  -- Breathing effect
        Pulse = true,   -- Pulsing effect
        Rainbow = false, -- Rainbow color cycle
        Wireframe = false, -- Wireframe rendering mode
            
            -- Colors and Transparency
        FillRGB = Color3.fromRGB(119, 120, 255),
        Fill_Transparency = 100,
        OutlineRGB = Color3.fromRGB(119, 120, 255),
        Outline_Transparency = 100,
            
            -- Thermal Effect Settings
        ThermalSpeed = 2,      -- Speed of thermal breathing
        ThermalIntensity = 3,  -- Intensity of thermal effect
            
            -- Pulse Effect Settings
        PulseSpeed = 1,        -- Speed of pulsing
        PulseMinTransparency = 0.2,
        PulseMaxTransparency = 0.5,
            
            -- Rainbow Effect Settings
        RainbowSpeed = 0.3,      -- Speed of color cycling
        RainbowSaturation = 1, -- Color saturation (0-1)
         RainbowBrightness = 1, -- Color brightness (0-1)
            
            -- Visibility Settings
        VisibleCheck = false,   -- Check if target is visible
        VisibleOnly = false,   -- Only show chams when target is visible
        OccludedColor = Color3.fromRGB(255, 0, 0),  -- Color when behind walls
        NonOccludedColor = Color3.fromRGB(0, 255, 0), -- Color when visible
            -- Team Settings
        TeamColorVisible = true, -- Use team colors for visible players
        TeamColorOccluded = false, -- Use team colors for occluded players
            -- Distance Settings
        MaxDistance = 1000,    -- Maximum distance to render chams
        FadeStartDistance = 500, -- Distance at which fade starts
            -- Performance Settings
         UpdateRate = 1,        -- Update rate for effects (1 = every frame)
        },
        Names = {
            Enabled = false,
            RGB = Color3.fromRGB(255, 255, 255),
        },
        Flags = {
            Enabled = true,
        },
        Distances = {
            Enabled = false, 
            Position = "Bottom",
            RGB = Color3.fromRGB(255, 255, 255),
        },
        Weapons = {
            Enabled = false, WeaponTextRGB = Color3.fromRGB(119, 120, 255),
            Outlined = true,
            Gradient = false,
            GradientRGB1 = Color3.fromRGB(255, 255, 255), GradientRGB2 = Color3.fromRGB(119, 120, 255),
        },
        Healthbar = {
            Enabled = false,  
            HealthText = true, Lerp = false, HealthTextRGB = Color3.fromRGB(255, 255, 255),
            Width = 2.5,
            Gradient = true, GradientRGB1 = Color3.fromRGB(3, 254, 174), GradientRGB2 = Color3.fromRGB(3, 254, 99), GradientRGB3 = Color3.fromRGB(58, 254, 3), 
        },
        Boxes = {
            Animate = false,
            RotationSpeed = 300,
            Gradient = true, GradientRGB1 = Color3.fromRGB(255, 255, 255), GradientRGB2 = Color3.fromRGB(255, 255, 255), 
            GradientFill = false, GradientFillRGB1 = Color3.fromRGB(255, 255, 255), GradientFillRGB2 = Color3.fromRGB(0, 0, 0), 
            LineBox = {
                Enabled = false,
                RGB = Color3.fromRGB(119, 120, 255),
            },
            Filled = {
                Enabled = true,
                Transparency = 1,
                RGB = Color3.fromRGB(119, 120, 255),
            },
            Full = {
                Enabled = false,
                RGB = Color3.fromRGB(119, 120, 255),
            },
            Corner = {
                Enabled = false,
                RGB = Color3.fromRGB(119, 120, 255),
            },
        };
    };
    Connections = {
        RunService = RunService;
    };
    Fonts = {};
}

local ChamsEffects = {}

-- Convert HSV to RGB for rainbow effect
ChamsEffects.HSVtoRGB = function(h, s, v)
    local r, g, b
    local i = math.floor(h * 6)
    local f = h * 6 - i
    local p = v * (1 - s)
    local q = v * (1 - f * s)
    local t = v * (1 - (1 - f) * s)

    i = i % 6

    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q
    end

    return Color3.new(r, g, b)
end

-- Calculate thermal effect
ChamsEffects.GetThermalEffect = function(settings, currentTime)
    local breathe_effect = math.atan(math.sin(currentTime * settings.ThermalSpeed)) * 2 / math.pi
    return breathe_effect * settings.ThermalIntensity
end

-- Calculate pulse effect
ChamsEffects.GetPulseEffect = function(settings, currentTime)
    local min, max = settings.PulseMinTransparency, settings.PulseMaxTransparency
    return min + (max - min) * (math.sin(currentTime * settings.PulseSpeed) + 1) / 2
end

-- Calculate rainbow color
ChamsEffects.GetRainbowColor = function(settings, currentTime)
    local hue = (currentTime * settings.RainbowSpeed) % 1
    -- Now, ChamsEffects is fully defined, and this call will work
    return ChamsEffects.HSVtoRGB(hue, settings.RainbowSaturation, settings.RainbowBrightness)
end

-- Test call
local ChamColor = ChamsEffects.HSVtoRGB(0.5, 1, 1)
print(ChamColor)  -- This should print the RGB color correctly

-- Def & Vars
local Euphoria = ESP.Connections;
local lplayer = Players.LocalPlayer;
local camera = game.Workspace.CurrentCamera;
local Cam = Workspace.CurrentCamera;
local RotationAngle, Tick = -45, tick();

-- Weapon Images
local Weapon_Icons = {
    ["Wooden Bow"] = "http://www.roblox.com/asset/?id=17677465400",
    ["Crossbow"] = "http://www.roblox.com/asset/?id=17677473017",
    ["Salvaged SMG"] = "http://www.roblox.com/asset/?id=17677463033",
    ["Salvaged AK47"] = "http://www.roblox.com/asset/?id=17677455113",
    ["Salvaged AK74u"] = "http://www.roblox.com/asset/?id=17677442346",
    ["Salvaged M14"] = "http://www.roblox.com/asset/?id=17677444642",
    ["Salvaged Python"] = "http://www.roblox.com/asset/?id=17677451737",
    ["Military PKM"] = "http://www.roblox.com/asset/?id=17677449448",
    ["Military M4A1"] = "http://www.roblox.com/asset/?id=17677479536",
    ["Bruno's M4A1"] = "http://www.roblox.com/asset/?id=17677471185",
    ["Military Barrett"] = "http://www.roblox.com/asset/?id=17677482998",
    ["Salvaged Skorpion"] = "http://www.roblox.com/asset/?id=17677459658",
    ["Salvaged Pump Action"] = "http://www.roblox.com/asset/?id=17677457186",
    ["Military AA12"] = "http://www.roblox.com/asset/?id=17677475227",
    ["Salvaged Break Action"] = "http://www.roblox.com/asset/?id=17677468751",
    ["Salvaged Pipe Rifle"] = "http://www.roblox.com/asset/?id=17677468751",
    ["Salvaged P250"] = "http://www.roblox.com/asset/?id=17677447257",
    ["Nail Gun"] = "http://www.roblox.com/asset/?id=17677484756",
    ["M249"] = "http://www.roblox.com/asset/?id=1760461955",  -- Replaced
    ["AWP"] = "http://www.roblox.com/asset/?id=1760466582",  -- Replaced
    ["CTKnife"] = "http://www.roblox.com/asset/?id=537583937",  -- Replaced
    ["DualBerettas"] = "http://www.roblox.com/asset/?id=1760451496",  -- Replaced
    ["R8"] = "http://www.roblox.com/asset/?id=1760453855",  -- Replaced
    ["FiveSeven"] = "http://www.roblox.com/asset/?id=1760452565",  -- Replaced
    ["DesertEagle"] = "http://www.roblox.com/asset/?id=1760453517",  -- Replaced
    ["Famas"] = "http://www.roblox.com/asset/?id=929141778",  -- Replaced
    ["Bizon"] = "http://www.roblox.com/asset/?id=929142284",  -- Replaced
    ["USP"] = "http://www.roblox.com/asset/?id=516703037",  -- Replaced
    ["MP7"] = "http://www.roblox.com/asset/?id=1760465938",  -- Replaced
    ["UMP"] = "http://www.roblox.com/asset/?id=1760462699",  -- Replaced
    ["MP7-SD"] = "http://www.roblox.com/asset/?id=1760464318",  -- Replaced
    ["Negev"] = "http://www.roblox.com/asset/?id=1760462131",  -- Replaced
    ["Nova"] = "http://www.roblox.com/asset/?id=1760461314",  -- Replaced
    ["M4A1"] = "http://www.roblox.com/asset/?id=1760463598",  -- Replaced
    ["CZ"] = "http://www.roblox.com/asset/?id=929140982",  -- Replaced
    ["CTGlove"] = "http://www.roblox.com/asset/?id=2135888079",  -- Replaced
    ["Scout"] = "http://www.roblox.com/asset/?id=929142913",  -- Replaced
    ["MP9"] = "http://www.roblox.com/asset/?id=1760466841",  -- Replaced
    ["P90"] = "http://www.roblox.com/asset/?id=929105150",  -- Replaced
    ["P2000"] = "http://www.roblox.com/asset/?id=929141651",  -- Replaced
    ["M4A4"] = "http://www.roblox.com/asset/?id=1760463859",  -- Replaced
    ["P250"] = "http://www.roblox.com/asset/?id=929141651",  -- Replaced
    ["AUG"] = "http://www.roblox.com/asset/?id=929141651",  -- Replaced
    ["MAG7"] = "http://www.roblox.com/asset/?id=1760461555",  -- Replaced
    ["XM"] = "http://www.roblox.com/asset/?id=929142464",  -- Replaced
    ["G3SG1"] = "http://www.roblox.com/asset/?id=929147844"  -- Replaced
};

-- Functions
local Functions = {}
do
    function Functions:Create(Class, Properties)
        local _Instance = typeof(Class) == 'string' and Instance.new(Class) or Class
        for Property, Value in pairs(Properties) do
            _Instance[Property] = Value
        end
        return _Instance;
    end
    --
    function Functions:FadeOutOnDist(element, distance)
        local transparency = math.max(0.1, 1 - (distance / ESP.MaxDistance))
        if element:IsA("TextLabel") then
            element.TextTransparency = 1 - transparency
        elseif element:IsA("ImageLabel") then
            element.ImageTransparency = 1 - transparency
        elseif element:IsA("UIStroke") then
            element.Transparency = 1 - transparency
        elseif element:IsA("Frame") and (element == Healthbar or element == BehindHealthbar) then
            element.BackgroundTransparency = 1 - transparency
        elseif element:IsA("Frame") then
            element.BackgroundTransparency = 1 - transparency
        elseif element:IsA("Highlight") then
            element.FillTransparency = 1 - transparency
            element.OutlineTransparency = 1 - transparency
        end;
    end;  
end;

do -- Initalize
    local ScreenGui = Functions:Create("ScreenGui", {
        Parent = CoreGui,
        Name = "ESPHolder",
    });

    local DupeCheck = function(plr)
        if ScreenGui:FindFirstChild(plr.Name) then
            ScreenGui[plr.Name]:Destroy()
        end
    end

    local ESP = function(plr)
        coroutine.wrap(DupeCheck)(plr) -- Dupecheck
        local Name = Functions:Create("TextLabel", {Parent = ScreenGui, Position = UDim2.new(0.5, 0, 0, -11), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0), RichText = true})
        local Distance = Functions:Create("TextLabel", {Parent = ScreenGui, Position = UDim2.new(0.5, 0, 0, 11), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0), RichText = true})
        local Weapon = Functions:Create("TextLabel", {Parent = ScreenGui, Position = UDim2.new(0.5, 0, 0, 31), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0), RichText = true})
        local Box = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 1, BorderSizePixel = 0})
        local Gradient1 = Functions:Create("UIGradient", {Parent = Box, Enabled = ESP.Drawing.Boxes.GradientFill, Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ESP.Drawing.Boxes.GradientFillRGB1), ColorSequenceKeypoint.new(1, ESP.Drawing.Boxes.GradientFillRGB2)}})
        local Outline = Functions:Create("UIStroke", {Parent = Box, Enabled = ESP.Drawing.Boxes.Gradient, Transparency = 0, Color = Color3.fromRGB(255, 255, 255), LineJoinMode = Enum.LineJoinMode.Miter})
        local Gradient2 = Functions:Create("UIGradient", {Parent = Outline, Enabled = ESP.Drawing.Boxes.Gradient, Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ESP.Drawing.Boxes.GradientRGB1), ColorSequenceKeypoint.new(1, ESP.Drawing.Boxes.GradientRGB2)}})
        local Healthbar = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0})
        local BehindHealthbar = Functions:Create("Frame", {Parent = ScreenGui, ZIndex = -1, BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 0})
        local HealthbarGradient = Functions:Create("UIGradient", {Parent = Healthbar, Enabled = ESP.Drawing.Healthbar.Gradient, Rotation = -90, Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ESP.Drawing.Healthbar.GradientRGB1), ColorSequenceKeypoint.new(0.5, ESP.Drawing.Healthbar.GradientRGB2), ColorSequenceKeypoint.new(1, ESP.Drawing.Healthbar.GradientRGB3)}})
        local HealthText = Functions:Create("TextLabel", {Parent = ScreenGui, Position = UDim2.new(0.5, 0, 0, 31), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0)})
        local Chams = Functions:Create("Highlight", {Parent = ScreenGui, FillTransparency = 1, OutlineTransparency = 0, OutlineColor = Color3.fromRGB(119, 120, 255), DepthMode = "AlwaysOnTop"})
        local WeaponIcon = Functions:Create("ImageLabel", {Parent = ScreenGui, BackgroundTransparency = 1, BorderColor3 = Color3.fromRGB(0, 0, 0), BorderSizePixel = 0, Size = UDim2.new(0, 40, 0, 40)})
        local Gradient3 = Functions:Create("UIGradient", {Parent = WeaponIcon, Rotation = -90, Enabled = ESP.Drawing.Weapons.Gradient, Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ESP.Drawing.Weapons.GradientRGB1), ColorSequenceKeypoint.new(1, ESP.Drawing.Weapons.GradientRGB2)}})
-- Full Box Lines
local TopLine = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.LineBox.RGB, ZIndex = 2})
local BottomLine = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.LineBox.RGB, ZIndex = 2})
local LeftLine = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.LineBox.RGB, ZIndex = 2})
local RightLine = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.LineBox.RGB, ZIndex = 2})

        local LeftTop = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
        local LeftSide = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
        local RightTop = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
        local RightSide = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
        local BottomSide = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
        local BottomDown = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
        local BottomRightSide = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
        local BottomRightDown = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
        local Flag1 = Functions:Create("TextLabel", {Parent = ScreenGui, Position = UDim2.new(1, 0, 0, 0), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0)})
        local Flag2 = Functions:Create("TextLabel", {Parent = ScreenGui, Position = UDim2.new(1, 0, 0, 0), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0)})
        --local DroppedItems = Functions:Create("TextLabel", {Parent = ScreenGui, AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0)})
        --
        local Updater = function()
            local Connection;
            local function HideESP()
                Box.Visible = false;
                Name.Visible = false;
                Distance.Visible = false;
                Weapon.Visible = false;
                Healthbar.Visible = false;
                BehindHealthbar.Visible = false;
                HealthText.Visible = false;
                WeaponIcon.Visible = false;
                LeftTop.Visible = false;
                LeftSide.Visible = false;
                BottomSide.Visible = false;
                BottomDown.Visible = false;
                RightTop.Visible = false;
                RightSide.Visible = false;
                BottomRightSide.Visible = false;
                BottomRightDown.Visible = false;
                Flag1.Visible = false;
                Chams.Enabled = false;
                Flag2.Visible = false;
                -- Full Line Box скрытие
    TopLine.Visible = false
    BottomLine.Visible = false
    LeftLine.Visible = false
    RightLine.Visible = false

                if not plr then
                    ScreenGui:Destroy();
                    Connection:Disconnect();
                end
            end
            --
            Connection = Euphoria.RunService.RenderStepped:Connect(function()
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local HRP = plr.Character.HumanoidRootPart
                    local Humanoid = plr.Character:WaitForChild("Humanoid");
                    local Pos, OnScreen = Cam:WorldToScreenPoint(HRP.Position)
                    local Dist = (Cam.CFrame.Position - HRP.Position).Magnitude / 3.5714285714
                    
                    if OnScreen and Dist <= ESP.MaxDistance then
                        local Size = HRP.Size.Y
                        local scaleFactor = (Size * Cam.ViewportSize.Y) / (Pos.Z * 2)
                        local w, h = 3 * scaleFactor, 4.5 * scaleFactor

                        Name.TextColor3 = ESP.Drawing.Names.RGB
            Distance.TextColor3 = ESP.Drawing.Distances.RGB
            Weapon.TextColor3 = ESP.Drawing.Weapons.WeaponTextRGB
            HealthText.TextColor3 = ESP.Drawing.Healthbar.HealthTextRGB

            -- LineBox (полные линии)
            TopLine.BackgroundColor3 = ESP.Drawing.Boxes.LineBox.RGB
            BottomLine.BackgroundColor3 = ESP.Drawing.Boxes.LineBox.RGB
            LeftLine.BackgroundColor3 = ESP.Drawing.Boxes.LineBox.RGB
            RightLine.BackgroundColor3 = ESP.Drawing.Boxes.LineBox.RGB

            -- Corner Box
            LeftTop.BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB
            LeftSide.BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB
            RightTop.BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB
            RightSide.BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB
            BottomSide.BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB
            BottomDown.BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB
            BottomRightSide.BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB
            BottomRightDown.BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB

            -- Filled Box
            Box.BackgroundColor3 = ESP.Drawing.Boxes.Filled.RGB

            -- Chams
            Chams.FillColor = ESP.Drawing.Chams.FillRGB
            Chams.OutlineColor = ESP.Drawing.Chams.OutlineRGB

            -- Градиенты
            Gradient1.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, ESP.Drawing.Boxes.GradientFillRGB1),
                ColorSequenceKeypoint.new(1, ESP.Drawing.Boxes.GradientFillRGB2)
            }

            Gradient2.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, ESP.Drawing.Boxes.GradientRGB1),
                ColorSequenceKeypoint.new(1, ESP.Drawing.Boxes.GradientRGB2)
            }

            HealthbarGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, ESP.Drawing.Healthbar.GradientRGB1),
                ColorSequenceKeypoint.new(0.5, ESP.Drawing.Healthbar.GradientRGB2),
                ColorSequenceKeypoint.new(1, ESP.Drawing.Healthbar.GradientRGB3)
            }

                        -- Fade-out effect --
                        if ESP.FadeOut.OnDistance then
                            Functions:FadeOutOnDist(Box, Dist)
                            Functions:FadeOutOnDist(Outline, Dist)
                            Functions:FadeOutOnDist(Name, Dist)
                            Functions:FadeOutOnDist(Distance, Dist)
                            Functions:FadeOutOnDist(Weapon, Dist)
                            Functions:FadeOutOnDist(Healthbar, Dist)
                            Functions:FadeOutOnDist(BehindHealthbar, Dist)
                            Functions:FadeOutOnDist(HealthText, Dist)
                            Functions:FadeOutOnDist(WeaponIcon, Dist)
                            Functions:FadeOutOnDist(LeftTop, Dist)
                            Functions:FadeOutOnDist(LeftSide, Dist)
                            Functions:FadeOutOnDist(BottomSide, Dist)
                            Functions:FadeOutOnDist(BottomDown, Dist)
                            Functions:FadeOutOnDist(RightTop, Dist)
                            Functions:FadeOutOnDist(RightSide, Dist)
                            Functions:FadeOutOnDist(BottomRightSide, Dist)
                            Functions:FadeOutOnDist(BottomRightDown, Dist)
                            Functions:FadeOutOnDist(Chams, Dist)
                            Functions:FadeOutOnDist(Flag1, Dist)
                            Functions:FadeOutOnDist(Flag2, Dist)
                        end

                        -- Teamcheck
                        if ESP.TeamCheck and plr ~= lplayer and ((lplayer.Team ~= plr.Team and plr.Team) or (not lplayer.Team and not plr.Team)) and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") then

                            do -- Chams
                                    if ESP.Drawing.Chams.Enabled then
                                        local settings = ESP.Drawing.Chams
                                        local currentTime = tick()
                                        
                                        -- Base setup
                                        Chams.Adornee = plr.Character
                                        Chams.Enabled = true
                                        
                                        -- Distance calculations
                                        local distance = (Cam.CFrame.Position - HRP.Position).Magnitude
                                        local distanceFade = math.clamp((settings.MaxDistance - distance) / (settings.MaxDistance - settings.FadeStartDistance), 0, 1)
                                        
                                        -- Visibility check
                                        local isVisible = true
                                        if settings.VisibleCheck then
                                            local ray = Ray.new(Cam.CFrame.Position, (HRP.Position - Cam.CFrame.Position).Unit * 500)
                                            local hit = workspace:FindPartOnRayWithIgnoreList(ray, {Cam, lplayer.Character})
                                            isVisible = hit and hit:IsDescendantOf(plr.Character) or false
                                        end
                                        
                                        -- Color determination
                                        local baseColor = settings.FillRGB
                                        if settings.Rainbow then
                                            baseColor = ChamsEffects.GetRainbowColor(settings, currentTime)
                                        elseif settings.VisibleCheck and settings.TeamColorVisible then
                                            baseColor = isVisible and settings.NonOccludedColor or settings.OccludedColor
                                        end
                                        
                                        -- Apply effects
                                        local finalTransparency = settings.Fill_Transparency * 0.01
                                        if settings.Thermal then
                                            finalTransparency = finalTransparency * ChamsEffects.GetThermalEffect(settings, currentTime)
                                        end
                                        if settings.Pulse then
                                            finalTransparency = finalTransparency * ChamsEffects.GetPulseEffect(settings, currentTime)
                                        end
                                        
                                        -- Apply distance fade
                                        finalTransparency = finalTransparency * distanceFade
                                        
                                        -- Update highlight properties
                                        Chams.FillColor = baseColor
                                        Chams.OutlineColor = settings.OutlineRGB
                                        Chams.FillTransparency = finalTransparency
                                        Chams.OutlineTransparency = settings.Outline_Transparency * 0.01 * distanceFade
                                        
                                        -- Update visibility mode
                                        if settings.VisibleCheck then
                                            Chams.DepthMode = settings.VisibleOnly and "Occluded" or "AlwaysOnTop"
                                        else
                                            Chams.DepthMode = "AlwaysOnTop"
                                        end
                                    else
                                        Chams.Enabled = false
                                    end
                                end


-- Обновление позиции и размера
do
    local x, y = math.floor(Pos.X), math.floor(Pos.Y)
    local width, height = math.floor(w), math.floor(h)

    -- Верхняя
    TopLine.Visible = ESP.Drawing.Boxes.LineBox.Enabled
    TopLine.Position = UDim2.new(0, x - width/2, 0, y - height/2)
    TopLine.Size = UDim2.new(0, width, 0, 1)

    -- Нижняя
    BottomLine.Visible = ESP.Drawing.Boxes.LineBox.Enabled
    BottomLine.Position = UDim2.new(0, x - width/2, 0, y + height/2 - 1)
    BottomLine.Size = UDim2.new(0, width, 0, 1)

    -- Левая
    LeftLine.Visible = ESP.Drawing.Boxes.LineBox.Enabled
    LeftLine.Position = UDim2.new(0, x - width/2, 0, y - height/2)
    LeftLine.Size = UDim2.new(0, 1, 0, height)

    -- Правая
    RightLine.Visible = ESP.Drawing.Boxes.LineBox.Enabled
    RightLine.Position = UDim2.new(0, x + width/2 - 1, 0, y - height/2)
    RightLine.Size = UDim2.new(0, 1, 0, height)

end

                            do -- Corner Boxes
                                LeftTop.Visible = ESP.Drawing.Boxes.Corner.Enabled
                                LeftTop.Position = UDim2.new(0, Pos.X - w / 2, 0, Pos.Y - h / 2)
                                LeftTop.Size = UDim2.new(0, w / 5, 0, 1)
                                
                                LeftSide.Visible = ESP.Drawing.Boxes.Corner.Enabled
                                LeftSide.Position = UDim2.new(0, Pos.X - w / 2, 0, Pos.Y - h / 2)
                                LeftSide.Size = UDim2.new(0, 1, 0, h / 5)
                                
                                BottomSide.Visible = ESP.Drawing.Boxes.Corner.Enabled
                                BottomSide.Position = UDim2.new(0, Pos.X - w / 2, 0, Pos.Y + h / 2)
                                BottomSide.Size = UDim2.new(0, 1, 0, h / 5)
                                BottomSide.AnchorPoint = Vector2.new(0, 5)
                                
                                BottomDown.Visible = ESP.Drawing.Boxes.Corner.Enabled
                                BottomDown.Position = UDim2.new(0, Pos.X - w / 2, 0, Pos.Y + h / 2)
                                BottomDown.Size = UDim2.new(0, w / 5, 0, 1)
                                BottomDown.AnchorPoint = Vector2.new(0, 1)
                                
                                RightTop.Visible = ESP.Drawing.Boxes.Corner.Enabled
                                RightTop.Position = UDim2.new(0, Pos.X + w / 2, 0, Pos.Y - h / 2)
                                RightTop.Size = UDim2.new(0, w / 5, 0, 1)
                                RightTop.AnchorPoint = Vector2.new(1, 0)
                                
                                RightSide.Visible = ESP.Drawing.Boxes.Corner.Enabled
                                RightSide.Position = UDim2.new(0, Pos.X + w / 2 - 1, 0, Pos.Y - h / 2)
                                RightSide.Size = UDim2.new(0, 1, 0, h / 5)
                                RightSide.AnchorPoint = Vector2.new(0, 0)
                                
                                BottomRightSide.Visible = ESP.Drawing.Boxes.Corner.Enabled
                                BottomRightSide.Position = UDim2.new(0, Pos.X + w / 2, 0, Pos.Y + h / 2)
                                BottomRightSide.Size = UDim2.new(0, 1, 0, h / 5)
                                BottomRightSide.AnchorPoint = Vector2.new(1, 1)
                                
                                BottomRightDown.Visible = ESP.Drawing.Boxes.Corner.Enabled
                                BottomRightDown.Position = UDim2.new(0, Pos.X + w / 2, 0, Pos.Y + h / 2)
                                BottomRightDown.Size = UDim2.new(0, w / 5, 0, 1)
                                BottomRightDown.AnchorPoint = Vector2.new(1, 1)                                                            
                            end

do -- Boxes
    Box.Position = UDim2.new(0, Pos.X - w / 2, 0, Pos.Y - h / 2)
    Box.Size = UDim2.new(0, w, 0, h)
    Box.Visible = ESP.Drawing.Boxes.Full.Enabled;

    -- Gradient
    if ESP.Drawing.Boxes.Filled.Enabled then
        Box.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

        -- Проверка Aimbot Lock
        local isLocked = (getgenv().Aimbot and getgenv().Aimbot.Locked == plr)
        if ESP.Options.AimbotLocked and isLocked then
            Gradient1.Color = ColorSequence.new(ESP.Options.LockColor)
            Gradient2.Color = ColorSequence.new(ESP.Options.LockColor)
        else
            Gradient1.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, ESP.Drawing.Boxes.GradientRGB1),
                ColorSequenceKeypoint.new(1, ESP.Drawing.Boxes.GradientRGB2)
            }
            Gradient2.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, ESP.Drawing.Boxes.GradientRGB1),
                ColorSequenceKeypoint.new(1, ESP.Drawing.Boxes.GradientRGB2)
            }
        end

        if ESP.Drawing.Boxes.GradientFill then
            Box.BackgroundTransparency = ESP.Drawing.Boxes.Filled.Transparency;
        else
            Box.BackgroundTransparency = 1
        end
        Box.BorderSizePixel = 1
    else
        Box.BackgroundTransparency = 1
    end

    -- Animation
    RotationAngle = RotationAngle + (tick() - Tick) * ESP.Drawing.Boxes.RotationSpeed * math.cos(math.pi / 4 * tick() - math.pi / 2)
    if ESP.Drawing.Boxes.Animate then
        Gradient1.Rotation = RotationAngle
        Gradient2.Rotation = RotationAngle
    else
        Gradient1.Rotation = -45
        Gradient2.Rotation = -45
    end
    Tick = tick()
end



                            -- Healthbar
                            do  
                                local health = Humanoid.Health / Humanoid.MaxHealth;
                                Healthbar.Visible = ESP.Drawing.Healthbar.Enabled;
                                Healthbar.Position = UDim2.new(0, Pos.X - w / 2 - 6, 0, Pos.Y - h / 2 + h * (1 - health))  
                                Healthbar.Size = UDim2.new(0, ESP.Drawing.Healthbar.Width, 0, h * health)  
                                --
                                BehindHealthbar.Visible = ESP.Drawing.Healthbar.Enabled;
                                BehindHealthbar.Position = UDim2.new(0, Pos.X - w / 2 - 6, 0, Pos.Y - h / 2)  
                                BehindHealthbar.Size = UDim2.new(0, ESP.Drawing.Healthbar.Width, 0, h)
                                -- Health Text
                                do
                                    if ESP.Drawing.Healthbar.HealthText then
                                        local healthPercentage = math.floor(Humanoid.Health / Humanoid.MaxHealth * 100)
                                        HealthText.Position = UDim2.new(0, Pos.X - w / 2 - 6, 0, Pos.Y - h / 2 + h * (1 - healthPercentage / 100) + 3)
                                        HealthText.Text = tostring(healthPercentage)
                                        HealthText.Visible = Humanoid.Health < Humanoid.MaxHealth
                                        if ESP.Drawing.Healthbar.Lerp then
                                            local color = health >= 0.75 and Color3.fromRGB(0, 255, 0) or health >= 0.5 and Color3.fromRGB(255, 255, 0) or health >= 0.25 and Color3.fromRGB(255, 170, 0) or Color3.fromRGB(255, 0, 0)
                                            HealthText.TextColor3 = color
                                        else
                                            HealthText.TextColor3 = ESP.Drawing.Healthbar.HealthTextRGB
                                        end
                                    end                        
                                end
                            end

do -- Names
    Name.Visible = ESP.Drawing.Names.Enabled
    local isLocked = (getgenv().Aimbot and getgenv().Aimbot.Locked == plr)
    local isFriend = (ESP.Options.Friendcheck and lplayer:IsFriendsWith(plr.UserId))
    local normalColor = ESP.Drawing.Names.RGB -- обычный цвет текста

    if ESP.Options.AimbotLocked and isLocked then
        -- Если включен AimbotLocked и цель захвачена
        Name.Text = string.format('[<font color="rgb(%d, %d, %d)">Locked</font>] %s', 255, 0, 0, plr.Name)
        Name.TextColor3 = ESP.Options.LockColor
    else
        -- Обычная проверка: друг или враг
        if isFriend then
Name.Text = string.format('[<font color="rgb(%d, %d, %d)">F</font>] %s', ESP.Options.FriendcheckRGB.R * 255, ESP.Options.FriendcheckRGB.G * 255, ESP.Options.FriendcheckRGB.B * 255, plr.Name)
            Name.TextColor3 = ESP.Options.FriendcheckRGB
        else
Name.Text = string.format('[<font color="rgb(%d, %d, %d)">E</font>] %s', 255, 0, 0, plr.Name)
        end
    end

    Name.Position = UDim2.new(0, Pos.X, 0, Pos.Y - h / 2 - 9)
end


                            
do -- Distance
    Distance.Visible = false
    Distance.Text = ""

    if ESP.Drawing.Distances.Enabled then
        if ESP.Drawing.Distances.Position == "Bottom" then
            Distance.Position = UDim2.new(0, Pos.X, 0, Pos.Y + h / 2 + 7)
            Distance.Text = string.format("%dm", math.floor(Dist))
            Distance.Visible = true

            -- сдвигаем Weapon вниз под Distance
            Weapon.Position = UDim2.new(0, Pos.X, 0, Pos.Y + h / 2 + 18)
            WeaponIcon.Position = UDim2.new(0, Pos.X - 21, 0, Pos.Y + h / 2 + 15)

        elseif ESP.Drawing.Distances.Position == "Text" then
            Distance.Visible = false
            -- Weapon остаётся под боксом
            Weapon.Position = UDim2.new(0, Pos.X, 0, Pos.Y + h / 2 + 8)
            WeaponIcon.Position = UDim2.new(0, Pos.X - 21, 0, Pos.Y + h / 2 + 5)

            if ESP.Options.Friendcheck and lplayer:IsFriendsWith(plr.UserId) then
                Name.Text = string.format('(<font color="rgb(%d, %d, %d)">F</font>) %s [%d]',
                    ESP.Options.FriendcheckRGB.R * 255,
                    ESP.Options.FriendcheckRGB.G * 255,
                    ESP.Options.FriendcheckRGB.B * 255,
                    plr.Name, math.floor(Dist))
            else
                Name.Text = string.format('(<font color="rgb(%d, %d, %d)">E</font>) %s [%d]',
                    255, 0, 0, plr.Name, math.floor(Dist))
            end
            Name.Visible = ESP.Drawing.Names.Enabled
        end
    else
        -- если Distance вообще выключен → Weapon под бокс
        Weapon.Position = UDim2.new(0, Pos.X, 0, Pos.Y + h / 2 + 8)
        WeaponIcon.Position = UDim2.new(0, Pos.X - 21, 0, Pos.Y + h / 2 + 5)
    end
end

do -- Weapons
    Weapon.Text = ""          -- сначала обнуляем
    Weapon.Visible = false    -- скрываем
    Weapon.Position = UDim2.new(0, Pos.X, 0, Pos.Y + h / 2 + 8) -- позиция по умолчанию под бокс
    WeaponIcon.Position = UDim2.new(0, Pos.X - 21, 0, Pos.Y + h / 2 + 5)

    if ESP.Drawing.Weapons.Enabled then
        Weapon.Visible = true
        Weapon.Text = "none"

        -- если Distance включён и видим
        if ESP.Drawing.Distances.Enabled and Distance.Visible then
            Weapon.Position = UDim2.new(0, Pos.X, 0, Pos.Y + h / 2 + 18)
            WeaponIcon.Position = UDim2.new(0, Pos.X - 21, 0, Pos.Y + h / 2 + 15)
        end

        -- проверяем оружие у игрока
        if plr.Character then
            for _, v in pairs(plr.Character:GetChildren()) do
                if v:IsA("Tool") then
                    Weapon.Text = v.Name
                    break
                end
            end
        end
    end
end    

                
                        else
                            HideESP();
                        end
                    else
                        HideESP();
                    end
                else
                    HideESP();
                end
            end)
        end
        coroutine.wrap(Updater)();
    end
    do -- Update ESP
        for _, v in pairs(game:GetService("Players"):GetPlayers()) do
            if v.Name ~= lplayer.Name then
                coroutine.wrap(ESP)(v)
            end      
        end
        --
        game:GetService("Players").PlayerAdded:Connect(function(v)
            coroutine.wrap(ESP)(v)
        end);
    end;
end;



Library:Notify("Loading UI", 2)


--// Cache

local select = select
local pcall, getgenv, next, Vector2, mathclamp, type, mousemoverel = select(1, pcall, getgenv, next, Vector2.new, math.clamp, type, mousemoverel or (Input and Input.MouseMove))

--// Preventing Multiple Processes

pcall(function()
	getgenv().Aimbot.Functions:Exit()
end)

--// Environment

getgenv().Aimbot = {}
local Environment = getgenv().Aimbot

--// Services

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

--// Variables

local RequiredDistance, Typing, Running, Animation, ServiceConnections = 2000, false, false, nil, {}

--// Script Settings

Environment.Settings = {
	Enabled = false,
	TeamCheck = false,
	AliveCheck = true,
	WallCheck = false, -- Laggy
	Sensitivity = 0, -- Animation length (in seconds) before fully locking onto target
	ThirdPerson = false, -- Uses mousemoverel instead of CFrame to support locking in third person (could be choppy)
	ThirdPersonSensitivity = 3, -- Boundary: 0.1 - 5
	TriggerKey = "MouseButton2",
	Toggle = false,
	LockPart = "Head" -- Body part to lock on
}

Environment.FOVSettings = {
	Enabled = true,
	Visible = true,
	Amount = 90,
	Color = Color3.fromRGB(255, 255, 255),
	LockedColor = Color3.fromRGB(255, 70, 70),
	Transparency = 0.5,
	Sides = 30,
	Thickness = 1,
	Filled = false
}

Environment.FOVCircle = Drawing.new("Circle")

--// Functions

local function CancelLock()
	Environment.Locked = nil
	if Animation then Animation:Cancel() end
	Environment.FOVCircle.Color = Environment.FOVSettings.Color
end

local function GetClosestPlayer()
	if not Environment.Locked then
		RequiredDistance = (Environment.FOVSettings.Enabled and Environment.FOVSettings.Amount or 2000)

		for _, v in next, Players:GetPlayers() do
			if v ~= LocalPlayer then
				if v.Character and v.Character:FindFirstChild(Environment.Settings.LockPart) and v.Character:FindFirstChildOfClass("Humanoid") then
					if Environment.Settings.TeamCheck and v.Team == LocalPlayer.Team then continue end
					if Environment.Settings.AliveCheck and v.Character:FindFirstChildOfClass("Humanoid").Health <= 0 then continue end
					if Environment.Settings.WallCheck and #(Camera:GetPartsObscuringTarget({v.Character[Environment.Settings.LockPart].Position}, v.Character:GetDescendants())) > 0 then continue end

					local Vector, OnScreen = Camera:WorldToViewportPoint(v.Character[Environment.Settings.LockPart].Position)
					local Distance = (Vector2(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2(Vector.X, Vector.Y)).Magnitude

					if Distance < RequiredDistance and OnScreen then
						RequiredDistance = Distance
						Environment.Locked = v
					end
				end
			end
		end
	else
		-- вот сюда и вставляется проверка на RequiredDistance
		if (Vector2(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) 
		- Vector2(Camera:WorldToViewportPoint(Environment.Locked.Character[Environment.Settings.LockPart].Position).X, 
		          Camera:WorldToViewportPoint(Environment.Locked.Character[Environment.Settings.LockPart].Position).Y)).Magnitude > RequiredDistance then
			CancelLock()
		end
	end
end


--// Typing Check

ServiceConnections.TypingStartedConnection = UserInputService.TextBoxFocused:Connect(function()
	Typing = true
end)

ServiceConnections.TypingEndedConnection = UserInputService.TextBoxFocusReleased:Connect(function()
	Typing = false
end)

--// Main

local function Load()
	ServiceConnections.RenderSteppedConnection = RunService.RenderStepped:Connect(function()
		if Environment.FOVSettings.Enabled and Environment.Settings.Enabled then
			Environment.FOVCircle.Radius = Environment.FOVSettings.Amount
			Environment.FOVCircle.Thickness = Environment.FOVSettings.Thickness
			Environment.FOVCircle.Filled = Environment.FOVSettings.Filled
			Environment.FOVCircle.NumSides = Environment.FOVSettings.Sides
			Environment.FOVCircle.Color = Environment.FOVSettings.Color
			Environment.FOVCircle.Transparency = Environment.FOVSettings.Transparency
			Environment.FOVCircle.Visible = Environment.FOVSettings.Visible
			Environment.FOVCircle.Position = Vector2(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
		else
			Environment.FOVCircle.Visible = false
		end

		if Running and Environment.Settings.Enabled then
			GetClosestPlayer()

			if Environment.Locked then
				if Environment.Settings.ThirdPerson then
					Environment.Settings.ThirdPersonSensitivity = mathclamp(Environment.Settings.ThirdPersonSensitivity, 0.1, 5)

					local Vector = Camera:WorldToViewportPoint(Environment.Locked.Character[Environment.Settings.LockPart].Position)
					mousemoverel((Vector.X - UserInputService:GetMouseLocation().X) * Environment.Settings.ThirdPersonSensitivity, (Vector.Y - UserInputService:GetMouseLocation().Y) * Environment.Settings.ThirdPersonSensitivity)
				else
					if Environment.Settings.Sensitivity > 0 then
						Animation = TweenService:Create(Camera, TweenInfo.new(Environment.Settings.Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(Camera.CFrame.Position, Environment.Locked.Character[Environment.Settings.LockPart].Position)})
						Animation:Play()
					else
						Camera.CFrame = CFrame.new(Camera.CFrame.Position, Environment.Locked.Character[Environment.Settings.LockPart].Position)
					end
				end

			Environment.FOVCircle.Color = Environment.FOVSettings.LockedColor

			end
		end
	end)

	ServiceConnections.InputBeganConnection = UserInputService.InputBegan:Connect(function(Input)
		if not Typing then
			pcall(function()
				if Input.KeyCode == Enum.KeyCode[Environment.Settings.TriggerKey] then
					if Environment.Settings.Toggle then
						Running = not Running

						if not Running then
							CancelLock()
						end
					else
						Running = true
					end
				end
			end)

			pcall(function()
				if Input.UserInputType == Enum.UserInputType[Environment.Settings.TriggerKey] then
					if Environment.Settings.Toggle then
						Running = not Running

						if not Running then
							CancelLock()
						end
					else
						Running = true
					end
				end
			end)
		end
	end)

	ServiceConnections.InputEndedConnection = UserInputService.InputEnded:Connect(function(Input)
		if not Typing then
			if not Environment.Settings.Toggle then
				pcall(function()
					if Input.KeyCode == Enum.KeyCode[Environment.Settings.TriggerKey] then
						Running = false; CancelLock()
					end
				end)

				pcall(function()
					if Input.UserInputType == Enum.UserInputType[Environment.Settings.TriggerKey] then
						Running = false; CancelLock()
					end
				end)
			end
		end
	end)
end

--// Functions

Environment.Functions = {}

function Environment.Functions:Exit()
	for _, v in next, ServiceConnections do
		v:Disconnect()
	end

	if Environment.FOVCircle.Remove then Environment.FOVCircle:Remove() end

	getgenv().Aimbot.Functions = nil
	getgenv().Aimbot = nil
	
	Load = nil; GetClosestPlayer = nil; CancelLock = nil
end

function Environment.Functions:Restart()
	for _, v in next, ServiceConnections do
		v:Disconnect()
	end

	Load()
end

function Environment.Functions:ResetSettings()
	Environment.Settings = {
		Enabled = true,
		TeamCheck = false,
		AliveCheck = true,
		WallCheck = false,
		Sensitivity = 0, -- Animation length (in seconds) before fully locking onto target
		ThirdPerson = false, -- Uses mousemoverel instead of CFrame to support locking in third person (could be choppy)
		ThirdPersonSensitivity = 3, -- Boundary: 0.1 - 5
		TriggerKey = "MouseButton2",
		Toggle = false,
		LockPart = "Head" -- Body part to lock on
	}

	Environment.FOVSettings = {
		Enabled = true,
		Visible = true,
		Amount = 90,
		Color = Color3.fromRGB(255, 255, 255),
		LockedColor = Color3.fromRGB(255, 70, 70),
		Transparency = 0.5,
		Sides = 30,
		Thickness = 1,
		Filled = false
	}
end

--// Load

Load()


local Window = Library:CreateWindow({
	-- Set Center to true if you want the menu to appear in the center
	-- Set AutoShow to true if you want the menu to appear when it is created
	-- Set Resizable to true if you want to have in-game resizable Window
	-- Set MobileButtonsSide to "Left" or "Right" if you want the ui toggle & lock buttons to be on the left or right side of the window
	-- Set ShowCustomCursor to false if you don't want to use the Linoria cursor
	-- NotifySide = Changes the side of the notifications (Left, Right) (Default value = Left)
	-- Position and Size are also valid options here
	-- but you do not need to define them unless you are changing them :)

	Title = "Project Radiant",
	Footer = "Universal | https://discord.gg/YyesGSdJCB |",
	Icon = 115758571278566,
	NotifySide = "Right",
	ShowCustomCursor = false,
})

-- CALLBACK NOTE:
-- Passing in callback functions via the initial element parameters (i.e. Callback = function(Value)...) works
-- HOWEVER, using Toggles/Options.INDEX:OnChanged(function(Value) ... ) is the RECOMMENDED way to do this.
-- I strongly recommend decoupling UI code from logic code. i.e. Create your UI elements FIRST, and THEN setup :OnChanged functions later.

-- You do not have to set your tabs & groups up this way, just a prefrence.
-- You can find more icons in https://lucide.dev/
local Tabs = {
	-- Creates a new tab titled Main
    Aimbot = Window:AddTab("Aimbot", "user"),
	ESP = Window:AddTab("ESP", "user"),
	["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}


--[[
Example of how to add a warning box to a tab; the title AND text support rich text formatting.

local WarningTab = Tabs["UI Settings"]:AddTab("Warning Box", "user")

WarningTab:UpdateWarningBox({
	Visible = true,
	Title = "Warning",
	Text = "This is a warning box!",
})

]]

-- Groupbox and Tabbox inherit the same functions
-- except Tabboxes you have to call the functions on a tab (Tabbox:AddTab(name))




local ESPBox = Tabs.ESP:AddLeftGroupbox('ESP')
local ChamsBox = Tabs.ESP:AddRightGroupbox('Chams')
local VisualsBox = Tabs.ESP:AddLeftGroupbox('Additional Visuals')
local CrosshairBox = Tabs.ESP:AddRightGroupbox('Crosshair Settings')





------_AIMBOT_------------


local AimbotGroup = Tabs.Aimbot:AddLeftGroupbox("Aimbot Settings")

AimbotGroup:AddToggle("Aimbot_Toggle", {
	Text = "Enable Aimbot",
	Default = Environment.Settings.Enabled,
	Tooltip = "Включить или отключить Aimbot",
	Callback = function(Value)
		Environment.Settings.Enabled = Value
	end,
})

AimbotGroup:AddToggle("Aimbot_Toggle", {
	Text = "ESPAimLocked",
	Default = ESP.Options.AimbotLocked,
	Tooltip = "Включить или отключить Aimbot",
	Callback = function(Value)
		ESP.Options.AimbotLocked = Value
	end,
}):AddColorPicker('NameESPColor', {
    Default = ESP.Options.LockColor,
    Title = 'LockedColor',
    Callback = function(Value)
        ESP.Options.LockColor = Value
    end
})



AimbotGroup:AddSlider("Aimbot_Sensitivity2", {
	Text = "mousemoverel Sensitivity",
	Default = Environment.Settings.Sensitivity,
	Min = 0,
	Max = 0.5,
	Rounding = 1,
	Callback = function(Value)
		Environment.Settings.Sensitivity = Value
	end,
})

AimbotGroup:AddToggle("Aimbot_Toggle", {
	Text = "TeamCheck",
	Default = Environment.Settings.ThirdPerson,
	Tooltip = "ThirdPersons",
	Callback = function(Value)
		Environment.Settings.ThirdPerson = Value
	end,
})
AimbotGroup:AddToggle("Aimbot_Toggle", {
	Text = "ThirdPerson",
	Default = Environment.Settings.ThirdPerson,
	Tooltip = "ThirdPersons",
	Callback = function(Value)
		Environment.Settings.ThirdPerson = Value
	end,
})


AimbotGroup:AddDropdown("Aimbot_LockPart", {
	Values = { "Head", "HumanoidRootPart", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg" },
	Default = Environment.Settings.LockPart,
	Multi = false,
	Tooltip = "Выбор части тела для прицеливания",
	Callback = function(Value)
		Environment.Settings.LockPart = Value
	end,
})





local AimbotFOVGroup = Tabs.Aimbot:AddRightGroupbox("Field Of View Settings")


AimbotFOVGroup:AddToggle("Field Of View", {
	Text = "Field Of View Visibility",
	--Tooltip = "Players Nametags", -- Information shown when you hover over the toggle
	DisabledTooltip = "I am disabled!", -- Information shown when you hover over the toggle while it's disabled

	Default = Environment.FOVSettings.Visible, -- Default value (true / false)
	Disabled = false, -- Will disable the toggle (true / false)
	Visible = true, -- Will make the toggle invisible (true / false)
	Risky = false, -- Makes the text red (the color can be changed using Library.Scheme.Red) (Default value = false)

	Callback = function(Value)
		Environment.FOVSettings.Visible = Value
	end
})

AimbotFOVGroup:AddToggle("Field Of View", {
	Text = "Filled",
	--Tooltip = "Players Nametags", -- Information shown when you hover over the toggle
	DisabledTooltip = "I am disabled!", -- Information shown when you hover over the toggle while it's disabled

	Default = Environment.FOVSettings.Filled, -- Default value (true / false)
	Disabled = false, -- Will disable the toggle (true / false)
	Visible = true, -- Will make the toggle invisible (true / false)
	Risky = false, -- Makes the text red (the color can be changed using Library.Scheme.Red) (Default value = false)

	Callback = function(Value)
		Environment.FOVSettings.Filled = Value
	end
})

AimbotFOVGroup:AddSlider("Aimbot_FOV_Radius", {
    Text = "Radius",
    Default = Environment.FOVSettings.Amount,
    Min = 0,
    Max = 720,
    Rounding = 0,
    Callback = function(Value)
        Environment.FOVSettings.Amount = Value
    end,
})

AimbotFOVGroup:AddSlider("Aimbot_FOV_NumSides", {
    Text = "Sides",
    Default = Environment.FOVSettings.Sides,
    Min = 3,
    Max = 30,
    Rounding = 0,
    Callback = function(Value)
        Environment.FOVSettings.Sides = Value
    end,
})

AimbotFOVGroup:AddSlider("Aimbot_FOV_Transparency", {
    Text = "Transparency",
    Default = Environment.FOVSettings.Transparency,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Callback = function(Value)
        Environment.FOVSettings.Transparency = Value
    end,
})

AimbotFOVGroup:AddSlider("Aimbot_FOV_Thickness", {
    Text = "Thickness",
    Default = Environment.FOVSettings.Thickness,
    Min = 1,
    Max = 5,
    Rounding = 0,
    Callback = function(Value)
        Environment.FOVSettings.Thickness = Value
    end,
})




-----_ESP_-------------
-- NameESP
ESPBox:AddToggle("Nametags Players", {
	Text = "Nametags",
	--Tooltip = "Players Nametags", -- Information shown when you hover over the toggle
	DisabledTooltip = "I am disabled!", -- Information shown when you hover over the toggle while it's disabled

	Default = false, -- Default value (true / false)
	Disabled = false, -- Will disable the toggle (true / false)
	Visible = true, -- Will make the toggle invisible (true / false)
	Risky = false, -- Makes the text red (the color can be changed using Library.Scheme.Red) (Default value = false)

	Callback = function(Value)
		ESP.Drawing.Names.Enabled = Value
	end
}):AddColorPicker('NameESPColor', {
    Default = ESP.Drawing.Names.RGB,
    Title = 'Nametags Color',
    Callback = function(Value)
        ESP.Drawing.Names.RGB = Value
    end
})
-- Distance
ESPBox:AddToggle('DistanceESP', {
    Text = 'Display Distance',
    Default = false,
    Callback = function(Value)
        ESP.Drawing.Distances.Enabled = Value
    end
})


ESPBox:AddDropdown("DistancePosition", {
    Text = "Distance Type",
    Values = { "Bottom", "Text" },
    Default = ESP.Drawing.Distances.Position,
    Callback = function(Value)
        ESP.Drawing.Distances.Position = Value

        -- если Distance включён, обновляем видимость/позицию
        if ESP.Drawing.Distances.Enabled then
            if Value == "Bottom" then
                Distance.Visible = true
                Weapon.Position = UDim2.new(0, Pos.X, 0, Pos.Y + h / 2 + 18)
                WeaponIcon.Position = UDim2.new(0, Pos.X - 21, 0, Pos.Y + h / 2 + 15)
                Distance.Position = UDim2.new(0, Pos.X, 0, Pos.Y + h / 2 + 7)
            elseif Value == "Text" then
                Distance.Visible = false
                Weapon.Position = UDim2.new(0, Pos.X, 0, Pos.Y + h / 2 + 8)
                WeaponIcon.Position = UDim2.new(0, Pos.X - 21, 0, Pos.Y + h / 2 + 5)
            end
        end
    end
})


-- Тоггл для обычных боксов (Corner / Line)

ESPBox:AddToggle("CornerEsp", {
    Text = "Boxes [Corner]",
    Default = ESP.Drawing.Boxes.Corner.Enabled,
    Callback = function(Value)
        ESP.Drawing.Boxes.Corner.Enabled = Value
    end
}):AddColorPicker('CornerColor', {
    Default = ESP.Drawing.Boxes.Corner.RGB,
    Title = "CornerPicker",
    Callback = function(Value)
        ESP.Drawing.Boxes.Corner.RGB = Value
    end
})
ESPBox:AddDivider()


-- Тоггл для Full Box отдельно
ESPBox:AddToggle("FullBoxEnabled", {
    Text = "Boxes",
    Default = ESP.Drawing.Boxes.Full.Enabled,
    Callback = function(Value)
        ESP.Drawing.Boxes.Full.Enabled = Value
    end
}):AddColorPicker('BoxesPicker', {
    Default = ESP.Drawing.Boxes.GradientRGB1,
    Title = "BoxesPicker_Gradient#1",
    Callback = function(Value)
        ESP.Drawing.Boxes.GradientRGB1 = Value
    end
}):AddColorPicker('FullBoxGradient2', {
    Default = ESP.Drawing.Boxes.GradientRGB2,
    Title = "BoxesPicker_Gradient#1",
    Callback = function(Value)
        ESP.Drawing.Boxes.GradientRGB2 = Value
    end
})

ESPBox:AddToggle("FullBoxEnabled", {
    Text = "Boxes [Animate]",
    Default = ESP.Drawing.Boxes.Animate,
    Risky = true,
    Callback = function(Value)
        ESP.Drawing.Boxes.Animate = Value
    end
})

-- Health ESP
local HealthESPToggle = ESPBox:AddToggle('HealthESP', {
    Text = 'Health Bars',
    Default = ESP.Drawing.Healthbar.Enabled,
    Callback = function(Value)
        ESP.Drawing.Healthbar.Enabled = Value
    end
})


ESPBox:AddSlider('MaxESPDistance', {
    Text = 'Max ESP Distance',
    Default = ESP.MaxDistance,
    Min = 0,
    Max = 15000,
    Callback = function(Value)
        ESP.MaxDistance = math.floor(Value / 100 + 0.5) * 100
    end
})



ESPBox:AddToggle("Team Player Check", {
	Text = "Team Check",
	--Tooltip = "Players Nametags", -- Information shown when you hover over the toggle
	DisabledTooltip = "I am disabled!", -- Information shown when you hover over the toggle while it's disabled

	Default = false, -- Default value (true / false)
	Disabled = false, -- Will disable the toggle (true / false)
	Visible = true, -- Will make the toggle invisible (true / false)
	Risky = false, -- Makes the text red (the color can be changed using Library.Scheme.Red) (Default value = false)

	Callback = function(Value)
		ESP.Options.Teamcheck = Value
	end
})





-- Box ESP
-- Гарантируем, что Enabled существует


-- Держим переменную текущего типа бокса
-- Держим переменную текущего типа бокса


-- Toggle для включения боксов


-- Dropdown для выбора типа бокса







-- Skeleton ESP
local SkeletonESPToggle = ESPBox:AddToggle('SkeletonESP', {
    Text = 'Skeleton ESP',
    Default = false,
    Callback = function(Value)
        ESP.Drawing.Flags.Enabled = Value
    end
})

SkeletonESPToggle:AddColorPicker('SkeletonESPColor', {
    Default = Color3.fromRGB(0, 255, 0),
    Title = 'Skeleton Color',
    Callback = function(Value)
        ESP.Drawing.Flags.RGB = Value
    end
})




-- Weapon ESP
ESPBox:AddToggle('WeaponESP', {
    Text = 'Weapon ESP',
    Default = false,
    Callback = function(Value)
        ESP.Drawing.Weapons.Enabled = Value
    end
})



-- Chams
local PlayerChamsToggle = ChamsBox:AddToggle('PlayerChams', {
    Text = 'Player Chams',
    Default = ESP.Drawing.Chams.Enabled,
    Callback = function(Value)
        ESP.Drawing.Chams.Enabled = Value
    end
})

local PlayerChamsVisCheck = ChamsBox:AddToggle('PlayerChamsVisCheck', {
    Text = 'Visible Check',
    Default = ESP.Drawing.Chams.VisibleCheck,
    Callback = function(Value)
        ESP.Drawing.Chams.VisibleCheck = Value
    end
})

local PlayerChamsVisOnly = ChamsBox:AddToggle('PlayerChamsVisOnly', {
    Text = 'Visible Only',
    Default = ESP.Drawing.Chams.VisibleOnly,
    Callback = function(Value)
        ESP.Drawing.Chams.VisibleOnly = Value
    end
})

PlayerChamsToggle:AddColorPicker('ChamsVisibleColor', {
    Default = ESP.Drawing.Chams.FillRGB,
    Title = 'Visible Color',
    Callback = function(Value)
        ESP.Drawing.Chams.FillRGB = Value
    end
})

PlayerChamsToggle:AddColorPicker('ChamsHiddenColor', {
    Default = ESP.Drawing.Chams.OutlineRGB,
    Title = 'Hidden Color',
    Callback = function(Value)
        ESP.Drawing.Chams.OutlineRGB = Value
    end
})

ChamsBox:AddSlider('PulseSpeed', {
    Text = 'Pulse Speed',
    Default = 1,
    Min = 1,
    Max = 10,
    Rounding = 0,
    Callback = function(Value)
        ESP.Drawing.Chams.PulseSpeed = Value
    end
})

ChamsBox:AddSlider('RainbowSpeed', {
    Text = 'Rainbow Speed',
    Default = 0.3,
    Min = 0,
    Max = 5,
    Rounding = 0,
    Callback = function(Value)
        ESP.Drawing.Chams.RainbowSpeed = Value
    end
})

ChamsBox:AddSlider('ThermalSpeed', {
    Text = 'Thermal Speed',
    Default = 0.5,
    Min = 0,
    Max = 5,
    Rounding = 0,
    Callback = function(Value)
        ESP.Drawing.Chams.ThermalSpeed = Value
    end
})

ChamsBox:AddDropdown('ChamsStyle', {
    Values = { 'Pulse', 'Rainbow', 'Wireframe', 'Thermal' },
    Default = 1,
    Text = 'Chams Effect',

    Callback = function(Value)
        -- Disable all effects first
        ESP.Drawing.Chams.Pulse = false
        ESP.Drawing.Chams.Rainbow = false
        
        -- Enable the selected effect
        ESP.Drawing.Chams[Value] = true
    end
})





local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu")

MenuGroup:AddToggle("KeybindMenuOpen", {
	Default = Library.KeybindFrame.Visible,
	Text = "Open Keybind Menu",
	Callback = function(value)
		Library.KeybindFrame.Visible = value
	end,
})
MenuGroup:AddToggle("ShowCustomCursor", {
	Text = "Custom Cursor",
	Default = Library.ShowCustomCursor,
	Callback = function(Value)
		Library.ShowCustomCursor = Value
	end,
})
MenuGroup:AddDropdown("NotificationSide", {
	Values = { "Left", "Right" },
	Default = "Right",

	Text = "Notification Side",

	Callback = function(Value)
		Library:SetNotifySide(Value)
	end,
})
MenuGroup:AddDropdown("DPIDropdown", {
	Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
	Default = "100%",

	Text = "DPI Scale",

	Callback = function(Value)
		Value = Value:gsub("%%", "")
		local DPI = tonumber(Value)

		Library:SetDPIScale(DPI)
	end,
})
MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind")
	:AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })

MenuGroup:AddButton("Unload", function()
	Library:Unload()
    Aimbot.Functions:Exit()
end)

Library.ToggleKeybind = Options.MenuKeybind -- Allows you to have a custom keybind for the menu

-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- ThemeManager (Allows you to have a menu theme system)

-- Hand the library over to our managers
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- Adds our MenuKeybind to the ignore list
-- (do you want each config to have a different menu key? probably not.)
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
ThemeManager:SetFolder("MyScriptHub")
SaveManager:SetFolder("MyScriptHub/specific-game")
SaveManager:SetSubFolder("specific-place") -- if the game has multiple places inside of it (for example: DOORS)
-- you can use this to save configs for those places separately
-- The path in this script would be: MyScriptHub/specific-game/settings/specific-place
-- [ This is optional ]

-- Builds our config menu on the right side of our tab
SaveManager:BuildConfigSection(Tabs["UI Settings"])

-- Builds our theme menu (with plenty of built in themes) on the left side
-- NOTE: you can also call ThemeManager:ApplyToGroupbox to add it to a specific groupbox
ThemeManager:ApplyToTab(Tabs["UI Settings"])

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()


local endTime = tick()
local elapsedTime = endTime - startTime

Library:Notify(string.format("Script Loaded in %.2fs", elapsedTime), 10)


