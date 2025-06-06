-- media/lua/client/VaccinationClient.lua
-- Gestion côté client du système de vaccination - Version BiteMunity compatible

VaccinationClient = VaccinationClient or {}

-- Fonction pour extraire du sang (menu contextuel)
function VaccinationClient.extractBlood(playerObj, targetPlayer)
    if playerObj == getSpecificPlayer(0) then
        VaccinationCore.extractBlood(targetPlayer, playerObj)
    end
end

-- Fonction pour administrer un vaccin (menu contextuel)
function VaccinationClient.administerVaccine(doctorObj, patientPlayer)
    if doctorObj == getSpecificPlayer(0) then
        local inventory = doctorObj:getInventory()
        local vaccine = inventory:getFirstTypeRecurse("BiteMunityVaccination.AntiZombieVaccine")
        
        if vaccine then
            VaccinationCore.administerVaccine(patientPlayer, doctorObj, vaccine)
        else
            doctorObj:Say("Je n'ai pas de vaccin sur moi.")
        end
    end
end

-- Fonction pour permettre au joueur de s'extraire du sang à lui-même
function VaccinationClient.extractOwnBlood(player)
    if player == getSpecificPlayer(0) then
        VaccinationCore.extractBlood(player, player)
    end
end

-- Fonction pour centrifuger le sang (menu contextuel sur l'item)
function VaccinationClient.centrifugeBlood(player, bloodItem)
    local inventory = player:getInventory()
    local centrifuge = inventory:getFirstTypeRecurse("BiteMunityVaccination.Centrifuge")
    
    if not centrifuge then
        player:Say("J'ai besoin d'une centrifugeuse.")
        return
    end
    
    if VaccinationCore.checkItemExpiry(bloodItem) then
        player:Say(VaccinationConfig.MESSAGES.EXPIRED_BLOOD)
        inventory:DoRemoveItem(bloodItem)
        return
    end
    
    ISTimedActionQueue.add(ISCentrifugeAction:new(player, bloodItem, centrifuge))
end

-- Fonction pour purifier le sérum (menu contextuel sur l'item)
function VaccinationClient.purifySerum(player, serumItem)
    local inventory = player:getInventory()
    local microscope = inventory:getFirstTypeRecurse("BiteMunityVaccination.LabMicroscope")
    local chemicals = inventory:getFirstTypeRecurse("BiteMunityVaccination.ChemicalReagents")
    
    if not microscope then
        player:Say("J'ai besoin d'un microscope de laboratoire.")
        return
    end
    
    if not chemicals then
        player:Say("J'ai besoin de produits chimiques.")
        return
    end
    
    if VaccinationCore.checkItemExpiry(serumItem) then
        player:Say(VaccinationConfig.MESSAGES.EXPIRED_SERUM)
        inventory:DoRemoveItem(serumItem)
        return
    end
    
    ISTimedActionQueue.add(ISPurificationAction:new(player, serumItem, microscope, chemicals))
end

-- Gestionnaire de menu contextuel pour les joueurs - VERSION BITEMUNITY
function VaccinationClient.onFillWorldObjectContextMenu(playerNum, context, worldObjects, test)
    if test then return end
    
    local player = getSpecificPlayer(playerNum)
    if not player then return end
    
    -- Vérifier si BiteMunity est chargé
    if not BiteMunityCore then
        print("[VaccinationSystem] ERREUR: BiteMunity n'est pas chargé!")
        return
    end
    
    -- Vérifier si le joueur peut s'extraire du sang à lui-même
    local canExtractSelf, _ = VaccinationCore.canExtractBlood(player, player)
    if canExtractSelf and BiteMunityCore.isPlayerPermanentlyImmune(player) then
        context:addOption("M'extraire du sang", player, VaccinationClient.extractOwnBlood)
    end
    
    -- Chercher d'autres joueurs dans la zone
    for i = 0, getNumActivePlayers() - 1 do
        local otherPlayer = getSpecificPlayer(i)
        if otherPlayer and otherPlayer ~= player then
            -- Vérifier la distance (2 cases maximum)
            local distance = math.abs(otherPlayer:getX() - player:getX()) + 
                           math.abs(otherPlayer:getY() - player:getY())
            
            if distance <= 2 and otherPlayer:getZ() == player:getZ() then
                local targetName = otherPlayer:getDisplayName() or "Joueur"
                
                -- Vérifier si on peut extraire du sang de ce joueur (doit être immunisé BiteMunity)
                local canExtract, _ = VaccinationCore.canExtractBlood(otherPlayer, player)
                if canExtract and BiteMunityCore.isPlayerPermanentlyImmune(otherPlayer) then
                    context:addOption("Extraire du sang de " .. targetName, player, VaccinationClient.extractBlood, otherPlayer)
                end
                
                -- Vérifier si on peut vacciner ce joueur
                local canVaccinate, _ = VaccinationCore.canVaccinate(otherPlayer, player)
                if canVaccinate then
                    local vaccine = player:getInventory():getFirstTypeRecurse("BiteMunityVaccination.AntiZombieVaccine")
                    if vaccine then
                        context:addOption("Vacciner " .. targetName, player, VaccinationClient.administerVaccine, otherPlayer)
                    end
                end
            end
        end
    end
end

-- Gestionnaire de menu contextuel pour les items
function VaccinationClient.onFillInventoryObjectContextMenu(playerNum, context, items)
    local player = getSpecificPlayer(playerNum)
    if not player then return end
    
    for i = 1, #items do
        local item = items[i]
        if item and item.getFullType then
            local itemType = item:getFullType()
            
            if itemType == "BiteMunityVaccination.ImmuneBlood" then
                context:addOption("Centrifuger", player, VaccinationClient.centrifugeBlood, item)
            elseif itemType == "BiteMunityVaccination.BloodSerum" then
                context:addOption("Purifier", player, VaccinationClient.purifySerum, item)
            end
        end
    end
end

-- Gestionnaire de commandes serveur
function VaccinationClient.onServerCommand(module, command, args)
    if module ~= "VaccinationSystem" then return end
    
    local player = getSpecificPlayer(0)
    if not player then return end
    
    if command == "VaccinationSuccess" then
        if args and args.patientID == tostring(player:getOnlineID()) then
            -- Synchroniser l'immunité avec BiteMunity
            if BiteMunityCore and BiteMunityCore.setPlayerPermanentImmunity then
                BiteMunityCore.setPlayerPermanentImmunity(player, true)
            end
        end
    end
end

-- Vérification périodique des items expirés
function VaccinationClient.checkExpiredItems()
    local player = getSpecificPlayer(0)
    if not player then return end
    
    local inventory = player:getInventory()
    if not inventory then return end
    
    local itemsToRemove = {}
    
    -- Vérifier tous les items liés à la vaccination
    for i = 0, inventory:getItems():size() - 1 do
        local item = inventory:getItems():get(i)
        if item and item.getFullType then
            local itemType = item:getFullType()
            
            if itemType == "BiteMunityVaccination.ImmuneBlood" or 
               itemType == "BiteMunityVaccination.BloodSerum" or 
               itemType == "BiteMunityVaccination.AntiZombieVaccine" then
                
                if VaccinationCore.checkItemExpiry(item) then
                    table.insert(itemsToRemove, item)
                end
            end
        end
    end
    
    -- Supprimer les items expirés
    for _, item in ipairs(itemsToRemove) do
        inventory:DoRemoveItem(item)
        player:Say("Un produit médical a expiré et a été jeté.")
    end
end

-- Fonction d'initialisation du client
function VaccinationClient.init()
    -- Vérifier que BiteMunity est bien chargé
    if not BiteMunityCore then
        print("[VaccinationSystem] ERREUR: BiteMunity n'est pas disponible! Assurez-vous que le mod BiteMunity est activé.")
        return
    end
    
    Events.OnFillWorldObjectContextMenu.Add(VaccinationClient.onFillWorldObjectContextMenu)
    Events.OnFillInventoryObjectContextMenu.Add(VaccinationClient.onFillInventoryObjectContextMenu)
    Events.OnServerCommand.Add(VaccinationClient.onServerCommand)
    Events.EveryTenMinutes.Add(VaccinationClient.checkExpiredItems)
    
    print("[VaccinationSystem] Client initialized with BiteMunity integration")
end

-- Initialiser le client
Events.OnGameStart.Add(VaccinationClient.init)