-- VaccinationClient.lua
-- Gestion côté client du système de vaccination

-- Import des modules partagés (sans require car ils sont chargés directement)
-- VaccinationCore, VaccinationConfig et VaccinationTimedActions sont chargés automatiquement

VaccinationClient = VaccinationClient or {}

-- Fonction pour extraire du sang (menu contextuel)
function VaccinationClient.extractBlood(playerObj, targetPlayer)
    if playerObj == getPlayer() then
        VaccinationCore.extractBlood(targetPlayer, playerObj)
    end
end

-- Fonction pour administrer un vaccin (menu contextuel)
function VaccinationClient.administerVaccine(doctorObj, patientPlayer)
    if doctorObj == getPlayer() then
        local inventory = doctorObj:getInventory()
        local vaccine = inventory:getFirstTypeRecurse("BiteMunityVaccination.AntiZombieVaccine")
        
        if vaccine then
            VaccinationCore.administerVaccine(patientPlayer, doctorObj, vaccine)
        else
            doctorObj:Say("Je n'ai pas de vaccin sur moi.")
        end
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

-- Gestionnaire de menu contextuel pour les joueurs
function VaccinationClient.onFillWorldObjectContextMenu(player, context, worldObjects, test)
    if test then return end
    if player ~= getPlayer() then return end
    
    for _, obj in ipairs(worldObjects) do
        if instanceof(obj, "IsoPlayer") then
            local targetPlayer = obj
            if targetPlayer ~= player then
                -- Vérifier si on peut extraire du sang
                local canExtract, _ = VaccinationCore.canExtractBlood(targetPlayer, player)
                if canExtract then
                    context:addOption("Extraire du sang", player, VaccinationClient.extractBlood, targetPlayer)
                end
                
                -- Vérifier si on peut vacciner
                local canVaccinate, _ = VaccinationCore.canVaccinate(targetPlayer, player)
                if canVaccinate then
                    local vaccine = player:getInventory():getFirstTypeRecurse("BiteMunityVaccination.AntiZombieVaccine")
                    if vaccine then
                        context:addOption("Administrer le vaccin", player, VaccinationClient.administerVaccine, targetPlayer)
                    end
                end
            end
        end
    end
end

-- Gestionnaire de menu contextuel pour les items
function VaccinationClient.onFillInventoryObjectContextMenu(player, context, items)
    if player ~= getPlayer() then return end
    
    for _, item in ipairs(items) do
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
    
    local player = getPlayer()
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
    local player = getPlayer()
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
    Events.OnFillWorldObjectContextMenu.Add(VaccinationClient.onFillWorldObjectContextMenu)
    Events.OnFillInventoryObjectContextMenu.Add(VaccinationClient.onFillInventoryObjectContextMenu)
    Events.OnServerCommand.Add(VaccinationClient.onServerCommand)
    Events.EveryTenMinutes.Add(VaccinationClient.checkExpiredItems)
    
    print("[VaccinationSystem] Client initialized")
end

-- Initialiser le client
Events.OnGameStart.Add(VaccinationClient.init)