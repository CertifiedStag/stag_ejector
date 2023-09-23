local QBCore = exports['qb-core']:GetCoreObject()
local version = "2.0"
print("[EjectorSeat] Script v" .. version .. " loaded.")

local ejectorSeatActive = false
local canEject = true

RegisterKeyMapping("eject", "Eject From Vehicle", "keyboard", "C")
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if
        IsControlJustReleased(0, Config.KeyToTriggerEject) then
            TriggerEvent("eject")
        end
    end
end)

RegisterCommand("eject", function()
    if not Config.EnableEjectorSeat then
        return
    end

    if QBCore.Functions.HasItem("ejectbutton") then
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)

        TriggerServerEvent('ejector:removeButton')

        if vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == playerPed then
            if not ejectorSeatActive then
                ejectorSeatActive = true
                local playerCoords = GetEntityCoords(playerPed)
                local forwardVector = GetEntityForwardVector(vehicle)
                local ejectPosition = playerCoords + vector3(0.0, 0.0, 0.0) + forwardVector * Config.EjectionDistanceMultiplier

                local forceMagnitude = 100 -- Adjust the force value as needed

                local ejectPos = playerCoords + vector3(0.0, 0.0, 0.0) + forwardVector * 3.0
                SetEntityCoordsNoOffset(playerPed, playerCoords.x, playerCoords.y, playerCoords.z + 3, true, true, true)
                SetEntityCollision(playerPed, true, true)
                AddExplosion(0, 0, 0, 32, 0, true, false, 100)
                SetEntityHasGravity(playerPed, false)
                SetPedToRagdoll(playerPed, 1000, 1000, 0, 0, 0, 0)
                SetEntityVelocity(playerPed, 30, 30, 30.0)
               ejectorSeatActive = false

                TaskParachute(playerPed, true)
               TriggerServerEvent('ejector:removeButton')

                canEject = false
                Citizen.SetTimeout(Config.EjectCooldown * 1000, function()
                    canEject = true
                end)
    
                QBCore.Functions.Notify("Ejected from the vehicle.", "success")
            else
                QBCore.Functions.Notify("Ejector seat is already active.", "error")
            end
        else
            QBCore.Functions.Notify("You must be the driver of a vehicle to use the ejector seat.", "error")
        end
    else
        QBCore.Functions.Notify("You must have an ejector seat fitted to eject.", "error")
    end
end)

