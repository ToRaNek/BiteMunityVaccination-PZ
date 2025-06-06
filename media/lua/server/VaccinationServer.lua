-- media/lua/server/VaccinationServer.lua
-- Gestion côté serveur du système de vaccination - Version BiteMunity compatible

VaccinationServer = VaccinationServer or {}

-- Gestionnaire de commandes client
function VaccinationServer.onClientCommand(module, command, player, args)
    if module ~= "VaccinationSystem" then return end
    if not isServer() then return end
    
    -- Vérifier que BiteMunity est disponible
    if not BiteMunityCore then
        print("[VaccinationSystem] ERREUR: BiteMunity n'est pas disponible sur le serveur!")
        return
    end
    
    if command == "VaccinationSuccess" then
        -- Un client signale une vaccination réussie
        if args and args.patientID then
            local patientID = args.patientID
            local targetPlayer = VaccinationServer.getPlayerByID(patientID)
            
            if targetPlayer then
                -- Utiliser BiteMunity pour accorder l'immunité permanente
                BiteMunityCore.setPlayerPermanentImmunity(targetPlayer, true)
                
                -- Diffuser à tous les clients pour synchronisation
                sendServerCommand("VaccinationSystem", "VaccinationSuccess", {
                    patientID = patientID
                })
                
                print("[VaccinationSystem] Vaccination réussie pour le joueur " .. patientID .. " - Immunité accordée via BiteMunity")
            end
            
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
                -- Vérifier que le donneur est immunisé via BiteMunity
                if BiteMunityCore.isPlayerPermanentlyImmune(donor) then
                    VaccinationCore.extractBlood(donor, extractor)
                    print("[VaccinationSystem] Extraction de sang: " .. donorID .. " -> " .. extractorID)
                else
                    print("[VaccinationSystem] Extraction refusée: le donneur " .. donorID .. " n'est pas immunisé BiteMunity")
                end
            end
        end
    elseif command == "SyncImmunity" then
        -- Synchronisation de l'immunité entre clients (délégué à BiteMunity)
        if args and args.playerID and args.immune ~= nil then
            local targetPlayer = VaccinationServer.getPlayerByID(args.playerID)
            if targetPlayer then
                BiteMunityCore.setPlayerPermanentImmunity(targetPlayer, args.immune)
                
                -- Laisser BiteMunity gérer sa propre synchronisation
                print("[VaccinationSystem] Synchronisation immunité via BiteMunity pour joueur " .. args.playerID)
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
    
    print("[VaccinationSystem] Sauvegarde périodique effectuée")
end

-- Chargement des données à la connexion
function VaccinationServer.onPlayerConnect(player)
    if not isServer() then return end
    if not player then return end
    
    -- Vérifier que BiteMunity est disponible
    if not BiteMunityCore then
        print("[VaccinationSystem] ERREUR: BiteMunity non disponible lors de la connexion du joueur")
        return
    end
    
    -- Charger les données de vaccination
    VaccinationCore.loadData(player)
    
    -- Synchroniser avec le statut BiteMunity
    local playerID = tostring(player:getOnlineID())
    local isImmune = BiteMunityCore.isPlayerPermanentlyImmune(player)
    
    print("[VaccinationSystem] Joueur connecté: " .. playerID .. " (Immunité BiteMunity: " .. tostring(isImmune) .. ")")
end

-- Sauvegarde des données à la déconnexion
function VaccinationServer.onPlayerDisconnect(player)
    if not isServer() then return end
    if not player then return end
    
    -- Sauvegarder les données de vaccination
    VaccinationCore.saveData(player)
    
    local playerID = tostring(player:getOnlineID())
    print("[VaccinationSystem] Joueur déconnecté: " .. playerID)
end

-- Nettoyage périodique des cooldowns expirés
function VaccinationServer.cleanupExpiredCooldowns()
    if not isServer() then return end
    
    local currentTime = VaccinationConfig.getGameTimeHours()
    local cleanedBlood = 0
    local cleanedVaccination = 0
    
    -- Nettoyer les cooldowns d'extraction de sang expirés
    local toRemoveBlood = {}
    for playerID, lastExtraction in pairs(VaccinationCore.bloodExtractionCooldowns) do
        if (currentTime - lastExtraction) > VaccinationConfig.BLOOD_EXTRACTION_COOLDOWN then
            table.insert(toRemoveBlood, playerID)
        end
    end
    for _, playerID in ipairs(toRemoveBlood) do
        VaccinationCore.bloodExtractionCooldowns[playerID] = nil
        cleanedBlood = cleanedBlood + 1
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
        cleanedVaccination = cleanedVaccination + 1
    end
    
    if cleanedBlood > 0 or cleanedVaccination > 0 then
        print("[VaccinationSystem] Nettoyage des cooldowns: " .. cleanedBlood .. " extractions, " .. cleanedVaccination .. " vaccinations")
    end
end

-- Vérification de l'intégrité avec BiteMunity
function VaccinationServer.validateBiteMunityIntegration()
    if not isServer() then return end
    
    if not BiteMunityCore then
        print("[VaccinationSystem] ATTENTION: BiteMunity n'est pas chargé! Le système de vaccination ne fonctionnera pas correctement.")
        return
    end
    
    -- Vérifier les joueurs connectés et leurs statuts d'immunité
    local players = getOnlinePlayers()
    if not players then return end
    
    local immuneCount = 0
    local totalCount = 0
    
    for i = 0, players:size() - 1 do
        local player = players:get(i)
        if player then
            totalCount = totalCount + 1
            if BiteMunityCore.isPlayerPermanentlyImmune(player) then
                immuneCount = immuneCount + 1
            end
        end
    end
    
    print("[VaccinationSystem] Validation BiteMunity: " .. immuneCount .. "/" .. totalCount .. " joueurs immunisés")
end

-- Fonction d'initialisation du serveur
function VaccinationServer.init()
    if not isServer() then return end
    
    -- Vérifier que BiteMunity est disponible
    if not BiteMunityCore then
        print("[VaccinationSystem] ERREUR CRITIQUE: Le mod BiteMunity n'est pas chargé!")
        print("[VaccinationSystem] Le système de vaccination ne peut pas fonctionner sans BiteMunity.")
        print("[VaccinationSystem] Assurez-vous que BiteMunity est installé et activé AVANT BiteMunityVaccination.")
        return
    end
    
    Events.OnClientCommand.Add(VaccinationServer.onClientCommand)
    Events.OnPlayerConnect.Add(VaccinationServer.onPlayerConnect)
    Events.OnPlayerDisconnect.Add(VaccinationServer.onPlayerDisconnect)
    Events.EveryTenMinutes.Add(VaccinationServer.saveAllPlayerData)
    Events.EveryHour.Add(VaccinationServer.cleanupExpiredCooldowns)
    Events.EveryDay.Add(VaccinationServer.validateBiteMunityIntegration)
    
    print("[VaccinationSystem] Server initialized successfully with BiteMunity integration")
end

-- Initialiser le serveur
Events.OnGameStart.Add(VaccinationServer.init)