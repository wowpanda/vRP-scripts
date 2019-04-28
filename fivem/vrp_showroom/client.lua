--[[
    FiveM Scripts
    Copyright C 2018  Sighmir

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    at your option any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]


vRP = Proxy.getInterface("vRP")
vRPg = Proxy.getInterface("vRP_garages")

function deleteVehiclePedIsIn()
  local v = GetVehiclePedIsIn(GetPlayerPed(-1),false)
  SetVehicleHasBeenOwnedByPlayer(v,false)
  Citizen.InvokeNative(0xAD738C3085FE7E11, v, false, true) -- set not as mission entity
  SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(v))
  Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(v))
end

local vehshop = {
	opened = false,
	title = "Vehicle Shop",
	currentmenu = "main",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 155, b = 255, a = 200, type = 1 },
	menu = {
		x = 0.1,
		y = 0.08,
		width = 0.2,
		height = 0.04,
		buttons = 10,
		from = 1,
		to = 10,
		scale = 0.4,
		font = 0,
		["main"] = {
			title = "Simeon Showroom",
			name = "main",
			buttons = {
				{name = "vehicles", description = ""},
				{name = "motorcycles", description = ""},
			}
		},
		["vehicles"] = {
			title = "voitures",
			name = "voitures",
			buttons = {
				{name = "compacts", description = ''},
				{name = "coupes", description = ''},
				{name = "sedans", description = ''},
				{name = "sports", description = ''},
				{name = "sportsclassics", description = ''},
				{name = "supers", description = ''},
				{name = "muscle", description = ''},
				{name = "offroad", description = ''},
				{name = "suvs", description = ''},
				{name = "vans", description = ''},
				--{name = "cycles", description = ''},
			}
		},
		["compacts"] = {
			title = "compacts",
			name = "compacts",
			buttons = {
				{name = "Blista", costs = 15000, description = {}, model = "blista"},
				{name = "Brioso R/A", costs = 30000, description = {}, model = "brioso"},
				{name = "Dilettante", costs = 30000, description = {}, model = "Dilettante"},
				{name = "Issi", costs = 50000, description = {}, model = "issi2"},
				{name = "Panto", costs = 40000, description = {}, model = "panto"},
				{name = "Golf R32", costs = 80000, description = {}, model = "elegy"},
				{name = "Prairie", costs = 30000, description = {}, model = "prairie"},
				{name = "Rhapsody", costs = 35000, description = {}, model = "rhapsody"},
			
			}
		},
		["coupes"] = {
			title = "coupes",
			name = "coupes",
			buttons = {
				{name = "Cognoscenti Cabrio", costs = 40000, description = {}, model = "cogcabrio"},
				{name = "Exemplar", costs = 60000, description = {}, model = "exemplar"},
				{name = "F620", costs = 60000, description = {}, model = "f620"},
				{name = "Felon", costs = 65000, description = {}, model = "felon"},
				{name = "Felon GT", costs = 70000, description = {}, model = "felon2"},
				{name = "Jackal", costs = 70000, description = {}, model = "jackal"},
				{name = "Oracle", costs = 80000, description = {}, model = "oracle"},
				{name = "Oracle XS", costs = 85000, description = {}, model = "oracle2"},
				{name = "Sentinel", costs = 45000, description = {}, model = "sentinel"},
				{name = "Sentinel XS", costs = 50000, description = {}, model = "sentinel2"},
				{name = "Windsor", costs = 45000, description = {}, model = "windsor"},
				{name = "Windsor Drop", costs = 50000, description = {}, model = "windsor2"},
				{name = "Zion", costs = 80000, description = {}, model = "zion"},
				{name = "Zion Cabrio", costs = 85000, description = {}, model = "zion2"},
			}
		},
		["sports"] = {
			title = "sports",
			name = "sports",
			buttons = {
				{name = "9F", costs = 150000, description = {}, model = "ninef"},
				{name = "9F Cabrio", costs = 155000, description = {}, model = "ninef2"},
				{name = "Alpha", costs = 70000, description = {}, model = "alpha"},
				{name = "Banshee", costs = 135000, description = {}, model = "banshee"},
				{name = "Bestia GTS", costs = 80000, description = {}, model = "bestiagts"},
				{name = "Blista Compact", costs = 25000, description = {}, model = "blista"},
				{name = "Buffalo", costs = 70000, description = {}, model = "buffalo"},
				{name = "Buffalo S", costs = 90000, description = {}, model = "buffalo2"},
				{name = "Carbonizzare", costs = 125000, description = {}, model = "carbonizzare"},
				{name = "Comet", costs = 125000, description = {}, model = "comet2"},
				{name = "Coquette", costs = 50000, description = {}, model = "coquette"},
				{name = "Drift Tampa", costs = 48000, description = {}, model = "tampa2"},
				{name = "Feltzer", costs = 180000, description = {}, model = "feltzer2"},
				{name = "Furore GT", costs = 90000, description = {}, model = "furoregt"},
				{name = "Kuruma", costs = 85000, description = {}, model = "kuruma"},
				{name = "Massacro", costs = 95000, description = {}, model = "massacro"},
				--{name = "Massacro(Racecar)", costs = 85000, description = {}, model = "massacro2"},
				{name = "Omnis", costs = 150000, description = {}, model = "omnis"},
				{name = "Penumbra", costs = 70000, description = {}, model = "penumbra"},
				{name = "Rapid GT", costs = 75000, description = {}, model = "rapidgt"},
				{name = "Rapid GT Convertible", costs = 80000, description = {}, model = "rapidgt2"},
				{name = "Schafter V12", costs = 56000, description = {}, model = "schafter3"},
				{name = "Sultan", costs = 20000, description = {}, model = "sultan"},
				{name = "Surano", costs = 110000, description = {}, model = "surano"},
				{name = "Tropos", costs = 81000, description = {}, model = "tropos"},
				{name = "Verkierer", costs = 135000, description = {}, model = "verlierer2"},
			}
		},
		["sportsclassics"] = {
			title = "sportsclassics",
			name = "sportsclassics",
			buttons = {
				{name = "Casco", costs = 100000, description = {}, model = "casco"},--------------------------------------------
				{name = "Coquette Classic", costs = 140500, description = {}, model = "coquette2"},
				{name = "JB 700", costs = 100000, description = {}, model = "jb700"},
				--{name = "Pigalle", costs = 40000, description = {}, model = "pigalle"},
				{name = "Stinger", costs = 125000, description = {}, model = "stinger"},
				{name = "Stinger GT", costs = 140000, description = {}, model = "stingergt"},
				{name = "Stirling GT", costs = 140000, description = {}, model = "feltzer3"},
				{name = "Z-Type", costs = 100000, description = {}, model = "ztype"},
			}
		},
		["supers"] = {
			title = "supers",
			name = "supers",
			buttons = {
				{name = "Adder", costs = 300000, description = {}, model = "adder"},
				{name = "Banshee 900R", costs = 300000, description = {}, model = "banshee2"},
				{name = "Bullet", costs = 300000, description = {}, model = "bullet"},
				{name = "Cheetah", costs = 400000, description = {}, model = "cheetah"},
				{name = "Entity XF", costs = 400000, description = {}, model = "entityxf"},
				{name = "ETR1", costs = 400000, description = {}, model = "sheava"},
				{name = "FMJ", costs = 400000, description = {}, model = "fmj"},
				{name = "Infernus", costs = 380000, description = {}, model = "infernus"},
				{name = "Osiris", costs = 300000, description = {}, model = "osiris"},
				--{name = "RE-7B", costs = 247500, description = {}, model = "le7b"},
				{name = "Reaper", costs = 400500, description = {}, model = "reaper"},
				{name = "Sultan RS", costs = 70000, description = {}, model = "sultanrs"},
				{name = "T20", costs = 400000, description = {}, model = "t20"},
				{name = "Turismo R", costs = 420000, description = {}, model = "turismor"},
				{name = "Tyrus", costs = 400000, description = {}, model = "tyrus"},
				{name = "Vacca", costs = 380000, description = {}, model = "vacca"},
				{name = "Voltic", costs = 150000, description = {}, model = "voltic"},
				--{name = "X80 Proto", costs = 270000, description = {}, model = "prototipo"},
				{name = "Zentorno", costs = 420000, description = {}, model = "zentorno"},
			}
		},
		["muscle"] = {
			title = "muscle",
			name = "muscle",
			buttons = {
				{name = "Blade", costs = 50000, description = {}, model = "blade"},
				{name = "Buccaneer", costs = 60000, description = {}, model = "buccaneer"},
				{name = "Chino", costs = 55000, description = {}, model = "chino"},
				{name = "Coquette BlackFin", costs = 150000, description = {}, model = "coquette3"},
				{name = "Dominator", costs = 120000, description = {}, model = "dominator"},
				{name = "Dukes", costs = 95000, description = {}, model = "dukes"},
				{name = "Gauntlet", costs = 80000, description = {}, model = "gauntlet"},
				{name = "Hotknife", costs = 90000, description = {}, model = "hotknife"},
				{name = "Faction", costs = 60000, description = {}, model = "faction"},
				{name = "Nightshade", costs = 90000, description = {}, model = "nightshade"},
				{name = "Picador", costs = 90000, description = {}, model = "picador"},
				{name = "Sabre Turbo", costs = 80000, description = {}, model = "sabregt"},
				--{name = "Mustang GT500", costs = 80000, description = {}, model = "sabregt2"},
				{name = "Tampa", costs = 175000, description = {}, model = "tampa"},
				{name = "Virgo", costs = 195000, description = {}, model = "virgo"},
				{name = "Vigero", costs = 90000, description = {}, model = "vigero"},
			}
		},
		["offroad"] = {
			title = "offroad",
			name = "offroad",
			buttons = {
				{name = "Bifta", costs = 75000, description = {}, model = "bifta"},
				{name = "Blazer", costs = 8000, description = {}, model = "blazer"},
				{name = "Brawler", costs = 71500, description = {}, model = "brawler"},
				{name = "Bubsta 6x6", costs = 5000, description = {}, model = "dubsta3"},
				{name = "Dune Buggy", costs = 58000, description = {}, model = "dune"},
				{name = "Rebel", costs = 50000, description = {}, model = "rebel2"},
				{name = "Sandking", costs = 70000, description = {}, model = "sandking"},
				{name = "The Liberator", costs = 150000, description = {}, model = "monster"},
				{name = "Trophy Truck", costs = 100000, description = {}, model = "trophytruck"},
			}
		},
		["suvs"] = {
			title = "suvs",
			name = "suvs",
			buttons = {
				{name = "Baller", costs = 90000, description = {}, model = "baller"},
				{name = "Cavalcade", costs = 80000, description = {}, model = "cavalcade"},
				{name = "Grabger", costs = 70000, description = {}, model = "granger"},
				{name = "Huntley S", costs = 95000, description = {}, model = "huntley"},
				{name = "Landstalker", costs = 75000, description = {}, model = "landstalker"},
				{name = "Radius", costs = 70000, description = {}, model = "radi"},
				{name = "Rocoto", costs = 90000, description = {}, model = "rocoto"},
				{name = "Seminole", costs = 60000, description = {}, model = "seminole"},
				{name = "XLS", costs = 101000, description = {}, model = "xls"},
			}
		},
		["vans"] = {
			title = "vans",
			name = "vans",
			buttons = {
				{name = "Bison", costs = 30000, description = {}, model = "bison"},
				{name = "Bobcat XL", costs = 23000, description = {}, model = "bobcatxl"},
				{name = "Gang Burrito", costs = 65000, description = {}, model = "gburrito"},
				{name = "Journey", costs = 15000, description = {}, model = "journey"},
				{name = "Minivan", costs = 30000, description = {}, model = "minivan"},
				{name = "Paradise", costs = 25000, description = {}, model = "paradise"},
				{name = "Rumpo", costs = 13000, description = {}, model = "rumpo"},
				{name = "Surfer", costs = 11000, description = {}, model = "surfer"},
				{name = "Youga", costs = 16000, description = {}, model = "youga"},
			}
		},
		["sedans"] = {
			title = "sedans",
			name = "sedans",
			buttons = {
				{name = "Asea", costs = 1000000, description = {}, model = "asea"},
				{name = "Asterope", costs = 1000000, description = {}, model = "asterope"},
				{name = "Cognoscenti", costs = 1000000, description = {}, model = "cognoscenti"},
				{name = "Cognoscenti(Armored)", costs = 1000000, description = {}, model = "cognoscenti2"},
				{name = "Cognoscenti 55", costs = 1000000, description = {}, model = "cog55"},
				{name = "Cognoscenti 55(Armored", costs = 1500000, description = {}, model = "cog552"},
				{name = "Fugitive", costs = 100000, description = {}, model = "fugitive"},
				{name = "Glendale", costs = 200000, description = {}, model = "glendale"},
				{name = "Ingot", costs = 75000, description = {}, model = "ingot"},
				{name = "Intruder", costs = 90000, description = {}, model = "intruder"},
				{name = "Premier", costs = 60000, description = {}, model = "premier"},
				{name = "Primo", costs = 40000, description = {}, model = "primo"},
				{name = "Primo Custom", costs = 5000, description = {}, model = "primo2"},
				{name = "Regina", costs = 45000, description = {}, model = "regina"},
				{name = "Schafter", costs = 45000, description = {}, model = "schafter2"},
				{name = "Stanier", costs = 50000, description = {}, model = "stanier"},
				{name = "Stratum", costs = 50000, description = {}, model = "stratum"},
				{name = "Stretch", costs = 58000, description = {}, model = "stretch"},
				{name = "Super Diamond", costs = 250000, description = {}, model = "superd"},
				{name = "Surge", costs = 80000, description = {}, model = "surge"},
				{name = "Tailgater", costs = 60000, description = {}, model = "tailgater"},
				{name = "Warrener", costs = 120000, description = {}, model = "warrener"},
				{name = "Washington", costs = 70000, description = {}, model = "washington"},
			}
		},
		["motorcycles"] = {
			title = "motos",
			name = "motos",
			buttons = {
				{name = "Akuma", costs = 25000, description = {}, model = "AKUMA"},
				{name = "Bagger", costs = 18000, description = {}, model = "bagger"},
				{name = "Bati 801", costs = 30000, description = {}, model = "bati"},
				--{name = "Bati 801RR", costs = 15000, description = {}, model = "bati2"},
				{name = "BF400", costs = 20000, description = {}, model = "bf400"},
				{name = "Carbon RS", costs = 40000, description = {}, model = "carbonrs"},
				{name = "Cliffhanger", costs = 40000, description = {}, model = "cliffhanger"},
				{name = "Daemon", costs = 35000, description = {}, model = "daemon"},
				{name = "Double T", costs = 30000, description = {}, model = "double"},
				{name = "Enduro", costs = 15000, description = {}, model = "enduro"},
				--{name = "Faggio", costs = 14000, description = {}, model = "faggio2"},
				{name = "Gargoyle", costs = 55000, description = {}, model = "gargoyle"},
				{name = "Hakuchou", costs = 40000, description = {}, model = "hakuchou"},
				{name = "Hexer", costs = 30000, description = {}, model = "hexer"},
				{name = "Innovation", costs = 45000, description = {}, model = "innovation"},
				{name = "Lectro", costs = 50000, description = {}, model = "lectro"},
				{name = "Nemesis", costs = 35000, description = {}, model = "nemesis"},
				{name = "PCJ-600", costs = 28000, description = {}, model = "pcj"},
				{name = "Ruffian", costs = 28000, description = {}, model = "ruffian"},
				{name = "Sanchez", costs = 19000, description = {}, model = "sanchez"},
				--{name = "Sovereign", costs = 90000, description = {}, model = "sovereign"},
				--{name = "Thrust", costs = 75000, description = {}, model = "thrust"},
				{name = "Vader", costs = 35000, description = {}, model = "vader"},
				--{name = "Vindicator", costs = 34000, description = {}, model = "vindicator"},
			}
		},
	}
}
local fakecar = {model = '', car = nil}
local vehshop_locations = {
{entering = {-33.803,-1102.322,25.422}, inside = {-46.56327,-1097.382,25.99875, 120.1953}, outside = {-31.849,-1090.648,25.998,322.345}},
}

local vehshop_blips ={}
local inrangeofvehshop = false
local currentlocation = nil
local boughtcar = false

function vehSR_drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end

function vehSR_IsPlayerInRangeOfVehshop()
	return inrangeofvehshop
end

local firstspawn = 0
AddEventHandler('playerSpawned', function(spawn)
if firstspawn == 0 then
	--326 car blip 227 225
	vehSR_ShowVehshopBlips(true)
	firstspawn = 1
end
end)
local info = false
function vehSR_ShowVehshopBlips(bool)
	if bool and #vehshop_blips == 0 then
		for station,pos in pairs(vehshop_locations) do
			local loc = pos
			pos = pos.entering
			local blip = AddBlipForCoord(pos[1],pos[2],pos[3])
			-- 60 58 137
			SetBlipSprite(blip,530)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Concession Auto")
			EndTextCommandSetBlipName(blip)
			SetBlipAsShortRange(blip,true)
			SetBlipAsMissionCreatorBlip(blip,true)
			table.insert(vehshop_blips, {blip = blip, pos = loc})
	     
		 if not info then 
			 RequestStreamedTextureDict("pm_tt_0",1)
			while not HasStreamedTextureDictLoaded("pm_tt_0")  do
				Wait(1)
			end
		    	
			exports['blip_info']:SetBlipInfoImage(blip,"pm_tt_0","ttshot0")  
			exports['blip_info']:SetBlipInfoTitle(blip, "~b~Concession Auto/Moto", false)
            exports['blip_info']:AddBlipInfoText(blip, "~y~Nous avons tous les types de vehicules!", "")
            exports['blip_info']:AddBlipInfoName(blip, "De la super car à la poubelle a roulettes!", "")
           
          info = true
        end		  
		
		end
		Citizen.CreateThread(function()
			while #vehshop_blips > 0 do
				Citizen.Wait(0)
				local inrange = false
				for i,b in ipairs(vehshop_blips) do
					if IsPlayerWantedLevelGreater(GetPlayerIndex(),0) == false and vehshop.opened == false and IsPedInAnyVehicle(vehSR_LocalPed(), true) == false and  GetDistanceBetweenCoords(b.pos.entering[1],b.pos.entering[2],b.pos.entering[3],GetEntityCoords(vehSR_LocalPed())) < 5 then
						DrawMarker(1,b.pos.entering[1],b.pos.entering[2],b.pos.entering[3],0,0,0,0,0,0,2.001,2.0001,0.5001,0,155,255,200,0,0,0,0)
						vehSR_drawTxt("Appuyez sur ~g~X~s~pour acheter un ~b~vehicule",0,1,0.5,0.8,0.6,255,255,255,255)
						currentlocation = b
						inrange = true
					end
				end
				inrangeofvehshop = inrange
			end
		end)
	elseif bool == false and #vehshop_blips > 0 then
		for i,b in ipairs(vehshop_blips) do
			if DoesBlipExist(b.blip) then
				SetBlipAsMissionCreatorBlip(b.blip,false)
				Citizen.InvokeNative(0x86A652570E5F25DD, Citizen.PointerValueIntInitialized(b.blip))
			end
		end
		vehshop_blips = {}
	end
end

function vehSR_f(n)
	return n + 0.0001
end

function vehSR_LocalPed()
	return GetPlayerPed(-1)
end

function vehSR_try(f, catch_f)
	local status, exception = pcall(f)
	if not status then
		catch_f(exception)
	end
end
function vehSR_firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end
--local veh = nil
function vehSR_OpenCreator()
	boughtcar = false
	local ped = vehSR_LocalPed()
	local pos = currentlocation.pos.inside
	FreezeEntityPosition(ped,true)
	SetEntityVisible(ped,false)
	local g = Citizen.InvokeNative(0xC906A7DAB05C8D2B,pos[1],pos[2],pos[3],Citizen.PointerValueFloat(),0)
	SetEntityCoords(ped,pos[1],pos[2],g)
	SetEntityHeading(ped,pos[4])
	vehshop.currentmenu = "main"
	vehshop.opened = true
	vehshop.selectedbutton = 0
end
local vehicle_price = 0
function vehSR_CloseCreator(vehicle,veh_type)
	Citizen.CreateThread(function()
		local ped = vehSR_LocalPed()
		if not boughtcar then
			local pos = currentlocation.pos.entering
			SetEntityCoords(ped,pos[1],pos[2],pos[3])
			FreezeEntityPosition(ped,false)
			SetEntityVisible(ped,true)
		else
			deleteVehiclePedIsIn()
			vRP.teleport({-44.21378326416,-1079.1402587891,26.67050743103})
			vRPg.spawnBoughtVehicle({veh_type, vehicle})
			SetEntityVisible(ped,true)
			FreezeEntityPosition(ped,false)
		end
		vehshop.opened = false
		vehshop.menu.from = 1
		vehshop.menu.to = 10
	end)
end

function vehSR_drawMenuButton(button,x,y,selected)
	local menu = vehshop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(menu.scale, menu.scale)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(button.name)
	if selected then
		DrawRect(x,y,menu.width,menu.height,255,255,255,255)
	else
		DrawRect(x,y,menu.width,menu.height,0,0,0,150)
	end
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

function vehSR_drawMenuTitle(txt,x,y)
local menu = vehshop.menu
	SetTextFont(2)
	SetTextProportional(0)
	SetTextScale(0.5, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawRect(x,y,menu.width,menu.height,0,0,0,150)
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end
function vehSR_tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end
function vehSR_Notify(text)
SetNotificationTextEntry('STRING')
AddTextComponentString(text)
DrawNotification(false, false)
end

function vehSR_drawMenuRight(txt,x,y,selected)
	local menu = vehshop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(menu.scale, menu.scale)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawText(x + menu.width/2 - 0.06, y - menu.height/2 + 0.0028)
end
local backlock = false
Citizen.CreateThread(function()
	local last_dir
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(1,201) and vehSR_IsPlayerInRangeOfVehshop() then
			if vehshop.opened then
				vehSR_CloseCreator("","")
			else
				vehSR_OpenCreator()
			end
		end
		if vehshop.opened then
			local ped = vehSR_LocalPed()
			local menu = vehshop.menu[vehshop.currentmenu]
			vehSR_drawTxt(vehshop.title,1,1,vehshop.menu.x,vehshop.menu.y,1.0, 255,255,255,255)
			vehSR_drawMenuTitle(menu.title, vehshop.menu.x,vehshop.menu.y + 0.08)
			vehSR_drawTxt(vehshop.selectedbutton.."/"..vehSR_tablelength(menu.buttons),0,0,vehshop.menu.x + vehshop.menu.width/2 - 0.0385,vehshop.menu.y + 0.067,0.4, 255,255,255,255)
			local y = vehshop.menu.y + 0.12
			buttoncount = vehSR_tablelength(menu.buttons)
			local selected = false

			for i,button in pairs(menu.buttons) do
				if i >= vehshop.menu.from and i <= vehshop.menu.to then

					if i == vehshop.selectedbutton then
						selected = true
					else
						selected = false
					end
					vehSR_drawMenuButton(button,vehshop.menu.x,y,selected)
					if button.costs ~= nil then
						if vehshop.currentmenu == "compacts" or vehshop.currentmenu == "coupes" or vehshop.currentmenu == "sedans" or vehshop.currentmenu == "sports" or vehshop.currentmenu == "sportsclassics" or vehshop.currentmenu == "supers" or vehshop.currentmenu == "muscle" or vehshop.currentmenu == "offroad" or vehshop.currentmenu == "suvs" or vehshop.currentmenu == "vans" or vehshop.currentmenu == "industrial" or vehshop.currentmenu == "cycles" or vehshop.currentmenu == "motorcycles" then
							vehSR_drawMenuRight(button.costs.."$",vehshop.menu.x,y,selected)
						else
							vehSR_drawMenuButton(button,vehshop.menu.x,y,selected)
						end
					end
					y = y + 0.04
					if vehshop.currentmenu == "compacts" or vehshop.currentmenu == "coupes" or vehshop.currentmenu == "sedans" or vehshop.currentmenu == "sports" or vehshop.currentmenu == "sportsclassics" or vehshop.currentmenu == "supers" or vehshop.currentmenu == "muscle" or vehshop.currentmenu == "offroad" or vehshop.currentmenu == "suvs" or vehshop.currentmenu == "vans" or vehshop.currentmenu == "industrial" or vehshop.currentmenu == "cycles" or vehshop.currentmenu == "motorcycles" then
						if selected then
							if fakecar.model ~= button.model then
								if DoesEntityExist(fakecar.car) then
									Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(fakecar.car))
								end
								local pos = currentlocation.pos.inside
								local hash = GetHashKey(button.model)
								RequestModel(hash)
								local timer = 0
								while not HasModelLoaded(hash) and timer < 255 do
									Citizen.Wait(1)
									vehSR_drawTxt("Loading...",0,1,0.5,0.5,1.5,255,255-timer,255-timer,255)
									RequestModel(hash)
									timer = timer + 1
								end
								if timer < 255 then
									local veh = CreateVehicle(hash,pos[1],pos[2],pos[3],pos[4],false,false)
									while not DoesEntityExist(veh) do
										Citizen.Wait(1)
										vehSR_drawTxt("Loading...",0,1,0.5,0.5,1.5,255,255-timer,255-timer,255)
									end
									FreezeEntityPosition(veh,true)
									SetEntityInvincible(veh,true)
									SetVehicleDoorsLocked(veh,4)
									--SetEntityCollision(veh,false,false)
									TaskWarpPedIntoVehicle(vehSR_LocalPed(),veh,-1)
									for i = 0,24 do
										SetVehicleModKit(veh,0)
										RemoveVehicleMod(veh,i)
									end
									fakecar = { model = button.model, car = veh}
								else
									timer = 0
									while timer < 50 do
										Citizen.Wait(1)
										vehSR_drawTxt("Failed!",0,1,0.5,0.5,1.5,255,0,0,255)
										timer = timer + 1
									end
									if last_dir then
										if vehshop.selectedbutton < buttoncount then
											vehshop.selectedbutton = vehshop.selectedbutton +1
											if buttoncount > 10 and vehshop.selectedbutton > vehshop.menu.to then
												vehshop.menu.to = vehshop.menu.to + 1
												vehshop.menu.from = vehshop.menu.from + 1
											end
										else
											last_dir = false
											vehshop.selectedbutton = vehshop.selectedbutton -1
											if buttoncount > 10 and vehshop.selectedbutton < vehshop.menu.from then
												vehshop.menu.from = vehshop.menu.from -1
												vehshop.menu.to = vehshop.menu.to - 1
											end
										end
									else
										if vehshop.selectedbutton > 1 then
											vehshop.selectedbutton = vehshop.selectedbutton -1
											if buttoncount > 10 and vehshop.selectedbutton < vehshop.menu.from then
												vehshop.menu.from = vehshop.menu.from -1
												vehshop.menu.to = vehshop.menu.to - 1
											end
										else
											last_dir = true
											vehshop.selectedbutton = vehshop.selectedbutton +1
											if buttoncount > 10 and vehshop.selectedbutton > vehshop.menu.to then
												vehshop.menu.to = vehshop.menu.to + 1
												vehshop.menu.from = vehshop.menu.from + 1
											end
										end
									end
								end
							end
						end
					end
					if selected and IsControlJustPressed(1,201) then
						vehSR_ButtonSelected(button)
					end
				end
			end
			if IsControlJustPressed(1,202) then
				vehSR_Back()
			end
			if IsControlJustReleased(1,202) then
				backlock = false
			end
			if IsControlJustPressed(1,188) then
				last_dir = false
				if vehshop.selectedbutton > 1 then
					vehshop.selectedbutton = vehshop.selectedbutton -1
					if buttoncount > 10 and vehshop.selectedbutton < vehshop.menu.from then
						vehshop.menu.from = vehshop.menu.from -1
						vehshop.menu.to = vehshop.menu.to - 1
					end
				end
			end
			if IsControlJustPressed(1,187)then
				last_dir = true
				if vehshop.selectedbutton < buttoncount then
					vehshop.selectedbutton = vehshop.selectedbutton +1
					if buttoncount > 10 and vehshop.selectedbutton > vehshop.menu.to then
						vehshop.menu.to = vehshop.menu.to + 1
						vehshop.menu.from = vehshop.menu.from + 1
					end
				end
			end
		end

	end
end)


function vehSR_round(num, idp)
  if idp and idp>0 then
    local mult = 10^idp
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end
function vehSR_ButtonSelected(button)
	local ped = GetPlayerPed(-1)
	local this = vehshop.currentmenu
	local btn = button.name
	if this == "main" then
		if btn == "vehicles" then
			vehSR_OpenMenu('vehicles')
		elseif btn == "motorcycles" then
			vehSR_OpenMenu('motorcycles')
		end
	elseif this == "vehicles" then
		if btn == "sports" then
			vehSR_OpenMenu('sports')
		elseif btn == "sedans" then
			vehSR_OpenMenu('sedans')
		elseif btn == "compacts" then
			vehSR_OpenMenu('compacts')
		elseif btn == "coupes" then
			vehSR_OpenMenu('coupes')
		elseif btn == "sportsclassics" then
			vehSR_OpenMenu("sportsclassics")
		elseif btn == "supers" then
			vehSR_OpenMenu('supers')
		elseif btn == "muscle" then
			vehSR_OpenMenu('muscle')
		elseif btn == "offroad" then
			vehSR_OpenMenu('offroad')
		elseif btn == "suvs" then
			vehSR_OpenMenu('suvs')
		elseif btn == "vans" then
			vehSR_OpenMenu('vans')
		end
	elseif this == "compacts" or this == "coupes" or this == "sedans" or this == "sports" or this == "sportsclassics" or this == "supers" or this == "muscle" or this == "offroad" or this == "suvs" or this == "vans" or this == "industrial" then
		TriggerServerEvent('veh_SR:CheckMoneyForVeh',button.model,button.costs, "car")
    elseif this == "cycles" or this == "motorcycles" then
		TriggerServerEvent('veh_SR:CheckMoneyForVeh',button.model,button.costs, "bike")
	end
end

RegisterNetEvent('veh_SR:CloseMenu')
AddEventHandler('veh_SR:CloseMenu', function(vehicle, veh_type)
	boughtcar = true
	vehSR_CloseCreator(vehicle,veh_type)
end)

function vehSR_OpenMenu(menu)
	fakecar = {model = '', car = nil}
	vehshop.lastmenu = vehshop.currentmenu
	if menu == "vehicles" then
		vehshop.lastmenu = "main"
	elseif menu == "bikes"  then
		vehshop.lastmenu = "main"
	elseif menu == 'race_create_objects' then
		vehshop.lastmenu = "main"
	elseif menu == "race_create_objects_spawn" then
		vehshop.lastmenu = "race_create_objects"
	end
	vehshop.menu.from = 1
	vehshop.menu.to = 10
	vehshop.selectedbutton = 0
	vehshop.currentmenu = menu
end


function vehSR_Back()
	if backlock then
		return
	end
	backlock = true
	if vehshop.currentmenu == "main" then
		vehSR_CloseCreator("","")
	elseif vehshop.currentmenu == "compacts" or vehshop.currentmenu == "coupes" or vehshop.currentmenu == "sedans" or vehshop.currentmenu == "sports" or vehshop.currentmenu == "sportsclassics" or vehshop.currentmenu == "supers" or vehshop.currentmenu == "muscle" or vehshop.currentmenu == "offroad" or vehshop.currentmenu == "suvs" or vehshop.currentmenu == "vans" or vehshop.currentmenu == "industrial" or vehshop.currentmenu == "cycles" or vehshop.currentmenu == "motorcycles" then
		if DoesEntityExist(fakecar.car) then
			Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(fakecar.car))
		end
		fakecar = {model = '', car = nil}
		vehSR_OpenMenu(vehshop.lastmenu)
	else
		vehSR_OpenMenu(vehshop.lastmenu)
	end

end

function vehSR_stringstarts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end