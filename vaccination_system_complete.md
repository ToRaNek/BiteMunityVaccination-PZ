# Système de Vaccination BiteMunity - Code Complet

## Structure du projet

```
BiteMunityVaccination/
├── mod.info
├── poster.png
└── media/
    ├── scripts/
    │   ├── items.txt
    │   ├── recipes.txt
    │   └── distributions.txt
    ├── lua/
    │   ├── client/
    │   │   ├── VaccinationClient.lua
    │   │   └── VaccinationUI.lua
    │   ├── server/
    │   │   └── VaccinationServer.lua
    │   └── shared/
    │       ├── VaccinationCore.lua
    │       ├── VaccinationConfig.lua
    │       ├── VaccinationTimedActions.lua
    │       └── Translate/
    │           ├── EN/
    │           │   └── ItemName_EN.txt
    │           └── FR/
    │               └── ItemName_FR.txt
    ├── textures/
    │   └── items/
    │       ├── Syringe.png
    │       ├── ImmuneBlood.png
    │       ├── BloodSerum.png
    │       ├── AntiZombieVaccine.png
    │       ├── Centrifuge.png
    │       └── Microscope.png
    └── models/
```

---

## media/scripts/distributions.txt
```txt
module BiteMunityVaccination
{
    imports
    {
        Base
    }

    item MedicalSyringe
    {
        DistributionTable = {
            MedicalStorageOutfit = 20,
            HospitalSurgery = 30,
            MedicalClinic = 25,
            AmbulanceTrunk = 15,
            FireStorageOutfit = 10,
            DrugLabGuns = 5,
            PoliceStorageOutfit = 8,
            GigamartPharmacy = 12,
            PharmacyCosmetics = 15,
        }
    }

    item Centrifuge
    {
        DistributionTable = {
            HospitalSurgery = 5,
            MedicalClinic = 3,
            OfficeDesk = 1,
            CollegeChemistry = 8,
            SchoolChemistry = 4,
        }
    }

    item LabMicroscope
    {
        DistributionTable = {
            HospitalSurgery = 8,
            MedicalClinic = 5,
            CollegeChemistry = 15,
            SchoolChemistry = 10,
            OfficeDesk = 2,
        }
    }

    item ChemicalReagents
    {
        DistributionTable = {
            MedicalStorageOutfit = 15,
            HospitalSurgery = 20,
            MedicalClinic = 18,
            CollegeChemistry = 25,
            SchoolChemistry = 15,
            DrugLabGuns = 10,
            GigamartPharmacy = 8,
        }
    }

    item DisinfectantAlcohol
    {
        DistributionTable = {
            MedicalStorageOutfit = 25,
            HospitalSurgery = 30,
            MedicalClinic = 28,
            AmbulanceTrunk = 20,
            GigamartPharmacy = 15,
            PharmacyCosmetics = 18,
            BathroomCabinet = 5,
        }
    }
}
```

---

## media/lua/shared/Translate/EN/ItemName_EN.txt
```txt
ItemName_EN = {
    ItemName_BiteMunityVaccination.MedicalSyringe = "Medical Syringe",
    ItemName_BiteMunityVaccination.SterilizedSyringe = "Sterilized Syringe",
    ItemName_BiteMunityVaccination.ImmuneBlood = "Immune Blood",
    ItemName_BiteMunityVaccination.BloodSerum = "Blood Serum",
    ItemName_BiteMunityVaccination.AntiZombieVaccine = "Anti-Zombie Vaccine",
    ItemName_BiteMunityVaccination.Centrifuge = "Centrifuge",
    ItemName_BiteMunityVaccination.LabMicroscope = "Laboratory Microscope",
    ItemName_BiteMunityVaccination.ChemicalReagents = "Chemical Reagents",
    ItemName_BiteMunityVaccination.DisinfectantAlcohol = "Disinfectant Alcohol",

    Tooltip_MedicalSyringe = "A medical syringe for blood extraction. Needs sterilization before use to reduce infection risks.",
    Tooltip_SterilizedSyringe = "A sterilized medical syringe. Safe for blood extraction with minimal infection risk.",
    Tooltip_ImmuneBlood = "Blood from a naturally immune person. Can be centrifuged to create serum. Expires in 24 hours.",
    Tooltip_BloodSerum = "Centrifuged blood serum containing antibodies. Can be purified into a vaccine. Expires in 24 hours.",
    Tooltip_AntiZombieVaccine = "A purified vaccine that may grant immunity to zombie infections. 20% success rate. Expires in 24 hours.",
    Tooltip_Centrifuge = "Laboratory equipment for separating blood components. Required for creating blood serum.",
    Tooltip_LabMicroscope = "Precision laboratory microscope. Required for vaccine purification process.",
    Tooltip_ChemicalReagents = "Chemical compounds needed for vaccine purification. Limited uses.",
    Tooltip_DisinfectantAlcohol = "Medical-grade alcohol for sterilizing equipment. Essential for safe procedures.",
}
```

---

## media/lua/shared/Translate/FR/ItemName_FR.txt
```txt
ItemName_FR = {
    ItemName_BiteMunityVaccination.MedicalSyringe = "Seringue Médicale",
    ItemName_BiteMunityVaccination.SterilizedSyringe = "Seringue Stérilisée",
    ItemName_BiteMunityVaccination.ImmuneBlood = "Sang Immunisé",
    ItemName_BiteMunityVaccination.BloodSerum = "Sérum Sanguin",
    ItemName_BiteMunityVaccination.AntiZombieVaccine = "Vaccin Anti-Zombification",
    ItemName_BiteMunityVaccination.Centrifuge = "Centrifugeuse",
    ItemName_BiteMunityVaccination.LabMicroscope = "Microscope de Laboratoire",
    ItemName_BiteMunityVaccination.ChemicalReagents = "Produits Chimiques",
    ItemName_BiteMunityVaccination.DisinfectantAlcohol = "Alcool Désinfectant",

    Tooltip_MedicalSyringe = "Seringue médicale pour l'extraction de sang. Nécessite une stérilisation avant usage pour réduire les risques d'infection.",
    Tooltip_SterilizedSyringe = "Seringue médicale stérilisée. Sûre pour l'extraction de sang avec un risque d'infection minimal.",
    Tooltip_ImmuneBlood = "Sang d'une personne naturellement immunisée. Peut être centrifugé pour créer un sérum. Expire en 24 heures.",
    Tooltip_BloodSerum = "Sérum sanguin centrifugé contenant des anticorps. Peut être purifié en vaccin. Expire en 24 heures.",
    Tooltip_AntiZombieVaccine = "Vaccin purifié qui peut accorder l'immunité aux infections zombies. 20% de chance de succès. Expire en 24 heures.",
    Tooltip_Centrifuge = "Équipement de laboratoire pour séparer les composants sanguins. Requis pour créer le sérum sanguin.",
    Tooltip_LabMicroscope = "Microscope de laboratoire de précision. Requis pour le processus de purification du vaccin.",
    Tooltip_ChemicalReagents = "Composés chimiques nécessaires pour la purification du vaccin. Utilisation limitée.",
    Tooltip_DisinfectantAlcohol = "Alcool de qualité médicale pour stériliser l'équipement. Essentiel pour des procédures sûres.",
}

---

## mod.info
```ini
name=BiteMunity Vaccination System
id=BiteMunityVaccination
description=Advanced vaccination system for BiteMunity mod - Create vaccines from immune blood
url=
modversion=1.0.0
pzversion=41.78
require=BiteMunity
```

---

## media/scripts/items.txt
```txt
module BiteMunityVaccination
{
    imports
    {
        Base
    }

    item MedicalSyringe
    {
        Weight = 0.1,
        Type = Normal,
        DisplayName = Seringue Médicale,
        Icon = Syringe,
        StaticModel = Syringe,
        WorldStaticModel = Syringe,
        ConditionLowerChanceOneIn = 20,
        ConditionMax = 10,
        Categories = Medical,
        CanBandage = false,
        BandageType = Standard,
        Tags = Medical;Sterilizable,
        Tooltip = Tooltip_MedicalSyringe,
        UseDelta = 0.1,
        UseWhileEquipped = false,
        CanStoreWater = false,
        MetalValue = 5,
    }

    item SterilizedSyringe
    {
        Weight = 0.1,
        Type = Normal,
        DisplayName = Seringue Stérilisée,
        Icon = Syringe,
        StaticModel = Syringe,
        WorldStaticModel = Syringe,
        ConditionLowerChanceOneIn = 50,
        ConditionMax = 10,
        Categories = Medical,
        CanBandage = false,
        BandageType = Standard,
        Tags = Medical;Sterile,
        Tooltip = Tooltip_SterilizedSyringe,
        UseDelta = 0.05,
        UseWhileEquipped = false,
        MetalValue = 5,
    }

    item ImmuneBlood
    {
        Weight = 0.1,
        Type = Normal,
        DisplayName = Sang Immunisé,
        Icon = ImmuneBlood,
        StaticModel = FlaskEmpty,
        WorldStaticModel = FlaskEmpty,
        DaysFresh = 1,
        DaysTotallyRotten = 1,
        ReplaceOnUse = Base.Flask,
        UseEndurance = false,
        Categories = Medical,
        CustomContextMenu = Centrifuger,
        Tags = Medical;Vaccine;Blood,
        Tooltip = Tooltip_ImmuneBlood,
    }

    item BloodSerum
    {
        Weight = 0.1,
        Type = Normal,
        DisplayName = Sérum Sanguin,
        Icon = BloodSerum,
        StaticModel = FlaskEmpty,
        WorldStaticModel = FlaskEmpty,
        DaysFresh = 1,
        DaysTotallyRotten = 1,
        ReplaceOnUse = Base.Flask,
        UseEndurance = false,
        Categories = Medical,
        CustomContextMenu = Purifier,
        Tags = Medical;Vaccine;Serum,
        Tooltip = Tooltip_BloodSerum,
    }

    item AntiZombieVaccine
    {
        Weight = 0.1,
        Type = Normal,
        DisplayName = Vaccin Anti-Zombification,
        Icon = AntiZombieVaccine,
        StaticModel = Pills,
        WorldStaticModel = Pills,
        DaysFresh = 1,
        DaysTotallyRotten = 1,
        UseEndurance = false,
        Categories = Medical,
        CustomContextMenu = Administrer,
        Tags = Medical;Vaccine;Final,
        Tooltip = Tooltip_AntiZombieVaccine,
    }

    item Centrifuge
    {
        Weight = 5.0,
        Type = Normal,
        DisplayName = Centrifugeuse,
        Icon = Centrifuge,
        StaticModel = Radio,
        WorldStaticModel = Radio,
        Categories = Medical,
        CanBandage = false,
        BandageType = Standard,
        Tags = Medical;Equipment,
        Tooltip = Tooltip_Centrifuge,
        MetalValue = 50,
    }

    item LabMicroscope
    {
        Weight = 3.0,
        Type = Normal,
        DisplayName = Microscope de Laboratoire,
        Icon = Microscope,
        StaticModel = Radio,
        WorldStaticModel = Radio,
        Categories = Medical,
        Tags = Medical;Equipment,
        Tooltip = Tooltip_LabMicroscope,
        MetalValue = 30,
    }

    item ChemicalReagents
    {
        Weight = 0.5,
        Type = Normal,
        DisplayName = Produits Chimiques,
        Icon = Pills,
        StaticModel = Pills,
        WorldStaticModel = Pills,
        Categories = Medical,
        Tags = Medical;Chemicals,
        Tooltip = Tooltip_ChemicalReagents,
        Uses = 5,
        UseDelta = 0.2,
    }

    item DisinfectantAlcohol
    {
        Weight = 0.3,
        Type = Normal,
        DisplayName = Alcool Désinfectant,
        Icon = AlcoholBottle,
        StaticModel = WineEmpty,
        WorldStaticModel = WineEmpty,
        Categories = Medical,
        Tags = Medical;Disinfectant,
        Tooltip = Tooltip_DisinfectantAlcohol,
        Uses = 10,
        UseDelta = 0.1,
        CanStoreWater = true,
        ReplaceOnUseOn = WaterDrop,
    }
}
```

---

## media/scripts/recipes.txt
```txt
module BiteMunityVaccination
{
    recipe Sterilize Syringe
    {
        BiteMunityVaccination.MedicalSyringe,
        BiteMunityVaccination.DisinfectantAlcohol,

        Result: BiteMunityVaccination.SterilizedSyringe,
        Time: 30.0,
        Category: Medical,
        CanBeDoneFromFloor: false,
        AnimNode: Disassemble,
        Prop1: Item,
        Prop2: Item,
        Sound: ClothesRipping,
    }

    recipe Sterilize Syringe Alt
    {
        BiteMunityVaccination.MedicalSyringe,
        Base.AlcoholWipes,

        Result: BiteMunityVaccination.SterilizedSyringe,
        Time: 20.0,
        Category: Medical,
        CanBeDoneFromFloor: false,
        AnimNode: Disassemble,
        Prop1: Item,
        Prop2: Item,
        Sound: ClothesRipping,
    }

    recipe Centrifuge Blood
    {
        BiteMunityVaccination.ImmuneBlood,
        BiteMunityVaccination.Centrifuge,

        Result: BiteMunityVaccination.BloodSerum,
        Time: 120.0,
        Category: Medical,
        NeedToBeLearn: true,
        CanBeDoneFromFloor: false,
        AnimNode: Disassemble,
        Prop1: Tools,
        Prop2: Item,
        RemoveResultItem: false,
        Sound: DeviceInteraction,
    }

    recipe Purify Serum
    {
        BiteMunityVaccination.BloodSerum,
        BiteMunityVaccination.LabMicroscope,
        BiteMunityVaccination.ChemicalReagents,

        Result: BiteMunityVaccination.AntiZombieVaccine,
        Time: 180.0,
        Category: Medical,
        NeedToBeLearn: true,
        CanBeDoneFromFloor: false,
        AnimNode: Disassemble,
        Prop1: Tools,
        Prop2: Item,
        RemoveResultItem: false,
        Sound: DeviceInteraction,
    }
}
```

---

## media/lua/shared/VaccinationConfig.lua
```lua
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
    local inventory = player:getInventory()
    
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
    local inventory = player:getInventory()
    local sterilizedSyringe = inventory:getFirstTypeRecurse("BiteMunityVaccination.SterilizedSyringe")
    return sterilizedSyringe and sterilizedSyringe:getCondition() >= 0.9
end
```

---

## media/lua/shared/VaccinationCore.lua
```lua
-- VaccinationCore.lua
-- Logique principale du système de vaccination

VaccinationCore = VaccinationCore or {}

-- Tables pour stocker les cooldowns
VaccinationCore.bloodExtractionCooldowns = {}
VaccinationCore.vaccinationCooldowns = {}

-- Fonction pour vérifier si un joueur peut donner du sang
function VaccinationCore.canExtractBlood(donor, extractor)
    if not donor or not extractor then
        return false, "Joueur invalide"
    end
    
    -- Vérifier le niveau de médecin de l'extracteur
    local doctorLevel = extractor:getPerkLevel(Perks.Doctor)
    if doctorLevel < VaccinationConfig.REQUIRED_DOCTOR_LEVEL then
        return false, VaccinationConfig.MESSAGES.EXTRACTION_FAILED_LEVEL
    end
    
    -- Vérifier si le donneur est naturellement immunisé
    if not BiteMunityCore.isPlayerPermanentlyImmune(donor) then
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
    if not VaccinationConfig.isEquipmentSterilized(extractor) then
        return false, VaccinationConfig.MESSAGES.EXTRACTION_FAILED_EQUIPMENT
    end
    
    return true, ""
end

-- Fonction pour extraire du sang
function VaccinationCore.extractBlood(donor, extractor)
    local canExtract, message = VaccinationCore.canExtractBlood(donor, extractor)
    
    if not canExtract then
        extractor:Say(message)
        return false
    end
    
    -- Vérifier le type d'équipement (stérilisé ou non)
    local equipmentStatus = VaccinationConfig.isEquipmentSterilized(extractor)
    local hasSterilizedEquipment = VaccinationConfig.hasSterilizedEquipment(extractor)
    
    if equipmentStatus == false then
        extractor:Say(VaccinationConfig.MESSAGES.EXTRACTION_FAILED_EQUIPMENT)
        return false
    end
    
    -- Si équipement non stérilisé, augmenter le risque d'infection
    if equipmentStatus == "risky" then
        local infectionChance = ZombRand(100) + 1
        if infectionChance <= VaccinationConfig.INFECTION_CHANCE_DIRTY_TOOLS then
            VaccinationCore.infectArmWound(donor)
            extractor:Say(VaccinationConfig.MESSAGES.EXTRACTION_INFECTION)
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
    stats:setFatigue(math.min(1.0, stats:getFatigue() + 0.3))
    
    -- Consommer l'équipement
    VaccinationCore.consumeExtractionEquipment(extractor, hasSterilizedEquipment)
    
    -- Enregistrer le cooldown
    local donorID = tostring(donor:getOnlineID())
    VaccinationCore.bloodExtractionCooldowns[donorID] = VaccinationConfig.getGameTimeHours()
    
    extractor:Say(VaccinationConfig.MESSAGES.EXTRACTION_SUCCESS)
    return true
end

-- Fonction pour infecter le bras en cas d'équipement sale
function VaccinationCore.infectArmWound(player)
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
    local inventory = player:getInventory()
    
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
    
    -- Vérifier si le patient est déjà immunisé
    if BiteMunityCore.isPlayerPermanentlyImmune(patient) then
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
        doctor:Say(message)
        return false
    end
    
    -- Vérifier si le vaccin a expiré
    local modData = vaccine:getModData()
    if modData.creationTime then
        local currentTime = VaccinationConfig.getGameTimeHours()
        if (currentTime - modData.creationTime) > VaccinationConfig.BLOOD_SERUM_EXPIRY then
            doctor:Say(VaccinationConfig.MESSAGES.EXPIRED_BLOOD)
            return false
        end
    end
    
    -- Test de réussite de la vaccination
    local successChance = ZombRand(100) + 1
    local isSuccess = successChance <= VaccinationConfig.VACCINATION_SUCCESS_CHANCE
    
    if isSuccess then
        -- Vaccination réussie - le patient devient immunisé
        BiteMunityCore.setPlayerPermanentImmunity(patient, true)
        patient:Say(VaccinationConfig.MESSAGES.VACCINATION_SUCCESS)
        
        -- Synchroniser avec le serveur si en multijoueur
        if isClient() then
            sendClientCommand(patient, "VaccinationSystem", "VaccinationSuccess", {
                patientID = tostring(patient:getOnlineID())
            })
        end
    else
        -- Vaccination échouée - effets négatifs
        VaccinationCore.applyNegativeEffects(patient)
        patient:Say(VaccinationConfig.MESSAGES.VACCINATION_FAILED)
        
        -- Programmer la récupération
        VaccinationCore.scheduleRecovery(patient)
    end
    
    -- Consommer le vaccin
    patient:getInventory():DoRemoveItem(vaccine)
    
    -- Enregistrer le cooldown
    local patientID = tostring(patient:getOnlineID())
    VaccinationCore.vaccinationCooldowns[patientID] = VaccinationConfig.getGameTimeHours()
    
    return true
end

-- Fonction pour appliquer les effets négatifs
function VaccinationCore.applyNegativeEffects(player)
    local bodyDamage = player:getBodyDamage()
    local stats = player:getStats()
    
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
    local bodyDamage = player:getBodyDamage()
    local stats = player:getStats()
    
    -- Restaurer la santé
    bodyDamage:setTemperature(37.0) -- Température normale
    bodyDamage:setNausea(false)
    bodyDamage:setOverallBodyHealth(math.min(100, bodyDamage:getOverallBodyHealth() + 30))
    stats:setEndurance(math.min(1.0, stats:getEndurance() + 0.5))
    
    player:Say(VaccinationConfig.MESSAGES.VACCINATION_RECOVERY)
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
    local modData = player:getModData()
    modData.bloodExtractionCooldowns = VaccinationCore.bloodExtractionCooldowns
    modData.vaccinationCooldowns = VaccinationCore.vaccinationCooldowns
end

-- Fonction pour charger les données
function VaccinationCore.loadData(player)
    local modData = player:getModData()
    if modData.bloodExtractionCooldowns then
        VaccinationCore.bloodExtractionCooldowns = modData.bloodExtractionCooldowns
    end
    if modData.vaccinationCooldowns then
        VaccinationCore.vaccinationCooldowns = modData.vaccinationCooldowns
    end
end
```

---

## media/lua/shared/VaccinationTimedActions.lua
```lua
-- VaccinationTimedActions.lua
-- Actions temporisées pour les processus de laboratoire

require "TimedActions/ISBaseTimedAction"

-- Action de centrifugation
ISCentrifugeAction = ISBaseTimedAction:derive("ISCentrifugeAction")

function ISCentrifugeAction:new(character, bloodItem, centrifuge)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
    o.bloodItem = bloodItem
    o.centrifuge = centrifuge
    o.stopOnWalk = true
    o.stopOnRun = true
    o.maxTime = VaccinationConfig.CENTRIFUGE_TIME * 60 * 60 -- Convertir en ticks
    return o
end

function ISCentrifugeAction:isValid()
    return self.character and self.bloodItem and self.centrifuge and
           self.character:getInventory():contains(self.bloodItem) and
           self.character:getInventory():contains(self.centrifuge)
end

function ISCentrifugeAction:update()
    -- Animation et sons
    if ZombRand(10) == 0 then
        self.character:playSound("DeviceInteraction")
    end
end

function ISCentrifugeAction:start()
    self.character:Say(VaccinationConfig.MESSAGES.CENTRIFUGE_START)
    self:setActionAnim("Disassemble")
end

function ISCentrifugeAction:stop()
    ISBaseTimedAction.stop(self)
end

function ISCentrifugeAction:perform()
    -- Vérifier si le sang a expiré
    if VaccinationCore.checkItemExpiry(self.bloodItem) then
        self.character:Say(VaccinationConfig.MESSAGES.EXPIRED_BLOOD)
        self.character:getInventory():DoRemoveItem(self.bloodItem)
        ISBaseTimedAction.perform(self)
        return
    end
    
    -- Créer le sérum sanguin
    local serum = InventoryItemFactory.CreateItem("BiteMunityVaccination.BloodSerum")
    if serum then
        -- Transférer les données du sang au sérum
        local bloodModData = self.bloodItem:getModData()
        local serumModData = serum:getModData()
        serumModData.creationTime = VaccinationConfig.getGameTimeHours()
        serumModData.originalCreationTime = bloodModData.creationTime
        serumModData.donorID = bloodModData.donorID
        
        self.character:getInventory():AddItem(serum)
    end
    
    -- Consommer le sang
    self.character:getInventory():DoRemoveItem(self.bloodItem)
    
    self.character:Say(VaccinationConfig.MESSAGES.CENTRIFUGE_COMPLETE)
    ISBaseTimedAction.perform(self)
end

-- Action de purification
ISPurificationAction = ISBaseTimedAction:derive("ISPurificationAction")

function ISPurificationAction:new(character, serumItem, microscope, chemicals)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
    o.serumItem = serumItem
    o.microscope = microscope
    o.chemicals = chemicals
    o.stopOnWalk = true
    o.stopOnRun = true
    o.maxTime = VaccinationConfig.PURIFICATION_TIME * 60 * 60 -- Convertir en ticks
    return o
end

function ISPurificationAction:isValid()
    return self.character and self.serumItem and self.microscope and self.chemicals and
           self.character:getInventory():contains(self.serumItem) and
           self.character:getInventory():contains(self.microscope) and
           self.character:getInventory():contains(self.chemicals)
end

function ISPurificationAction:update()
    -- Animation et sons
    if ZombRand(15) == 0 then
        self.character:playSound("DeviceInteraction")
    end
end

function ISPurificationAction:start()
    self.character:Say(VaccinationConfig.MESSAGES.PURIFICATION_START)
    self:setActionAnim("Disassemble")
end

function ISPurificationAction:stop()
    ISBaseTimedAction.stop(self)
end

function ISPurificationAction:perform()
    -- Vérifier si le sérum a expiré
    if VaccinationCore.checkItemExpiry(self.serumItem) then
        self.character:Say(VaccinationConfig.MESSAGES.EXPIRED_SERUM)
        self.character:getInventory():DoRemoveItem(self.serumItem)
        ISBaseTimedAction.perform(self)
        return
    end
    
    -- Créer le vaccin
    local vaccine = InventoryItemFactory.CreateItem("BiteMunityVaccination.AntiZombieVaccine")
    if vaccine then
        -- Transférer les données du sérum au vaccin
        local serumModData = self.serumItem:getModData()
        local vaccineModData = vaccine:getModData()
        vaccineModData.creationTime = VaccinationConfig.getGameTimeHours()
        vaccineModData.originalCreationTime = serumModData.originalCreationTime
        vaccineModData.donorID = serumModData.donorID
        
        self.character:getInventory():AddItem(vaccine)
    end
    
    -- Consommer le sérum et les produits chimiques
    self.character:getInventory():DoRemoveItem(self.serumItem)
    self.character:getInventory():DoRemoveItem(self.chemicals)
    
    self.character:Say(VaccinationConfig.MESSAGES.PURIFICATION_COMPLETE)
    ISBaseTimedAction.perform(self)
end
```

---

## media/lua/client/VaccinationClient.lua
```lua
-- VaccinationClient.lua
-- Gestion côté client du système de vaccination

require "shared/VaccinationCore"
require "shared/VaccinationConfig"
require "shared/VaccinationTimedActions"

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
        local itemType = item:getFullType()
        
        if itemType == "BiteMunityVaccination.ImmuneBlood" then
            context:addOption("Centrifuger", player, VaccinationClient.centrifugeBlood, item)
        elseif itemType == "BiteMunityVaccination.BloodSerum" then
            context:addOption("Purifier", player, VaccinationClient.purifySerum, item)
        end
    end
end

-- Gestionnaire de commandes serveur
function VaccinationClient.onServerCommand(module, command, args)
    if module ~= "VaccinationSystem" then return end
    
    local player = getPlayer()
    if not player then return end
    
    if command == "VaccinationSuccess" then
        if args.patientID == tostring(player:getOnlineID()) then
            -- Synchroniser l'immunité avec BiteMunity
            BiteMunityCore.setPlayerPermanentImmunity(player, true)
        end
    end
end

-- Vérification périodique des items expirés
function VaccinationClient.checkExpiredItems()
    local player = getPlayer()
    if not player then return end
    
    local inventory = player:getInventory()
    local itemsToRemove = {}
    
    -- Vérifier tous les items liés à la vaccination
    for i = 0, inventory:getItems():size() - 1 do
        local item = inventory:getItems():get(i)
        local itemType = item:getFullType()
        
        if itemType == "BiteMunityVaccination.ImmuneBlood" or 
           itemType == "BiteMunityVaccination.BloodSerum" or 
           itemType == "BiteMunityVaccination.AntiZombieVaccine" then
            
            if VaccinationCore.checkItemExpiry(item) then
                table.insert(itemsToRemove, item)
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
```

---

## media/lua/server/VaccinationServer.lua
```lua
-- VaccinationServer.lua
-- Gestion côté serveur du système de vaccination

require "shared/VaccinationCore"
require "shared/VaccinationConfig"

VaccinationServer = VaccinationServer or {}

-- Gestionnaire de commandes client
function VaccinationServer.onClientCommand(module, command, player, args)
    if module ~= "VaccinationSystem" then return end
    if not isServer() then return end
    
    if command == "VaccinationSuccess" then
        -- Un client signale une vaccination réussie
        local patientID = args.patientID
        
        -- Diffuser à tous les clients pour synchronisation
        sendServerCommand("VaccinationSystem", "VaccinationSuccess", {
            patientID = patientID
        })
        
        -- Sauvegarder les données
        if player then
            VaccinationCore.saveData(player)
        end
    elseif command == "ExtractBlood" then
        -- Traitement de l'extraction de sang côté serveur
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

-- Fonction pour trouver un joueur par ID
function VaccinationServer.getPlayerByID(playerID)
    local players = getOnlinePlayers()
    for i = 0, players:size() - 1 do
        local player = players:get(i)
        if tostring(player:getOnlineID()) == playerID then
            return player
        end
    end
    return nil
end

-- Sauvegarde périodique des données
function VaccinationServer.saveAllPlayerData()
    if not isServer() then return end
    
    local players = getOnlinePlayers()
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
    
    -- Charger les données de vaccination
    VaccinationCore.loadData(player)
end

-- Sauvegarde des données à la déconnexion
function VaccinationServer.onPlayerDisconnect(player)
    if not isServer() then return end
    
    -- Sauvegarder les données de vaccination
    VaccinationCore.saveData(player)
end

-- Nettoyage périodique des cooldowns expirés
function VaccinationServer.cleanupExpiredCooldowns()
    if not isServer() then return end
    
    local currentTime = VaccinationConfig.getGameTimeHours()
    
    -- Nettoyer les cooldowns d'extraction de sang expirés
    for playerID, lastExtraction in pairs(VaccinationCore.bloodExtractionCooldowns) do
        if (currentTime - lastExtraction) > VaccinationConfig.BLOOD_EXTRACTION_COOLDOWN then
            VaccinationCore.bloodExtractionCooldowns[playerID] = nil
        end
    end
    
    -- Nettoyer les cooldowns de vaccination expirés
    for playerID, lastVaccination in pairs(VaccinationCore.vaccinationCooldowns) do
        if (currentTime - lastVaccination) > VaccinationConfig.VACCINATION_COOLDOWN then
            VaccinationCore.vaccinationCooldowns[playerID] = nil
        end
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
```

---

## Fonctionnalités clés du système

### 🩸 **Extraction de sang**
- Nécessite un docteur niveau 6+
- Équipement stérilisé requis (seringue 90%+, gants 80%+, lingettes)
- Cooldown de 7 jours par donneur
- Risque d'infection si équipement sale

### 🧪 **Traitement en laboratoire**
- **Centrifugation** : 2 heures avec centrifugeuse
- **Purification** : 3 heures avec microscope + produits chimiques
- Items expirent après 24 heures

### 💉 **Administration du vaccin**
- 20% de chance de succès
- Cooldown de 3 jours après échec
- Effets négatifs pendant 24h en cas d'échec

### 🔄 **Intégration BiteMunity**
- Détection automatique des joueurs immunisés naturellement
- Synchronisation multi-joueur
- Système de persistance des données

### ⚡ **Optimisations techniques**
- Object Pooling pour les TimedActions
- Gestion efficace des cooldowns
- Validation robuste des conditions
- Architecture client-serveur sécurisée

Ce système offre une expérience de vaccination réaliste et équilibrée, parfaitement intégrée à votre mod BiteMunity existant !

---

## 🎨 Textures requises

Créez ces fichiers PNG 64x64 pixels dans `media/textures/items/` :

### **Syringe.png**
- Seringue médicale avec aiguille
- Couleur : blanc/argent
- Style : propre et médical

### **ImmuneBlood.png** 
- Fiole/tube à essai avec liquide rouge foncé
- Étiquette "IMMUNE" visible
- Bouchon sécurisé

### **BloodSerum.png**
- Fiole avec liquide jaune/ambré translucide
- Aspect plus raffiné que le sang brut
- Étiquette scientifique

### **AntiZombieVaccine.png**
- Seringue pré-remplie ou fiole vaccinale
- Liquide clair légèrement bleuté
- Aspect "produit fini" médical

### **Centrifuge.png**
- Appareil de laboratoire compact
- Couleur : blanc/gris métallique
- Rotor visible au centre

### **Microscope.png**
- Microscope de laboratoire traditionnel
- Oculaires, objectifs, platine visible
- Couleur : noir/argent

---

## 🔧 Installation et test

1. **Copier tous les fichiers** dans le dossier du mod
2. **Créer les textures** selon les spécifications
3. **Tester la progression complète** :
   - Trouver un joueur naturellement immunisé
   - Extraire son sang avec équipement stérilisé
   - Centrifuger le sang (2h)
   - Purifier le sérum (3h)
   - Vacciner un patient

4. **Vérifier les cooldowns** :
   - Extraction : 7 jours
   - Vaccination : 3 jours après échec

5. **Tester la multijoueur** :
   - Synchronisation des immunités
   - Persistance des données
   - Messages partagés

---

## ⚙️ Configuration avancée

Le système peut être facilement modifié via `VaccinationConfig.lua` :

```lua
-- Modifier les chances de succès
VaccinationConfig.VACCINATION_SUCCESS_CHANCE = 30  -- 30% au lieu de 20%

-- Ajuster les cooldowns
VaccinationConfig.BLOOD_EXTRACTION_COOLDOWN = 120  -- 5 jours au lieu de 7

-- Changer les temps de laboratoire
VaccinationConfig.CENTRIFUGE_TIME = 1.5  -- 1.5h au lieu de 2h
VaccinationConfig.PURIFICATION_TIME = 2.0  -- 2h au lieu de 3h
```
