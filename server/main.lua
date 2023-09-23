local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('ejector:removeButton', function() 
     local Player = QBCore.Functions.GetPlayer(source) 
     if not Player then return end 
  
     Player.Functions.RemoveItem('ejectbutton', 1) 
 end)