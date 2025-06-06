-- VaccinationServer.lua
-- Gestion côté serveur du système de vaccination

-- Import des modules partagés (sans require car ils sont chargés directement)
-- VaccinationCore et VaccinationConfig sont chargés automatiquement

VaccinationServer = VaccinationServer or {}

-- Gestionnaire de commandes client
function VaccinationServer.onClientCommand(module, command, player, args)
    if module ~= "VaccinationSystem" then return end
    if not isServer() then return end
    
    if command == "VaccinationSuccess" then
        -- Un client signale une vaccination réussie
        if args and args.patientID then
            local patientID = args.patientID
            
            -- Diffuser à tous les clients pour synchronisation
            sendServerCommand("VaccinationSystem", "VaccinationSuccess", {
                patientID = patientID
            })
            
            -- Sauvegarder les données
            if player then
                VaccinationCore.saveData(player)
            end
        end
    elseif command == "ExtractBlood" then
        -- Traitement de l'extraction de sang côté serveur
        if args and args.donorID and args.extractorID then
            local donorID = args.donorID
            local extractorID = args.extractorID
            
            -- Trouver les joueurs
            local donor = VaccinationServer.getPlayerByID(donorID)
            local extractor = VaccinationServer.getPlayerByID(extractorID)
            
            if donor and extractor then
                VaccinationCore.extractBlood(donor, extractor)
            end
        end
    end
end

-- Fonction pour trouver un joueur par ID
function VaccinationServer.getPlayerByID(playerID)
    if not playerID then return nil end
    
    local players = getOnlinePlayers()
    if not players then return nil end
    
    for i = 0, players:size() - 1 do
        local player = players:get(i)
        if player and tostring(player:getOnlineID()) == playerID then
            return player
        end
    end
    return nil
end

-- Sauvegarde périodique des données
function VaccinationServer.saveAllPlayerData()
    if not isServer() then return end
    
    local players = getOnlinePlayers()
    if not players then return end
    
    for i = 0, players:size() - 1 do
        local player = players:get(i)
        if player then
            VaccinationCore.saveData(player)
        end
    end
end

-- Chargement des données à la connexion
function VaccinationServer.onPlayerConnect(player)
    if not isServer() then return end
    if not player then return end
    
    -- Charger les données de vaccination
    VaccinationCore.loadData(player)
end

-- Sauvegarde des données à la déconnexion
function VaccinationServer.onPlayerDisconnect(player)
    if not isServer() then return end
    if not player then return end
    
    -- Sauvegarder les données de vaccination
    VaccinationCore.saveData(player)
end

-- Nettoyage périodique des cooldowns expirés
function VaccinationServer.cleanupExpiredCooldowns()
    if not isServer() then return end
    
    local currentTime = VaccinationConfig.getGameTimeHours()
    
    -- Nettoyer les cooldowns d'extraction de sang expirés
    local toRemoveBlood = {}
    for playerID, lastExtraction in pairs(VaccinationCore.bloodExtractionCooldowns) do
        if (currentTime - lastExtraction) > VaccinationConfig.BLOOD_EXTRACTION_COOLDOWN then
            table.insert(toRemoveBlood, playerID)
        end
    end
    for _, playerID in ipairs(toRemoveBlood) do
        VaccinationCore.bloodExtractionCooldowns[playerID] = nil
    end
    
    -- Nettoyer les cooldowns de vaccination expirés
    local toRemoveVaccination = {}
    for playerID, lastVaccination in pairs(VaccinationCore.vaccinationCooldowns) do
        if (currentTime - lastVaccination) > VaccinationConfig.VACCINATION_COOLDOWN then
            table.insert(toRemoveVaccination, playerID)
        end
    end
    for _, playerID in ipairs(toRemoveVaccination) do
        VaccinationCore.vaccinationCooldowns[playerID] = nil
    end
end

-- Fonction d'initialisation du serveur
function VaccinationServer.init()
    if not isServer() then return end
    
    Events.OnClientCommand.Add(VaccinationServer.onClientCommand)
    Events.OnPlayerConnect.Add(VaccinationServer.onPlayerConnect)
    Events.OnPlayerDisconnect.Add(VaccinationServer.onPlayerDisconnect)
    Events.EveryTenMinutes.Add(VaccinationServer.saveAllPlayerData)
    Events.EveryHour.Add(VaccinationServer.cleanupExpiredCooldowns)
    
    print("[VaccinationSystem] Server initialized")
end

-- Initialiser le serveur
Events.OnGameStart.Add(VaccinationServer.init)