-- VaccinationConfig.lua
-- Configuration pour le système de vaccination

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
    EXTRACTION_SUCCESS = "Extraction de sang réussie. Le donneur doit maintenant se reposer.",
    EXTRACTION_FAILED_LEVEL = "Niveau de médecin insuffisant (niveau 6 requis).",
    EXTRACTION_FAILED_COOLDOWN = "Ce donneur a déjà donné son sang récemment (7 jours requis).",
    EXTRACTION_FAILED_NOT_IMMUNE = "Ce joueur n'est pas naturellement immunisé.",
    EXTRACTION_FAILED_EQUIPMENT = "Équipement médical manquant ou en mauvais état.",
    EXTRACTION_INFECTION = "Infection due à un équipement non stérilisé !",
    
    VACCINATION_SUCCESS = "Vaccination réussie ! Vous êtes maintenant immunisé.",
    VACCINATION_FAILED = "Je ne me sens pas bien... La vaccination a échoué.",
    VACCINATION_RECOVERY = "Je me sens mieux maintenant.",
    VACCINATION_FAILED_COOLDOWN = "Ce patient a été vacciné récemment (3 jours requis).",
    VACCINATION_FAILED_ALREADY_IMMUNE = "Ce patient est déjà immunisé.",
    
    CENTRIFUGE_START = "Démarrage de la centrifugation...",
    CENTRIFUGE_COMPLETE = "Centrifugation terminée. Sérum sanguin obtenu.",
    PURIFICATION_START = "Démarrage de la purification...",
    PURIFICATION_COMPLETE = "Purification terminée. Vaccin prêt.",
    
    EXPIRED_BLOOD = "Le sang a expiré et n'est plus utilisable.",
    EXPIRED_SERUM = "Le sérum a expiré et n'est plus utilisable.",
}

-- Effets négatifs de la vaccination échouée
VaccinationConfig.NEGATIVE_EFFECTS = {
    {stat = "Fever", value = 0.8, duration = 24},
    {stat = "Pain", value = 30, duration = 24},
    {stat = "Nausea", value = true, duration = 24},
    {stat = "Weakness", value = true, duration = 24}
}

-- Validation des équipements requis
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

function VaccinationConfig.getGameTimeHours()
    local gameTime = getGameTime()
    if gameTime then
        local worldAge = gameTime:getWorldAgeHours() or 0
        return worldAge
    end
    return 0
end

function VaccinationConfig.isEquipmentSterilized(player)
    if not player then return false end
    local inventory = player:getInventory()
    if not inventory then return false end
    
    -- Vérifier d'abord avec seringue stérilisée
    local hasSterilizedSyringe = false
    for _, item in ipairs(VaccinationConfig.REQUIRED_EXTRACTION_ITEMS) do
        local foundItem = inventory:getFirstTypeRecurse(item.type)
        if item.type == "BiteMunityVaccination.SterilizedSyringe" and foundItem and foundItem:getCondition() >= item.condition then
            hasSterilizedSyringe = true
        elseif item.type ~= "BiteMunityVaccination.SterilizedSyringe" then
            if not foundItem or foundItem:getCondition() < item.condition then
                return false
            end
        end
    end
    
    if hasSterilizedSyringe then
        return true
    end
    
    -- Sinon vérifier avec seringue normale (moins sûr)
    for _, item in ipairs(VaccinationConfig.REQUIRED_EXTRACTION_ITEMS_RISKY) do
        local foundItem = inventory:getFirstTypeRecurse(item.type)
        if not foundItem or foundItem:getCondition() < item.condition then
            return false
        end
    end
    
    return "risky" -- Indique que l'équipement n'est pas stérilisé
end

function VaccinationConfig.hasSterilizedEquipment(player)
    if not player then return false end
    local inventory = player:getInventory()
    if not inventory then return false end
    
    local sterilizedSyringe = inventory:getFirstTypeRecurse("BiteMunityVaccination.SterilizedSyringe")
    return sterilizedSyringe and sterilizedSyringe:getCondition() >= 0.9
end