-- media/lua/client/debug_vaccination.lua
-- Script de debug pour vérifier si les items se chargent correctement

VaccinationDebug = VaccinationDebug or {}

function VaccinationDebug.testItemsExist()
    print("[VaccinationDebug] === TEST DES ITEMS ===")

    local itemsToTest = {
        "BiteMunityVaccination.MedicalSyringe",
        "BiteMunityVaccination.SterilizedSyringe",
        "BiteMunityVaccination.ImmuneBlood",
        "BiteMunityVaccination.BloodSerum",
        "BiteMunityVaccination.AntiZombieVaccine",
        "BiteMunityVaccination.Centrifuge",
        "BiteMunityVaccination.LabMicroscope",
        "BiteMunityVaccination.ChemicalReagents",
        "BiteMunityVaccination.DisinfectantAlcohol"
    }

    for _, itemType in ipairs(itemsToTest) do
        local item = InventoryItemFactory.CreateItem(itemType)
        if item then
            print("[VaccinationDebug] ✓ Item trouvé: " .. itemType .. " - " .. item:getDisplayName())
        else
            print("[VaccinationDebug] ✗ Item MANQUANT: " .. itemType)
        end
    end

    print("[VaccinationDebug] === FIN DU TEST ===")
end

function VaccinationDebug.spawnTestItems()
    local player = getPlayer()
    if not player then
        print("[VaccinationDebug] Aucun joueur trouvé")
        return
    end

    local inventory = player:getInventory()

    local itemsToSpawn = {
        "BiteMunityVaccination.MedicalSyringe",
        "BiteMunityVaccination.SterilizedSyringe",
        "BiteMunityVaccination.Centrifuge",
        "BiteMunityVaccination.LabMicroscope",
        "BiteMunityVaccination.ChemicalReagents",
        "BiteMunityVaccination.DisinfectantAlcohol"
    }

    print("[VaccinationDebug] Ajout des items de test...")

    for _, itemType in ipairs(itemsToSpawn) do
        local item = InventoryItemFactory.CreateItem(itemType)
        if item then
            inventory:AddItem(item)
            print("[VaccinationDebug] ✓ Ajouté: " .. itemType)
        else
            print("[VaccinationDebug] ✗ Impossible d'ajouter: " .. itemType)
        end
    end
end

function VaccinationDebug.testBiteMunityIntegration()
    print("[VaccinationDebug] === TEST INTEGRATION BITEMUNITY ===")

    if BiteMunityCore then
        print("[VaccinationDebug] ✓ BiteMunityCore chargé")

        local player = getPlayer()
        if player then
            local isImmune = BiteMunityCore.isPlayerPermanentlyImmune(player)
            print("[VaccinationDebug] Statut immunité joueur: " .. tostring(isImmune))
        end
    else
        print("[VaccinationDebug] ✗ BiteMunityCore NON CHARGÉ - Vérifiez que BiteMunity est activé")
    end

    if VaccinationCore then
        print("[VaccinationDebug] ✓ VaccinationCore chargé")
    else
        print("[VaccinationDebug] ✗ VaccinationCore NON CHARGÉ")
    end

    print("[VaccinationDebug] === FIN TEST INTEGRATION ===")
end

-- Commande pour tester via debug console
function VaccinationDebug.init()
    -- Tester au démarrage du jeu
    Events.OnGameStart.Add(function()
        -- Attendre un peu que tout soit chargé
        Events.OnTick.Add(function()
            VaccinationDebug.testItemsExist()
            VaccinationDebug.testBiteMunityIntegration()
            Events.OnTick.Remove(VaccinationDebug.testItemsExist)
        end)
    end)

    print("[VaccinationDebug] Module de debug initialisé")
    print("[VaccinationDebug] Utilisez les commandes suivantes dans la console de debug:")
    print("[VaccinationDebug] - VaccinationDebug.testItemsExist() pour tester les items")
    print("[VaccinationDebug] - VaccinationDebug.spawnTestItems() pour obtenir les items")
    print("[VaccinationDebug] - VaccinationDebug.testBiteMunityIntegration() pour tester l'intégration")
end

-- Initialiser le debug
VaccinationDebug.init()