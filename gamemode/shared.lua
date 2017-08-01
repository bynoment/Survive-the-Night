--[[---------------------------------------------------------

  This file should contain variables and functions that are
   the same on both client and server.

  This file will get sent to the client - so don't add
   anything to this file that you don't want them to be
   able to see.

-----------------------------------------------------------]]

include( 'obj_player_extend.lua' )
include( 'config/classes_config.lua' )
include( 'sv_resourcedl.lua' )
include( 'config/main_config.lua' )
include( 'gravitygun.lua' )
include( 'player_shd.lua' )
include( 'cl_overheadinfo.lua' )
include( 'animations.lua' )
include( 'player_class/player_default.lua' )
include('cl_hud.lua')
include('cl_weaponchange.lua')
include('cl_winscreen.lua')
include('cl_factionboard.lua')
include('cl_fonts.lua')
include('sv_methods.lua')
include("burgerbase/sh_burger_init.lua");
include("sh_judgement.lua");

AddCSLuaFile("burgerbase/sh_burger_init.lua");
AddCSLuaFile( "sh_judgement.lua" );



GM.Name			= "Survive the Night"
GM.Author		= "SweetLikeCammy"
GM.Email		= "jacksonpeeven@gmail.com"
GM.Website		= "http://watts-onservers.com/forums"
GM.TeamBased	= true

SH_BaseIndex = 100
SH_playerJobs = {}

--[[---------------------------------------------------------
   Name: gamemode:KeyPress( )
   Desc: Player pressed a key (see IN enums)
-----------------------------------------------------------]]
function GM:KeyPress( player, key )
end

--[[---------------------------------------------------------
   Name: gamemode:KeyRelease( )
   Desc: Player released a key (see IN enums)
-----------------------------------------------------------]]
function GM:KeyRelease( player, key )
end

--[[---------------------------------------------------------
   Name: gamemode:PlayerConnect( )
   Desc: Player has connects to the server (hasn't spawned)
-----------------------------------------------------------]]
function GM:PlayerConnect( name, address )
end

--[[---------------------------------------------------------
   Name: gamemode:PropBreak( )
   Desc: Prop has been broken
-----------------------------------------------------------]]
function GM:PropBreak( attacker, prop )
end

--[[---------------------------------------------------------
   Name: gamemode:PhysgunPickup( )
   Desc: Return true if player can pickup entity
-----------------------------------------------------------]]
function GM:PhysgunPickup( ply, ent )

	-- Don't pick up players
	if ( ent:GetClass() == "player" ) then return false end

	return true
end

--[[---------------------------------------------------------
   Name: gamemode:PhysgunDrop( )
   Desc: Dropped an entity
-----------------------------------------------------------]]
function GM:PhysgunDrop( ply, ent )
end

--[[---------------------------------------------------------
   Name: gamemode:PlayerShouldTakeDamage
   Return true if this player should take damage from this attacker
-----------------------------------------------------------]]
function GM:PlayerShouldTakeDamage( ply, attacker )
	if(!attacker:IsPlayer())then return true end
	local fistsDamage = MAIN_CONFIG.fistsDamage or false
	if(!fistsDamage && attacker:GetActiveWeapon():GetClass() == "weapon_fists")then
		return false
	end
	return true
end

--[[---------------------------------------------------------
   Name: Text to show in the server browser
-----------------------------------------------------------]]
function GM:GetGameDescription()
	return self.Name
end

--[[---------------------------------------------------------
   Name: Saved
-----------------------------------------------------------]]
function GM:Saved()
end

--[[---------------------------------------------------------
   Name: Restored
-----------------------------------------------------------]]
function GM:Restored()
end

--[[---------------------------------------------------------
   Name: EntityRemoved
   Desc: Called right before an entity is removed. Note that this
   isn't going to be totally reliable on the client since the client
   only knows about entities that it has had in its PVS.
-----------------------------------------------------------]]
function GM:EntityRemoved( ent )
end

--[[---------------------------------------------------------
   Name: Tick
   Desc: Like Think except called every tick on both client and server
-----------------------------------------------------------]]
function GM:Tick()
	
end

--[[---------------------------------------------------------
   Name: OnEntityCreated
   Desc: Called right after the Entity has been made visible to Lua
-----------------------------------------------------------]]
function GM:OnEntityCreated( Ent )
end

--[[---------------------------------------------------------
   Name: gamemode:EntityKeyValue( ent, key, value )
   Desc: Called when an entity has a keyvalue set
		 Returning a string it will override the value
-----------------------------------------------------------]]
function GM:EntityKeyValue( ent, key, value )
end

--[[---------------------------------------------------------
   Name: gamemode:CreateTeams()
   Desc: Note - HAS to be shared.
-----------------------------------------------------------]]
function GM:CreateTeams()

	-- Don't do this if not teambased. But if it is teambased we
	-- create a few teams here as an example. If you're making a teambased
	-- gamemode you should override this function in your gamemode

	
	-- Check to see if game is TeamBased, REMOVE
	if ( !GAMEMODE.TeamBased ) then return end
	local factions = CLASS_CONFIG.Factions or {}
	
	-- Set all teams using the config file
	local teamIndex = 0
	for a,b in pairs(CLASS_CONFIG.Factions) do
		teamCode = SH_BaseIndex+teamIndex
		team.SetUp(teamCode, b["name"], b["color"])
		print("Setup Team: " .. b["name"] .. "as team index: " .. teamIndex)
		CLASS_CONFIG.Factions[a]["teamCode"] = teamCode
		teamIndex = teamIndex + 1
		
		for x,y in pairs(CLASS_CONFIG.Classes)do
			if(y["faction"] == b)then
				team.SetClass(teamCode, y["name"])
			end
		end
	end
	
	TEAM_DEAD = 99
	team.SetUp(TEAM_DEAD, "Dead", Color(80,80,80,255))
	print("Setup Team: " .. "Dead" )
	
	--[[
	TEAM_BLUE = 1
	team.SetUp( TEAM_BLUE, "Blue Team", Color( 0, 0, 255 ) )
	team.SetSpawnPoint( TEAM_BLUE, "ai_hint" ) -- <-- This would be info_terrorist or some entity that is in your map

	TEAM_ORANGE = 2
	team.SetUp( TEAM_ORANGE, "Orange Team", Color( 255, 150, 0 ) )
	team.SetSpawnPoint( TEAM_ORANGE, "sky_camera" ) -- <-- This would be info_terrorist or some entity that is in your map

	TEAM_SEXY = 3
	team.SetUp( TEAM_SEXY, "Sexy Team", Color( 255, 150, 150 ) )
	team.SetSpawnPoint( TEAM_SEXY, "info_player_start" ) -- <-- This would be info_terrorist or some entity that is in your map

	team.SetSpawnPoint( TEAM_SPECTATOR, "worldspawn" )
	]]

end

--[[---------------------------------------------------------
-- Purpose: This is called pre player movement and copies all the data necessary
--          from the player for movement. Copy from the usercmd to move.
-----------------------------------------------------------]]
function GM:SetupMove( ply, mv, cmd )

	if ( drive.StartMove( ply, mv, cmd ) ) then return true end
	if ( player_manager.RunClass( ply, "StartMove", mv, cmd ) ) then return true end

end

--[[---------------------------------------------------------
   Name: gamemode:FinishMove( player, movedata )
-----------------------------------------------------------]]
function GM:FinishMove( ply, mv )

	if ( drive.FinishMove( ply, mv ) ) then return true end
	if ( player_manager.RunClass( ply, "FinishMove", mv ) ) then return true end

end

--[[---------------------------------------------------------
	Called after the player's think.
-----------------------------------------------------------]]
function GM:PlayerPostThink( ply )

end

--[[---------------------------------------------------------
	A player has started driving an entity
-----------------------------------------------------------]]
function GM:StartEntityDriving( ent, ply )

	drive.Start( ply, ent )

end

--[[---------------------------------------------------------
	A player has stopped driving an entity
-----------------------------------------------------------]]
function GM:EndEntityDriving( ent, ply )

	drive.End( ply, ent )

end

--[[---------------------------------------------------------
	To update the player's animation during a drive
-----------------------------------------------------------]]
function GM:PlayerDriveAnimate( ply )

end

--[[---------------------------------------------------------
	The gamemode has been reloaded
-----------------------------------------------------------]]
function GM:OnReloaded()
end

function GM:PreGamemodeLoaded()
end

function GM:OnGamemodeLoaded()
end

function GM:PostGamemodeLoaded()
end

--
-- Name: GM:OnViewModelChanged
-- Desc: Called when the player changes their weapon to another one - and their viewmodel model changes
-- Arg1: Entity|viewmodel|The viewmodel that is changing
-- Arg2: string|old|The old model
-- Arg3: string|new|The new model
-- Ret1:
--
function GM:OnViewModelChanged( vm, old, new )

	local ply = vm:GetOwner()
	if ( IsValid( ply ) ) then
		player_manager.RunClass( ply, "ViewModelChanged", vm, old, new )
	end

end

--[[---------------------------------------------------------
	Disable properties serverside for all non-sandbox derived gamemodes.
-----------------------------------------------------------]]
function GM:CanProperty( pl, property, ent )
	return false
end
