-- ============================================
-- FISH IT! RNG DESTROYER ONLY
-- Khusus untuk: https://www.roblox.com/games/121864768012064/Fish-It
-- Hanya menghancurkan RNG, tidak ada bot atau auto-clicker
-- ============================================

local OxyX_RNG_Destroyer = {
    GameID = 121864768012064, -- Fish It! ID
    Active = false,
    OriginalRandom = nil,
    Hooks = {}
}

print("==========================================")
print("   💥 OXYX RNG DESTROYER - FISH IT! 💥")
print("   Mode: RNG Destruction Only")
print("==========================================")

-- 🎯 **FUNGSI INTI: PENGHANCURAN RNG TOTAL**
local function DestroyRNG_Complete()
    if OxyX_RNG_Destroyer.Active then return end
    
    print("[RNG] Memulai penghancuran sistem RNG Fish It...")
    
    -- 1. HANCURKAN math.random GLOBAL
    OxyX_RNG_Destroyer.OriginalRandom = math.random
    math.random = function(a, b)
        -- Untuk Fish It, selalu return nilai TERBAIK:
        -- - Peluang: 0.99 (99%)
        -- - Pilihan: nilai MAX
        -- - Random number: 0.99
        if not a and not b then
            return 0.999 -- Peluang sukses maksimal
        elseif a and not b then
            return a -- Selalu pilihan pertama/terbaik
        else
            return (b or a) -- Selalu nilai tertinggi
        end
    end
    print("[RNG] ✅ math.random() DESTROYED")
    
    -- 2. HANCURKAN Random.new() jika ada
    if Random then
        OxyX_RNG_Destroyer.Hooks.RandomNew = Random.new
        Random.new = function(seed)
            local fakeRNG = {
                NextNumber = function(self)
                    return 0.999 -- Always lucky
                end,
                NextInteger = function(self, min, max)
                    return max or 999999 -- Always max
                end
            }
            return fakeRNG
        end
        print("[RNG] ✅ Random.new() DESTROYED")
    end
    
    -- 3. HOOK REMOTE EVENT FISHING (TANGKAPAN IKAN)
    local fishingHooked = false
    for _, remote in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if remote:IsA("RemoteEvent") then
            local name = remote.Name:lower()
            
            -- Hook untuk event menangkap ikan
            if name:find("fish") or name:find("catch") or name:find("reel") then
                print("[RNG] Found fishing remote: " .. remote.Name)
                
                local originalFire = remote.FireServer
                remote.FireServer = function(self, ...)
                    local args = {...}
                    
                    -- Jika ini event menangkap ikan, ganti dengan hasil TERBAIK
                    if #args > 0 then
                        local firstArg = tostring(args[1]):lower()
                        
                        if firstArg:find("fish") or firstArg:find("catch") or firstArg:find("reel") then
                            print("[RNG] 🎣 Override fishing result: LEGENDARY + MAX VALUE")
                            -- Ganti args dengan hasil legendary
                            return originalFire(self, 
                                args[1], -- Original command
                                "LEGENDARY_FISH", -- Rarity
                                999999, -- Value
                                "GemStone", -- Type
                                true, -- Critical
                                100 -- Size (max)
                            )
                        end
                    end
                    
                    return originalFire(self, ...)
                end
                
                fishingHooked = true
                OxyX_RNG_Destroyer.Hooks[remote.Name] = remote
            end
            
            -- Hook untuk event koin/hadiah
            if name:find("coin") or name:find("money") or name:find("reward") then
                print("[RNG] Found currency remote: " .. remote.Name)
                
                local originalFire = remote.FireServer
                remote.FireServer = function(self, ...)
                    local args = {...}
                    
                    -- Jika ini event dapat koin, ganti dengan jumlah MAX
                    if #args > 0 then
                        local firstArg = tostring(args[1]):lower()
                        
                        if firstArg:find("add") or firstArg:find("coin") or firstArg:find("reward") then
                            -- Ganti amount dengan 999999
                            if #args >= 2 then
                                args[2] = 999999
                            end
                            print("[RNG] 💰 Override currency reward: 999,999")
                        end
                    end
                    
                    return originalFire(self, unpack(args))
                end
            end
        end
    end
    
    if not fishingHooked then
        print("[RNG] ⚠ No fishing remote found, using global RNG destruction only")
    end
    
    -- 4. HOOK GACHA/LOOTBOX SYSTEMS
    for _, remote in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if remote:IsA("RemoteEvent") then
            local name = remote.Name:lower()
            
            if name:find("gacha") or name:find("spin") or name:find("loot") or name:find("crate") then
                print("[RNG] Found gacha system: " .. remote.Name)
                
                local originalFire = remote.FireServer
                remote.FireServer = function(self, ...)
                    local args = {...}
                    
                    print("[RNG] 🎰 Override gacha: ALWAYS LEGENDARY")
                    -- Selalu return item legendary
                    return {"LEGENDARY", "RAINBOW_ROD", 999999, true}
                end
            end
        end
    end
    
    -- 5. OVERRIDE NUMBER VALUES (KOIN, DIAMOND, DLL)
    spawn(function()
        while OxyX_RNG_Destroyer.Active do
            pcall(function()
                -- Cari semua value yang berhubungan dengan mata uang
                for _, obj in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                    if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                        local name = obj.Name:lower()
                        
                        if name:find("coin") or name:find("cash") or 
                           name:find("money") or name:find("diamond") or 
                           name:find("gem") or name:find("token") then
                            -- Set ke nilai maksimal
                            obj.Value = 9999999
                        end
                    end
                end
            end)
            wait(1)
        end
    end)
    
    -- 6. OVERRIDE ATTRIBUTES (RARITY, CHANCE, PROBABILITY)
    spawn(function()
        while OxyX_RNG_Destroyer.Active do
            pcall(function()
                -- Set semua atribut peluang/chance ke 1.0 (100%)
                for _, obj in pairs(game:GetDescendants()) do
                    for _, attrName in pairs(obj:GetAttributes()) do
                        if tostring(attrName):lower():find("chance") or
                           tostring(attrName):lower():find("prob") or
                           tostring(attrName):lower():find("rate") or
                           tostring(attrName):lower():find("rarity") then
                            obj:SetAttribute(attrName, 1.0) -- 100%
                        end
                    end
                end
            end)
            wait(2)
        end
    end)
    
    OxyX_RNG_Destroyer.Active = true
    print("[RNG] =========================================")
    print("[RNG] ✅ RNG DESTROYER AKTIF!")
    print("[RNG] Efek yang diterapkan:")
    print("[RNG]   1. math.random() → SELALU 0.999")
    print("[RNG]   2. Fishing → SELALU LEGENDARY")
    print("[RNG]   3. Currency → SELALU 999,999")
    print("[RNG]   4. Gacha → SELALU LEGENDARY ITEM")
    print("[RNG]   5. All probabilities → 100%")
    print("[RNG] =========================================")
    
    -- Efek visual konfirmasi
    local player = game.Players.LocalPlayer
    if player.Character then
        local head = player.Character:FindFirstChild("Head")
        if head then
            local sparkles = Instance.new("ParticleEmitter")
            sparkles.Texture = "rbxassetid://242019912"
            sparkles.Color = ColorSequence.new(
                Color3.fromRGB(255, 0, 0),   -- Merah
                Color3.fromRGB(0, 255, 0),   -- Hijau
                Color3.fromRGB(0, 0, 255)    -- Biru
            )
            sparkles.Parent = head
            game.Debris:AddItem(sparkles, 5)
        end
    end
end

-- 🔧 **FUNGSI RESTORE RNG**
local function RestoreRNG()
    if not OxyX_RNG_Destroyer.Active then return end
    
    print("[RNG] Mengembalikan sistem RNG ke normal...")
    
    -- Kembalikan math.random
    if OxyX_RNG_Destroyer.OriginalRandom then
        math.random = OxyX_RNG_Destroyer.OriginalRandom
        print("[RNG] ✅ math.random() restored")
    end
    
    -- Kembalikan Random.new
    if OxyX_RNG_Destroyer.Hooks.RandomNew then
        Random.new = OxyX_RNG_Destroyer.Hooks.RandomNew
        print("[RNG] ✅ Random.new() restored")
    end
    
    -- Hapus hook dari remote events
    for remoteName, remote in pairs(OxyX_RNG_Destroyer.Hooks) do
        if remote:IsA("RemoteEvent") then
            -- Reset ke fungsi asli (dengan asumsi kita simpan)
            -- Note: Ini simplified version
            remote.FireServer = nil -- Ini akan reset ke default
            print("[RNG] ✅ Hook removed from: " .. remoteName)
        end
    end
    
    OxyX_RNG_Destroyer.Active = false
    OxyX_RNG_Destroyer.Hooks = {}
    print("[RNG] Sistem RNG telah dipulihkan")
end

-- 🎮 **SIMPLE GUI**
local function CreateSimpleGUI()
    local player = game.Players.LocalPlayer
    local gui = Instance.new("ScreenGui")
    gui.Name = "OxyX_RNG_Destroyer_GUI"
    gui.Parent = player:WaitForChild("PlayerGui")
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 150)
    frame.Position = UDim2.new(0.5, -100, 0, 10)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
    frame.BorderSizePixel = 2
    frame.Active = true
    frame.Draggable = true
    frame.Parent = gui
    
    local title = Instance.new("TextLabel")
    title.Text = "RNG DESTROYER"
    title.Size = UDim2.new(1, 0, 0, 30)
    title.TextColor3 = Color3.fromRGB(255, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    title.Font = Enum.Font.GothamBlack
    title.Parent = frame
    
    local status = Instance.new("TextLabel")
    status.Text = "Status: INACTIVE"
    status.Size = UDim2.new(1, 0, 0, 20)
    status.Position = UDim2.new(0, 0, 0.25, 0)
    status.TextColor3 = Color3.fromRGB(255, 255, 0)
    status.BackgroundTransparency = 1
    status.Parent = frame
    
    local btnDestroy = Instance.new("TextButton")
    btnDestroy.Text = "💥 DESTROY RNG"
    btnDestroy.Size = UDim2.new(0.8, 0, 0, 30)
    btnDestroy.Position = UDim2.new(0.1, 0, 0.5, 0)
    btnDestroy.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    btnDestroy.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnDestroy.Parent = frame
    
    local btnRestore = Instance.new("TextButton")
    btnRestore.Text = "🔧 RESTORE RNG"
    btnRestore.Size = UDim2.new(0.8, 0, 0, 30)
    btnRestore.Position = UDim2.new(0.1, 0, 0.75, 0)
    btnRestore.BackgroundColor3 = Color3.fromRGB(50, 50, 255)
    btnRestore.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnRestore.Parent = frame
    
    btnDestroy.MouseButton1Click:Connect(function()
        DestroyRNG_Complete()
        status.Text = "Status: DESTROYED"
        status.TextColor3 = Color3.fromRGB(0, 255, 0)
    end)
    
    btnRestore.MouseButton1Click:Connect(function()
        RestoreRNG()
        status.Text = "Status: RESTORED"
        status.TextColor3 = Color3.fromRGB(255, 255, 0)
    end)
    
    -- Close button
    local btnClose = Instance.new("TextButton")
    btnClose.Text = "X"
    btnClose.Size = UDim2.new(0, 20, 0, 20)
    btnClose.Position = UDim2.new(1, -20, 0, 0)
    btnClose.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    btnClose.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnClose.Parent = frame
    btnClose.MouseButton1Click:Connect(function()
        gui.Enabled = not gui.Enabled
    end)
    
    return gui
end

-- 🚀 **AUTO-START**
wait(2) -- Tunggu game load

-- Cek apakah kita di game Fish It!
if game.PlaceId == OxyX_RNG_Destroyer.GameID then
    print("[AUTO] Fish It! terdeteksi, membuat GUI...")
    CreateSimpleGUI()
    
    -- Auto-destroy setelah 3 detik
    spawn(function()
        wait(3)
        print("[AUTO] Auto-destroying RNG in 3... 2... 1...")
        DestroyRNG_Complete()
    end)
else
    warn("[WARNING] Bukan di game Fish It!")
    warn("[WARNING] Script mungkin tidak bekerja optimal")
    CreateSimpleGUI() -- Buat GUI anyway
end

print("\n==========================================")
print("PERINTAH:")
print("  - Klik 'DESTROY RNG' untuk hancurkan")
print("  - Klik 'RESTORE RNG' untuk pulihkan")
print("==========================================")

-- Keep script alive
while true do
    if OxyX_RNG_Destroyer.Active then
        -- Periodically reinforce RNG destruction
        pcall(function()
            -- Ensure math.random stays overridden
            math.random = function(a, b)
                return b or a or 0.999
            end
        end)
    end
    wait(5)
end