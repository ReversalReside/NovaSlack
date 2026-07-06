local HttpService = game:GetService("HttpService")

-- Получаем ID текущего плейса
local placeId = game.PlaceId

-- URL репозитория (замените на ваш репозиторий)
local repoUrl = "https://raw.githubusercontent.com/ReversalReside/your-repo/main/GamesList.json"

local success, result = pcall(function()
    return HttpService:GetAsync(repoUrl)
end)

if success then
    local gamesList = HttpService:JSONDecode(result)
    
    local foundGame = false
    
    for _, game in ipairs(gamesList) do
        if game.placeId == placeId then
            foundGame = true
            
            -- Загружаем и выполняем скрипт для этой игры
            local scriptUrl = game.scriptUrl
            local scriptSuccess, scriptResult = pcall(function()
                return HttpService:GetAsync(scriptUrl)
            end)
            
            if scriptSuccess then
                loadstring(scriptResult)()
            else
                warn("Ошибка загрузки скрипта для игры с Place ID: " .. placeId)
            end
            
            break
        end
    end
    
    if not foundGame then
        print("Игра не найдена в GamesList.json. Place ID: " .. placeId)
    end
else
    warn("Ошибка загрузки GamesList.json: " .. tostring(result))
    print("Не удалось проверить список игр. Place ID: " .. placeId)
end
