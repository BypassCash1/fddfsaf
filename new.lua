--[[
    Zyulo Library - Fully Fixed & Optimized
    - Proper Section Stacking (No 3-per-row issues)
    - Click vs Scroll Detection (No accidental activation)
    - Toggle Button Fixed (Click anywhere works)
    - Dark Theme + Color Themes
    - Wider Sections
    - Mobile Toggle with Correct Image
    - Dropdown Scroll Without Auto-Select
]]

-- Variables 
    local uis = game:GetService("UserInputService") 
    local players = game:GetService("Players") 
    local ws = game:GetService("Workspace")
    local rs = game:GetService("ReplicatedStorage")
    local http_service = game:GetService("HttpService")
    local gui_service = game:GetService("GuiService")
    local lighting = game:GetService("Lighting")
    local run = game:GetService("RunService")
    local stats = game:GetService("Stats")
    local coregui = game:GetService("CoreGui")
    local debris = game:GetService("Debris")
    local tween_service = game:GetService("TweenService")
    local sound_service = game:GetService("SoundService")

    local vec2 = Vector2.new
    local vec3 = Vector3.new
    local dim2 = UDim2.new
    local dim = UDim.new 
    local rect = Rect.new
    local cfr = CFrame.new
    local empty_cfr = cfr()
    local angle = CFrame.Angles
    local dim_offset = UDim2.fromOffset

    local color = Color3.new
    local rgb = Color3.fromRGB
    local hex = Color3.fromHex
    local hsv = Color3.fromHSV
    local rgbseq = ColorSequence.new
    local rgbkey = ColorSequenceKeypoint.new
    local numseq = NumberSequence.new
    local numkey = NumberSequenceKeypoint.new

    local camera = ws.CurrentCamera
    local lp = players.LocalPlayer 
    local mouse = lp:GetMouse() 
    local gui_offset = gui_service:GetGuiInset().Y

    local max = math.max 
    local floor = math.floor 
    local min = math.min 
    local abs = math.abs 
    local noise = math.noise
    local rad = math.rad 
    local random = math.random 
    local pow = math.pow 
    local sin = math.sin 
    local pi = math.pi 
    local tan = math.tan 
    local atan2 = math.atan2 
    local clamp = math.clamp 

    local insert = table.insert 
    local find = table.find 
    local remove = table.remove
    local concat = table.concat
-- 

-- Device Detection
    local viewportSize = camera.ViewportSize
    local isPhone = uis.TouchEnabled and not uis.KeyboardEnabled and viewportSize.X < 500
    local isTablet = uis.TouchEnabled and not uis.KeyboardEnabled and viewportSize.X >= 500
    local isConsole = uis.GamepadEnabled and not uis.TouchEnabled
    local isMobile = isPhone or isTablet or isConsole
    local isPC = not isMobile

    local scaleFactor = 1
    if isPhone then scaleFactor = 0.75
    elseif isTablet then scaleFactor = 0.9
    elseif isConsole then scaleFactor = 1.1
    end

-- Library init
    getgenv().library = {
        directory = "zyulo",
        folders = {"/fonts", "/configs"},
        flags = {},
        config_flags = {},
        connections = {},   
        notifications = {notifs = {}},
        current_open = nil,
        current_theme = "dark",
    }

    local themes = {
        preset = {
            accent = rgb(155, 150, 219),
            background = rgb(14, 14, 16),
            section_bg = rgb(25, 25, 29),
            section_inline = rgb(22, 22, 24),
            button_bg = rgb(33, 33, 35),
            text = rgb(245, 245, 245),
            subtext = rgb(72, 72, 73),
        },
        dark = {
            accent = rgb(155, 150, 219),
            background = rgb(14, 14, 16),
            section_bg = rgb(25, 25, 29),
            section_inline = rgb(22, 22, 24),
            button_bg = rgb(33, 33, 35),
            text = rgb(245, 245, 245),
            subtext = rgb(72, 72, 73),
        },
        light = {
            accent = rgb(100, 95, 165),
            background = rgb(235, 235, 240),
            section_bg = rgb(220, 220, 228),
            section_inline = rgb(228, 228, 235),
            button_bg = rgb(210, 210, 218),
            text = rgb(30, 30, 35),
            subtext = rgb(100, 100, 110),
        },
        midnight = {
            accent = rgb(100, 149, 237),
            background = rgb(8, 8, 15),
            section_bg = rgb(15, 15, 25),
            section_inline = rgb(12, 12, 22),
            button_bg = rgb(20, 20, 35),
            text = rgb(220, 220, 240),
            subtext = rgb(100, 100, 130),
        },
        crimson = {
            accent = rgb(220, 50, 50),
            background = rgb(16, 8, 8),
            section_bg = rgb(25, 12, 12),
            section_inline = rgb(22, 10, 10),
            button_bg = rgb(35, 15, 15),
            text = rgb(245, 220, 220),
            subtext = rgb(150, 100, 100),
        },
        forest = {
            accent = rgb(50, 180, 80),
            background = rgb(8, 16, 10),
            section_bg = rgb(12, 25, 15),
            section_inline = rgb(10, 22, 12),
            button_bg = rgb(15, 35, 18),
            text = rgb(220, 245, 225),
            subtext = rgb(100, 150, 110),
        },
        ocean = {
            accent = rgb(50, 150, 220),
            background = rgb(8, 12, 18),
            section_bg = rgb(12, 18, 28),
            section_inline = rgb(10, 15, 25),
            button_bg = rgb(15, 22, 38),
            text = rgb(220, 235, 250),
            subtext = rgb(100, 140, 180),
        },
        sunset = {
            accent = rgb(255, 140, 50),
            background = rgb(18, 14, 10),
            section_bg = rgb(28, 20, 14),
            section_inline = rgb(25, 18, 12),
            button_bg = rgb(38, 25, 16),
            text = rgb(250, 235, 220),
            subtext = rgb(180, 140, 100),
        },
    }

    local activeTheme = themes.dark

    local utility = {
        accent_bg = {},
        accent_text = {},
        accent_image = {},
    }

    local keys = {
        [Enum.KeyCode.LeftShift] = "LS", [Enum.KeyCode.RightShift] = "RS",
        [Enum.KeyCode.LeftControl] = "LC", [Enum.KeyCode.RightControl] = "RC",
        [Enum.KeyCode.Insert] = "INS", [Enum.KeyCode.Backspace] = "BS",
        [Enum.KeyCode.Return] = "Ent", [Enum.KeyCode.LeftAlt] = "LA",
        [Enum.KeyCode.RightAlt] = "RA", [Enum.KeyCode.CapsLock] = "CAPS",
        [Enum.KeyCode.One] = "1", [Enum.KeyCode.Two] = "2",
        [Enum.KeyCode.Three] = "3", [Enum.KeyCode.Four] = "4",
        [Enum.KeyCode.Five] = "5", [Enum.KeyCode.Six] = "6",
        [Enum.KeyCode.Seven] = "7", [Enum.KeyCode.Eight] = "8",
        [Enum.KeyCode.Nine] = "9", [Enum.KeyCode.Zero] = "0",
        [Enum.KeyCode.Minus] = "-", [Enum.KeyCode.Equals] = "=",
        [Enum.KeyCode.Escape] = "ESC", [Enum.KeyCode.Space] = "SPC",
        [Enum.UserInputType.MouseButton1] = "MB1",
        [Enum.UserInputType.MouseButton2] = "MB2",
        [Enum.UserInputType.MouseButton3] = "MB3",
    }
        
    library.__index = library

    for _, path in next, library.folders do 
        makefolder(library.directory .. path)
    end

    local flags = library.flags 
    local config_flags = library.config_flags
    local notifications = library.notifications 

    local fonts = {}; do
        function Register_Font(Name, Weight, Style, Asset)
            if not isfile(Asset.Id) then writefile(Asset.Id, Asset.Font) end
            if isfile(Name .. ".font") then delfile(Name .. ".font") end
            local Data = {name = Name, faces = {{name = "Normal", weight = Weight, style = Style, assetId = getcustomasset(Asset.Id)}}}
            writefile(Name .. ".font", http_service:JSONEncode(Data))
            return getcustomasset(Name .. ".font")
        end
        
        local Medium = Register_Font("Medium", 200, "Normal", {
            Id = "Medium.ttf",
            Font = game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/Inter_28pt-Medium.ttf"),
        })
        local SemiBold = Register_Font("SemiBold", 200, "Normal", {
            Id = "SemiBold.ttf",
            Font = game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/Inter_28pt-SemiBold.ttf"),
        })
        fonts = {
            small = Font.new(Medium, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
            font = Font.new(SemiBold, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
        }
    end
--

-- Helper: Detect click vs drag
    local function makeClickable(button, callback)
        local touchStartPos = nil
        local touchMoved = false
        local isTouch = false
        
        button.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                touchStartPos = input.Position
                touchMoved = false
                isTouch = true
            elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                isTouch = false
                touchMoved = false
            end
        end)
        
        button.InputChanged:Connect(function(input)
            if isTouch and input.UserInputType == Enum.UserInputType.Touch and touchStartPos then
                local delta = (input.Position - touchStartPos).Magnitude
                if delta > 8 then
                    touchMoved = true
                end
            end
        end)
        
        button.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                if not touchMoved and touchStartPos then
                    callback()
                end
                isTouch = false
                touchStartPos = nil
            elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                if not touchMoved then
                    callback()
                end
            end
        end)
        
        button.MouseButton1Click:Connect(function()
            if not isTouch then
                callback()
            end
        end)
    end

-- Library functions 
    function library:tween(obj, properties, easing_style, time) 
        local t = tween_service:Create(obj, TweenInfo.new(time or 0.25, easing_style or Enum.EasingStyle.Quint, Enum.EasingDirection.InOut, 0, false, 0), properties)
        t:Play()
        return t
    end

    function library:draggify(frame)
        local dragging = false 
        local startPos = nil
        local start_size = frame.Position

        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                startPos = input.Position
                start_size = frame.Position
            end
        end)

        frame.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)

        library:connection(uis.InputChanged, function(input) 
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local vx, vy = camera.ViewportSize.X, camera.ViewportSize.Y
                frame.Position = dim2(0,
                    clamp(start_size.X.Offset + (input.Position.X - startPos.X), -(frame.Size.X.Offset * 0.8), vx - (frame.Size.X.Offset * 0.2)),
                    0,
                    clamp(start_size.Y.Offset + (input.Position.Y - startPos.Y), -(frame.Size.Y.Offset * 0.8), vy - (frame.Size.Y.Offset * 0.2))
                )
            end
        end)
    end 

    function fag(tbl)
        local Size = 0
        for _ in tbl do Size = Size + 1 end
        return Size
    end
    
    function library:next_flag()
        return string.format("flagnumber%s", fag(library.flags) + 1)
    end 

    function library:convert(str)
        local values = {}
        for value in string.gmatch(str, "[^,]+") do insert(values, tonumber(value)) end
        if #values == 4 then return unpack(values) else return end
    end
    
    function library:convert_enum(enum)
        local enum_parts = {}
        for part in string.gmatch(enum, "[%w_]+") do insert(enum_parts, part) end
        local enum_table = Enum
        for i = 2, #enum_parts do enum_table = enum_table[enum_parts[i]] end
        return enum_table
    end

    local config_holder;
    function library:update_config_list() 
        if not config_holder then return end
        local list = {}
        for _, file in listfiles(library.directory .. "/configs") do
            local name = file:gsub(library.directory .. "/configs\\", ""):gsub(".cfg", ""):gsub(library.directory .. "\\configs\\", "")
            list[#list + 1] = name
        end
        if #list == 0 then list = {"No configs found"} end
        config_holder.refresh_options(list)
    end 

    function library:get_config()
        local Config = {}
        for _, v in next, flags do
            if type(v) == "table" and v.key then Config[_] = {active = v.active, mode = v.mode, key = tostring(v.key)}
            elseif type(v) == "table" and v["Transparency"] and v["Color"] then Config[_] = {Transparency = v["Transparency"], Color = v["Color"]:ToHex()}
            else Config[_] = v end
        end 
        return http_service:JSONEncode(Config)
    end

    function library:load_config(config_json) 
        local config = http_service:JSONDecode(config_json)
        for _, v in config do 
            local function_set = library.config_flags[_]
            if _ == "config_name_list" then continue end
            if function_set then 
                if type(v) == "table" and v["Transparency"] and v["Color"] then function_set(hex(v["Color"]), v["Transparency"])
                elseif type(v) == "table" and v["active"] then function_set(v)
                else function_set(v) end
            end 
        end 
    end 
    
    function library:round(number, float) 
        local multiplier = 1 / (float or 1)
        return floor(number * multiplier + 0.5) / multiplier
    end 

    function library:update_theme(themeName)
        if themes[themeName] then
            activeTheme = themes[themeName]
            library.current_theme = themeName
            -- Update all tracked objects
            for _, obj in ipairs(utility.accent_bg) do
                if obj and obj.Parent then obj.BackgroundColor3 = activeTheme.accent end
            end
            for _, obj in ipairs(utility.accent_text) do
                if obj and obj.Parent then obj.TextColor3 = activeTheme.accent end
            end
            for _, obj in ipairs(utility.accent_image) do
                if obj and obj.Parent then obj.ImageColor3 = activeTheme.accent end
            end
        end
    end

    function library:track_accent_bg(obj) insert(utility.accent_bg, obj) end
    function library:track_accent_text(obj) insert(utility.accent_text, obj) end
    function library:track_accent_image(obj) insert(utility.accent_image, obj) end

    function library:connection(signal, callback)
        local connection = signal:Connect(callback)
        insert(library.connections, connection)
        return connection 
    end

    function library:close_element(new_path) 
        local open_element = library.current_open
        if open_element and new_path ~= open_element then
            if open_element.set_visible then open_element.set_visible(false) end
            if open_element.open ~= nil then open_element.open = false end
        end 
        if new_path ~= open_element then 
            library.current_open = new_path or nil
        end
    end 

    function library:create(instance, options)
        local ins = Instance.new(instance) 
        for prop, value in options do ins[prop] = value end
        return ins 
    end

    -- Global click-off detection
    local function setupGlobalClickListener()
        library:connection(uis.InputBegan, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if library.current_open then
                    local pos = input.Position
                    local openEl = library.current_open
                    
                    -- Check dropdown holders
                    if openEl.items and openEl.items.dropdown_holder then
                        local holder = openEl.items.dropdown_holder
                        local absPos = holder.AbsolutePosition
                        local absSize = holder.AbsoluteSize
                        if pos.X < absPos.X or pos.X > absPos.X + absSize.X or pos.Y < absPos.Y or pos.Y > absPos.Y + absSize.Y then
                            if openEl.items.dropdown then
                                local trig = openEl.items.dropdown
                                local tPos = trig.AbsolutePosition
                                local tSize = trig.AbsoluteSize
                                if pos.X < tPos.X or pos.X > tPos.X + tSize.X or pos.Y < tPos.Y or pos.Y > tPos.Y + tSize.Y then
                                    openEl.set_visible(false)
                                    openEl.open = false
                                    library.current_open = nil
                                end
                            end
                        end
                    end
                    
                    -- Check colorpicker holders
                    if openEl.items and openEl.items.colorpicker_holder then
                        local holder = openEl.items.colorpicker_holder
                        local absPos = holder.AbsolutePosition
                        local absSize = holder.AbsoluteSize
                        if pos.X < absPos.X or pos.X > absPos.X + absSize.X or pos.Y < absPos.Y or pos.Y > absPos.Y + absSize.Y then
                            if openEl.items.colorpicker then
                                local trig = openEl.items.colorpicker
                                local tPos = trig.AbsolutePosition
                                local tSize = trig.AbsoluteSize
                                if pos.X < tPos.X or pos.X > tPos.X + tSize.X or pos.Y < tPos.Y or pos.Y > tPos.Y + tSize.Y then
                                    openEl.set_visible(false)
                                    openEl.open = false
                                    library.current_open = nil
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
--

    function library:window(properties)
        local baseWidth = 720
        local baseHeight = 565
        
        if isPhone then
            baseWidth = viewportSize.X * 0.94
            baseHeight = viewportSize.Y * 0.78
        elseif isTablet then
            baseWidth = 680
            baseHeight = 560
        end
        
        local cfg = { 
            suffix = properties.suffix or "tech",
            name = properties.name or "zyulo",
            game_name = properties.gameInfo or "Zyulo Framework",
            size = dim2(0, baseWidth, 0, baseHeight),
            selected_tab = nil,
            items = {},
            menuOpen = true,
            footer1 = "Zyulo Library",
            footer2 = "v3.0",
        }
        
        library["items"] = library:create("ScreenGui", {
            Parent = coregui, Name = "\0", Enabled = true,
            ZIndexBehavior = Enum.ZIndexBehavior.Global, IgnoreGuiInset = true, ResetOnSpawn = false,
        })
        
        library["other"] = library:create("ScreenGui", {
            Parent = coregui, Name = "\0", Enabled = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling, IgnoreGuiInset = true, ResetOnSpawn = false,
        })

        local items = cfg.items; do
            items["main"] = library:create("Frame", {
                Parent = library["items"], Size = cfg.size, Name = "\0",
                Position = dim2(0.5, -cfg.size.X.Offset / 2, 0.5, -cfg.size.Y.Offset / 2),
                BorderColor3 = rgb(0, 0, 0), BorderSizePixel = 0,
                BackgroundColor3 = activeTheme.background, ClipsDescendants = true,
            })
            items["main"].Position = dim2(0, items["main"].AbsolutePosition.X, 0, items["main"].AbsolutePosition.Y)
            
            library:create("UICorner", {Parent = items["main"], CornerRadius = dim(0, 10)})
            library:create("UIStroke", {Color = rgb(23, 23, 29), Parent = items["main"], ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
            
            -- Side bar
            items["side_frame"] = library:create("Frame", {
                Parent = items["main"], BackgroundTransparency = 1, Name = "\0",
                BorderColor3 = rgb(0, 0, 0), Size = dim2(0, 196 * scaleFactor, 1, -25),
                BorderSizePixel = 0, BackgroundColor3 = activeTheme.background,
            })
            library:create("Frame", {
                AnchorPoint = vec2(1, 0), Parent = items["side_frame"],
                Position = dim2(1, 0, 0, 0), BorderColor3 = rgb(0, 0, 0),
                Size = dim2(0, 1, 1, 0), BorderSizePixel = 0, BackgroundColor3 = rgb(21, 21, 23),
            })
            
            items["side_scroll"] = library:create("ScrollingFrame", {
                Parent = items["side_frame"], Name = "\0", BackgroundTransparency = 1,
                Position = dim2(0, 0, 0, 60), BorderColor3 = rgb(0, 0, 0),
                Size = dim2(1, 0, 1, -60), BorderSizePixel = 0,
                CanvasSize = dim2(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ScrollBarThickness = 3, ScrollBarImageColor3 = rgb(44, 44, 46),
                ScrollingDirection = Enum.ScrollingDirection.Y,
            })
            
            items["button_holder"] = library:create("Frame", {
                Parent = items["side_scroll"], Name = "\0", BackgroundTransparency = 1,
                Size = dim2(1, 0, 0, 0), BorderColor3 = rgb(0, 0, 0),
                BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = rgb(255, 255, 255),
            }); cfg.button_holder = items["button_holder"]
            
            library:create("UIListLayout", {Parent = items["button_holder"], Padding = dim(0, 5), SortOrder = Enum.SortOrder.LayoutOrder})
            library:create("UIPadding", {PaddingTop = dim(0, 16), PaddingBottom = dim(0, 36), Parent = items["button_holder"], PaddingRight = dim(0, 11), PaddingLeft = dim(0, 10)})

            items["title"] = library:create("TextLabel", {
                FontFace = fonts.font, BorderColor3 = rgb(0, 0, 0),
                Parent = items["side_frame"], Name = "\0",
                Text = string.format('<u>%s</u><font color="rgb(255, 255, 255)">%s</font>', cfg.name, cfg.suffix),
                BackgroundTransparency = 1, Size = dim2(1, 0, 0, 70),
                TextColor3 = activeTheme.accent, BorderSizePixel = 0, RichText = true,
                TextSize = 30, BackgroundColor3 = rgb(255, 255, 255),
            }); library:track_accent_text(items["title"])
            
            items["multi_holder"] = library:create("Frame", {
                Parent = items["main"], Name = "\0", BackgroundTransparency = 1,
                Position = dim2(0, 196 * scaleFactor, 0, 0), BorderColor3 = rgb(0, 0, 0),
                Size = dim2(1, -196 * scaleFactor, 0, 56), BorderSizePixel = 0,
                BackgroundColor3 = rgb(255, 255, 255),
            }); cfg.multi_holder = items["multi_holder"]
            
            library:create("Frame", {
                AnchorPoint = vec2(0, 1), Parent = items["multi_holder"],
                Position = dim2(0, 0, 1, 0), BorderColor3 = rgb(0, 0, 0),
                Size = dim2(1, 0, 0, 1), BorderSizePixel = 0, BackgroundColor3 = rgb(21, 21, 23),
            })
            
            items["global_fade"] = library:create("Frame", {
                Parent = items["main"], Name = "\0", BackgroundTransparency = 1,
                Position = dim2(0, 196 * scaleFactor, 0, 56), BorderColor3 = rgb(0, 0, 0),
                Size = dim2(1, -196 * scaleFactor, 1, -81), BorderSizePixel = 0,
                BackgroundColor3 = activeTheme.background, ZIndex = 2,
            })
            
            -- Footer
            items["info"] = library:create("Frame", {
                AnchorPoint = vec2(0, 1), Parent = items["main"], Name = "\0",
                Position = dim2(0, 0, 1, 0), BorderColor3 = rgb(0, 0, 0),
                Size = dim2(1, 0, 0, 25), BorderSizePixel = 0, BackgroundColor3 = rgb(23, 23, 25),
            })
            library:create("UICorner", {Parent = items["info"], CornerRadius = dim(0, 10)})
            
            items["grey_fill"] = library:create("Frame", {
                Name = "\0", Parent = items["info"], BorderColor3 = rgb(0, 0, 0),
                Size = dim2(1, 0, 0, 6), BorderSizePixel = 0, BackgroundColor3 = rgb(23, 23, 25),
            })
            
            items["footer1"] = library:create("TextLabel", {
                FontFace = fonts.font, Parent = items["info"], TextColor3 = rgb(150, 150, 150),
                BorderColor3 = rgb(0, 0, 0), Text = cfg.footer1, Name = "\0",
                Size = dim2(1, 0, 0, 0), AnchorPoint = vec2(0, 0.5),
                Position = dim2(0, 10, 0.5, -1), BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.XY, TextSize = 13, BackgroundColor3 = rgb(255, 255, 255),
            })
            
            items["footer2"] = library:create("TextLabel", {
                Parent = items["info"], RichText = true, Name = "\0",
                TextColor3 = activeTheme.accent, BorderColor3 = rgb(0, 0, 0),
                Text = cfg.footer2, Size = dim2(1, 0, 0, 0),
                Position = dim2(0, -10, 0.5, -1), AnchorPoint = vec2(0, 0.5),
                BorderSizePixel = 0, BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Right, AutomaticSize = Enum.AutomaticSize.XY,
                FontFace = fonts.font, TextSize = 13, BackgroundColor3 = rgb(255, 255, 255),
            }); library:track_accent_text(items["footer2"])
        end 

        -- Mobile Toggle Button
        local mobileToggle;
        if isMobile then
            mobileToggle = library:create("ImageButton", {
                Parent = library["items"], Name = "MobileToggle",
                Size = dim2(0, 50, 0, 50), Position = dim2(1, -65, 0, 15),
                BackgroundColor3 = rgb(18, 18, 20), BorderColor3 = rgb(0, 0, 0),
                BorderSizePixel = 0, Image = "rbxassetid://84983817196455",
                ImageColor3 = activeTheme.accent, AutoButtonColor = false, ZIndex = 1000,
                ScaleType = Enum.ScaleType.Fit,
            })
            library:track_accent_image(mobileToggle)
            
            library:create("UICorner", {Parent = mobileToggle, CornerRadius = dim(0, 14)})
            library:create("UIStroke", {
                Color = rgb(35, 35, 39), Parent = mobileToggle,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Thickness = 2,
            })
            
            -- Draggable toggle
            local toggleDragging = false
            local toggleStart = nil
            local toggleStartPos = nil
            local moved = false
            
            mobileToggle.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    toggleDragging = true
                    toggleStart = input.Position
                    toggleStartPos = mobileToggle.Position
                    moved = false
                end
            end)
            
            mobileToggle.InputChanged:Connect(function(input)
                if toggleDragging and input.UserInputType == Enum.UserInputType.Touch then
                    local delta = (input.Position - toggleStart).Magnitude
                    if delta > 6 then moved = true end
                    mobileToggle.Position = dim2(0,
                        clamp(toggleStartPos.X.Offset + (input.Position.X - toggleStart.X), 0, camera.ViewportSize.X - 50),
                        0,
                        clamp(toggleStartPos.Y.Offset + (input.Position.Y - toggleStart.Y), 0, camera.ViewportSize.Y - 50)
                    )
                end
            end)
            
            mobileToggle.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch and not moved then
                    cfg.toggle_menu(not cfg.menuOpen)
                end
                toggleDragging = false
            end)
            
            mobileToggle.MouseButton1Click:Connect(function()
                if not toggleDragging then
                    cfg.toggle_menu(not cfg.menuOpen)
                end
            end)
        end

        do
            library:draggify(items["main"])
            setupGlobalClickListener()
        end 

        function cfg.toggle_menu(bool) 
            cfg.menuOpen = bool
            library["items"].Enabled = bool
        end
        
        function cfg.update_footer1(text) items["footer1"].Text = text end
        function cfg.update_footer2(text) items["footer2"].Text = text end
        
        if isMobile then cfg.toggle_menu(false) end
            
        return setmetatable(cfg, library)
    end 

    function library:tab(properties)
        local cfg = {
            name = properties.name or "visuals",
            icon = properties.icon or "http://www.roblox.com/asset/?id=6034767608",
            tabs = properties.tabs or {"Main"},
            pages = {},
            current_multi = nil,
            items = {},
            isSettingsTab = properties.isSettings or false,
        }

        local items = cfg.items; do 
            items["tab_holder"] = library:create("Frame", {
                Parent = library.cache, Name = "\0", Visible = false,
                BackgroundTransparency = 1, Position = dim2(0, 196 * scaleFactor, 0, 56),
                BorderColor3 = rgb(0, 0, 0), Size = dim2(1, -216 * scaleFactor, 1, -101),
                BorderSizePixel = 0, BackgroundColor3 = rgb(255, 255, 255),
            })
            
            -- Tab button
            items["button"] = library:create("TextButton", {
                FontFace = fonts.font, TextColor3 = rgb(255, 255, 255),
                BorderColor3 = rgb(0, 0, 0), Text = "",
                Parent = self.items["button_holder"], AutoButtonColor = false,
                BackgroundTransparency = 1, Name = "\0",
                Size = dim2(1, 0, 0, 35), BorderSizePixel = 0, TextSize = 16,
                BackgroundColor3 = rgb(29, 29, 29),
                LayoutOrder = cfg.isSettingsTab and 999 or 0,
            })
            
            items["icon"] = library:create("ImageLabel", {
                ImageColor3 = rgb(72, 72, 73), BorderColor3 = rgb(0, 0, 0),
                Parent = items["button"], AnchorPoint = vec2(0, 0.5),
                Image = cfg.icon, BackgroundTransparency = 1,
                Position = dim2(0, 10, 0.5, 0), Name = "\0",
                Size = dim2(0, 22, 0, 22), BorderSizePixel = 0, BackgroundColor3 = rgb(255, 255, 255),
            }); library:track_accent_image(items["icon"])
            
            items["name"] = library:create("TextLabel", {
                FontFace = fonts.font, TextColor3 = rgb(72, 72, 73),
                BorderColor3 = rgb(0, 0, 0), Text = cfg.name,
                Parent = items["button"], Name = "\0",
                Size = dim2(0, 0, 1, 0), Position = dim2(0, 40, 0, 0),
                BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.X, TextSize = 16,
                BackgroundColor3 = rgb(255, 255, 255),
            })
            library:create("UIPadding", {Parent = items["name"], PaddingRight = dim(0, 5), PaddingLeft = dim(0, 5)})
            library:create("UICorner", {Parent = items["button"], CornerRadius = dim(0, 7)})

            -- Multi sections
            items["multi_section_button_holder"] = library:create("Frame", {
                Parent = library.cache, BackgroundTransparency = 1, Name = "\0",
                Visible = false, BorderColor3 = rgb(0, 0, 0),
                Size = dim2(1, 0, 1, 0), BorderSizePixel = 0, BackgroundColor3 = rgb(255, 255, 255),
            })
            library:create("UIListLayout", {
                Parent = items["multi_section_button_holder"], Padding = dim(0, 7),
                SortOrder = Enum.SortOrder.LayoutOrder, FillDirection = Enum.FillDirection.Horizontal,
            })
            library:create("UIPadding", {
                PaddingTop = dim(0, 8), PaddingBottom = dim(0, 7),
                Parent = items["multi_section_button_holder"], PaddingRight = dim(0, 7), PaddingLeft = dim(0, 7),
            })

            for _, section in cfg.tabs do
                local data = {items = {}}
                local mi = data.items; do
                    mi["button"] = library:create("TextButton", {
                        FontFace = fonts.font, TextColor3 = rgb(255, 255, 255),
                        BorderColor3 = rgb(0, 0, 0), AutoButtonColor = false, Text = "",
                        Parent = items["multi_section_button_holder"], Name = "\0",
                        Size = dim2(0, 0, 0, 39), BackgroundTransparency = 1, ClipsDescendants = true,
                        BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.X, TextSize = 16,
                        BackgroundColor3 = activeTheme.section_bg,
                    })
                    mi["name"] = library:create("TextLabel", {
                        FontFace = fonts.font, TextColor3 = rgb(62, 62, 63),
                        BorderColor3 = rgb(0, 0, 0), Text = section,
                        Parent = mi["button"], Name = "\0", Size = dim2(0, 0, 1, 0),
                        BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
                        BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.XY, TextSize = 16,
                        BackgroundColor3 = rgb(255, 255, 255),
                    })
                    library:create("UIPadding", {Parent = mi["name"], PaddingRight = dim(0, 5), PaddingLeft = dim(0, 5)})
                    
                    mi["accent"] = library:create("Frame", {
                        BorderColor3 = rgb(0, 0, 0), AnchorPoint = vec2(0, 1),
                        Parent = mi["button"], BackgroundTransparency = 1,
                        Position = dim2(0, 10, 1, 4), Name = "\0",
                        Size = dim2(1, -20, 0, 6), BorderSizePixel = 0,
                        BackgroundColor3 = activeTheme.accent,
                    }); library:track_accent_bg(mi["accent"])
                    library:create("UICorner", {Parent = mi["accent"], CornerRadius = dim(0, 999)})
                    library:create("UIPadding", {Parent = mi["button"], PaddingRight = dim(0, 10), PaddingLeft = dim(0, 10)})
                    library:create("UICorner", {Parent = mi["button"], CornerRadius = dim(0, 7)})
                    
                    mi["tab"] = library:create("Frame", {
                        Parent = library.cache, BackgroundTransparency = 1, Name = "\0",
                        BorderColor3 = rgb(0, 0, 0), Size = dim2(1, -20, 1, -20),
                        BorderSizePixel = 0, Visible = false, BackgroundColor3 = rgb(255, 255, 255),
                    })
                    library:create("UIListLayout", {
                        FillDirection = Enum.FillDirection.Vertical, HorizontalFlex = Enum.UIFlexAlignment.Fill,
                        Parent = mi["tab"], Padding = dim(0, 7), SortOrder = Enum.SortOrder.LayoutOrder,
                        VerticalFlex = Enum.UIFlexAlignment.Fill,
                    })
                    library:create("UIPadding", {
                        PaddingTop = dim(0, 7), PaddingBottom = dim(0, 7),
                        Parent = mi["tab"], PaddingRight = dim(0, 7), PaddingLeft = dim(0, 7),
                    })
                end

                data.text = mi["name"]
                data.accent = mi["accent"]
                data.button = mi["button"]
                data.page = mi["tab"]
                data.parent = setmetatable(data, library):sub_tab({}).items["tab_parent"]

                function data.open_page()
                    local page = cfg.current_multi
                    if page and page.text ~= data.text then
                        self.items["global_fade"].BackgroundTransparency = 0
                        library:tween(self.items["global_fade"], {BackgroundTransparency = 1}, Enum.EasingStyle.Quad, 0.4)
                        page.page.Size = dim2(1, -20, 1, -20)
                    end
                    if page then
                        library:tween(page.text, {TextColor3 = rgb(62, 62, 63)})
                        library:tween(page.accent, {BackgroundTransparency = 1})
                        library:tween(page.button, {BackgroundTransparency = 1})
                        page.page.Visible = false
                        page.page.Parent = library["cache"]
                    end
                    library:tween(data.text, {TextColor3 = rgb(255, 255, 255)})
                    library:tween(data.accent, {BackgroundTransparency = 0})
                    library:tween(data.button, {BackgroundTransparency = 0})
                    library:tween(data.page, {Size = dim2(1, 0, 1, 0)}, Enum.EasingStyle.Quad, 0.4)
                    data.page.Visible = true
                    data.page.Parent = items["tab_holder"]
                    cfg.current_multi = data
                    library:close_element()
                end

                makeClickable(mi["button"], function() data.open_page() end)
                cfg.pages[#cfg.pages + 1] = setmetatable(data, library)
            end
            if cfg.pages[1] then cfg.pages[1].open_page() end
        end 

        function cfg.open_tab() 
            local selected_tab = self.selected_tab
            if selected_tab then
                if selected_tab[4] ~= items["tab_holder"] then
                    self.items["global_fade"].BackgroundTransparency = 0
                    library:tween(self.items["global_fade"], {BackgroundTransparency = 1}, Enum.EasingStyle.Quad, 0.4)
                    selected_tab[4].Size = dim2(1, -216 * scaleFactor, 1, -101)
                end
                library:tween(selected_tab[1], {BackgroundTransparency = 1})
                library:tween(selected_tab[2], {ImageColor3 = rgb(72, 72, 73)})
                library:tween(selected_tab[3], {TextColor3 = rgb(72, 72, 73)})
                selected_tab[4].Visible = false; selected_tab[4].Parent = library["cache"]
                selected_tab[5].Visible = false; selected_tab[5].Parent = library["cache"]
            end
            library:tween(items["button"], {BackgroundTransparency = 0})
            library:tween(items["icon"], {ImageColor3 = activeTheme.accent})
            library:tween(items["name"], {TextColor3 = rgb(255, 255, 255)})
            library:tween(items["tab_holder"], {Size = dim2(1, -196 * scaleFactor, 1, -81)}, Enum.EasingStyle.Quad, 0.4)
            items["tab_holder"].Visible = true; items["tab_holder"].Parent = self.items["main"]
            items["multi_section_button_holder"].Visible = true; items["multi_section_button_holder"].Parent = self.items["multi_holder"]
            self.selected_tab = {items["button"], items["icon"], items["name"], items["tab_holder"], items["multi_section_button_holder"]}
            library:close_element()
        end

        makeClickable(items["button"], function() cfg.open_tab() end)
        
        if not self.selected_tab then cfg.open_tab(true) end
        return unpack(cfg.pages)
    end

    function library:seperator(properties)
        local cfg = {items = {}, name = properties.Name or properties.name or "General"}
        local items = cfg.items; do 
            items["name"] = library:create("TextLabel", {
                FontFace = fonts.font, TextColor3 = rgb(72, 72, 73),
                BorderColor3 = rgb(0, 0, 0), Text = cfg.name,
                Parent = self.items["button_holder"], Name = "\0",
                Size = dim2(1, 0, 0, 0), Position = dim2(0, 40, 0, 0),
                BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.XY, TextSize = 16,
                BackgroundColor3 = rgb(255, 255, 255),
            })
            library:create("UIPadding", {Parent = items["name"], PaddingRight = dim(0, 5), PaddingLeft = dim(0, 5)})
        end
        return setmetatable(cfg, library)
    end 

    function library:column(properties) 
        local cfg = {items = {}, size = properties.size or 1}
        local items = cfg.items; do     
            items["column"] = library:create("Frame", {
                Parent = self["parent"] or self.items["tab_parent"],
                BackgroundTransparency = 1, Name = "\0", BorderColor3 = rgb(0, 0, 0),
                Size = dim2(0, 0, cfg.size, 0), BorderSizePixel = 0, BackgroundColor3 = rgb(255, 255, 255),
            })
            library:create("UIPadding", {PaddingBottom = dim(0, 10), Parent = items["column"]})
            library:create("UIListLayout", {
                Parent = items["column"], HorizontalFlex = Enum.UIFlexAlignment.Fill,
                Padding = dim(0, 10), FillDirection = Enum.FillDirection.Vertical,
                SortOrder = Enum.SortOrder.LayoutOrder,
            })
        end
        return setmetatable(cfg, library)
    end 

    function library:sub_tab(properties) 
        local cfg = {items = {}, order = properties.order or 0, size = properties.size or 1}
        local items = cfg.items; do 
            items["tab_parent"] = library:create("Frame", {
                Parent = self.items["tab"], BackgroundTransparency = 1, Name = "\0",
                Size = dim2(0, 0, cfg.size, 0), BorderColor3 = rgb(0, 0, 0),
                BorderSizePixel = 0, Visible = true, BackgroundColor3 = rgb(255, 255, 255),
            })
            library:create("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal, HorizontalFlex = Enum.UIFlexAlignment.Fill,
                VerticalFlex = Enum.UIFlexAlignment.Fill, Parent = items["tab_parent"],
                Padding = dim(0, 7), SortOrder = Enum.SortOrder.LayoutOrder,
            })
        end
        return setmetatable(cfg, library)
    end 

    function library:section(properties)
        local cfg = {
            name = properties.name or "section",
            default = properties.default or false,
            size = properties.size or self.size or 0.5,
            icon = properties.icon or "http://www.roblox.com/asset/?id=6022668898",
            fading_toggle = properties.fading or false,
            items = {},
        }
        
        local items = cfg.items; do 
            items["outline"] = library:create("Frame", {
                Name = "\0", Parent = self.items["column"],
                BorderColor3 = rgb(0, 0, 0), Size = dim2(0, 0, cfg.size, -3),
                BorderSizePixel = 0, BackgroundColor3 = activeTheme.section_bg,
            })
            library:create("UICorner", {Parent = items["outline"], CornerRadius = dim(0, 7)})
            
            items["inline"] = library:create("Frame", {
                Parent = items["outline"], Name = "\0", Position = dim2(0, 1, 0, 1),
                BorderColor3 = rgb(0, 0, 0), Size = dim2(1, -2, 1, -2),
                BorderSizePixel = 0, BackgroundColor3 = activeTheme.section_inline,
            })
            library:create("UICorner", {Parent = items["inline"], CornerRadius = dim(0, 7)})
            
            items["scrolling"] = library:create("ScrollingFrame", {
                ScrollBarImageColor3 = rgb(44, 44, 46), Active = true,
                AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 6,
                Parent = items["inline"], Name = "\0", Size = dim2(1, 0, 1, -40),
                BackgroundTransparency = 1, Position = dim2(0, 0, 0, 35),
                BackgroundColor3 = rgb(255, 255, 255), BorderColor3 = rgb(0, 0, 0),
                BorderSizePixel = 0, CanvasSize = dim2(0, 0, 0, 0),
                ScrollingDirection = Enum.ScrollingDirection.Y,
                VerticalScrollBarInset = Enum.ScrollBarInset.Always,
                ElasticBehavior = Enum.ElasticBehavior.Never,
            })
            
            items["elements"] = library:create("Frame", {
                BorderColor3 = rgb(0, 0, 0), Parent = items["scrolling"], Name = "\0",
                BackgroundTransparency = 1, Position = dim2(0, 10, 0, 10),
                Size = dim2(1, -20, 0, 0), BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = rgb(255, 255, 255),
            })
            library:create("UIListLayout", {Parent = items["elements"], Padding = dim(0, 10), SortOrder = Enum.SortOrder.LayoutOrder})
            library:create("UIPadding", {PaddingBottom = dim(0, 15), Parent = items["elements"]})
            
            items["button"] = library:create("TextButton", {
                FontFace = fonts.font, TextColor3 = rgb(255, 255, 255),
                BorderColor3 = rgb(0, 0, 0), Text = "", AutoButtonColor = false,
                Parent = items["outline"], Name = "\0", Position = dim2(0, 1, 0, 1),
                Size = dim2(1, -2, 0, 35), BorderSizePixel = 0, TextSize = 16,
                BackgroundColor3 = rgb(19, 19, 21),
            })
            library:create("UICorner", {Parent = items["button"], CornerRadius = dim(0, 7)})
            
            items["Icon"] = library:create("ImageLabel", {
                ImageColor3 = activeTheme.accent, BorderColor3 = rgb(0, 0, 0),
                Parent = items["button"], AnchorPoint = vec2(0, 0.5),
                Image = cfg.icon, BackgroundTransparency = 1,
                Position = dim2(0, 10, 0.5, 0), Name = "\0",
                Size = dim2(0, 22, 0, 22), BorderSizePixel = 0, BackgroundColor3 = rgb(255, 255, 255),
            }); library:track_accent_image(items["Icon"])
            
            items["section_title"] = library:create("TextLabel", {
                FontFace = fonts.font, TextColor3 = rgb(255, 255, 255),
                BorderColor3 = rgb(0, 0, 0), Text = cfg.name,
                Parent = items["button"], Name = "\0", Size = dim2(0, 0, 1, 0),
                Position = dim2(0, 40, 0, -1), BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.X, TextSize = 16, BackgroundColor3 = rgb(255, 255, 255),
            })
            library:create("Frame", {
                AnchorPoint = vec2(0, 1), Parent = items["button"], Position = dim2(0, 0, 1, 0),
                BorderColor3 = rgb(0, 0, 0), Size = dim2(1, 0, 0, 1),
                BorderSizePixel = 0, BackgroundColor3 = rgb(36, 36, 37),
            })
            
            if cfg.fading_toggle then
                items["toggle"] = library:create("TextButton", {
                    FontFace = fonts.small, TextColor3 = rgb(0, 0, 0),
                    BorderColor3 = rgb(0, 0, 0), AutoButtonColor = false, Text = "",
                    AnchorPoint = vec2(1, 0.5), Parent = items["button"], Name = "\0",
                    Position = dim2(1, -9, 0.5, 0), Size = dim2(0, 36, 0, 18),
                    BorderSizePixel = 0, TextSize = 14, BackgroundColor3 = rgb(58, 58, 62),
                }); library:track_accent_bg(items["toggle"])
                library:create("UICorner", {Parent = items["toggle"], CornerRadius = dim(0, 999)})
                
                items["toggle_outline"] = library:create("Frame", {
                    Parent = items["toggle"], Size = dim2(1, -2, 1, -2), Name = "\0",
                    BorderMode = Enum.BorderMode.Inset, BorderColor3 = rgb(0, 0, 0),
                    Position = dim2(0, 1, 0, 1), BorderSizePixel = 0, BackgroundColor3 = rgb(50, 50, 50),
                }); library:track_accent_bg(items["toggle_outline"])
                library:create("UICorner", {Parent = items["toggle_outline"], CornerRadius = dim(0, 999)})
                
                items["toggle_circle"] = library:create("Frame", {
                    Parent = items["toggle_outline"], Name = "\0", Position = dim2(0, 2, 0, 2),
                    BorderColor3 = rgb(0, 0, 0), Size = dim2(0, 12, 0, 12),
                    BorderSizePixel = 0, BackgroundColor3 = rgb(86, 86, 88),
                })
                library:create("UICorner", {Parent = items["toggle_circle"], CornerRadius = dim(0, 999)})
                
                items["fade"] = library:create("Frame", {
                    Parent = items["outline"], BackgroundTransparency = 0.8, Name = "\0",
                    BorderColor3 = rgb(0, 0, 0), Size = dim2(1, 0, 1, 0),
                    BorderSizePixel = 0, BackgroundColor3 = rgb(0, 0, 0),
                })
                library:create("UICorner", {Parent = items["fade"], CornerRadius = dim(0, 7)})
                
                makeClickable(items["button"], function()
                    cfg.default = not cfg.default
                    cfg.toggle_section(cfg.default)
                end)
                
                function cfg.toggle_section(bool)
                    library:tween(items["toggle"], {BackgroundColor3 = bool and activeTheme.accent or rgb(58, 58, 62)}, Enum.EasingStyle.Quad)
                    library:tween(items["toggle_outline"], {BackgroundColor3 = bool and activeTheme.accent or rgb(50, 50, 50)}, Enum.EasingStyle.Quad)
                    library:tween(items["toggle_circle"], {BackgroundColor3 = bool and rgb(255, 255, 255) or rgb(86, 86, 88), Position = bool and dim2(1, -14, 0, 2) or dim2(0, 2, 0, 2)}, Enum.EasingStyle.Quad)
                    library:tween(items["fade"], {BackgroundTransparency = bool and 1 or 0.8}, Enum.EasingStyle.Quad)
                end
            end
        end
        return setmetatable(cfg, library)
    end  

    function library:toggle(options) 
        local cfg = {
            name = options.name or "Toggle", info = options.info or nil,
            flag = options.flag or library:next_flag(),
            default = options.default or false,
            callback = options.callback or function() end,
            items = {}, seperator = options.seperator or false,
            enabled = options.default or false,
        }
        flags[cfg.flag] = cfg.default

        local items = cfg.items; do
            items["toggle_frame"] = library:create("TextButton", {
                FontFace = fonts.small, TextColor3 = rgb(0, 0, 0),
                BorderColor3 = rgb(0, 0, 0), Text = "",
                Parent = self.items["elements"], Name = "\0",
                BackgroundTransparency = 1, Size = dim2(1, 0, 0, 0),
                BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.Y,
                TextSize = 14, BackgroundColor3 = rgb(255, 255, 255),
            })
            
            items["name"] = library:create("TextLabel", {
                FontFace = fonts.small, TextColor3 = activeTheme.text,
                BorderColor3 = rgb(0, 0, 0), Text = cfg.name,
                Parent = items["toggle_frame"], Name = "\0",
                Size = dim2(1, -30, 0, 0), BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0,
                TextWrapped = true, AutomaticSize = Enum.AutomaticSize.Y, TextSize = 16,
                BackgroundColor3 = rgb(255, 255, 255),
            })

            if cfg.info then 
                items["info"] = library:create("TextLabel", {
                    FontFace = fonts.small, TextColor3 = rgb(130, 130, 130),
                    BorderColor3 = rgb(0, 0, 0), TextWrapped = true, Text = cfg.info,
                    Parent = items["toggle_frame"], Name = "\0",
                    Position = dim2(0, 5, 0, 22), Size = dim2(1, -10, 0, 0),
                    BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.Y, TextSize = 14,
                    BackgroundColor3 = rgb(255, 255, 255),
                })
            end 
            
            -- Checkbox (filled box style)
            items["toggle_button"] = library:create("TextButton", {
                FontFace = fonts.small, TextColor3 = rgb(0, 0, 0),
                BorderColor3 = rgb(0, 0, 0), Text = "",
                AnchorPoint = vec2(1, 0.5), Parent = items["toggle_frame"],
                Name = "\0", Position = dim2(1, -2, 0.5, 0),
                Size = dim2(0, 20, 0, 20), BorderSizePixel = 0, TextSize = 14,
                BackgroundColor3 = rgb(67, 67, 68),
            }); library:track_accent_bg(items["toggle_button"])
            library:create("UICorner", {Parent = items["toggle_button"], CornerRadius = dim(0, 4)})
            
            items["outline"] = library:create("Frame", {
                Parent = items["toggle_button"], Size = dim2(1, -2, 1, -2), Name = "\0",
                BorderMode = Enum.BorderMode.Inset, BorderColor3 = rgb(0, 0, 0),
                Position = dim2(0, 1, 0, 1), BorderSizePixel = 0, BackgroundColor3 = rgb(22, 22, 24),
            }); library:track_accent_bg(items["outline"])
            
            items["tick"] = library:create("ImageLabel", {
                ImageTransparency = 1, BorderColor3 = rgb(0, 0, 0),
                Image = "rbxassetid://111862698467575", BackgroundTransparency = 1,
                Position = dim2(0, -1, 0, 0), Parent = items["outline"],
                Size = dim2(1, 2, 1, 2), BorderSizePixel = 0,
                BackgroundColor3 = rgb(255, 255, 255), ZIndex = 1,
            })
            library:create("UICorner", {Parent = items["outline"], CornerRadius = dim(0, 4)})
            
            library:create("UIPadding", {Parent = items["name"], PaddingRight = dim(0, 5), PaddingLeft = dim(0, 5)})
        end;
        
        function cfg.set(bool)
            cfg.enabled = bool
            library:tween(items["tick"], {Rotation = bool and 0 or 45, ImageTransparency = bool and 0 or 1})
            library:tween(items["toggle_button"], {BackgroundColor3 = bool and activeTheme.accent or rgb(67, 67, 68)})
            library:tween(items["outline"], {BackgroundColor3 = bool and activeTheme.accent or rgb(22, 22, 24)})
            cfg.callback(bool)
            flags[cfg.flag] = bool
        end 
        
        local function toggleFunc()
            cfg.set(not cfg.enabled)
        end
        
        -- Make the whole toggle clickable, not just text
        makeClickable(items["toggle_frame"], toggleFunc)
        makeClickable(items["toggle_button"], toggleFunc)
        
        if cfg.seperator then 
            library:create("Frame", {
                AnchorPoint = vec2(0, 1), Parent = self.items["elements"],
                Position = dim2(0, 0, 1, 0), BorderColor3 = rgb(0, 0, 0),
                Size = dim2(1, 1, 0, 1), BorderSizePixel = 0, BackgroundColor3 = rgb(36, 36, 37),
            })
        end

        cfg.set(cfg.default)
        config_flags[cfg.flag] = cfg.set
        return setmetatable(cfg, library)
    end 
    
    function library:slider(options) 
        local cfg = {
            name = options.name or nil, suffix = options.suffix or "",
            flag = options.flag or library:next_flag(),
            callback = options.callback or function() end,
            info = options.info or nil,
            min = options.min or 0, max = options.max or 100,
            intervals = options.interval or 1,
            default = options.default or 10, value = options.default or 10,
            seperator = options.seperator or true,
            dragging = false, items = {},
        }
        flags[cfg.flag] = cfg.default

        local items = cfg.items; do
            items["slider_object"] = library:create("TextButton", {
                FontFace = fonts.small, TextColor3 = rgb(0, 0, 0),
                BorderColor3 = rgb(0, 0, 0), Text = "",
                Parent = self.items["elements"], Name = "\0",
                BackgroundTransparency = 1, Size = dim2(1, 0, 0, 0),
                BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.Y,
                TextSize = 14, BackgroundColor3 = rgb(255, 255, 255),
            })
            
            items["name"] = library:create("TextLabel", {
                FontFace = fonts.small, TextColor3 = activeTheme.text,
                BorderColor3 = rgb(0, 0, 0), Text = cfg.name,
                Parent = items["slider_object"], Name = "\0",
                Size = dim2(1, -10, 0, 0), BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0,
                TextWrapped = true, AutomaticSize = Enum.AutomaticSize.Y, TextSize = 16,
                BackgroundColor3 = rgb(255, 255, 255),
            })
            
            if cfg.info then 
                items["info"] = library:create("TextLabel", {
                    FontFace = fonts.small, TextColor3 = rgb(130, 130, 130),
                    BorderColor3 = rgb(0, 0, 0), TextWrapped = true, Text = cfg.info,
                    Parent = items["slider_object"], Name = "\0",
                    Position = dim2(0, 5, 0, 42), Size = dim2(1, -10, 0, 0),
                    BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.Y, TextSize = 14,
                    BackgroundColor3 = rgb(255, 255, 255),
                })
            end 

            library:create("UIPadding", {Parent = items["name"], PaddingRight = dim(0, 5), PaddingLeft = dim(0, 5)})
            
            items["slider_bar_holder"] = library:create("Frame", {
                Parent = items["slider_object"], Name = "\0", BackgroundTransparency = 1,
                Position = dim2(0, 4, 0, 28), BorderColor3 = rgb(0, 0, 0),
                Size = dim2(1, 0, 0, 16), BorderSizePixel = 0, BackgroundColor3 = rgb(255, 255, 255),
            })
            
            items["slider"] = library:create("TextButton", {
                FontFace = fonts.small, TextColor3 = rgb(0, 0, 0),
                BorderColor3 = rgb(0, 0, 0), Text = "", AutoButtonColor = false,
                AnchorPoint = vec2(1, 0), Parent = items["slider_bar_holder"],
                Name = "\0", Position = dim2(1, 0, 0, 0),
                Size = dim2(1, -4, 0, 8), BorderSizePixel = 0, TextSize = 14,
                BackgroundColor3 = activeTheme.button_bg,
            })
            library:create("UICorner", {Parent = items["slider"], CornerRadius = dim(0, 999)})
            
            items["fill"] = library:create("Frame", {
                Name = "\0", Parent = items["slider"], BorderColor3 = rgb(0, 0, 0),
                Size = dim2(0.5, 0, 0, 8), BorderSizePixel = 0,
                BackgroundColor3 = activeTheme.accent,
            }); library:track_accent_bg(items["fill"])
            library:create("UICorner", {Parent = items["fill"], CornerRadius = dim(0, 999)})
            
            items["circle"] = library:create("Frame", {
                AnchorPoint = vec2(0.5, 0.5), Parent = items["fill"], Name = "\0",
                Position = dim2(1, 0, 0.5, 0), BorderColor3 = rgb(0, 0, 0),
                Size = dim2(0, 16, 0, 16), BorderSizePixel = 0, BackgroundColor3 = rgb(244, 244, 244),
            })
            library:create("UICorner", {Parent = items["circle"], CornerRadius = dim(0, 999)})
            library:create("UIPadding", {Parent = items["slider_bar_holder"], PaddingTop = dim(0, 4)})
            
            items["value"] = library:create("TextLabel", {
                FontFace = fonts.small, TextColor3 = activeTheme.subtext,
                BorderColor3 = rgb(0, 0, 0), Text = "50%",
                Parent = items["slider_object"], Name = "\0",
                Size = dim2(1, 0, 0, 0), Position = dim2(0, 6, 0, 0),
                BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Right,
                BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.XY, TextSize = 16,
                BackgroundColor3 = rgb(255, 255, 255),
            })
            library:create("UIPadding", {Parent = items["value"], PaddingRight = dim(0, 5), PaddingLeft = dim(0, 5)})
        end 

        function cfg.set(value)
            cfg.value = clamp(library:round(value, cfg.intervals), cfg.min, cfg.max)
            library:tween(items["fill"], {Size = dim2((cfg.value - cfg.min) / (cfg.max - cfg.min), cfg.value == cfg.min and 0 or -4, 0, 2)}, Enum.EasingStyle.Linear, 0.05)
            items["value"].Text = tostring(cfg.value) .. cfg.suffix
            flags[cfg.flag] = cfg.value
            cfg.callback(flags[cfg.flag])
        end

        local function sliderInput(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                cfg.dragging = true
                library:tween(items["value"], {TextColor3 = rgb(255, 255, 255)}, Enum.EasingStyle.Quad, 0.2)
                local size_x = (input.Position.X - items["slider"].AbsolutePosition.X) / items["slider"].AbsoluteSize.X
                cfg.set(((cfg.max - cfg.min) * size_x) + cfg.min)
            end
        end
        
        items["slider"].InputBegan:Connect(sliderInput)

        library:connection(uis.InputChanged, function(input)
            if cfg.dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then 
                local size_x = (input.Position.X - items["slider"].AbsolutePosition.X) / items["slider"].AbsoluteSize.X
                cfg.set(((cfg.max - cfg.min) * size_x) + cfg.min)
            end
        end)

        library:connection(uis.InputEnded, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                cfg.dragging = false
                library:tween(items["value"], {TextColor3 = activeTheme.subtext}, Enum.EasingStyle.Quad, 0.2)
            end 
        end)

        if cfg.seperator then 
            library:create("Frame", {
                AnchorPoint = vec2(0, 1), Parent = self.items["elements"],
                Position = dim2(0, 0, 1, 0), BorderColor3 = rgb(0, 0, 0),
                Size = dim2(1, 1, 0, 1), BorderSizePixel = 0, BackgroundColor3 = rgb(36, 36, 37),
            })
        end 

        cfg.set(cfg.default)
        config_flags[cfg.flag] = cfg.set
        return setmetatable(cfg, library)
    end 

    function library:dropdown(options) 
        local cfg = {
            name = options.name or nil, info = options.info or nil,
            flag = options.flag or library:next_flag(),
            options = options.items or {""},
            callback = options.callback or function() end,
            multi = options.multi or false,
            searchable = true,
            width = options.width or 155,
            open = false, option_instances = {}, multi_items = {},
            items = {}, y_size = nil,
            seperator = options.seperator or true,
        }   

        cfg.default = options.default or (cfg.multi and {cfg.options[1]}) or cfg.options[1] or "None"
        flags[cfg.flag] = cfg.default

        local items = cfg.items; do 
            items["dropdown_object"] = library:create("TextButton", {
                FontFace = fonts.small, TextColor3 = rgb(0, 0, 0),
                BorderColor3 = rgb(0, 0, 0), Text = "",
                Parent = self.items["elements"], Name = "\0",
                BackgroundTransparency = 1, Size = dim2(1, 0, 0, 0),
                BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.Y,
                TextSize = 14, BackgroundColor3 = rgb(255, 255, 255),
            })
            
            items["name"] = library:create("TextLabel", {
                FontFace = fonts.small, TextColor3 = activeTheme.text,
                BorderColor3 = rgb(0, 0, 0), Text = cfg.name or "Dropdown",
                Parent = items["dropdown_object"], Name = "\0",
                Size = dim2(1, -10, 0, 0), BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0,
                TextWrapped = true, AutomaticSize = Enum.AutomaticSize.Y, TextSize = 16,
                BackgroundColor3 = rgb(255, 255, 255),
            })
            
            if cfg.info then 
                items["info"] = library:create("TextLabel", {
                    FontFace = fonts.small, TextColor3 = rgb(130, 130, 130),
                    BorderColor3 = rgb(0, 0, 0), TextWrapped = true, Text = cfg.info,
                    Parent = items["dropdown_object"], Name = "\0",
                    Position = dim2(0, 5, 0, 22), Size = dim2(1, -10, 0, 0),
                    BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.Y, TextSize = 14,
                    BackgroundColor3 = rgb(255, 255, 255),
                })
            end 

            library:create("UIPadding", {Parent = items["name"], PaddingRight = dim(0, 5), PaddingLeft = dim(0, 5)})
            
            items["dropdown"] = library:create("TextButton", {
                FontFace = fonts.small, TextColor3 = rgb(0, 0, 0),
                BorderColor3 = rgb(0, 0, 0), Text = "", AutoButtonColor = false,
                AnchorPoint = vec2(1, 0), Parent = items["dropdown_object"],
                Name = "\0", Position = dim2(1, 0, 0, 4),
                Size = dim2(0, cfg.width, 0, 24), BorderSizePixel = 0, TextSize = 14,
                BackgroundColor3 = activeTheme.button_bg,
            })
            library:create("UICorner", {Parent = items["dropdown"], CornerRadius = dim(0, 5)})
            
            items["sub_text"] = library:create("TextLabel", {
                FontFace = fonts.small, TextColor3 = rgb(200, 200, 200),
                BorderColor3 = rgb(0, 0, 0), Text = "",
                Parent = items["dropdown"], Name = "\0",
                Size = dim2(1, -12, 0, 0), BorderSizePixel = 0,
                BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd, AutomaticSize = Enum.AutomaticSize.Y,
                TextSize = 14, BackgroundColor3 = rgb(255, 255, 255),
            })
            library:create("UIPadding", {Parent = items["sub_text"], PaddingTop = dim(0, 4), PaddingRight = dim(0, 5), PaddingLeft = dim(0, 8)})
            
            items["indicator"] = library:create("ImageLabel", {
                ImageColor3 = rgb(150, 150, 150), BorderColor3 = rgb(0, 0, 0),
                Parent = items["dropdown"], AnchorPoint = vec2(1, 0.5),
                Image = "rbxassetid://101025591575185", BackgroundTransparency = 1,
                Position = dim2(1, -5, 0.5, 0), Name = "\0",
                Size = dim2(0, 14, 0, 14), BorderSizePixel = 0, BackgroundColor3 = rgb(255, 255, 255),
            })

            -- Dropdown holder
            items["dropdown_holder"] = library:create("Frame", {
                BorderColor3 = rgb(0, 0, 0), Parent = library["items"],
                Name = "\0", Visible = true, BackgroundTransparency = 1,
                Size = dim2(0, 0, 0, 0), BorderSizePixel = 0,
                BackgroundColor3 = rgb(0, 0, 0), ZIndex = 10, ClipsDescendants = true,
            })
            
            items["outline"] = library:create("Frame", {
                Parent = items["dropdown_holder"], Size = dim2(1, 0, 1, 0),
                ClipsDescendants = true, BorderColor3 = rgb(0, 0, 0),
                BorderSizePixel = 0, BackgroundColor3 = rgb(28, 28, 32), ZIndex = 10,
            })
            
            -- Search bar
            if cfg.searchable then
                items["search"] = library:create("TextBox", {
                    FontFace = fonts.small, Text = "", Parent = items["outline"],
                    Name = "\0", TextTruncate = Enum.TextTruncate.AtEnd,
                    BorderSizePixel = 0, PlaceholderColor3 = rgb(100, 100, 100),
                    PlaceholderText = "Search...", CursorPosition = -1,
                    ClearTextOnFocus = false, TextSize = 13,
                    BackgroundColor3 = rgb(35, 35, 39), TextColor3 = rgb(200, 200, 200),
                    BorderColor3 = rgb(0, 0, 0), Size = dim2(1, -8, 0, 28),
                    Position = dim2(0, 4, 0, 4), ZIndex = 10,
                })
                library:create("UICorner", {Parent = items["search"], CornerRadius = dim(0, 4)})
                library:create("UIPadding", {Parent = items["search"], PaddingLeft = dim(0, 8), PaddingRight = dim(0, 8)})
            end
            
            items["dropdown_scroll"] = library:create("ScrollingFrame", {
                ScrollBarImageColor3 = rgb(44, 44, 46), Active = true,
                AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 4,
                Parent = items["outline"], Name = "\0",
                Size = dim2(1, 0, 1, cfg.searchable and -36 or 0),
                Position = dim2(0, 0, 0, cfg.searchable and 36 or 0),
                BackgroundTransparency = 1, BackgroundColor3 = rgb(255, 255, 255),
                BorderColor3 = rgb(0, 0, 0), BorderSizePixel = 0,
                CanvasSize = dim2(0, 0, 0, 0), ScrollingDirection = Enum.ScrollingDirection.Y,
                ZIndex = 10, ClipsDescendants = true,
            })
            
            items["option_container"] = library:create("Frame", {
                Parent = items["dropdown_scroll"], Name = "\0",
                BackgroundTransparency = 1, Size = dim2(1, 0, 0, 0),
                BorderColor3 = rgb(0, 0, 0), BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = rgb(255, 255, 255),
                ZIndex = 10,
            })
            library:create("UIListLayout", {Parent = items["option_container"], Padding = dim(0, 2), SortOrder = Enum.SortOrder.LayoutOrder})
            library:create("UIPadding", {PaddingBottom = dim(0, 3), PaddingTop = dim(0, 3), PaddingLeft = dim(0, 3), PaddingRight = dim(0, 3), Parent = items["option_container"]})
            library:create("UICorner", {Parent = items["outline"], CornerRadius = dim(0, 6)})
        end 

        function cfg.render_option(text)
            local button = library:create("TextButton", {
                FontFace = fonts.small, TextColor3 = rgb(180, 180, 180),
                BorderColor3 = rgb(0, 0, 0), Text = text,
                Parent = items["option_container"], Name = "\0",
                Size = dim2(1, -6, 0, 28), BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.Y, TextSize = 14,
                BackgroundColor3 = rgb(255, 255, 255), ZIndex = 10,
            })
            library:create("UICorner", {Parent = button, CornerRadius = dim(0, 4)})
            library:create("UIPadding", {Parent = button, PaddingTop = dim(0, 4), PaddingBottom = dim(0, 4), PaddingRight = dim(0, 8), PaddingLeft = dim(0, 8)})
            return button
        end
        
        function cfg.filter_options(searchText)
            for _, option in cfg.option_instances do 
                option.Visible = (searchText == "" or option.Text:lower():find(searchText:lower()))
            end
        end
        
        function cfg.set_visible(bool)
            local optionHeight = 0
            for _, opt in cfg.option_instances do
                if opt.Visible then optionHeight = optionHeight + opt.AbsoluteSize.Y + 2 end
            end
            optionHeight = optionHeight + 6
            local displayHeight = math.min(optionHeight, 200)
            local totalHeight = displayHeight + (cfg.searchable and 36 or 0)
            
            library:tween(items["dropdown_holder"], {Size = dim_offset(items["dropdown"].AbsoluteSize.X, bool and totalHeight or 0)})
            
            local dropdownAbsPos = items["dropdown"].AbsolutePosition
            items["dropdown_holder"].Position = dim2(0, dropdownAbsPos.X, 0, dropdownAbsPos.Y + items["dropdown"].AbsoluteSize.Y + 5)
            
            if bool then
                items["dropdown_scroll"].CanvasSize = dim2(0, 0, 0, optionHeight)
                if items["search"] then items["search"].Text = ""; cfg.filter_options("") end
            end
            
            if not bool then
                if library.current_open == cfg then library.current_open = nil end
            else
                library:close_element(cfg)
                library.current_open = cfg
            end
        end
        
        function cfg.set(value)
            local selected = {}
            local isTable = type(value) == "table"
            for _, option in cfg.option_instances do 
                if option.Text == value or (isTable and find(value, option.Text)) then 
                    insert(selected, option.Text)
                    cfg.multi_items = selected
                    option.TextColor3 = activeTheme.accent
                else
                    option.TextColor3 = rgb(180, 180, 180)
                end
            end
            items["sub_text"].Text = isTable and concat(selected, ", ") or selected[1] or ""
            flags[cfg.flag] = isTable and selected or selected[1]
            cfg.callback(flags[cfg.flag]) 
        end
        
        function cfg.refresh_options(list) 
            cfg.y_size = 0; cfg.allOptions = list
            for _, option in cfg.option_instances do option:Destroy() end
            cfg.option_instances = {}
            for _, option in list do 
                local button = cfg.render_option(option)
                cfg.y_size = cfg.y_size + button.AbsoluteSize.Y + 2
                insert(cfg.option_instances, button)
                
                local function selectOption()
                    if cfg.multi then 
                        local idx = find(cfg.multi_items, button.Text)
                        if idx then remove(cfg.multi_items, idx) else insert(cfg.multi_items, button.Text) end
                        cfg.set(cfg.multi_items)
                    else 
                        cfg.set_visible(false); cfg.open = false
                        cfg.set(button.Text)
                    end
                end
                
                makeClickable(button, selectOption)
            end
        end

        local function toggleDropdown()
            cfg.open = not cfg.open
            cfg.set_visible(cfg.open)
        end
        
        makeClickable(items["dropdown"], toggleDropdown)
        
        if items["search"] then
            items["search"]:GetPropertyChangedSignal("Text"):Connect(function()
                cfg.filter_options(items["search"].Text)
            end)
        end

        if cfg.seperator then 
            library:create("Frame", {
                AnchorPoint = vec2(0, 1), Parent = self.items["elements"],
                Position = dim2(0, 0, 1, 0), BorderColor3 = rgb(0, 0, 0),
                Size = dim2(1, 1, 0, 1), BorderSizePixel = 0, BackgroundColor3 = rgb(36, 36, 37),
            })
        end 

        flags[cfg.flag] = {}
        config_flags[cfg.flag] = cfg.set
        cfg.refresh_options(cfg.options)
        cfg.set(cfg.default)
        return setmetatable(cfg, library)
    end

    function library:label(options)
        local cfg = {
            name = options.name or "Label",
            seperator = options.seperator or false,
            info = options.info or nil,
            items = {},
        }
        local items = cfg.items; do 
            items["label"] = library:create("TextButton", {
                FontFace = fonts.small, TextColor3 = rgb(0, 0, 0),
                BorderColor3 = rgb(0, 0, 0), Text = "",
                Parent = self.items["elements"], Name = "\0",
                BackgroundTransparency = 1, Size = dim2(1, 0, 0, 0),
                BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.Y,
                TextSize = 14, BackgroundColor3 = rgb(255, 255, 255),
            })
            items["name"] = library:create("TextLabel", {
                FontFace = fonts.small, TextColor3 = activeTheme.text,
                BorderColor3 = rgb(0, 0, 0), Text = cfg.name,
                Parent = items["label"], Name = "\0",
                Size = dim2(1, -10, 0, 0), BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0,
                TextWrapped = true, AutomaticSize = Enum.AutomaticSize.Y, TextSize = 16,
                BackgroundColor3 = rgb(255, 255, 255),
            })
            if cfg.info then 
                items["info"] = library:create("TextLabel", {
                    FontFace = fonts.small, TextColor3 = rgb(130, 130, 130),
                    BorderColor3 = rgb(0, 0, 0), TextWrapped = true, Text = cfg.info,
                    Parent = items["label"], Name = "\0",
                    Position = dim2(0, 5, 0, 22), Size = dim2(1, -10, 0, 0),
                    BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.Y, TextSize = 14,
                    BackgroundColor3 = rgb(255, 255, 255),
                })
            end 
            library:create("UIPadding", {Parent = items["name"], PaddingRight = dim(0, 5), PaddingLeft = dim(0, 5)})
        end 
        if cfg.seperator then 
            library:create("Frame", {
                AnchorPoint = vec2(0, 1), Parent = self.items["elements"],
                Position = dim2(0, 0, 1, 0), BorderColor3 = rgb(0, 0, 0),
                Size = dim2(1, 1, 0, 1), BorderSizePixel = 0, BackgroundColor3 = rgb(36, 36, 37),
            })
        end 
        return setmetatable(cfg, library)
    end 
    
    function library:colorpicker(options) 
        local cfg = {
            name = options.name or "Color",
            flag = options.flag or library:next_flag(),
            color = options.color or color(1, 1, 1),
            alpha = options.alpha and 1 - options.alpha or 0,
            open = false,
            callback = options.callback or function() end,
            items = {},
            seperator = options.seperator or false,
        }

        local dragging_sat, dragging_hue, dragging_alpha = false, false, false
        local h, s, v = cfg.color:ToHSV()
        local a = cfg.alpha
        flags[cfg.flag] = {Color = cfg.color, Transparency = cfg.alpha}

        local label
        if not self.items.right_components then
            label = self:label({name = cfg.name, seperator = cfg.seperator})
        end

        local items = cfg.items; do 
            items["colorpicker"] = library:create("TextButton", {
                FontFace = fonts.small, TextColor3 = rgb(0, 0, 0),
                BorderColor3 = rgb(0, 0, 0), Text = "", AutoButtonColor = false,
                AnchorPoint = vec2(1, 0.5),
                Parent = label and label.items.label or self.items["right_components"],
                Name = "\0", Position = dim2(1, 0, 0.5, 0),
                Size = dim2(0, 20, 0, 20), BorderSizePixel = 0, TextSize = 14,
                BackgroundColor3 = cfg.color,
            })
            library:create("UICorner", {Parent = items["colorpicker"], CornerRadius = dim(0, 4)})
            items["colorpicker_inline"] = library:create("Frame", {
                Parent = items["colorpicker"], Size = dim2(1, -2, 1, -2), Name = "\0",
                BorderMode = Enum.BorderMode.Inset, BorderColor3 = rgb(0, 0, 0),
                Position = dim2(0, 1, 0, 1), BorderSizePixel = 0, BackgroundColor3 = cfg.color,
            })
            library:create("UICorner", {Parent = items["colorpicker_inline"], CornerRadius = dim(0, 4)})
            
            -- Colorpicker popup
            items["colorpicker_holder"] = library:create("Frame", {
                Parent = library["other"], Name = "\0",
                BorderColor3 = rgb(0, 0, 0), Size = dim2(0, 200, 0, 230),
                BorderSizePixel = 0, Visible = true, BackgroundColor3 = activeTheme.section_bg,
            })
            items["colorpicker_components"] = library:create("Frame", {
                Parent = items["colorpicker_holder"], Name = "\0",
                Position = dim2(0, 1, 0, 1), BorderColor3 = rgb(0, 0, 0),
                Size = dim2(1, -2, 1, -2), BorderSizePixel = 0,
                BackgroundColor3 = activeTheme.section_inline,
            })
            library:create("UICorner", {Parent = items["colorpicker_components"], CornerRadius = dim(0, 6)})
            
            items["saturation_holder"] = library:create("Frame", {
                Parent = items["colorpicker_components"], Name = "\0",
                Position = dim2(0, 7, 0, 7), BorderColor3 = rgb(0, 0, 0),
                Size = dim2(1, -14, 1, -100), BorderSizePixel = 0,
                BackgroundColor3 = hsv(h, 1, 1),
            })
            items["sat"] = library:create("TextButton", {
                Parent = items["saturation_holder"], Name = "\0",
                Size = dim2(1, 0, 1, 0), Text = "", AutoButtonColor = false,
                BorderColor3 = rgb(0, 0, 0), ZIndex = 2, BorderSizePixel = 0,
                BackgroundColor3 = rgb(255, 255, 255),
            })
            library:create("UICorner", {Parent = items["sat"], CornerRadius = dim(0, 4)})
            library:create("UIGradient", {Rotation = 270, Transparency = numseq{numkey(0, 0), numkey(1, 1)}, Parent = items["sat"], Color = rgbseq{rgbkey(0, rgb(0, 0, 0)), rgbkey(1, rgb(0, 0, 0))}})
            items["val"] = library:create("Frame", {Name = "\0", Parent = items["saturation_holder"], BorderColor3 = rgb(0, 0, 0), Size = dim2(1, 0, 1, 0), BorderSizePixel = 0, BackgroundColor3 = rgb(255, 255, 255)})
            library:create("UIGradient", {Parent = items["val"], Transparency = numseq{numkey(0, 0), numkey(1, 1)}})
            library:create("UICorner", {Parent = items["val"], CornerRadius = dim(0, 4)})
            library:create("UICorner", {Parent = items["saturation_holder"], CornerRadius = dim(0, 4)})
            
            items["satvalpicker"] = library:create("TextButton", {
                BorderColor3 = rgb(0, 0, 0), AutoButtonColor = false, Text = "",
                AnchorPoint = vec2(0, 1), Parent = items["saturation_holder"],
                Name = "\0", Position = dim2(0, 0, 1, 0),
                Size = dim2(0, 12, 0, 12), ZIndex = 5, BorderSizePixel = 0,
                BackgroundColor3 = hsv(h, s, v),
            })
            library:create("UICorner", {Parent = items["satvalpicker"], CornerRadius = dim(0, 9999)})
            library:create("UIStroke", {Color = rgb(255, 255, 255), Parent = items["satvalpicker"], ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
            
            items["hue_gradient"] = library:create("TextButton", {
                Parent = items["colorpicker_components"], Name = "\0",
                Position = dim2(0, 10, 1, -84), BorderColor3 = rgb(0, 0, 0),
                Size = dim2(1, -20, 0, 12), BorderSizePixel = 0,
                BackgroundColor3 = rgb(255, 255, 255), AutoButtonColor = false, Text = "",
            })
            library:create("UIGradient", {Color = rgbseq{rgbkey(0, rgb(255, 0, 0)), rgbkey(0.17, rgb(255, 255, 0)), rgbkey(0.33, rgb(0, 255, 0)), rgbkey(0.5, rgb(0, 255, 255)), rgbkey(0.67, rgb(0, 0, 255)), rgbkey(0.83, rgb(255, 0, 255)), rgbkey(1, rgb(255, 0, 0))}, Parent = items["hue_gradient"]})
            library:create("UICorner", {Parent = items["hue_gradient"], CornerRadius = dim(0, 6)})
            
            items["hue_picker"] = library:create("TextButton", {
                BorderColor3 = rgb(0, 0, 0), AutoButtonColor = false, Text = "",
                AnchorPoint = vec2(0, 0.5), Parent = items["hue_gradient"],
                Name = "\0", Position = dim2(0, 0, 0.5, 0),
                Size = dim2(0, 12, 0, 12), ZIndex = 5, BorderSizePixel = 0,
                BackgroundColor3 = hsv(h, 1, 1),
            })
            library:create("UICorner", {Parent = items["hue_picker"], CornerRadius = dim(0, 9999)})
            library:create("UIStroke", {Color = rgb(255, 255, 255), Parent = items["hue_picker"], ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
            
            items["alpha_gradient"] = library:create("TextButton", {
                Parent = items["colorpicker_components"], Name = "\0",
                Position = dim2(0, 10, 1, -62), BorderColor3 = rgb(0, 0, 0),
                Size = dim2(1, -20, 0, 12), BorderSizePixel = 0,
                BackgroundColor3 = activeTheme.section_bg, AutoButtonColor = false, Text = "",
            })
            library:create("UICorner", {Parent = items["alpha_gradient"], CornerRadius = dim(0, 6)})
            
            items["alpha_picker"] = library:create("TextButton", {
                BorderColor3 = rgb(0, 0, 0), AutoButtonColor = false, Text = "",
                AnchorPoint = vec2(0, 0.5), Parent = items["alpha_gradient"],
                Name = "\0", Position = dim2(1, 0, 0.5, 0),
                Size = dim2(0, 12, 0, 12), ZIndex = 5, BorderSizePixel = 0,
                BackgroundColor3 = hsv(h, 1, 1 - a),
            })
            library:create("UICorner", {Parent = items["alpha_picker"], CornerRadius = dim(0, 9999)})
            library:create("UIStroke", {Color = rgb(255, 255, 255), ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = items["alpha_picker"]})
            library:create("UIGradient", {Color = rgbseq{rgbkey(0, rgb(0, 0, 0)), rgbkey(1, rgb(255, 255, 255))}, Parent = items["alpha_gradient"]})
            
            items["alpha_indicator"] = library:create("ImageLabel", {
                ScaleType = Enum.ScaleType.Tile, BorderColor3 = rgb(0, 0, 0),
                Parent = items["alpha_gradient"], Image = "rbxassetid://18274452449",
                BackgroundTransparency = 1, Name = "\0", Size = dim2(1, 0, 1, 0),
                TileSize = dim2(0, 6, 0, 6), BorderSizePixel = 0, BackgroundColor3 = rgb(0, 0, 0),
            })
            library:create("UIGradient", {Color = rgbseq{rgbkey(0, rgb(112, 112, 112)), rgbkey(1, hsv(h, 1, 1))}, Transparency = numseq{numkey(0, 0.8), numkey(1, 0)}, Parent = items["alpha_indicator"]})
            library:create("UICorner", {Parent = items["alpha_indicator"], CornerRadius = dim(0, 6)})

            items["input"] = library:create("TextBox", {
                FontFace = fonts.font, AnchorPoint = vec2(1, 1), Text = "",
                Parent = items["colorpicker_components"], Name = "\0",
                TextTruncate = Enum.TextTruncate.AtEnd, BorderSizePixel = 0,
                PlaceholderColor3 = rgb(255, 255, 255), CursorPosition = -1,
                ClearTextOnFocus = false, TextSize = 14,
                TextColor3 = rgb(72, 72, 72), BorderColor3 = rgb(0, 0, 0),
                Position = dim2(1, -8, 1, -11), Size = dim2(1, -16, 0, 22),
                BackgroundColor3 = activeTheme.button_bg,
            })
            library:create("UICorner", {Parent = items["input"], CornerRadius = dim(0, 3)})
            library:create("UICorner", {Parent = items["colorpicker_holder"], Name = "\0", CornerRadius = dim(0, 4)})
        end;

        function cfg.set_visible(bool)
            items["colorpicker_holder"].Parent = bool and library["items"] or library["other"]
            local cpAbsPos = items["colorpicker"].AbsolutePosition
            items["colorpicker_holder"].Position = dim_offset(cpAbsPos.X + 30, cpAbsPos.Y + items["colorpicker"].AbsoluteSize.Y + 10)
            if not bool then
                if library.current_open == cfg then library.current_open = nil end
            else
                library:close_element(cfg)
                library.current_open = cfg
            end
        end

        function cfg.set(color, alpha)
            if type(color) == "boolean" then return end
            if color then h, s, v = color:ToHSV() end
            if alpha then a = alpha end
            local Color = hsv(h, s, v)
            library:tween(items["hue_picker"], {Position = dim2(0, (items["hue_gradient"].AbsoluteSize.X - 12) * h, 0.5, 0)}, Enum.EasingStyle.Linear, 0.05)
            library:tween(items["alpha_picker"], {Position = dim2(0, (items["alpha_gradient"].AbsoluteSize.X - 12) * (1 - a), 0.5, 0)}, Enum.EasingStyle.Linear, 0.05)
            library:tween(items["satvalpicker"], {Position = dim2(0, s * (items["saturation_holder"].AbsoluteSize.X - 12), 1, 1 - v * (items["saturation_holder"].AbsoluteSize.Y - 12))}, Enum.EasingStyle.Linear, 0.05)
            
            if items["alpha_indicator"]:FindFirstChildOfClass("UIGradient") then
                items["alpha_indicator"]:FindFirstChildOfClass("UIGradient").Color = rgbseq{rgbkey(0, rgb(112, 112, 112)), rgbkey(1, hsv(h, 1, 1))}
            end
            items["colorpicker"].BackgroundColor3 = Color
            items["colorpicker_inline"].BackgroundColor3 = Color
            items["saturation_holder"].BackgroundColor3 = hsv(h, 1, 1)
            items["hue_picker"].BackgroundColor3 = hsv(h, 1, 1)
            items["alpha_picker"].BackgroundColor3 = hsv(h, 1, 1 - a)
            items["satvalpicker"].BackgroundColor3 = hsv(h, s, v)
            flags[cfg.flag] = {Color = Color, Transparency = a}
            local c = items["colorpicker"].BackgroundColor3
            items["input"].Text = string.format("%s, %s, %s, %s", library:round(c.R * 255), library:round(c.G * 255), library:round(c.B * 255), library:round(1 - a, 0.01))
            cfg.callback(Color, a)
        end
        
        function cfg.update_color()
            local mousePos = uis:GetMouseLocation()
            local offset = vec2(mousePos.X, mousePos.Y - gui_offset)
            if dragging_sat then
                s = clamp((offset - items["sat"].AbsolutePosition).X / items["sat"].AbsoluteSize.X, 0, 1)
                v = 1 - clamp((offset - items["sat"].AbsolutePosition).Y / items["sat"].AbsoluteSize.Y, 0, 1)
            elseif dragging_hue then
                h = clamp((offset - items["hue_gradient"].AbsolutePosition).X / items["hue_gradient"].AbsoluteSize.X, 0, 1)
            elseif dragging_alpha then
                a = 1 - clamp((offset - items["alpha_gradient"].AbsolutePosition).X / items["alpha_gradient"].AbsoluteSize.X, 0, 1)
            end
            cfg.set()
        end

        local function toggleCP()
            cfg.open = not cfg.open
            cfg.set_visible(cfg.open)
        end
        
        makeClickable(items["colorpicker"], toggleCP)

        uis.InputChanged:Connect(function(input)
            if (dragging_sat or dragging_hue or dragging_alpha) and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                cfg.update_color()
            end
        end)
        library:connection(uis.InputEnded, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging_sat, dragging_hue, dragging_alpha = false, false, false
            end
        end)

        local function startAlphaDrag(input)
            dragging_alpha = true
            if input.UserInputType == Enum.UserInputType.Touch then
                a = 1 - clamp((input.Position.X - items["alpha_gradient"].AbsolutePosition.X) / items["alpha_gradient"].AbsoluteSize.X, 0, 1)
                cfg.set()
            end
        end
        local function startHueDrag(input)
            dragging_hue = true
            if input.UserInputType == Enum.UserInputType.Touch then
                h = clamp((input.Position.X - items["hue_gradient"].AbsolutePosition.X) / items["hue_gradient"].AbsoluteSize.X, 0, 1)
                cfg.set()
            end
        end
        local function startSatDrag(input)
            dragging_sat = true
            if input.UserInputType == Enum.UserInputType.Touch then
                s = clamp((input.Position.X - items["sat"].AbsolutePosition.X) / items["sat"].AbsoluteSize.X, 0, 1)
                v = 1 - clamp((input.Position.Y - items["sat"].AbsolutePosition.Y) / items["sat"].AbsoluteSize.Y, 0, 1)
                cfg.set()
            end
        end

        items["alpha_gradient"].InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then startAlphaDrag(input) end
        end)
        items["hue_gradient"].InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then startHueDrag(input) end
        end)
        items["sat"].InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then startSatDrag(input) end
        end)

        items["input"].FocusLost:Connect(function()
            local r, g, b, a_val = library:convert(items["input"].Text)
            if r and g and b and a_val then cfg.set(rgb(r, g, b), 1 - a_val) end
        end)
        items["input"].Focused:Connect(function() library:tween(items["input"], {TextColor3 = rgb(245, 245, 245)}) end)
        items["input"].FocusLost:Connect(function() library:tween(items["input"], {TextColor3 = rgb(72, 72, 72)}) end)
        
        cfg.set(cfg.color, cfg.alpha)
        config_flags[cfg.flag] = cfg.set
        return setmetatable(cfg, library)
    end 

    function library:textbox(options) 
        local cfg = {
            name = options.name or "TextBox",
            placeholder = options.placeholder or "type here...",
            default = options.default or "",
            flag = options.flag or library:next_flag(),
            callback = options.callback or function() end,
            items = {},
        }
        flags[cfg.flag] = cfg.default
        local items = cfg.items; do 
            items["textbox"] = library:create("TextButton", {
                FontFace = fonts.font, TextColor3 = rgb(0, 0, 0),
                BorderColor3 = rgb(0, 0, 0), Text = "",
                Parent = self.items["elements"], Name = "\0",
                BackgroundTransparency = 1, Size = dim2(1, 0, 0, 0),
                BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.Y,
                TextSize = 14, BackgroundColor3 = rgb(255, 255, 255),
            })
            items["name"] = library:create("TextLabel", {
                FontFace = fonts.font, TextColor3 = activeTheme.text,
                BorderColor3 = rgb(0, 0, 0), Text = cfg.name,
                Parent = items["textbox"], Name = "\0",
                Size = dim2(1, -10, 0, 0), BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0,
                TextWrapped = true, AutomaticSize = Enum.AutomaticSize.Y, TextSize = 16,
                BackgroundColor3 = rgb(255, 255, 255),
            })
            library:create("UIPadding", {Parent = items["name"], PaddingRight = dim(0, 5), PaddingLeft = dim(0, 5)})
            
            items["input"] = library:create("TextBox", {
                FontFace = fonts.font, Text = "",
                Parent = items["textbox"], Name = "\0",
                TextTruncate = Enum.TextTruncate.AtEnd, BorderSizePixel = 0,
                PlaceholderColor3 = rgb(72, 72, 73), PlaceholderText = cfg.placeholder,
                CursorPosition = -1, ClearTextOnFocus = false, TextSize = 14,
                TextColor3 = rgb(72, 72, 72), BorderColor3 = rgb(0, 0, 0),
                Position = dim2(0, 4, 0, 24), Size = dim2(1, -4, 0, 30),
                BackgroundColor3 = activeTheme.button_bg,
            })
            library:create("UICorner", {Parent = items["input"], CornerRadius = dim(0, 3)})
        end 
        
        function cfg.set(text) 
            flags[cfg.flag] = text
            items["input"].Text = text
            cfg.callback(text)
        end 
        items["input"]:GetPropertyChangedSignal("Text"):Connect(function() cfg.set(items["input"].Text) end)
        items["input"].Focused:Connect(function() library:tween(items["input"], {TextColor3 = rgb(245, 245, 245)}) end)
        items["input"].FocusLost:Connect(function() library:tween(items["input"], {TextColor3 = rgb(72, 72, 72)}) end)
        if cfg.default then cfg.set(cfg.default) end
        config_flags[cfg.flag] = cfg.set
        return setmetatable(cfg, library)
    end

    function library:keybind(options) 
        local cfg = {
            flag = options.flag or library:next_flag(),
            callback = options.callback or function() end,
            name = options.name or nil,
            key = options.key or nil,
            mode = options.mode or "Toggle",
            active = options.default or false,
            open = false, binding = nil,
            hold_instances = {}, items = {},
        }
        flags[cfg.flag] = {mode = cfg.mode, key = cfg.key, active = cfg.active}
        local items = cfg.items; do 
            items["keybind_element"] = library:create("TextButton", {
                FontFace = fonts.font, TextColor3 = rgb(0, 0, 0),
                BorderColor3 = rgb(0, 0, 0), Text = "",
                Parent = self.items["elements"], Name = "\0",
                BackgroundTransparency = 1, Size = dim2(1, 0, 0, 0),
                BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.Y,
                TextSize = 14, BackgroundColor3 = rgb(255, 255, 255),
            })
            items["name"] = library:create("TextLabel", {
                FontFace = fonts.font, TextColor3 = activeTheme.text,
                BorderColor3 = rgb(0, 0, 0), Text = cfg.name,
                Parent = items["keybind_element"], Name = "\0",
                Size = dim2(1, -10, 0, 0), BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0,
                TextWrapped = true, AutomaticSize = Enum.AutomaticSize.Y, TextSize = 16,
                BackgroundColor3 = rgb(255, 255, 255),
            })
            library:create("UIPadding", {Parent = items["name"], PaddingRight = dim(0, 5), PaddingLeft = dim(0, 5)})
            
            items["keybind_holder"] = library:create("TextButton", {
                FontFace = fonts.font, TextColor3 = rgb(0, 0, 0),
                BorderColor3 = rgb(0, 0, 0), Text = "",
                Parent = items["keybind_element"], AutoButtonColor = false,
                AnchorPoint = vec2(1, 0.5), Size = dim2(0, 0, 0, 24),
                Name = "\0", Position = dim2(1, 0, 0.5, 0),
                BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.X, TextSize = 14,
                BackgroundColor3 = activeTheme.button_bg,
            })
            library:create("UICorner", {Parent = items["keybind_holder"], CornerRadius = dim(0, 5)})
            
            items["key"] = library:create("TextLabel", {
                FontFace = fonts.font, TextColor3 = rgb(200, 200, 200),
                BorderColor3 = rgb(0, 0, 0), Text = "NONE",
                Parent = items["keybind_holder"], Name = "\0",
                Size = dim2(1, -12, 0, 0), BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.XY, TextSize = 14, BackgroundColor3 = rgb(255, 255, 255),
            })
            library:create("UIPadding", {Parent = items["key"], PaddingTop = dim(0, 4), PaddingRight = dim(0, 5), PaddingLeft = dim(0, 8)})
            
            -- Mode dropdown
            items["dropdown"] = library:create("Frame", {
                BorderColor3 = rgb(0, 0, 0), Parent = library.items,
                Name = "\0", BackgroundTransparency = 1,
                Size = dim2(0, 0, 0, 0), BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = rgb(0, 0, 0),
            })
            items["inline"] = library:create("Frame", {
                Parent = items["dropdown"], Size = dim2(1, 0, 1, 0), Name = "\0",
                ClipsDescendants = true, BorderColor3 = rgb(0, 0, 0),
                BorderSizePixel = 0, BackgroundColor3 = rgb(28, 28, 32),
            })
            library:create("UIPadding", {PaddingBottom = dim(0, 6), PaddingTop = dim(0, 3), PaddingLeft = dim(0, 3), Parent = items["inline"]})
            library:create("UIListLayout", {Parent = items["inline"], Padding = dim(0, 5), SortOrder = Enum.SortOrder.LayoutOrder})
            library:create("UICorner", {Parent = items["inline"], CornerRadius = dim(0, 6)})
            
            local options = {"Hold", "Toggle", "Always"}
            cfg.y_size = 20
            for _, option in options do
                local name = library:create("TextButton", {
                    FontFace = fonts.font, TextColor3 = rgb(180, 180, 180),
                    BorderColor3 = rgb(0, 0, 0), Text = option,
                    Parent = items["inline"], Name = "\0",
                    Size = dim2(0, 0, 0, 0), BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY, TextSize = 14, BackgroundColor3 = rgb(255, 255, 255),
                }); cfg.hold_instances[option] = name
                cfg.y_size = cfg.y_size + name.AbsoluteSize.Y
                library:create("UIPadding", {Parent = name, PaddingTop = dim(0, 1), PaddingRight = dim(0, 5), PaddingLeft = dim(0, 5)})
                makeClickable(name, function() cfg.set(option); cfg.set_visible(false); cfg.open = false end)
            end
        end 
        
        function cfg.modify_mode_color(path)
            for _, v in cfg.hold_instances do v.TextColor3 = rgb(180, 180, 180) end
            cfg.hold_instances[path].TextColor3 = activeTheme.accent
        end
        function cfg.set_mode(mode) 
            cfg.mode = mode
            if mode == "Always" then cfg.set(true) elseif mode == "Hold" then cfg.set(false) end
            flags[cfg.flag]["mode"] = mode
            cfg.modify_mode_color(mode)
        end 
        function cfg.set(input)
            if type(input) == "boolean" then cfg.active = input; if cfg.mode == "Always" then cfg.active = true end
            elseif tostring(input):find("Enum") then cfg.key = input.Name == "Escape" and "NONE" or input
            elseif find({"Toggle", "Hold", "Always"}, input) then
                if input == "Always" then cfg.active = true end
                cfg.mode = input; cfg.set_mode(cfg.mode)
            elseif type(input) == "table" then
                input.key = type(input.key) == "string" and input.key ~= "NONE" and library:convert_enum(input.key) or input.key
                input.key = input.key == Enum.KeyCode.Escape and "NONE" or input.key
                cfg.key = input.key or "NONE"; cfg.mode = input.mode or "Toggle"
                if input.active then cfg.active = input.active end
                cfg.set_mode(cfg.mode)
            end
            cfg.callback(cfg.active)
            local text = tostring(cfg.key) ~= "Enums" and (keys[cfg.key] or tostring(cfg.key):gsub("Enum.", "")) or nil
            items["key"].Text = text and tostring(text):gsub("KeyCode.", ""):gsub("UserInputType.", "") or "NONE"
            flags[cfg.flag] = {mode = cfg.mode, key = cfg.key, active = cfg.active}
        end
        function cfg.set_visible(bool)
            library:tween(items["dropdown"], {Size = dim_offset(items["keybind_holder"].AbsoluteSize.X, bool and cfg.y_size or 0)})
            items["dropdown"].Position = dim_offset(items["keybind_holder"].AbsolutePosition.X, items["keybind_holder"].AbsolutePosition.Y + items["keybind_holder"].AbsoluteSize.Y + 60)
        end

        items["keybind_holder"].InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                items["key"].Text = "..."
                cfg.binding = library:connection(uis.InputBegan, function(keycode, game_event)  
                    cfg.set(keycode.KeyCode ~= Enum.KeyCode.Unknown and keycode.KeyCode or keycode.UserInputType)
                    if cfg.binding then cfg.binding:Disconnect(); cfg.binding = nil end
                end)
            elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                cfg.open = not cfg.open; cfg.set_visible(cfg.open)
            end
        end)

        library:connection(uis.InputBegan, function(input, game_event) 
            if not game_event then
                local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType
                if selected_key == cfg.key then
                    if cfg.mode == "Toggle" then cfg.active = not cfg.active; cfg.set(cfg.active)
                    elseif cfg.mode == "Hold" then cfg.set(true) end
                end
            end
        end)
        library:connection(uis.InputEnded, function(input, game_event) 
            if game_event then return end
            local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType
            if selected_key == cfg.key and cfg.mode == "Hold" then cfg.set(false) end
        end)
        
        cfg.set({mode = cfg.mode, active = cfg.active, key = cfg.key})
        config_flags[cfg.flag] = cfg.set
        return setmetatable(cfg, library)
    end

    function library:button(options) 
        local cfg = {name = options.name or "Button", callback = options.callback or function() end, items = {}}
        local items = cfg.items; do 
            items["button"] = library:create("TextButton", {
                FontFace = fonts.font, TextColor3 = rgb(0, 0, 0),
                BorderColor3 = rgb(0, 0, 0), Text = "",
                AutoButtonColor = false, Parent = self.items["elements"],
                Name = "\0", Size = dim2(1, -4, 0, 34),
                BorderSizePixel = 0, TextSize = 14, BackgroundColor3 = activeTheme.button_bg,
            })
            library:create("UICorner", {Parent = items["button"], CornerRadius = dim(0, 5)})
            items["name"] = library:create("TextLabel", {
                FontFace = fonts.small, TextColor3 = activeTheme.text,
                BorderColor3 = rgb(0, 0, 0), Text = cfg.name,
                Parent = items["button"], Name = "\0",
                BackgroundTransparency = 1, Size = dim2(1, 0, 1, 0),
                BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.XY, TextSize = 14,
                BackgroundColor3 = rgb(255, 255, 255),
            })
        end 
        local function buttonClick()
            cfg.callback()
            items["name"].TextColor3 = activeTheme.accent
            library:tween(items["name"], {TextColor3 = activeTheme.text})
        end
        makeClickable(items["button"], buttonClick)
        return setmetatable(cfg, library)
    end 

    function library:list(properties) 
        local cfg = {
            items = {}, options = properties.options or {"1", "2", "3"},
            flag = properties.flag or library:next_flag(),
            callback = properties.callback or function() end,
            data_store = {}, current_element = nil,
        }
        local items = cfg.items; do
            items["list"] = library:create("Frame", {
                Parent = self.items["elements"], BackgroundTransparency = 1,
                Name = "\0", Size = dim2(1, 0, 0, 0),
                BorderColor3 = rgb(0, 0, 0), BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.XY, BackgroundColor3 = rgb(255, 255, 255),
            })
            library:create("UIListLayout", {Parent = items["list"], Padding = dim(0, 10), SortOrder = Enum.SortOrder.LayoutOrder})
            library:create("UIPadding", {Parent = items["list"], PaddingRight = dim(0, 4), PaddingLeft = dim(0, 4)})
        end 

        function cfg.refresh_options(options_to_refresh)
            for _, option in cfg.data_store do option:Destroy() end
            cfg.data_store = {}
            for _, option_data in options_to_refresh do
                local button = library:create("TextButton", {
                    FontFace = fonts.small, TextColor3 = rgb(0, 0, 0),
                    BorderColor3 = rgb(0, 0, 0), Text = "", AutoButtonColor = false,
                    Parent = items["list"], Name = "\0",
                    Size = dim2(1, 0, 0, 34), BorderSizePixel = 0, TextSize = 14,
                    BackgroundColor3 = activeTheme.button_bg,
                }); cfg.data_store[#cfg.data_store + 1] = button
                local name = library:create("TextLabel", {
                    FontFace = fonts.font, TextColor3 = rgb(180, 180, 180),
                    BorderColor3 = rgb(0, 0, 0), Text = option_data,
                    Parent = button, Name = "\0", BackgroundTransparency = 1,
                    Size = dim2(1, 0, 1, 0), BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY, TextSize = 14, BackgroundColor3 = rgb(255, 255, 255),
                })
                library:create("UICorner", {Parent = button, CornerRadius = dim(0, 5)})
                
                local function selectItem()
                    local current = cfg.current_element
                    if current and current ~= name then library:tween(current, {TextColor3 = rgb(180, 180, 180)}) end
                    flags[cfg.flag] = option_data
                    cfg.callback(option_data)
                    library:tween(name, {TextColor3 = activeTheme.text})
                    cfg.current_element = name
                end
                makeClickable(button, selectItem)
            end
        end
        cfg.refresh_options(cfg.options)
        return setmetatable(cfg, library)
    end 

    function library:init_config(window) 
        window:seperator({name = "Settings"})
        local main = window:tab({name = "Settings", icon = "rbxassetid://129380150574313", tabs = {"Configs", "Theme"}, isSettings = true})
        
        local column = main:column({size = 0.5})
        local section = column:section({name = "Configs", size = 1, default = true, icon = "rbxassetid://139628202576511"})
        config_holder = section:list({options = {"No configs found"}, callback = function(option) end, flag = "config_name_list"}); library:update_config_list()
        section:textbox({name = "Config name:", flag = "config_name_text", placeholder = "Enter config name..."})
        section:button({name = "Save Config", callback = function() 
            local name = flags["config_name_text"] or flags["config_name_list"]
            if name and name ~= "No configs found" then
                writefile(library.directory .. "/configs/" .. name .. ".cfg", library:get_config())
                library:update_config_list()
                notifications:create_notification({name = "Configs", info = "Saved: " .. name})
            end
        end})
        section:button({name = "Load Config", callback = function() 
            local name = flags["config_name_list"]
            if name and name ~= "No configs found" and isfile(library.directory .. "/configs/" .. name .. ".cfg") then
                library:load_config(readfile(library.directory .. "/configs/" .. name .. ".cfg"))
                notifications:create_notification({name = "Configs", info = "Loaded: " .. name})
            end
        end})
        section:button({name = "Delete Config", callback = function() 
            local name = flags["config_name_list"]
            if name and name ~= "No configs found" and isfile(library.directory .. "/configs/" .. name .. ".cfg") then
                delfile(library.directory .. "/configs/" .. name .. ".cfg")
                library:update_config_list()
                notifications:create_notification({name = "Configs", info = "Deleted: " .. name})
            end
        end})
        
        local column2 = main:column({size = 0.5})
        local section2 = column2:section({name = "Theme", size = 1, default = true, icon = "rbxassetid://6022668898"})
        section2:dropdown({name = "Theme", items = {"dark", "light", "midnight", "crimson", "forest", "ocean", "sunset"}, default = "dark", callback = function(theme) library:update_theme(theme) end})
        section2:colorpicker({name = "Accent Color", callback = function(color, alpha) activeTheme.accent = color; library:update_theme(library.current_theme) end, color = activeTheme.accent})
        section2:keybind({name = "Menu Bind", callback = function(bool) window.toggle_menu(bool) end, default = true, key = Enum.KeyCode.Insert})
    end

    -- Notifications
    function notifications:refresh_notifs() 
        local offset = 50
        for i, v in notifications.notifs do
            library:tween(v, {Position = dim_offset(20, offset)}, Enum.EasingStyle.Quad, 0.4)
            offset = offset + v.AbsoluteSize.Y + 10
        end
        return offset
    end
    
    function notifications:fade(path, is_fading)
        local fading = is_fading and 1 or 0
        library:tween(path, {BackgroundTransparency = fading}, Enum.EasingStyle.Quad, 1)
        for _, instance in path:GetDescendants() do 
            if not instance:IsA("GuiObject") then
                if instance:IsA("UIStroke") then library:tween(instance, {Transparency = fading}, Enum.EasingStyle.Quad, 1) end
                continue
            end
            if instance:IsA("TextLabel") then library:tween(instance, {TextTransparency = fading})
            elseif instance:IsA("Frame") then library:tween(instance, {BackgroundTransparency = fading}) end
        end
    end 
    
    function notifications:create_notification(options)
        local cfg = {name = options.name or "Title", info = options.info or "Info", lifetime = options.lifetime or 3, items = {}}
        local items = cfg.items; do 
            items["notification"] = library:create("Frame", {
                Parent = library["items"], Size = dim2(0, 230, 0, 53), Name = "\0",
                BorderColor3 = rgb(0, 0, 0), BorderSizePixel = 0,
                BackgroundTransparency = 1, AnchorPoint = vec2(1, 0),
                AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = activeTheme.background,
            })
            library:create("UIStroke", {Color = rgb(23, 23, 29), Parent = items["notification"], Transparency = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
            items["title"] = library:create("TextLabel", {
                FontFace = fonts.font, TextColor3 = rgb(255, 255, 255),
                BorderColor3 = rgb(0, 0, 0), Text = cfg.name,
                Parent = items["notification"], Name = "\0", BackgroundTransparency = 1,
                Position = dim2(0, 7, 0, 6), BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.XY, TextSize = 14, BackgroundColor3 = rgb(255, 255, 255),
            })
            library:create("UICorner", {Parent = items["notification"], CornerRadius = dim(0, 3)})
            items["info"] = library:create("TextLabel", {
                FontFace = fonts.font, TextColor3 = rgb(145, 145, 145),
                BorderColor3 = rgb(0, 0, 0), Text = cfg.info,
                Parent = items["notification"], Name = "\0",
                Position = dim2(0, 9, 0, 22), BorderSizePixel = 0, BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true,
                AutomaticSize = Enum.AutomaticSize.XY, TextSize = 14, BackgroundColor3 = rgb(255, 255, 255),
            })
            library:create("UIPadding", {PaddingBottom = dim(0, 17), PaddingRight = dim(0, 8), Parent = items["info"]})
            items["bar"] = library:create("Frame", {
                AnchorPoint = vec2(0, 1), Parent = items["notification"], Name = "\0",
                Position = dim2(0, 8, 1, -6), BorderColor3 = rgb(0, 0, 0),
                Size = dim2(0, 0, 0, 5), BackgroundTransparency = 1,
                BorderSizePixel = 0, BackgroundColor3 = activeTheme.accent,
            }); library:track_accent_bg(items["bar"])
            library:create("UICorner", {Parent = items["bar"], CornerRadius = dim(0, 999)})
            library:create("UIPadding", {PaddingRight = dim(0, 8), Parent = items["notification"]})
        end
        
        local index = #notifications.notifs + 1
        notifications.notifs[index] = items["notification"]
        notifications:fade(items["notification"], false)
        local offset = notifications:refresh_notifs()
        items["notification"].Position = dim_offset(20, offset)
        library:tween(items["notification"], {AnchorPoint = vec2(0, 0)}, Enum.EasingStyle.Quad, 1)
        library:tween(items["bar"], {Size = dim2(1, -8, 0, 5)}, Enum.EasingStyle.Quad, cfg.lifetime)
        task.spawn(function()
            task.wait(cfg.lifetime)
            notifications.notifs[index] = nil
            notifications:fade(items["notification"], true)
            library:tween(items["notification"], {AnchorPoint = vec2(1, 0)}, Enum.EasingStyle.Quad, 1)
            task.wait(1)
            items["notification"]:Destroy()
        end)
    end
--

return library
