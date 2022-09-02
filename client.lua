local inClothingShop = false
local inBarberShop   = false 
local inTattooShop   = false
local allMyOutfits   = {}

if not ESX then
	Citizen.CreateThread(function()
		while ESX == nil do
			TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
			Citizen.Wait(0)
		end
		
		while ESX.GetPlayerData().job == nil do
			Citizen.Wait(10)
		end
	
		ESX.PlayerData = ESX.GetPlayerData()
	end)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

Citizen.CreateThread(function()
	for k, v in pairs(Config.Shops) do

		if v.blip == true then
			local blip = AddBlipForCoord(vector3(v.x, v.y, v.z))

			SetBlipSprite (blip, v.blipSprite)
			SetBlipColour (blip, v.blipColour)
			SetBlipScale (blip, 0.7)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName('STRING')
			AddTextComponentSubstringPlayerName(v.type)

			EndTextCommandSetBlipName(blip)
		end
  
		exports["bt-polyzone"]:AddBoxZone(v.name,vector3(v.x, v.y, v.z), v.l, v.w, {
			name = v.name,
			heading = v.h,
			debugPoly = false,
			minZ = v.minZ,
			maxZ = v.maxZ
		})
	end
end)

RegisterNetEvent('bt-polyzone:enter')
AddEventHandler('bt-polyzone:enter', function(name)
	for k, v in pairs(Config.Shops) do
        if v.name == name then
			if v.type == "Clothing Shop" then
				if v.job ~= nil then
					for k2, v2 in pairs(v.job) do
						if v2 == ESX.PlayerData.job.name then
							inClothingShop = true
							TriggerEvent('fivem-appearance:inShop')
							break
						end
					end
				else 
					inClothingShop = true
					TriggerEvent('fivem-appearance:inShop')
				end
			elseif v.type == "Barber Shop" then
				inBarberShop = true
				TriggerEvent('fivem-appearance:inShop')
			elseif v.type == "Tattoo Shop" then
				inTattooShop = true
				TriggerEvent('fivem-appearance:inShop')
			end
            break
        end
    end
end)

RegisterNetEvent('bt-polyzone:exit')
AddEventHandler('bt-polyzone:exit', function(name)
	for k, v in pairs(Config.Shops) do
        if v.name == name then
			if v.type == "Clothing Shop" then
				inClothingShop = false
				TriggerEvent('cd_drawtextui:HideUI')
			elseif v.type == "Barber Shop" then
				inBarberShop = false
				TriggerEvent('cd_drawtextui:HideUI')
			elseif v.type == "Tattoo Shop" then
				inTattooShop = false
				TriggerEvent('cd_drawtextui:HideUI')
			end
            break
        end
    end
end)

RegisterNetEvent('fivem-appearance:inShop')
AddEventHandler('fivem-appearance:inShop', function()
	if inClothingShop then
		TriggerEvent('cd_drawtextui:ShowUI', 'show', "[E] Change Clothing")
	elseif inBarberShop then
		TriggerEvent('cd_drawtextui:ShowUI', 'show', "[E] Change Hair/Face")
	elseif inTattooShop then
		TriggerEvent('cd_drawtextui:ShowUI', 'show', "[E] Change Tattoos")
	end
	while inClothingShop or inBarberShop or inTattooShop do
		Citizen.Wait(0)
		if IsControlPressed(1, 38) then
			Citizen.Wait(500)
			if inClothingShop then
				TriggerEvent("fivem-appearance:clothingShop")
			end
			if inTattooShop then
				TriggerEvent("fivem-appearance:tattooMenu")
			end
			if inBarberShop then
				TriggerEvent('cd_drawtextui:HideUI')
				local config = {
					ped = true,
					headBlend = true,
					faceFeatures = true,
					headOverlays = true,
					components = false,
					props = false,
					tattoos = false
				}
				exports['fivem-appearance']:startPlayerCustomization(function (appearance)
					if (appearance) then
						TriggerServerEvent('esx_skin:save', appearance)
						-- print(appearance)
						print('Saved')
					else
						print('Canceled')
					end
					TriggerEvent('cd_drawtextui:ShowUI', 'show', "[E] Change Hair/Face")
				end, config)
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
		ped = true,
		headBlend = false,
		faceFeatures = false,
		headOverlays = false,
		components = true,
		props = true,
    	tattoos = false
	}
	
	exports['fivem-appearance']:startPlayerCustomization(function (appearance)
		if (appearance) then
			TriggerServerEvent('esx_skin:save', appearance)
			-- print(appearance)
			print('Saved')
		else
			print('Canceled')
		end
	end, config)
end)

RegisterNetEvent('fivem-appearance:tattooMenu', function()
	local config = {
		ped = false,
		headBlend = false,
		faceFeatures = false,
		headOverlays = false,
		components = false,
		props = false,
    	tattoos = true
	}
	
	exports['fivem-appearance']:startPlayerCustomization(function (appearance)
		if (appearance) then
			local tattoos = exports['fivem-appearance']:getPedTattoos(PlayerPedId())
			TriggerServerEvent('esx_skin:save', appearance, tattoos)
			-- print(appearance)
			print('Saved')
		else
			print('Canceled')
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
		TriggerServerEvent('esx_skin:save', appearance)
	else
		exports['fivem-appearance']:setPedComponents(playerPed, pedComponents)
		exports['fivem-appearance']:setPedProps(playerPed, pedProps)
		local appearance = exports['fivem-appearance']:getPedAppearance(playerPed)
		TriggerServerEvent('esx_skin:save', appearance)
	end
end)

RegisterNetEvent('fivem-appearance:saveOutfit', function()
	local keyboard = exports["nh-keyboard"]:KeyboardInput({
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

RegisterNetEvent('fivem-appearance:useWardrobe')
AddEventHandler('fivem-appearance:useWardrobe', function()
	TriggerEvent('fivem-appearance:getOutfits')
    TriggerEvent('nh-context:sendMenu', {
        {
            id = 1,
            header = "Outfits",
            txt = "",
            params = {
                -- event = "fivem-appearance:clothingShop"
            }
        },
    })
	Citizen.Wait(300)
	for i=1, #allMyOutfits, 1 do
		TriggerEvent('nh-context:sendMenu', {
			{
				id = (i + 1),
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

-- Add compatibility with skinchanger and esx_skin TriggerEvents
RegisterNetEvent('skinchanger:loadSkin')
AddEventHandler('skinchanger:loadSkin', function(skin, cb)
	if not skin.model then skin.model = 'mp_m_freemode_01' end
	local playerPed = PlayerPedId()
	Citizen.Wait(500)
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
		props = true,
    	tattoos = false
	}
	
	exports['fivem-appearance']:startPlayerCustomization(function (appearance)
		if (appearance) then
			TriggerServerEvent('esx_skin:save', appearance)
			-- print(appearance)
			if submitCb() ~= nil then submitCb() end
		elseif cancelCb ~= nil then
			cancelCb()
		end
	end, config)
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