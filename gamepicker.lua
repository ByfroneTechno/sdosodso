--== GamePicker ==--

-- Список игр (можно по PlaceId или по GameId)
local Games = {
    [94647229517154] = "https://raw.githubusercontent.com/ByfroneTechno/sdosodso/refs/heads/main/Azure-Latch.lua", -- пример: Jailbreak
    [9876543210] = "https://pastebin.com/raw/BBB222", -- пример: Blox Fruits
    -- добавляй свои игры сюда
}

-- Универсальный скрипт (если игра не найдена)
local UniversalScript = "https://raw.githubusercontent.com/ByfroneTechno/sdosodso/refs/heads/main/Universal.lua"

-- Определяем ID
local placeId = game.PlaceId
local gameId = game.GameId

-- Проверка по PlaceId > GameId > универсал
local ScriptURL = Games[placeId] or Games[gameId] or UniversalScript

-- Загружаем
loadstring(game:HttpGet(ScriptURL))()
