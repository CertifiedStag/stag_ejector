local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('ejector:removeButton')
AddEventHandler('ejector:removeButton', function() 
     local Player = QBCore.Functions.GetPlayer(source) 
     if not Player then return end 
  
     Player.Functions.RemoveItem('ejectbutton', 1) 
end)

RegisterNetEvent('ejector:server:Passengerkick')
AddEventHandler('ejector:server:Passengerkick', function(PassengerId) 
    local id = PassengerId
    print(id)
    TriggerClientEvent("ejector:client:Passengerkick", id, source)
end)

RegisterNetEvent('ejector:server:driverEnable')
AddEventHandler('ejector:server:driverEnable', function(DriverId) 
    local id = DriverId
    TriggerClientEvent("ejector:client:driverEnable", id)
end)

