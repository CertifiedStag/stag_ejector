local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('ejector:removeButton')
AddEventHandler('ejector:removeButton', function(whatbutton) 
     local Player = QBCore.Functions.GetPlayer(source) 
    if not Player then return end 
    if whatbutton == "0" then
        Player.Functions.RemoveItem('ejectbutton', 1) 
    elseif whatbutton == "1" then
        Player.Functions.RemoveItem('ejectbuttonpassenger', 1) 
    else 
        print("hacker id: "..  source .." hacker name: ".. Player.PlayerData.name .." hacker license: ".. Player.PlayerData.license)
    end
end)

RegisterNetEvent('ejector:server:Passengerkick')
AddEventHandler('ejector:server:Passengerkick', function(PassengerId) 
    local id = PassengerId
    TriggerClientEvent("ejector:client:Passengerkick", id, source)
end)

RegisterNetEvent('ejector:server:driverEnable')
AddEventHandler('ejector:server:driverEnable', function(DriverId) 
    local id = DriverId
    TriggerClientEvent("ejector:client:driverEnable", id)
end)



QBCore.Functions.CreateUseableItem("ejectbutton", function(source, item)
    if not source then return end
    if not item then return end
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end 
    
    if Player.Functions.RemoveItem(item.name, 1) then
        Player.Functions.AddItem(item.name, 1)
        TriggerClientEvent("ejector:client:driver", source)
    end
end)


QBCore.Functions.CreateUseableItem("ejectbuttonpassenger", function(source, item)
    if not source then return end
    if not item then return end
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end 

    if Player.Functions.RemoveItem(item.name, 1) then
        Player.Functions.AddItem(item.name, 1)
        TriggerClientEvent("ejector:client:passenger", source)
    end
end)