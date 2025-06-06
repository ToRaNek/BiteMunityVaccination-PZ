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
    o.maxTime = VaccinationConfig.CENTRIFUGE_TIME * 60 * 60 -- Convertir en ticks (1 heure = 3600 ticks)
    if o.character then
        o.jobType = getText("ContextMenu_Centrifuge") or "Centrifuger"
    end
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
        getSoundManager():PlaySound("DeviceInteraction", false, 0.3)
    end
end

function ISCentrifugeAction:start()
    if self.character and self.character.Say then
        self.character:Say(VaccinationConfig.MESSAGES.CENTRIFUGE_START)
    end
    self:setActionAnim("Disassemble")
end

function ISCentrifugeAction:stop()
    ISBaseTimedAction.stop(self)
end

function ISCentrifugeAction:perform()
    -- Vérifier si le sang a expiré
    if VaccinationCore.checkItemExpiry(self.bloodItem) then
        if self.character and self.character.Say then
            self.character:Say(VaccinationConfig.MESSAGES.EXPIRED_BLOOD)
        end
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
        serumModData.originalCreationTime = bloodModData.creationTime or VaccinationConfig.getGameTimeHours()
        serumModData.donorID = bloodModData.donorID
        
        self.character:getInventory():AddItem(serum)
    end
    
    -- Consommer le sang
    self.character:getInventory():DoRemoveItem(self.bloodItem)
    
    if self.character and self.character.Say then
        self.character:Say(VaccinationConfig.MESSAGES.CENTRIFUGE_COMPLETE)
    end
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
    if o.character then
        o.jobType = getText("ContextMenu_Purify") or "Purifier"
    end
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
        getSoundManager():PlaySound("DeviceInteraction", false, 0.3)
    end
end

function ISPurificationAction:start()
    if self.character and self.character.Say then
        self.character:Say(VaccinationConfig.MESSAGES.PURIFICATION_START)
    end
    self:setActionAnim("Disassemble")
end

function ISPurificationAction:stop()
    ISBaseTimedAction.stop(self)
end

function ISPurificationAction:perform()
    -- Vérifier si le sérum a expiré
    if VaccinationCore.checkItemExpiry(self.serumItem) then
        if self.character and self.character.Say then
            self.character:Say(VaccinationConfig.MESSAGES.EXPIRED_SERUM)
        end
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
        vaccineModData.originalCreationTime = serumModData.originalCreationTime or VaccinationConfig.getGameTimeHours()
        vaccineModData.donorID = serumModData.donorID
        
        self.character:getInventory():AddItem(vaccine)
    end
    
    -- Consommer le sérum et les produits chimiques
    self.character:getInventory():DoRemoveItem(self.serumItem)
    if self.chemicals and self.chemicals.Use then
        self.chemicals:Use()
    else
        self.character:getInventory():DoRemoveItem(self.chemicals)
    end
    
    if self.character and self.character.Say then
        self.character:Say(VaccinationConfig.MESSAGES.PURIFICATION_COMPLETE)
    end
    ISBaseTimedAction.perform(self)
end