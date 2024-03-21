# 📚 Garry's Mod Data Storages

[Data Storages](https://javascript.info/localstorage) like in JavaScript.

Example:

```lua
store:New("localStorage") -- creates localStorage table in lua global table

localStorage.test_key = 666 -- set value to localStorage, and this value will be save in SQLite gmod database

print(localStorage.test_key) -- checks that the value has been stored in the table
```