local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local hasAlreadyEnteredMarker = false
local allMyOutfits = {}

if not ESX then
	Citizen.CreateThread(function()
		while ESX == nil do
			TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
			Citizen.Wait(0)
		end
	end)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerLoaded = true
end)

-- RegisterCommand('reloadskin', function()
-- 	ESX.TriggerServerCallback('fivem-appearance:getPlayerSkin', function(appearance)
-- 		exports['fivem-appearance']:setPlayerAppearance(appearance)
-- 	end)
-- end)

-- RegisterCommand('customization', function()
-- 	local config = {
-- 		ped = true,
-- 		headBlend = true,
-- 		faceFeatures = true,
-- 		headOverlays = true,
-- 		components = true,
-- 		props = true,
-- 	}
-- 	exports['fivem-appearance']:startPlayerCustomization(function (appearance)
-- 		if (appearance) then
-- 			TriggerServerEvent('fivem-appearance:save', appearance)
-- 			print('Saved')
-- 		else
-- 			print('Canceled')
-- 		end
-- 	end, config)
-- end, false)


Citizen.CreateThread(function()
	for k,v in ipairs(Config.ClothingShops) do
		local data = v
		if data.blip == true then
			local blip = AddBlipForCoord(data.coords)

			SetBlipSprite (blip, 73)
			SetBlipColour (blip, 47)
			SetBlipScale (blip, 0.7)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName('STRING')
			AddTextComponentSubstringPlayerName('Clothing Shop')
			EndTextCommandSetBlipName(blip)
		end
	end
end)

Citizen.CreateThread(function()
	for k,v in ipairs(Config.BarberShops) do
		local blip = AddBlipForCoord(v)

		SetBlipSprite (blip, 71)
		SetBlipColour (blip, 47)
		SetBlipScale (blip, 0.7)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName('Barber Shop')
		EndTextCommandSetBlipName(blip)
	end
end)

Citizen.CreateThread(function()
	while true do
		local playerCoords, isInClothingShop, isInBarberShop, currentZone, letSleep = GetEntityCoords(PlayerPedId()), false, false, nil, true
		local sleep = 2000
		for k,v in pairs(Config.ClothingShops) do
			local data = v
			local distance = #(playerCoords - data.coords)

			if distance < Config.DrawDistance then
				sleep = 0
				if distance < data.MarkerSize.x then
					isInClothingShop, currentZone = true, k
				end
			end
		end

		for k,v in pairs(Config.BarberShops) do
			local distance = #(playerCoords - v)

			if distance < Config.DrawDistance then
				sleep = 0
				if distance < Config.MarkerSize.x then
					isInBarberShop, currentZone = true, k
				end
			end
		end

		if (isInClothingShop and not hasAlreadyEnteredMarker) or (isInClothingShop and LastZone ~= currentZone) then
			hasAlreadyEnteredMarker, LastZone = true, currentZone
			CurrentAction     = 'clothingMenu'
			TriggerEvent('cd_drawtextui:ShowUI', 'show', "Press [E] To Change Clothing")
		end

		if (isInBarberShop and not hasAlreadyEnteredMarker) or (isInBarberShop and LastZone ~= currentZone) then
			hasAlreadyEnteredMarker, LastZone = true, currentZone
			CurrentAction     = 'barberMenu'
			TriggerEvent('cd_drawtextui:ShowUI', 'show', "Press [E] To Change Hair/Face")
		end

		if not isInClothingShop and not isInBarberShop and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			sleep = 1000
			TriggerEvent('fivem-appearance:hasExitedMarker', LastZone)
			TriggerEvent('cd_drawtextui:HideUI')
		end

		Citizen.Wait(sleep)
	end
end)

AddEventHandler('fivem-appearance:hasExitedMarker', function(zone)
	CurrentAction = nil
end)

Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)

		if CurrentAction ~= nil then

			if IsControlPressed(1,  38) then
				Citizen.Wait(500)

				if CurrentAction == 'clothingMenu' then

					TriggerEvent("fivem-appearance:clothingShop")

				end

				if CurrentAction == 'barberMenu' then

					local config = {
						ped = false,
						headBlend = true,
						faceFeatures = true,
						headOverlays = true,
						components = false,
						props = false
					}
					
					exports['fivem-appearance']:startPlayerCustomization(function (appearance)
						if (appearance) then
							TriggerServerEvent('fivem-appearance:save', appearance)
							if Config.UseLegacy then
								ESX.SetPlayerData('ped', PlayerPedId()) -- Fix for esx legacy
							end
						else
							if Config.UseLegacy then
								ESX.SetPlayerData('ped', PlayerPedId()) -- Fix for esx legacy
							end
						end
					end, config)
				end
			end
		end
	end
end)

RegisterNetEvent('fivem-appearance:clothingShop', function()
    TriggerEvent('nh-context:sendMenu', {
        {
            id = 1,
            header = "Change clothing",
            txt = "",
			params = {
				event = "fivem-appearance:clothingMenu"
			}
        },
        {
            id = 2,
            header = "Change Outfit",
            txt = "",
            params = {
                event = "fivem-appearance:pickNewOutfit",
                args = {
                    number = 1,
                    id = 2
                }
            }
        },
		{
            id = 3,
            header = "Save New Outfit",
            txt = "",
			params = {
				event = "fivem-appearance:saveOutfit"
			}
        },
		{
			id = 4,
            header = "Delete Outfit",
            txt = "",
            params = {
                event = "fivem-appearance:deleteOutfitMenu",
                args = {
                    number = 1,
                    id = 2
                }
            }
        }
    })
end)

RegisterNetEvent('fivem-appearance:clothingMenu', function()
	local config = {
		ped = false,
		headBlend = false,
		faceFeatures = false,
		headOverlays = false,
		components = true,
		props = true
	}
	
	exports['fivem-appearance']:startPlayerCustomization(function (appearance)
		if (appearance) then
			TriggerServerEvent('fivem-appearance:save', appearance)
			if Config.UseLegacy then
				ESX.SetPlayerData('ped', PlayerPedId()) -- Fix for esx legacy
			end
		else
			if Config.UseLegacy then
				ESX.SetPlayerData('ped', PlayerPedId()) -- Fix for esx legacy
			end
		end
	end, config)
end)

RegisterNetEvent('fivem-appearance:pickNewOutfit', function(data)
    local id = data.id
    local number = data.number
	TriggerEvent('fivem-appearance:getOutfits')
    TriggerEvent('nh-context:sendMenu', {
        {
            id = 1,
            header = "< Go Back",
            txt = "",
            params = {
                event = "fivem-appearance:clothingShop"
            }
        },
    })
	Citizen.Wait(300)
	for i=1, #allMyOutfits, 1 do
		TriggerEvent('nh-context:sendMenu', {
			{
				id = (1 + i),
				header = allMyOutfits[i].name,
				txt = "",
				params = {
					event = 'fivem-appearance:setOutfit',
					args = {
						ped = allMyOutfits[i].pedModel, 
						components = allMyOutfits[i].pedComponents, 
						props = allMyOutfits[i].pedProps
					}
				}
			},
		})
	end
end)

RegisterNetEvent('fivem-appearance:getOutfits')
AddEventHandler('fivem-appearance:getOutfits', function()
	TriggerServerEvent('fivem-appearance:getOutfits')
end)

RegisterNetEvent('fivem-appearance:sendOutfits')
AddEventHandler('fivem-appearance:sendOutfits', function(myOutfits)
	local Outfits = {}
	for i=1, #myOutfits, 1 do
		table.insert(Outfits, {id = myOutfits[i].id, name = myOutfits[i].name, pedModel = myOutfits[i].ped, pedComponents = myOutfits[i].components, pedProps = myOutfits[i].props})
	end
	allMyOutfits = Outfits
end)

RegisterNetEvent('fivem-appearance:setOutfit')
AddEventHandler('fivem-appearance:setOutfit', function(data)
	local pedModel = data.ped
	local pedComponents = data.components
	local pedProps = data.props
	local playerPed = PlayerPedId()
	local currentPedModel = exports['fivem-appearance']:getPedModel(playerPed)
	if currentPedModel ~= pedModel then
    	exports['fivem-appearance']:setPlayerModel(pedModel)
		Citizen.Wait(500)
		playerPed = PlayerPedId()
		exports['fivem-appearance']:setPedComponents(playerPed, pedComponents)
		exports['fivem-appearance']:setPedProps(playerPed, pedProps)
		local appearance = exports['fivem-appearance']:getPedAppearance(playerPed)
		TriggerServerEvent('fivem-appearance:save', appearance)
		if Config.UseLegacy then
			ESX.SetPlayerData('ped', PlayerPedId()) -- Fix for esx legacy
		end
	else
		exports['fivem-appearance']:setPedComponents(playerPed, pedComponents)
		exports['fivem-appearance']:setPedProps(playerPed, pedProps)
		local appearance = exports['fivem-appearance']:getPedAppearance(playerPed)
		TriggerServerEvent('fivem-appearance:save', appearance)
		if Config.UseLegacy then
			ESX.SetPlayerData('ped', PlayerPedId()) -- Fix for esx legacy
		end
	end
end)

RegisterNetEvent('fivem-appearance:saveOutfit', function()
    if Config.UseNewNHKeyboard then
        local keyboard, name = exports["nh-keyboard"]:Keyboard({
            header = "Name Outfit", 
            rows = {"Outfit name here"}
        })
        if keyboard then
            if name then
                local playerPed = PlayerPedId()
                local pedModel = exports['fivem-appearance']:getPedModel(playerPed)
                local pedComponents = exports['fivem-appearance']:getPedComponents(playerPed)
                local pedProps = exports['fivem-appearance']:getPedProps(playerPed)
                Citizen.Wait(500)
                TriggerServerEvent('fivem-appearance:saveOutfit', name, pedModel, pedComponents, pedProps)
            end
        end
    else
        local keyboard = exports["nh-keyboard"]:Keyboard({
            header = "Name Outfit", 
            rows = {
                {
                    id = 0, 
                    txt = ""
                }
            }
        })
        if keyboard ~= nil then
            local playerPed = PlayerPedId()
            local pedModel = exports['fivem-appearance']:getPedModel(playerPed)
            local pedComponents = exports['fivem-appearance']:getPedComponents(playerPed)
            local pedProps = exports['fivem-appearance']:getPedProps(playerPed)
            Citizen.Wait(500)
            TriggerServerEvent('fivem-appearance:saveOutfit', keyboard[1].input, pedModel, pedComponents, pedProps)
            
        end
    end
end)

RegisterNetEvent('fivem-appearance:deleteOutfitMenu', function(data)
    local id = data.id
    local number = data.number
	TriggerEvent('fivem-appearance:getOutfits')
	Citizen.Wait(150)
    TriggerEvent('nh-context:sendMenu', {
        {
            id = 1,
            header = "< Go Back",
            txt = "",
            params = {
                event = "fivem-appearance:clothingShop"
            }
        },
    })
	for i=1, #allMyOutfits, 1 do
		TriggerEvent('nh-context:sendMenu', {
			{
				id = (1 + i),
				header = allMyOutfits[i].name,
				txt = "",
				params = {
					event = 'fivem-appearance:deleteOutfit',
					args = allMyOutfits[i].id
				}
			},
		})
	end
end)

RegisterNetEvent('fivem-appearance:deleteOutfit')
AddEventHandler('fivem-appearance:deleteOutfit', function(id)
	TriggerServerEvent('fivem-appearance:deleteOutfit', id)
end)

RegisterCommand('propfix', function()
    for k, v in pairs(GetGamePool('CObject')) do
        if IsEntityAttachedToEntity(PlayerPedId(), v) then
            SetEntityAsMissionEntity(v, true, true)
            DeleteObject(v)
            DeleteEntity(v)
        end
    end
end)

-- Add compatibility with skinchanger and esx_skin TriggerEvents
RegisterNetEvent('skinchanger:loadSkin')
AddEventHandler('skinchanger:loadSkin', function(skin, cb)
	if not skin.model then skin.model = 'mp_m_freemode_01' end
	exports['fivem-appearance']:setPlayerAppearance(skin)
	if cb ~= nil then
		cb()
	end
end)

RegisterNetEvent('esx_skin:openSaveableMenu')
AddEventHandler('esx_skin:openSaveableMenu', function(submitCb, cancelCb)
	local config = {
		ped = true,
		headBlend = true,
		faceFeatures = true,
		headOverlays = true,
		components = true,
		props = true
	}
	exports['fivem-appearance']:startPlayerCustomization(function (appearance)
		if (appearance) then
			TriggerServerEvent('fivem-appearance:save', appearance)
			if Config.UseLegacy then
			   ESX.SetPlayerData('ped', PlayerPedId()) -- Fix for esx legacy
			end
			if submitCb then submitCb() end
		else
			if cancelCb then cancelCb() end
			if Config.UseLegacy then
			   ESX.SetPlayerData('ped', PlayerPedId()) -- Fix for esx legacy
			end
		end
	end, config)
end)
