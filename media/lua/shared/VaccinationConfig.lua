-- media/lua/shared/VaccinationConfig.lua
-- Configuration pour le système de vaccination - Version corrigée

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

-- Durées des effets en heures
VaccinationConfig.NEGATIVE_EFFECTS_DURATION = 24  -- 24 heures
VaccinationConfig.BLOOD_SERUM_EXPIRY = 24  -- 24 heures

-- Conditions d'équipement
VaccinationConfig.MIN_SYRINGE_CONDITION = 0.9  -- 90%
VaccinationConfig.MIN_GLOVES_CONDITION = 0.8   -- 80%

-- Messages
VaccinationConfig.MESSAGES = {
    EXTRACTION_SUCCESS = "Extraction de sang reussie. Le donneur doit maintenant se reposer.",
    EXTRACTION_FAILED_LEVEL = "Niveau de medecin insuffisant (niveau 6 requis).",
    EXTRACTION_FAILED_COOLDOWN = "Ce donneur a deja donne son sang recemment (7 jours requis).",
    EXTRACTION_FAILED_NOT_IMMUNE = "Ce joueur n'est pas naturellement immunise.",
    EXTRACTION_FAILED_EQUIPMENT = "Equipement medical manquant ou en mauvais etat.",
    EXTRACTION_INFECTION = "Infection due a un equipement non sterilise !",

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

-- Validation des équipements requis avec seringue stérilisée
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

-- Équipement minimal pour auto-extraction (moins strict)
VaccinationConfig.REQUIRED_SELF_EXTRACTION_ITEMS = {
    {type = "BiteMunityVaccination.MedicalSyringe", condition = 0.5},
    {type = "Base.AlcoholWipes", condition = 0.1, optional = true}
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

function VaccinationConfig.canSelfExtract(player)
    if not player then
        return false
    end

    local inventory = player:getInventory()
    if not inventory then
        return false
    end

    -- Vérifier l'équipement minimal pour auto-extraction
    for i = 1, #VaccinationConfig.REQUIRED_SELF_EXTRACTION_ITEMS do
        local item = VaccinationConfig.REQUIRED_SELF_EXTRACTION_ITEMS[i]
        if not item.optional then
            local foundItem = inventory:getFirstTypeRecurse(item.type)
            if not foundItem or foundItem:getCondition() < item.condition then
                return false
            end
        end
    end

    return true
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
    return sterilizedSyringe and sterilizedSyringe:getCondition() >= 0.9
end
