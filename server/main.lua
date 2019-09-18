ESX 						   = nil
local CopsConnected       	   = 0
local PlayersHarvestingKoda    = {}
local PlayersTransformingKoda  = {}
local PlayersSellingKoda       = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function CountCops()
	local xPlayers = ESX.GetPlayers()

	CopsConnected = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			CopsConnected = CopsConnected + 1
		end
	end

	SetTimeout(120 * 1000, CountCops)
end

CountCops()

--kodeina
local function HarvestKoda(source)

	SetTimeout(Config.TimeToFarm, function()
		if PlayersHarvestingKoda[source] then
			local xPlayer = ESX.GetPlayerFromId(source)
			local koda = xPlayer.getInventoryItem('bitcoin')

			if koda.limit ~= -1 and koda.count >= koda.limit then
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text =_U('mochila_full'), style = { ['background-color'] = '#FF0000', ['color']= '#000000' }})
			else
				xPlayer.addInventoryItem('bitcoin', 1)
				HarvestKoda(source)
			end
		end
	end)
end

RegisterServerEvent('esx_bitcoin:startHarvestKoda')
AddEventHandler('esx_bitcoin:startHarvestKoda', function()
	local _source = source

	if not PlayersHarvestingKoda[_source] then
		PlayersHarvestingKoda[_source] = true

		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text =_U('pegar_frutos'), style = { ['background-color'] = '#00FF00', ['color']= '#000000' }})
		HarvestKoda(_source)
	else
		print(('esx_bitcoin: %s adlı oyuncuyu sistemi bozmaya çalıştı!'):format(GetPlayerIdentifiers(_source)[1]))
	end
end)

RegisterServerEvent('esx_bitcoin:stopHarvestKoda')
AddEventHandler('esx_bitcoin:stopHarvestKoda', function()
	local _source = source

	PlayersHarvestingKoda[_source] = false
end)

local function TransformKoda(source)

	SetTimeout(Config.TimeToProcess, function()
		if PlayersTransformingKoda[source] then
			local xPlayer = ESX.GetPlayerFromId(source)
			local kodaQuantity = xPlayer.getInventoryItem('bitcoin').count
			local pooch = xPlayer.getInventoryItem('bitcoin')

			if pooch.limit ~= -1 and pooch.count >= pooch.limit then
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text =_U('nao_tens_frutos_suficientes'), style = { ['background-color'] = '#FF0000', ['color']= '#000000' }})
			elseif kodaQuantity < 2 then
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text =_U('nao_tens_mais_frutos'), style = { ['background-color'] = '#FF0000', ['color']= '#000000' }})
			else
				xPlayer.removeInventoryItem('bitcoin', 2)
				xPlayer.addInventoryItem('bitcoin', 1)

				TransformKoda(source)
			end
		end
	end)
end

RegisterServerEvent('esx_bitcoin:startTransformKoda')
AddEventHandler('esx_bitcoin:startTransformKoda', function()
	local _source = source

	if not PlayersTransformingKoda[_source] then
		PlayersTransformingKoda[_source] = true

		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text =_U('colocar_frutos_dentro_dos_sacos'), style = { ['background-color'] = '#ffffff', ['color']= '#000000' }})
		TransformKoda(_source)
	else
		print(('esx_bitcoin: %s attempted to exploit the marker!'):format(GetPlayerIdentifiers(_source)[1]))
	end
end)

RegisterServerEvent('esx_bitcoin:stopTransformKoda')
AddEventHandler('esx_bitcoin:stopTransformKoda', function()
	local _source = source

	PlayersTransformingKoda[_source] = false
end)

local function SellKoda(source)

	SetTimeout(Config.TimeToSell, function()
		if PlayersSellingKoda[source] then
			local xPlayer = ESX.GetPlayerFromId(source)
			local poochQuantity = xPlayer.getInventoryItem('bitcoin').count

			if poochQuantity == 0 then
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text =_U('nao_tens_sacos_com_frutos'), style = { ['background-color'] = '#ffffff', ['color']= '#000000' }})
			else
				xPlayer.removeInventoryItem('bitcoin', 1)
				if CopsConnected == 0 then
					xPlayer.addAccountMoney('black_money', 100)
					TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text =_U('vendeste_sacos'), style = { ['background-color'] = '#00FF00', ['color']= '#000000' }})
				elseif CopsConnected == 1 then
					xPlayer.addAccountMoney('black_money', 110)
					TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text =_U('vendeste_sacos'), style = { ['background-color'] = '#00FF00', ['color']= '#000000' }})
				elseif CopsConnected == 2 then
					xPlayer.addAccountMoney('black_money', 120)
					TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text =_U('vendeste_sacos'), style = { ['background-color'] = '#00FF00', ['color']= '#000000' }})
				elseif CopsConnected == 3 then
					xPlayer.addAccountMoney('black_money', 130)
					TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text =_U('vendeste_sacos'), style = { ['background-color'] = '#00FF00', ['color']= '#000000' }})
				elseif CopsConnected == 4 then
					xPlayer.addAccountMoney('black_money', 140)
					TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text =_U('vendeste_sacos'), style = { ['background-color'] = '#00FF00', ['color']= '#000000' }})
				elseif CopsConnected >= 5 then
					xPlayer.addAccountMoney('black_money', 150)
					TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text =_U('vendeste_sacos'), style = { ['background-color'] = '#00FF00', ['color']= '#000000' }})
				end

				SellKoda(source)
			end
		end
	end)
end

RegisterServerEvent('esx_bitcoin:startSellKoda')
AddEventHandler('esx_bitcoin:startSellKoda', function()
	local _source = source

	if not PlayersSellingKoda[_source] then
		PlayersSellingKoda[_source] = true

		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text =_U('venda_do_sacos'), style = { ['background-color'] = '#ffffff', ['color']= '#000000' }})
		SellKoda(_source)
	else
		print(('esx_bitcoin: %s adlı oyuncu sistemi bozmaya çalıştı!'):format(GetPlayerIdentifiers(_source)[1]))
	end
end)

RegisterServerEvent('esx_bitcoin:stopSellKoda')
AddEventHandler('esx_bitcoin:stopSellKoda', function()
	local _source = source

	PlayersSellingKoda[_source] = false
end)

RegisterServerEvent('esx_bitcoin:GetUserInventory')
AddEventHandler('esx_bitcoin:GetUserInventory', function(currentZone)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	TriggerClientEvent('esx_bitcoin:ReturnInventory',
		_source,
		xPlayer.getInventoryItem('bitcoin').count,
		xPlayer.getInventoryItem('bitcoin').count,
		xPlayer.job.name,
		currentZone
	)
end)

ESX.RegisterUsableItem('bitcoin', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('bitcoin', 1)

	TriggerClientEvent('esx_bitcoin:onPot', _source)
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text =_U('used_one_koda'), style = { ['background-color'] = '#ffffff', ['color']= '#000000' }})
end)
