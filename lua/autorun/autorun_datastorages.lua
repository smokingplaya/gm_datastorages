/*
    Garry's Mod Data Storages
        coded by smokingplaya<3 2024

    repo: https://github.com/smokingplaya/gmod_data_storages
    license: GPL-3.0 license (https://github.com/smokingplaya/gmod_data_storages/blob/main/LICENSE)
*/

local query = sql.Query

local store_mt = {}
store_mt.__index = store_mt

store = {}
store.list = {}

function store:New(name)
    if store.list[name] then
        return store.list[name]
    end

    if _G[name] then
        return _G[name]
    end

    local storage = {type = name}

    local tabName = SQLStr("storage_data_" .. name)

    query("CREATE TABLE IF NOT EXISTS " .. tabName .. "(key TEXT, value TEXT)")

    local existData = query("SELECT * FROM " .. tabName)

    local data = existData and existData[1]
    if data then
        for i=0, #data do
            storage[data.key] = data.value
        end
    end

    setmetatable(storage, store_mt)

    _G[name] = storage
    store.list[name] = storage

    return storage
end

function store_mt:__newindex(k, v)
    local db_name = SQLStr("storage_data_" .. self.type)

    rawset(self, k, v) /* Добавляем значение в таблицу */

    local data = query("SELECT * FROM " .. db_name .. " WHERE key = '" .. k .. "';")
    local valueSafe, keySafe = SQLStr(v), SQLStr(k)

    query(data and "UPDATE " .. db_name .. " SET value=" .. valueSafe .. " WHERE key=" .. keySafe .. ";" or "INSERT INTO " .. db_name .. " VALUES(" .. keySafe .. "," .. valueSafe .. ");")
end