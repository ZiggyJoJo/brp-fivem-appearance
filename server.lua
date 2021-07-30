if not ESX then TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) end

RegisterServerEvent('fivem-appearance:save')
AddEventHandler('fivem-appearance:save', function(appearance)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE users SET skin = @skin WHERE identifier = @identifier', {
		['@skin'] = json.encode(appearance),
		['@identifier'] = xPlayer.identifier
	})
end)

ESX.RegisterServerCallback('fivem-appearance:getPlayerSkin', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT skin FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(users)
		local user, appearance = users[1]
		if user.skin then
			appearance = json.decode(user.skin)
		end
		cb(appearance)
	end)
end)

ESX.RegisterServerCallback('esx_skin:getPlayerSkin', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT skin FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(users)
		local user, appearance = users[1]
		if user.skin then
			appearance = json.decode(user.skin)
		end
		cb(appearance)
	end)
end)

RegisterServerEvent("fivem-appearance:saveOutfit")
AddEventHandler("fivem-appearance:saveOutfit", function(name, pedModel, pedComponents, pedProps)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.insert('INSERT INTO `outfits` (`identifier`, `name`, `ped`, `components`, `props`) VALUES (@identifier, @name, @ped, @components, @props)', {
		['@ped'] = json.encode(pedModel),
		['@components'] = json.encode(pedComponents),
		['@props'] = json.encode(pedProps),
		['@name'] = name,
		['@identifier'] = xPlayer.identifier
	})
end)

RegisterServerEvent("fivem-appearance:getOutfit")
AddEventHandler("fivem-appearance:getOutfit", function(name)
	local xPlayer = ESX.GetPlayerFromId(source)
	local oSource = source

	MySQL.Async.fetchScalar('SELECT outfit FROM outfits WHERE identifier = @identifier AND name = @name', {
		['@identifier'] = xPlayer.identifier,
		['@name'] = name
	}, function(outfit)
		local newOutfit = outfit
		if newOutfit then
			newOutfit = json.decode(newOutfit)
			TriggerClientEvent('fivem-appearance:setOutfit', oSource, newOutfit)
		end
	end)
end)

RegisterServerEvent("fivem-appearance:getOutfits")
AddEventHandler("fivem-appearance:getOutfits", function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local oSource = source
	local myOutfits = {}

	MySQL.Async.fetchAll('SELECT id, name, ped, components, props FROM outfits WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		for i=1, #result, 1 do
			table.insert(myOutfits, {id = result[i].id, name = result[i].name, ped = json.decode(result[i].ped), components = json.decode(result[i].components), props = json.decode(result[i].props)})
		end
		TriggerClientEvent('fivem-appearance:sendOutfits', oSource, myOutfits)
	end)
end)

RegisterServerEvent("fivem-appearance:deleteOutfit")
AddEventHandler("fivem-appearance:deleteOutfit", function(id)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('DELETE FROM `outfits` WHERE `id` = @id', {
		['@id'] = id
	})
end)