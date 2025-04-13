Config = {}

-- Configuration générale
Config.EnableBlips = true
Config.EnableJobBlips = true
Config.JobName = 'parkranger'

-- Armurerie
Config.Armurerie = {
    Position = {x = -1861.7316894531, y = 7307.3852539062, z = 60.568881988525},
    Armes = {
        {name = 'weapon_nightstick', label = 'Matraque', price = 0},
        {name = 'weapon_combatpistol', label = 'Pistolet de combat', price = 0},
        {name = 'weapon_pumpshotgun', label = 'Fusil à pompe', price = 0},
        {name = 'weapon_sniperrifle', label = 'Fusil de précision', price = 0}
    }
}

-- Garage
Config.Garage = {
    Position = {x = -1864.7668457031, y = 7305.8525390625, z = 60.075439453125},
    SpawnPoint = {x = -1868.2303466797, y = 7308.1889648438, z = 59.89673614502, h = 88.2},
    DeletePoint = {x = -1868.0876464844, y = 7312.6420898438, z = 59.931224822998},
    Blip = {
        Enable = true,
        Sprite = 357,
        Color = 49,
        Scale = 0.8,
        Name = "Garage Park Ranger"
    },
    Vehicules = {
        {model = 'roxsandkparkr', label = 'Park Ranger PickUp', price = 0},
        {model = 'prangerbison', label = 'Pickup2-Ranger', price = 0}
    }
}

-- Vestiaire (optionnel)
Config.LockerRoom = {
    Position = {x = -1863.5213623047, y = 7294.0512695312, z = 60.119201660156},
    Blip = {
        Enable = true,
        Sprite = 366,
        Color = 25,
        Scale = 0.8,
        Name = "Vestiaire Park Ranger"
    }
}