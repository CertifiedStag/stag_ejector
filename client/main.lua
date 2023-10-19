local QBCore = exports['qb-core']:GetCoreObject()
local version = "3.0"
print("[EjectorSeat] Script v" .. version .. " loaded.")

local ejectorSeatActive = false
local canEject = true

RegisterNetEvent("ejector:client:driver")
AddEventHandler("ejector:client:driver", function()
    if not Config.EnableEjectorSeat then
        return
    end

    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if DoesEntityExist(vehicle) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
        TriggerServerEvent('ejector:removeButton', "0")

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
end)


RegisterNetEvent("ejector:client:passenger")
AddEventHandler("ejector:client:passenger", function()
    if not Config.EnableEjectorSeat then
        return
    end 

    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if DoesEntityExist(vehicle) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
        if not IsVehicleSeatFree(vehicle, 0) then
            if not ejectorSeatActive then
                TriggerServerEvent('ejector:removeButton', "1")
                ejectorSeatActive = true
                local passengerPed = GetPedInVehicleSeat(vehicle, 0)
                local passengerId = GetPlayerFromIndex(NetworkGetPlayerIndexFromPed(passengerPed))
                TriggerServerEvent('ejector:server:Passengerkick', passengerId)
            end
        end
    else
        QBCore.Functions.Notify("You must be the driver of a vehicle to use the ejector seat.", "error")
    end

end)

RegisterNetEvent("ejector:client:Passengerkick")
AddEventHandler("ejector:client:Passengerkick", function(DriverId)

    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

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

    canEject = false
    Citizen.SetTimeout(Config.EjectCooldown * 1000, function()
        canEject = true
    end)

    QBCore.Functions.Notify("Ejected from the vehicle.", "success")
    TriggerServerEvent("ejector:server:driverEnable", DriverId)

end)


RegisterNetEvent("ejector:client:driverEnable")
AddEventHandler("ejector:client:driverEnable", function()
    ejectorSeatActive = false
end)