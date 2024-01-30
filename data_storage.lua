local store_mt = {}
store_mt.__index = store_mt
 
store = {}
store.list = {}
function store:New(name)
    if store.list[name] then return store.list[name] end
 
    local storage = {type = name}
 
    setmetatable(storage, store_mt)
 
    _G[name] = storage
    store.list[name] = storage
 
    return storage
end
 
-- mt methods
 
local db_query = sql and sql.Query
 
function store_mt:__newindex(k, v)
    local db_name = "storage_data_" .. self.type
 
    rawset(self, k, v)
 
    if not db_query then print("Query function is not defined! The data hasn't been saved to the database.") return end
 
    local data = db_query("SELECT * FROM " .. db_name .. " WHERE key = '" .. k .. "';")
 
    db_query(data and "UPDATE " .. db_name .. " SET value = '" .. v .. "' WHERE key = '" .. k .. "';" or "INSERT INTO " .. db_name .. "(key, value) VALUES('" .. k .. "', '" .. v .. "');")
end
 
-- test
 
store:New("localstorage")
localstorage.test_key = 666
print(localstorage.test_key)
