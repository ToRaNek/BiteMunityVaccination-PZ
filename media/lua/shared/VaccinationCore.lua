-- media/lua/shared/VaccinationCore.lua
-- Logique principale du système de vaccination - Version BiteMunity compatible

VaccinationCore = VaccinationCore or {}

-- Tables pour stocker les cooldowns
VaccinationCore.bloodExtractionCooldowns = {}
VaccinationCore.vaccinationCooldowns = {}

-- Fonction pour vérifier si un joueur peut donner du sang
function VaccinationCore.canExtractBlood(donor, extractor)
    if not donor or not extractor then
        return false, "Joueur invalide"
    end
    
    -- Vérifier le niveau de médecin de l'extracteur (sauf si c'est pour lui-même)
    if donor ~= extractor then
        local doctorLevel = extractor:getPerkLevel(Perks.Doctor)
        if doctorLevel < VaccinationConfig.REQUIRED_DOCTOR_LEVEL then
            return false, VaccinationConfig.MESSAGES.EXTRACTION_FAILED_LEVEL
        end
    end
    
    -- Vérifier si le donneur est naturellement immunisé (utilise BiteMunity)
    if not BiteMunityCore or not BiteMunityCore.isPlayerPermanentlyImmune(donor) then
        return false, VaccinationConfig.MESSAGES.EXTRACTION_FAILED_NOT_IMMUNE
    end
    
    -- Vérifier le cooldown
    local donorID = tostring(donor:getOnlineID())
    local lastExtraction = VaccinationCore.bloodExtractionCooldowns[donorID]
    local currentTime = VaccinationConfig.getGameTimeHours()
    
    if lastExtraction and (currentTime - lastExtraction) < VaccinationConfig.BLOOD_EXTRACTION_COOLDOWN then
        return false, VaccinationConfig.MESSAGES.EXTRACTION_FAILED_COOLDOWN
    end
    
    -- Vérifier l'équipement
    local equipmentStatus = VaccinationConfig.isEquipmentSterilized(extractor)
    if equipmentStatus == false then
        return false, VaccinationConfig.MESSAGES.EXTRACTION_FAILED_EQUIPMENT
    end
    
    return true, ""
end

-- Fonction pour extraire du sang
function VaccinationCore.extractBlood(donor, extractor)
    local canExtract, message = VaccinationCore.canExtractBlood(donor, extractor)
    
    if not canExtract then
        if extractor and extractor.Say then
            extractor:Say(message)
        end
        return false
    end
    
    -- Vérifier le type d'équipement (stérilisé ou non)
    local equipmentStatus = VaccinationConfig.isEquipmentSterilized(extractor)
    local hasSterilizedEquipment = VaccinationConfig.hasSterilizedEquipment(extractor)
    
    -- Si équipement non stérilisé, augmenter le risque d'infection
    if equipmentStatus == "risky" then
        local infectionChance = ZombRand(100) + 1
        if infectionChance <= VaccinationConfig.INFECTION_CHANCE_DIRTY_TOOLS then
            VaccinationCore.infectArmWound(donor)
            if extractor and extractor.Say then
                extractor:Say(VaccinationConfig.MESSAGES.EXTRACTION_INFECTION)
            end
        end
    end
    
    -- Créer le sang immunisé
    local immuneBlood = InventoryItemFactory.CreateItem("BiteMunityVaccination.ImmuneBlood")
    if immuneBlood then
        -- Marquer l'heure de création pour la gestion de l'expiration
        local modData = immuneBlood:getModData()
        modData.creationTime = VaccinationConfig.getGameTimeHours()
        modData.donorID = tostring(donor:getOnlineID())
        modData.sterilized = hasSterilizedEquipment
        
        extractor:getInventory():AddItem(immuneBlood)
    end
    
    -- Ajouter de la fatigue au donneur
    local stats = donor:getStats()
    if stats then
        stats:setFatigue(math.min(1.0, stats:getFatigue() + 0.3))
    end
    
    -- Consommer l'équipement
    VaccinationCore.consumeExtractionEquipment(extractor, hasSterilizedEquipment)
    
    -- Enregistrer le cooldown
    local donorID = tostring(donor:getOnlineID())
    VaccinationCore.bloodExtractionCooldowns[donorID] = VaccinationConfig.getGameTimeHours()
    
    if extractor and extractor.Say then
        extractor:Say(VaccinationConfig.MESSAGES.EXTRACTION_SUCCESS)
    end
    return true
end

-- Fonction pour infecter le bras en cas d'équipement sale
function VaccinationCore.infectArmWound(player)
    if not player then return end
    
    local bodyDamage = player:getBodyDamage()
    if bodyDamage then
        -- Ajouter une petite blessure infectée au bras
        local bodyParts = bodyDamage:getBodyParts()
        for i = 0, bodyParts:size() - 1 do
            local bodyPart = bodyParts:get(i)
            if bodyPart and (bodyPart:getType() == BodyPartType.Hand_L or bodyPart:getType() == BodyPartType.Hand_R) then
                bodyPart:AddDamage(5) -- Petite blessure
                bodyPart:setInfectedWound(true)
                break
            end
        end
    end
end

-- Fonction pour consommer l'équipement d'extraction
function VaccinationCore.consumeExtractionEquipment(player, hasSterilizedEquipment)
    if not player then return end
    
    local inventory = player:getInventory()
    if not inventory then return end
    
    -- Consommer les lingettes alcoolisées
    local wipes = inventory:getFirstTypeRecurse("Base.AlcoholWipes")
    if wipes then
        wipes:Use()
    end
    
    -- Consommer la seringue appropriée
    if hasSterilizedEquipment then
        local syringe = inventory:getFirstTypeRecurse("BiteMunityVaccination.SterilizedSyringe")
        if syringe then
            syringe:setCondition(math.max(0, syringe:getCondition() - 0.1))
            -- La seringue stérilisée devient une seringue normale après usage
            if syringe:getCondition() <= 0.1 then
                inventory:DoRemoveItem(syringe)
                local normalSyringe = InventoryItemFactory.CreateItem("BiteMunityVaccination.MedicalSyringe")
                if normalSyringe then
                    normalSyringe:setCondition(0.8)
                    inventory:AddItem(normalSyringe)
                end
            end
        end
    else
        local syringe = inventory:getFirstTypeRecurse("BiteMunityVaccination.MedicalSyringe")
        if syringe then
            syringe:setCondition(math.max(0, syringe:getCondition() - 0.15)) -- Plus d'usure
        end
    end
    
    -- Réduire la condition des gants
    local gloves = inventory:getFirstTypeRecurse("Base.Gloves_Surgical")
    if gloves then
        gloves:setCondition(math.max(0, gloves:getCondition() - 0.05))
    end
end

-- Fonction pour vérifier si un patient peut être vacciné
function VaccinationCore.canVaccinate(patient, doctor)
    if not patient or not doctor then
        return false, "Joueur invalide"
    end
    
    -- Vérifier si le patient est déjà immunisé (utilise BiteMunity)
    if BiteMunityCore and BiteMunityCore.isPlayerPermanentlyImmune(patient) then
        return false, VaccinationConfig.MESSAGES.VACCINATION_FAILED_ALREADY_IMMUNE
    end
    
    -- Vérifier le cooldown
    local patientID = tostring(patient:getOnlineID())
    local lastVaccination = VaccinationCore.vaccinationCooldowns[patientID]
    local currentTime = VaccinationConfig.getGameTimeHours()
    
    if lastVaccination and (currentTime - lastVaccination) < VaccinationConfig.VACCINATION_COOLDOWN then
        return false, VaccinationConfig.MESSAGES.VACCINATION_FAILED_COOLDOWN
    end
    
    return true, ""
end

-- Fonction pour administrer le vaccin
function VaccinationCore.administerVaccine(patient, doctor, vaccine)
    local canVaccinate, message = VaccinationCore.canVaccinate(patient, doctor)
    
    if not canVaccinate then
        if doctor and doctor.Say then
            doctor:Say(message)
        end
        return false
    end
    
    -- Vérifier si le vaccin a expiré
    local modData = vaccine:getModData()
    if modData.creationTime then
        local currentTime = VaccinationConfig.getGameTimeHours()
        if (currentTime - modData.creationTime) > VaccinationConfig.BLOOD_SERUM_EXPIRY then
            if doctor and doctor.Say then
                doctor:Say(VaccinationConfig.MESSAGES.EXPIRED_BLOOD)
            end
            return false
        end
    end
    
    -- Test de réussite de la vaccination
    local successChance = ZombRand(100) + 1
    local isSuccess = successChance <= VaccinationConfig.VACCINATION_SUCCESS_CHANCE
    
    if isSuccess then
        -- Vaccination réussie - le patient devient immunisé (utilise BiteMunity)
        if BiteMunityCore and BiteMunityCore.setPlayerPermanentImmunity then
            BiteMunityCore.setPlayerPermanentImmunity(patient, true)
        end
        if patient and patient.Say then
            patient:Say(VaccinationConfig.MESSAGES.VACCINATION_SUCCESS)
        end
        
        -- Synchroniser avec le serveur si en multijoueur
        if isClient() then
            sendClientCommand(patient, "VaccinationSystem", "VaccinationSuccess", {
                patientID = tostring(patient:getOnlineID())
            })
        end
    else
        -- Vaccination échouée - effets négatifs
        VaccinationCore.applyNegativeEffects(patient)
        if patient and patient.Say then
            patient:Say(VaccinationConfig.MESSAGES.VACCINATION_FAILED)
        end
        
        -- Programmer la récupération
        VaccinationCore.scheduleRecovery(patient)
    end
    
    -- Consommer le vaccin
    if doctor then
        doctor:getInventory():DoRemoveItem(vaccine)
    end
    
    -- Enregistrer le cooldown
    local patientID = tostring(patient:getOnlineID())
    VaccinationCore.vaccinationCooldowns[patientID] = VaccinationConfig.getGameTimeHours()
    
    return true
end

-- Fonction pour appliquer les effets négatifs
function VaccinationCore.applyNegativeEffects(player)
    if not player then return end
    
    local bodyDamage = player:getBodyDamage()
    local stats = player:getStats()
    
    if not bodyDamage or not stats then return end
    
    -- Appliquer chaque effet négatif
    for _, effect in ipairs(VaccinationConfig.NEGATIVE_EFFECTS) do
        if effect.stat == "Fever" then
            bodyDamage:setTemperature(bodyDamage:getTemperature() + effect.value)
        elseif effect.stat == "Pain" then
            bodyDamage:setOverallBodyHealth(bodyDamage:getOverallBodyHealth() - effect.value)
        elseif effect.stat == "Nausea" then
            bodyDamage:setNausea(true)
        elseif effect.stat == "Weakness" then
            stats:setEndurance(math.max(0, stats:getEndurance() - 0.5))
        end
    end
    
    -- Marquer le temps de début des effets pour la récupération
    local modData = player:getModData()
    modData.vaccinationEffectsStartTime = VaccinationConfig.getGameTimeHours()
end

-- Fonction pour programmer la récupération
function VaccinationCore.scheduleRecovery(player)
    local checkRecovery
    checkRecovery = function()
        if not player then return end
        
        local modData = player:getModData()
        local startTime = modData.vaccinationEffectsStartTime
        
        if startTime then
            local currentTime = VaccinationConfig.getGameTimeHours()
            if (currentTime - startTime) >= VaccinationConfig.NEGATIVE_EFFECTS_DURATION then
                -- Récupération complète
                VaccinationCore.recoverFromVaccination(player)
                modData.vaccinationEffectsStartTime = nil
                Events.EveryTenMinutes.Remove(checkRecovery)
            end
        end
    end
    
    Events.EveryTenMinutes.Add(checkRecovery)
end

-- Fonction pour récupérer des effets de la vaccination
function VaccinationCore.recoverFromVaccination(player)
    if not player then return end
    
    local bodyDamage = player:getBodyDamage()
    local stats = player:getStats()
    
    if not bodyDamage or not stats then return end
    
    -- Restaurer la santé
    bodyDamage:setTemperature(37.0) -- Température normale
    bodyDamage:setNausea(false)
    bodyDamage:setOverallBodyHealth(math.min(100, bodyDamage:getOverallBodyHealth() + 30))
    stats:setEndurance(math.min(1.0, stats:getEndurance() + 0.5))
    
    if player.Say then
        player:Say(VaccinationConfig.MESSAGES.VACCINATION_RECOVERY)
    end
end

-- Fonction de vérification d'expiration des items
function VaccinationCore.checkItemExpiry(item)
    if not item then return false end
    
    local modData = item:getModData()
    if modData.creationTime then
        local currentTime = VaccinationConfig.getGameTimeHours()
        return (currentTime - modData.creationTime) > VaccinationConfig.BLOOD_SERUM_EXPIRY
    end
    
    return false
end

-- Fonction pour sauvegarder les données
function VaccinationCore.saveData(player)
    if not player then return end
    
    local modData = player:getModData()
    modData.bloodExtractionCooldowns = VaccinationCore.bloodExtractionCooldowns
    modData.vaccinationCooldowns = VaccinationCore.vaccinationCooldowns
end

-- Fonction pour charger les données
function VaccinationCore.loadData(player)
    if not player then return end
    
    local modData = player:getModData()
    if modData.bloodExtractionCooldowns then
        VaccinationCore.bloodExtractionCooldowns = modData.bloodExtractionCooldowns
    end
    if modData.vaccinationCooldowns then
        VaccinationCore.vaccinationCooldowns = modData.vaccinationCooldowns
    end
end