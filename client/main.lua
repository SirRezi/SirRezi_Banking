local ox_target = exports.ox_target

CreateThread(function()
    for _, bank in pairs(Config.Banks) do
        if bank.blip then
            local blip = AddBlipForCoord(bank.coords.x, bank.coords.y, bank.coords.z)
            SetBlipSprite(blip, bank.blip.sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, bank.blip.scale)
            SetBlipColour(blip, bank.blip.color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(bank.blip.name)
            EndTextCommandSetBlipName(blip)
        end

        if bank.ped then
            lib.requestModel(bank.ped.model)
            local ped = CreatePed(4, GetHashKey(bank.ped.model), bank.coords.x, bank.coords.y, bank.coords.z, bank.heading, false, true)
            SetEntityHeading(ped, bank.heading)
            FreezeEntityPosition(ped, true)
            SetEntityInvincible(ped, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
            TaskStartScenarioInPlace(ped, bank.ped.scenario, 0, true)

            ox_target:addLocalEntity(ped, {
                {
                    name = 'open_bank',
                    icon = 'fa-solid fa-building-columns',
                    label = 'Open Bank',
                    onSelect = function()
                        OpenBankUI()
                    end
                }
            })
        end
    end
end)

ox_target:addModel(Config.ATMModels, {
    {
        name = 'access_atm',
        icon = 'fa-solid fa-money-bill',
        label = 'Use ATM',
        onSelect = function()
            OpenBankUI(true)
        end
    }
})

function OpenBankUI(isAtm)
    local playerData = ESX.GetPlayerData()
    local accounts = playerData.accounts
    local cash = 0
    local bank = 0

    for _, acc in pairs(accounts) do
        if acc.name == 'money' then cash = acc.money end
        if acc.name == 'bank' then bank = acc.money end
    end

    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'open',
        data = {
            isAtm = isAtm,
            name = playerData.firstName .. ' ' .. playerData.lastName,
            job = playerData.job.label .. ' - ' .. playerData.job.grade_label,
            cash = cash,
            bank = bank,
            identifier = playerData.identifier
        }
    })
end

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('deposit', function(data, cb)
    TriggerServerEvent('sirrezi_banking:deposit', data.amount)
    cb('ok')
end)

RegisterNUICallback('withdraw', function(data, cb)
    TriggerServerEvent('sirrezi_banking:withdraw', data.amount)
    cb('ok')
end)

RegisterNUICallback('transfer', function(data, cb)
    TriggerServerEvent('sirrezi_banking:transfer', data.target, data.amount)
    cb('ok')
end)

RegisterNetEvent('sirrezi_banking:updateUI')
AddEventHandler('sirrezi_banking:updateUI', function(data)
    SendNUIMessage({
        action = 'update',
        data = data
    })
end)
