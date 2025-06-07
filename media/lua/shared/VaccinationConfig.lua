-- media/lua/shared/VaccinationConfig.lua
-- Configuration pour le système de vaccination - Version corrigée et optimisée

VaccinationConfig = VaccinationConfig or {}

-- Temps en heures de jeu
VaccinationConfig.CENTRIFUGE_TIME = 2.0  -- 2 heures
VaccinationConfig.PURIFICATION_TIME = 3.0  -- 3 heures

-- Cooldowns en heures de jeu
VaccinationConfig.BLOOD_EXTRACTION_COOLDOWN = 168  -- 7 jours = 168 heures
VaccinationConfig.VACCINATION_COOLDOWN = 72  -- 3 jours = 72 heures

-- Niveaux requis
VaccinationConfig.REQUIRED_DOCTOR_LEVEL = 6

-- Chances de succès
VaccinationConfig.VACCINATION_SUCCESS_CHANCE = 20  -- 20%
VaccinationConfig.INFECTION_CHANCE_DIRTY_TOOLS = 30  -- 30% si outils sales
VaccinationConfig.SELF_EXTRACTION_INFECTION_CHANCE_CLEAN = 10  -- 10% en auto-extraction avec outils propres
VaccinationConfig.SELF_EXTRACTION_INFECTION_CHANCE_DIRTY = 25  -- 25% en auto-extraction avec outils sales

-- Durées des effets en heures
VaccinationConfig.NEGATIVE_EFFECTS_DURATION = 24  -- 24 heures
VaccinationConfig.BLOOD_SERUM_EXPIRY = 24  -- 24 heures

-- Conditions d'équipement
VaccinationConfig.MIN_SYRINGE_CONDITION = 0.9  -- 90%
VaccinationConfig.MIN_GLOVES_CONDITION = 0.8   -- 80%
VaccinationConfig.MIN_SELF_SYRINGE_CONDITION = 0.5  -- 50% pour auto-extraction

-- Messages
VaccinationConfig.MESSAGES = {
    EXTRACTION_SUCCESS = "Extraction de sang reussie. Le donneur doit maintenant se reposer.",
    EXTRACTION_FAILED_LEVEL = "Niveau de medecin insuffisant (niveau 6 requis).",
    EXTRACTION_FAILED_COOLDOWN = "Ce donneur a deja donne son sang recemment (7 jours requis).",
    EXTRACTION_FAILED_NOT_IMMUNE = "Ce joueur n'est pas naturellement immunise.",
    EXTRACTION_FAILED_EQUIPMENT = "Equipement medical manquant ou en mauvais etat.",
    EXTRACTION_INFECTION = "Infection due a un equipement non sterilise !",
    EXTRACTION_SELF_FAILED_EQUIPMENT = "Il me faut au moins une seringue en bon etat pour m'extraire du sang.",
    EXTRACTION_SELF_SUCCESS = "Auto-extraction reussie. Je dois maintenant me reposer.",

    VACCINATION_SUCCESS = "Vaccination reussie ! Vous etes maintenant immunise.",
    VACCINATION_FAILED = "Je ne me sens pas bien... La vaccination a echoue.",
    VACCINATION_RECOVERY = "Je me sens mieux maintenant.",
    VACCINATION_FAILED_COOLDOWN = "Ce patient a ete vaccine recemment (3 jours requis).",
    VACCINATION_FAILED_ALREADY_IMMUNE = "Ce patient est deja immunise.",

    CENTRIFUGE_START = "Demarrage de la centrifugation...",
    CENTRIFUGE_COMPLETE = "Centrifugation terminee. Serum sanguin obtenu.",
    PURIFICATION_START = "Demarrage de la purification...",
    PURIFICATION_COMPLETE = "Purification terminee. Vaccin pret.",

    EXPIRED_BLOOD = "Le sang a expire et n'est plus utilisable.",
    EXPIRED_SERUM = "Le serum a expire et n'est plus utilisable.",
}

-- Effets négatifs de la vaccination échouée
VaccinationConfig.NEGATIVE_EFFECTS = {
    {stat = "Fever", value = 0.8, duration = 24},
    {stat = "Pain", value = 30, duration = 24},
    {stat = "Nausea", value = true, duration = 24},
    {stat = "Weakness", value = true, duration = 24}
}

-- Équipement requis pour extraction par un médecin avec seringue stérilisée
VaccinationConfig.REQUIRED_EXTRACTION_ITEMS = {
    {type = "Base.AlcoholWipes", condition = 0.1},
    {type = "BiteMunityVaccination.SterilizedSyringe", condition = 0.9},
    {type = "Base.Gloves_Surgical", condition = 0.8}
}

-- Alternative avec seringue non stérilisée (plus de risques)
VaccinationConfig.REQUIRED_EXTRACTION_ITEMS_RISKY = {
    {type = "Base.AlcoholWipes", condition = 0.1},
    {type = "BiteMunityVaccination.MedicalSyringe", condition = 0.9},
    {type = "Base.Gloves_Surgical", condition = 0.8}
}

-- Équipement minimal pour auto-extraction (beaucoup moins strict)
VaccinationConfig.REQUIRED_SELF_EXTRACTION_ITEMS = {
    {type = "BiteMunityVaccination.MedicalSyringe", condition = 0.5, mandatory = true},
    {type = "BiteMunityVaccination.SterilizedSyringe", condition = 0.5, mandatory = false, priority = true}, -- Préférable
    {type = "Base.AlcoholWipes", condition = 0.1, mandatory = false, optional = true},
    {type = "Base.Bandage", condition = 0.1, mandatory = false, optional = true} -- Pour arrêter le saignement
}

function VaccinationConfig.getGameTimeHours()
    local gameTime = getGameTime()
    if gameTime then
        local worldAge = gameTime:getWorldAgeHours()
        if worldAge then
            return worldAge
        end
    end
    return 0
end

function VaccinationConfig.isEquipmentSterilized(player)
    if not player then
        return false
    end

    local inventory = player:getInventory()
    if not inventory then
        return false
    end

    -- Vérifier d'abord avec seringue stérilisée
    local hasSterilizedSyringe = false
    local hasOtherItems = true

    for i = 1, #VaccinationConfig.REQUIRED_EXTRACTION_ITEMS do
        local item = VaccinationConfig.REQUIRED_EXTRACTION_ITEMS[i]
        local foundItem = inventory:getFirstTypeRecurse(item.type)
        if item.type == "BiteMunityVaccination.SterilizedSyringe" then
            if foundItem and foundItem:getCondition() >= item.condition then
                hasSterilizedSyringe = true
            end
        else
            if not foundItem or foundItem:getCondition() < item.condition then
                hasOtherItems = false
                break
            end
        end
    end

    if hasSterilizedSyringe and hasOtherItems then
        return true
    end

    -- Sinon vérifier avec seringue normale (moins sûr)
    local hasNormalSyringe = false
    local hasOtherItemsRisky = true

    for i = 1, #VaccinationConfig.REQUIRED_EXTRACTION_ITEMS_RISKY do
        local item = VaccinationConfig.REQUIRED_EXTRACTION_ITEMS_RISKY[i]
        local foundItem = inventory:getFirstTypeRecurse(item.type)
        if item.type == "BiteMunityVaccination.MedicalSyringe" then
            if foundItem and foundItem:getCondition() >= item.condition then
                hasNormalSyringe = true
            end
        else
            if not foundItem or foundItem:getCondition() < item.condition then
                hasOtherItemsRisky = false
                break
            end
        end
    end

    if hasNormalSyringe and hasOtherItemsRisky then
        return "risky"
    end

    return false
end

-- FONCTION CORRIGÉE : Vérifier si le joueur peut s'auto-extraire du sang
function VaccinationConfig.canSelfExtract(player)
    if not player then
        return false
    end

    local inventory = player:getInventory()
    if not inventory then
        return false
    end

    -- Vérifier d'abord si on a une seringue stérilisée (idéal)
    local sterilizedSyringe = inventory:getFirstTypeRecurse("BiteMunityVaccination.SterilizedSyringe")
    if sterilizedSyringe and sterilizedSyringe:getCondition() >= VaccinationConfig.MIN_SELF_SYRINGE_CONDITION then
        return true
    end

    -- Sinon vérifier si on a une seringue normale (minimum requis)
    local normalSyringe = inventory:getFirstTypeRecurse("BiteMunityVaccination.MedicalSyringe")
    if normalSyringe and normalSyringe:getCondition() >= VaccinationConfig.MIN_SELF_SYRINGE_CONDITION then
        return true
    end

    -- Aucune seringue appropriée trouvée
    return false
end

-- NOUVELLE FONCTION : Vérifier la qualité de l'équipement d'auto-extraction
function VaccinationConfig.getSelfExtractionQuality(player)
    if not player then
        return "none"
    end

    local inventory = player:getInventory()
    if not inventory then
        return "none"
    end

    local score = 0
    local details = {}

    -- Vérifier seringue stérilisée (meilleur)
    local sterilizedSyringe = inventory:getFirstTypeRecurse("BiteMunityVaccination.SterilizedSyringe")
    if sterilizedSyringe and sterilizedSyringe:getCondition() >= VaccinationConfig.MIN_SELF_SYRINGE_CONDITION then
        score = score + 3
        details.syringe = "sterilized"
    else
        -- Vérifier seringue normale
        local normalSyringe = inventory:getFirstTypeRecurse("BiteMunityVaccination.MedicalSyringe")
        if normalSyringe and normalSyringe:getCondition() >= VaccinationConfig.MIN_SELF_SYRINGE_CONDITION then
            score = score + 1
            details.syringe = "normal"
        else
            return "none" -- Pas de seringue utilisable
        end
    end

    -- Vérifier les lingettes alcoolisées
    local wipes = inventory:getFirstTypeRecurse("Base.AlcoholWipes")
    if wipes and wipes:getCondition() >= 0.1 then
        score = score + 1
        details.wipes = true
    end

    -- Vérifier les bandages pour après
    local bandage = inventory:getFirstTypeRecurse("Base.Bandage")
    if bandage and bandage:getCondition() >= 0.1 then
        score = score + 0.5
        details.bandage = true
    end

    -- Déterminer la qualité globale
    if score >= 4 then
        return "excellent" -- Seringue stérilisée + lingettes + bandages
    elseif score >= 3 then
        return "good" -- Seringue stérilisée ou seringue normale + lingettes
    elseif score >= 1 then
        return "poor" -- Juste une seringue
    else
        return "none"
    end
end

function VaccinationConfig.hasSterilizedEquipment(player)
    if not player then
        return false
    end

    local inventory = player:getInventory()
    if not inventory then
        return false
    end

    local sterilizedSyringe = inventory:getFirstTypeRecurse("BiteMunityVaccination.SterilizedSyringe")
    return sterilizedSyringe and sterilizedSyringe:getCondition() >= VaccinationConfig.MIN_SELF_SYRINGE_CONDITION
end

-- NOUVELLE FONCTION : Obtenir un message d'aide pour l'auto-extraction
function VaccinationConfig.getSelfExtractionHelpMessage(player)
    if not player then
        return "Impossible de vérifier l'équipement."
    end

    local inventory = player:getInventory()
    if not inventory then
        return "Aucun inventaire disponible."
    end

    local messages = {}
    
    -- Vérifier seringues
    local sterilizedSyringe = inventory:getFirstTypeRecurse("BiteMunityVaccination.SterilizedSyringe")
    local normalSyringe = inventory:getFirstTypeRecurse("BiteMunityVaccination.MedicalSyringe")
    
    if not sterilizedSyringe and not normalSyringe then
        table.insert(messages, "❌ Seringue requise (médicale ou stérilisée)")
    elseif sterilizedSyringe and sterilizedSyringe:getCondition() >= VaccinationConfig.MIN_SELF_SYRINGE_CONDITION then
        table.insert(messages, "✅ Seringue stérilisée disponible")
    elseif normalSyringe and normalSyringe:getCondition() >= VaccinationConfig.MIN_SELF_SYRINGE_CONDITION then
        table.insert(messages, "⚠️ Seringue normale disponible (risque d'infection)")
    else
        table.insert(messages, "❌ Seringues en trop mauvais état")
    end

    -- Vérifier les lingettes
    local wipes = inventory:getFirstTypeRecurse("Base.AlcoholWipes")
    if wipes and wipes:getCondition() >= 0.1 then
        table.insert(messages, "✅ Lingettes alcoolisées disponibles")
    else
        table.insert(messages, "⚠️ Pas de lingettes (risque d'infection accru)")
    end

    -- Vérifier les bandages
    local bandage = inventory:getFirstTypeRecurse("Base.Bandage")
    if bandage and bandage:getCondition() >= 0.1 then
        table.insert(messages, "✅ Bandages disponibles")
    else
        table.insert(messages, "⚠️ Pas de bandages (difficile d'arrêter le saignement)")
    end

    return table.concat(messages, "\n")
end