ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Gestion des menottes
RegisterServerEvent('esx_parkrangerjob:handcuff')
AddEventHandler('esx_parkrangerjob:handcuff', function(target)
    TriggerClientEvent('esx_parkrangerjob:handcuff', target)
end)

-- Gestion de l'escorte
RegisterServerEvent('esx_parkrangerjob:drag')
AddEventHandler('esx_parkrangerjob:drag', function(target)
    local _source = source
    TriggerClientEvent('esx_parkrangerjob:drag', target, _source)
end)

-- Mettre dans véhicule
RegisterServerEvent('esx_parkrangerjob:putInVehicle')
AddEventHandler('esx_parkrangerjob:putInVehicle', function(target)
    TriggerClientEvent('esx_parkrangerjob:putInVehicle', target)
end)

-- Sortir du véhicule
RegisterServerEvent('esx_parkrangerjob:OutVehicle')
AddEventHandler('esx_parkrangerjob:OutVehicle', function(target)
    TriggerClientEvent('esx_parkrangerjob:OutVehicle', target)
end)

-- Confiscation d'items
RegisterServerEvent('esx_parkrangerjob:confiscatePlayerItem')
AddEventHandler('esx_parkrangerjob:confiscatePlayerItem', function(target, itemType, itemName)
    local _source = source
    local sourceXPlayer = ESX.GetPlayerFromId(_source)
    local targetXPlayer = ESX.GetPlayerFromId(target)

    if itemType == 'item_standard' then
        local item = targetXPlayer.getInventoryItem(itemName)
        targetXPlayer.removeInventoryItem(itemName, item.count)
        sourceXPlayer.addInventoryItem(itemName, item.count)
        TriggerClientEvent('esx:showNotification', _source, "Vous avez confisqué ~b~"..item.count..' '..item.label.."~s~.")
        TriggerClientEvent('esx:showNotification', target, "Quelqu'un vous a pris ~b~"..item.count..' '..item.label.."~s~.")
    elseif itemType == 'item_account' then
        targetXPlayer.removeAccountMoney(itemName, amount)
        sourceXPlayer.addAccountMoney(itemName, amount)
    elseif itemType == 'item_weapon' then
        targetXPlayer.removeWeapon(itemName)
        sourceXPlayer.addWeapon(itemName, 0)
        TriggerClientEvent('esx:showNotification', _source, "Vous avez confisqué ~b~"..ESX.GetWeaponLabel(itemName).."~s~.")
        TriggerClientEvent('esx:showNotification', target, "Quelqu'un vous a pris ~b~"..ESX.GetWeaponLabel(itemName).."~s~.")
    end
end)

-- Callback pour les données joueur
ESX.RegisterServerCallback('esx_parkrangerjob:getOtherPlayerData', function(source, cb, target)
    local xPlayer = ESX.GetPlayerFromId(target)

    if xPlayer then
        local data = {
            name = xPlayer.getName(),
            job = xPlayer.job.label,
            inventory = xPlayer.getInventory(),
            accounts = xPlayer.getAccounts(),
            weapons = xPlayer.getLoadout()
        }

        cb(data)
    end
end)

RegisterServerEvent('esx_parkrangerjob:giveWeapon')
AddEventHandler('esx_parkrangerjob:giveWeapon', function(weaponName, weaponLabel)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer.job.name == 'parkranger' then
        -- Pour ox_inventory
        if exports.ox_inventory:CanCarryItem(source, weaponName, 1) then
            exports.ox_inventory:AddItem(source, weaponName, 1)
            TriggerClientEvent('esx:showNotification', source, "Vous avez reçu: "..weaponLabel)
        else
            TriggerClientEvent('esx:showNotification', source, "Vous n'avez pas assez de place")
        end
    else
        print(('esx_parkrangerjob: %s a tenté de prendre une arme illégalement!'):format(xPlayer.identifier))
        DropPlayer(source, 'Tentative d\'exploitation')
    end
end)