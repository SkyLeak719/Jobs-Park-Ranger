local parkRangerMenu = false
local isParkRanger = false
local ESX = nil

-- Initialisation ESX
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(100)
    end

    -- Vérification régulière du job
    while true do
        Citizen.Wait(5000)
        local playerData = ESX.GetPlayerData()
        isParkRanger = (playerData.job and playerData.job.name == 'parkranger')
    end
end)

-- Fonction pour ouvrir le menu de l'armurerie
function OpenArmoryMenu()
    local elements = {}

    for i=1, #Config.Armurerie.Armes do
        local weapon = Config.Armurerie.Armes[i]
        table.insert(elements, {
            label = ('%s - <span style="color:green;">%s</span>'):format(weapon.label, 'Gratuit'),
            value = weapon.name,
            name = weapon.name,
            labelReal = weapon.label
        })
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory', {
        title    = 'Armurerie Park Ranger',
        align    = 'top-left',
        elements = elements
    }, function(data, menu)
        menu.close()
        TriggerServerEvent('esx_parkrangerjob:giveWeapon', data.current.value, data.current.labelReal)
    end, function(data, menu)
        menu.close()
    end)
end

-- Fonction pour ouvrir le menu du garage
function OpenGarageMenu()
    local elements = {}

    for i=1, #Config.Garage.Vehicules do
        local vehicle = Config.Garage.Vehicules[i]
        table.insert(elements, {
            label = ('%s - <span style="color:green;">%s</span>'):format(vehicle.label, 'Gratuit'),
            value = vehicle.model
        })
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'garage', {
        title    = 'Garage Park Ranger',
        align    = 'top-left',
        elements = elements
    }, function(data, menu)
        menu.close()
        SpawnVehicle(data.current.value)
    end, function(data, menu)
        menu.close()
    end)
end

-- Fonction pour faire apparaître un véhicule
function SpawnVehicle(model)
    local spawnPoint = Config.Garage.SpawnPoint
    ESX.Game.SpawnVehicle(model, vector3(spawnPoint.x, spawnPoint.y, spawnPoint.z), spawnPoint.h, function(vehicle)
        local playerPed = PlayerPedId()
        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
        SetVehicleLivery(vehicle, 0)
    end)
end

-- Thread combiné pour tous les marqueurs
Citizen.CreateThread(function()
    local markers = {
        { -- Garage
            pos = vector3(-1865.2216796875, 7305.6865234375, 60.065090179443),
            text = "Garage Park Ranger",
            color = {0, 255, 0}, -- Vert
            action = function()
                if isParkRanger then
                    OpenGarageMenu()
                else
                    ESX.ShowNotification("Vous n'êtes pas un Park Ranger!")
                end
            end
        },
        { -- Armurerie
            pos = vector3(-1861.5867919922, 7307.0024414062, 60.568912506104),
            text = "Armurerie Park Ranger",
            color = {255, 0, 0}, -- Rouge
            action = function()
                if isParkRanger then
                    OpenArmoryMenu()
                else
                    ESX.ShowNotification("Vous n'êtes pas un Park Ranger!")
                end
            end
        }
    }

    while true do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())

        if isParkRanger then
            for _, marker in ipairs(markers) do
                local distance = #(playerCoords - marker.pos)

                if distance < 7.0 then
                    -- Dessin du marqueur
                    DrawMarker(
                        23, -- Type sphère
                        marker.pos.x, marker.pos.y, marker.pos.z - 0.97,
                        0.0, 0.0, 0.0,
                        0.0, 0.0, 0.0,
                        1.5, 1.5, 1.5,
                        marker.color[1], marker.color[2], marker.color[3], 100,
                        false, true, 2, false, nil, nil, false
                    )

                    -- Texte 3D
                    if distance < 7.0 then
                        ESX.Game.Utils.DrawText3D(
                            vector3(marker.pos.x, marker.pos.y, marker.pos.z + 0.5), 
                            marker.text, 
                            0.6
                        )
                    end

                    -- Interaction
                    if distance < 1.5 then
                        ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour interagir")
                        if IsControlJustReleased(0, 38) then -- Touche E
                            marker.action()
                        end
                    end
                end
            end
        end
    end
end)

-- Menu F6 uniquement
Citizen.CreateThread(function()
    local lastPress = 0
    while true do
        Citizen.Wait(0)
        
        if isParkRanger then
            if IsControlJustPressed(0, 167) then -- 167 = F6 uniquement
                local currentTime = GetGameTimer()
                if currentTime - lastPress > 200 then -- Anti-spam 200ms
                    lastPress = currentTime
                    OpenParkRangerMenu()
                end
            end
        end
    end
end)

-- Fonction pour ouvrir le menu principal
function OpenParkRangerMenu()
    ESX.UI.Menu.CloseAll()

    local elements = {
        {label = 'Actions Ranger', value = 'ranger_actions'},
        {label = 'Gestion Véhicule', value = 'vehicle_menu'},
        {label = 'Facturation', value = 'billing'}
    }

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'park_ranger_main', {
        title    = 'Menu Park Ranger',
        align    = 'top-left',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'ranger_actions' then
            OpenRangerActionsMenu()
        elseif data.current.value == 'vehicle_menu' then
            OpenVehicleMenu()
        elseif data.current.value == 'billing' then
            OpenBillingMenu()
        end
    end, function(data, menu)
        menu.close()
    end)
end