--== GamePicker ==--

-- Список игр (можно по PlaceId или по GameId)
local Games = {
    [1234567890] = "https://pastebin.com/raw/AAA111", -- пример: Jailbreak
    [9876543210] = "https://pastebin.com/raw/BBB222", -- пример: Blox Fruits
    -- добавляй свои игры сюда
}

-- Универсальный скрипт (если игра не найдена)
local UniversalScript = "https://pastebin.com/raw/UNIVERSAL"

-- Определяем ID
local placeId = game.PlaceId
local gameId = game.GameId

-- Проверка по PlaceId > GameId > универсал
local ScriptURL = Games[placeId] or Games[gameId] or UniversalScript

-- Загружаем
loadstring(game:HttpGet(ScriptURL))()
