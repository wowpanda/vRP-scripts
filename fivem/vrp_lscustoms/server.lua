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

MySQL = module("vrp_mysql", "MySQL")
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_lscustoms")

MySQL.createCommand("vRP/lscustoms_columns", [[

CREATE TABLE IF NOT EXISTS vrp_user_vehicles(
  user_id INTEGER,
  vehicle VARCHAR(100),
  veh_type varchar(255) NOT NULL DEFAULT 'default' ,
  vehicle_colorprimary varchar(255) DEFAULT NULL,
  vehicle_colorsecondary varchar(255) DEFAULT NULL,
  vehicle_pearlescentcolor varchar(255) DEFAULT NULL,
  vehicle_wheelcolor varchar(255) DEFAULT NULL,
  vehicle_plateindex varchar(255) DEFAULT NULL,
  vehicle_neoncolor1 varchar(255) DEFAULT NULL,
  vehicle_neoncolor2 varchar(255) DEFAULT NULL,
  vehicle_neoncolor3 varchar(255) DEFAULT NULL,
  vehicle_windowtint varchar(255) DEFAULT NULL,
  vehicle_wheeltype varchar(255) DEFAULT NULL,
  vehicle_mods0 varchar(255) DEFAULT NULL,
  vehicle_mods1 varchar(255) DEFAULT NULL,
  vehicle_mods2 varchar(255) DEFAULT NULL,
  vehicle_mods3 varchar(255) DEFAULT NULL,
  vehicle_mods4 varchar(255) DEFAULT NULL,
  vehicle_mods5 varchar(255) DEFAULT NULL,
  vehicle_mods6 varchar(255) DEFAULT NULL,
  vehicle_mods7 varchar(255) DEFAULT NULL,
  vehicle_mods8 varchar(255) DEFAULT NULL,
  vehicle_mods9 varchar(255) DEFAULT NULL,
  vehicle_mods10 varchar(255) DEFAULT NULL,
  vehicle_mods11 varchar(255) DEFAULT NULL,
  vehicle_mods12 varchar(255) DEFAULT NULL,
  vehicle_mods13 varchar(255) DEFAULT NULL,
  vehicle_mods14 varchar(255) DEFAULT NULL,
  vehicle_mods15 varchar(255) DEFAULT NULL,
  vehicle_mods16 varchar(255) DEFAULT NULL,
  vehicle_turbo varchar(255) NOT NULL DEFAULT 'off',
  vehicle_tiresmoke varchar(255) NOT NULL DEFAULT 'off',
  vehicle_xenon varchar(255) NOT NULL DEFAULT 'off',
  vehicle_mods23 varchar(255) DEFAULT NULL,
  vehicle_mods24 varchar(255) DEFAULT NULL,
  vehicle_neon0 varchar(255) DEFAULT NULL,
  vehicle_neon1 varchar(255) DEFAULT NULL,
  vehicle_neon2 varchar(255) DEFAULT NULL,
  vehicle_neon3 varchar(255) DEFAULT NULL,
  vehicle_bulletproof varchar(255) DEFAULT NULL,
  vehicle_smokecolor1 varchar(255) DEFAULT NULL,
  vehicle_smokecolor2 varchar(255) DEFAULT NULL,
  vehicle_smokecolor3 varchar(255) DEFAULT NULL,
  vehicle_modvariation varchar(255) NOT NULL DEFAULT 'off',
  vehicle_plate varchar(255) NOT NULL,
  CONSTRAINT pk_user_vehicles PRIMARY KEY(user_id,vehicle),
  CONSTRAINT fk_user_vehicles_users FOREIGN KEY(user_id) REFERENCES vrp_users(id) ON DELETE CASCADE
);
]])

MySQL.createCommand("vRP/ls_customs", "SELECT * FROM vrp_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle") -- added for lscustoms
MySQL.createCommand("vRP/lsc_get_vehicle","SELECT vehicle FROM vrp_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle AND vehicle_plate = @plate") -- lscustoms and plygarages
MySQL.createCommand("vRP/lsc_update_vehicle","UPDATE vrp_user_vehicles SET vehicle_plateindex=@plateindex, vehicle_colorprimary=@primarycolor, vehicle_colorsecondary=@secondarycolor, vehicle_pearlescentcolor=@pearlescentcolor, vehicle_wheelcolor=@wheelcolor, vehicle_neoncolor1=@neoncolor1, vehicle_neoncolor2=@neoncolor2, vehicle_neoncolor3=@neoncolor3, vehicle_windowtint=@windowtint, vehicle_wheeltype=@wheeltype, vehicle_mods0=@mods0, vehicle_mods1=@mods1, vehicle_mods2=@mods2, vehicle_mods3=@mods3, vehicle_mods4=@mods4, vehicle_mods5=@mods5, vehicle_mods6=@mods6, vehicle_mods7=@mods7, vehicle_mods8=@mods8, vehicle_mods9=@mods9, vehicle_mods10=@mods10, vehicle_mods11=@mods11, vehicle_mods12=@mods12, vehicle_mods13=@mods13, vehicle_mods14=@mods14, vehicle_mods15=@mods15, vehicle_mods16=@mods16, vehicle_turbo=@turbo, vehicle_tiresmoke=@tiresmoke, vehicle_xenon=@xenon, vehicle_mods23=@mods23, vehicle_mods24=@mods24, vehicle_neon0=@neon0, vehicle_neon1=@neon1, vehicle_neon2=@neon2, vehicle_neon3=@neon3, vehicle_bulletproof=@bulletproof, vehicle_smokecolor1=@smokecolor1, vehicle_smokecolor2=@smokecolor2, vehicle_smokecolor3=@smokecolor3, vehicle_modvariation=@variation WHERE user_id=@user_id AND vehicle=@vehicle") 

-- init
MySQL.query("vRP/lscustoms_columns")

-- LSCUSTOM SERVER LOCKS -- ADD CLIENT POSTION TOO
local tbl = {
	[1] = {locked = false},
	[2] = {locked = false},
	[3] = {locked = false},
	[4] = {locked = false},
	[5] = {locked = false},
}
RegisterServerEvent('lockGarage')
AddEventHandler('lockGarage', function(b,garage)
	tbl[tonumber(garage)].locked = b
	TriggerClientEvent('lockGarage',-1,tbl)
	--print(json.encode(tbl))
end)
RegisterServerEvent('getGarageInfo')
AddEventHandler('getGarageInfo', function()
TriggerClientEvent('lockGarage',-1,tbl)
--print(json.encode(tbl))
end)

RegisterServerEvent('lscustoms:payGarage')
AddEventHandler('lscustoms:payGarage', function(button)
  local user_id = vRP.getUserId({source})
  local player = vRP.getUserSource({user_id})
  if button.costs ~= nil then
	if vRP.tryFullPayment({user_id,tonumber(button.costs)}) then 
	  TriggerClientEvent("lscustoms:buttonSelected", player, button)
	else
	  TriggerClientEvent("lscustoms:payGarageFalse", player)
	end
  else
    TriggerClientEvent("lscustoms:buttonSelected", player, button)
  end
end)

RegisterServerEvent('lscustoms:UpdateVeh')
AddEventHandler('lscustoms:UpdateVeh', function(vehicle, plate, plateindex, primarycolor, secondarycolor, pearlescentcolor, wheelcolor, neoncolor1, neoncolor2, neoncolor3, windowtint, wheeltype, mods0, mods1, mods2, mods3, mods4, mods5, mods6, mods7, mods8, mods9, mods10, mods11, mods12, mods13, mods14, mods15, mods16, turbo, tiresmoke, xenon, mods23, mods24, neon0, neon1, neon2, neon3, bulletproof, smokecolor1, smokecolor2, smokecolor3, variation)
  local user_id = vRP.getUserId({source})
  local player = vRP.getUserSource({user_id})
  MySQL.query("vRP/lsc_get_vehicle", {user_id = user_id, vehicle = vehicle, plate = plate}, function(rows, affected)
    if #rows > 0 then -- has vehicle
        MySQL.query("vRP/lsc_update_vehicle", {
    	user_id = user_id,  
	    vehicle = vehicle,  
    	plateindex = plateindex,  
	    primarycolor = primarycolor, 
    	secondarycolor = secondarycolor,  
	    pearlescentcolor = pearlescentcolor, 
    	wheelcolor = wheelcolor, 
	    neoncolor1 = neoncolor1,
    	neoncolor2 = neoncolor2, 
	    neoncolor3 = neoncolor3,
    	windowtint = windowtint, 
	    wheeltype = wheeltype, 
    	mods0 = mods0, 
	    mods1 = mods1,
    	mods2 = mods2, 
	    mods3 = mods3,
    	mods4 = mods4,
	    mods5 = mods5,
    	mods6 = mods6, 
	    mods7 = mods7, 
    	mods8 = mods8, 
	    mods9 = mods9, 
    	mods10 = mods10, 
	    mods11 = mods11, 
    	mods12 = mods12, 
	    mods13 = mods13,
    	mods14 = mods14,
	    mods15 = mods15, 
    	mods16 = mods16,
	    turbo = turbo, 
    	tiresmoke = tiresmoke,
	    xenon = xenon,
    	mods23 = mods23,
	    mods24 = mods24, 
    	neon0 = neon0,
	    neon1 = neon1, 
    	neon2 = neon2,
	    neon3 = neon3,
    	bulletproof = bulletproof,
	    smokecolor1 = smokecolor1,
    	smokecolor2 = smokecolor2,
	    smokecolor3 = smokecolor3, 
    	variation = variation})
        TriggerClientEvent('lscustoms:UpdateDone', player)
    else
        TriggerClientEvent('lscustoms:StoreVehicleFalse', player)
	end
  end)
end)