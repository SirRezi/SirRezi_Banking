print('^2[SirRezi_Banking] ^7Successfully loaded v1.0.0')

RegisterNetEvent('sirrezi_banking:deposit')
AddEventHandler('sirrezi_banking:deposit', function(amount)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    amount = tonumber(amount)

    if amount and amount > 0 then
        if xPlayer.getMoney() >= amount then
            xPlayer.removeMoney(amount)
            xPlayer.addAccountMoney('bank', amount)
            TriggerClientEvent('ox_lib:notify', source, {type = 'success', description = 'Deposited $' .. amount})
            UpdateClientUI(source)
        else
            TriggerClientEvent('ox_lib:notify', source, {type = 'error', description = 'Not enough cash'})
        end
    end
end)

RegisterNetEvent('sirrezi_banking:withdraw')
AddEventHandler('sirrezi_banking:withdraw', function(amount)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    amount = tonumber(amount)

    if amount and amount > 0 then
        if xPlayer.getAccount('bank').money >= amount then
            xPlayer.removeAccountMoney('bank', amount)
            xPlayer.addMoney(amount)
            TriggerClientEvent('ox_lib:notify', source, {type = 'success', description = 'Withdrew $' .. amount})
            UpdateClientUI(source)
        else
            TriggerClientEvent('ox_lib:notify', source, {type = 'error', description = 'Not enough money in bank'})
        end
    end
end)

RegisterNetEvent('sirrezi_banking:transfer')
AddEventHandler('sirrezi_banking:transfer', function(targetId, amount)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(targetId)
    amount = tonumber(amount)

    if not xTarget then
        TriggerClientEvent('ox_lib:notify', source, {type = 'error', description = 'Player not found'})
        return
    end

    if amount and amount > 0 then
        if xPlayer.getAccount('bank').money >= amount then
            xPlayer.removeAccountMoney('bank', amount)
            xTarget.addAccountMoney('bank', amount)

            TriggerClientEvent('ox_lib:notify', source, {type = 'success', description = 'Transferred $' .. amount .. ' to ' .. xTarget.getName()})
            TriggerClientEvent('ox_lib:notify', targetId, {type = 'success', description = 'Received $' .. amount .. ' from ' .. xPlayer.getName()})

            UpdateClientUI(source)
            UpdateClientUI(targetId)
        else
            TriggerClientEvent('ox_lib:notify', source, {type = 'error', description = 'Not enough money in bank'})
        end
    end
end)

function UpdateClientUI(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local cash = xPlayer.getMoney()
        local bank = xPlayer.getAccount('bank').money
        TriggerClientEvent('sirrezi_banking:updateUI', source, {
            cash = cash,
            bank = bank
        })
    end
end
