#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <sdkhooks>

#pragma newdecls required

// V model & skin
int POKEBALL_VMODEL;
int PlayerModelIndex[MAXPLAYERS+1];

// W model
#define POKEBALL_WMODEL "models/akami/weapons/pokeball/w_pokeball.mdl"

// Cvars
ConVar Cvar_He, Cvar_Flash, Cvar_Decoy, Cvar_Smoke, Cvar_Inc, Cvar_Molotov;
char Skin_He[64], Skin_Flash[64], Skin_Decoy[64], Skin_Smoke[64], Skin_Inc[64], Skin_Molotov[64];

public Plugin myinfo = 
{
	name = "Pokeball Nades",
	author = "Kento",
	description = "Pokeball Nades",
	version = "1.0",
	url = "http://steamcommunity.com/id/kentomatoryoshika/"
};

public void OnPluginStart()
{
	// Hook
	HookEvent("player_spawn", Event_Spawn, EventHookMode_Post);
	
	// Cvars
	Cvar_He = CreateConVar("pokeball_he", "0", "Skin of pokeball hegrenade.", FCVAR_NOTIFY, true, -1.0, true, 23.0);
	Cvar_Flash = CreateConVar("pokeball_flash", "5", "Skin of pokeball flashbang.", FCVAR_NOTIFY, true, -1.0, true, 23.0);
	Cvar_Decoy = CreateConVar("pokeball_decoy", "23", "Skin of pokeball decoy.", FCVAR_NOTIFY, true, -1.0, true, 23.0);
	Cvar_Smoke = CreateConVar("pokeball_smoke", "15", "Skin of pokeball smokegrenade.", FCVAR_NOTIFY, true, -1.0, true, 23.0);
	Cvar_Inc = CreateConVar("pokeball_inc", "12", "Skin of pokeball incgrenade.", FCVAR_NOTIFY, true, -1.0, true, 23.0);
	Cvar_Molotov = CreateConVar("pokeball_molotov", "12", "Skin of pokeball molotov.", FCVAR_NOTIFY, true, -1.0, true, 23.0);
	
	Cvar_He.AddChangeHook(OnConVarChanged);
	Cvar_Flash.AddChangeHook(OnConVarChanged);
	Cvar_Decoy.AddChangeHook(OnConVarChanged);
	Cvar_Smoke.AddChangeHook(OnConVarChanged);
	Cvar_Inc.AddChangeHook(OnConVarChanged);
	Cvar_Molotov.AddChangeHook(OnConVarChanged);
	
	AutoExecConfig(true, "kento_pokeball");
}

public void OnConfigsExecuted()
{
	Cvar_He.GetString(Skin_He, sizeof(Skin_He));
	Cvar_Flash.GetString(Skin_Flash, sizeof(Skin_Flash));
	Cvar_Decoy.GetString(Skin_Decoy, sizeof(Skin_Decoy));
	Cvar_Smoke.GetString(Skin_Smoke, sizeof(Skin_Smoke));
	Cvar_Inc.GetString(Skin_Inc, sizeof(Skin_Inc));
	Cvar_Molotov.GetString(Skin_Molotov, sizeof(Skin_Molotov));
}

public void OnConVarChanged(ConVar convar, const char[] oldValue, const char[] newValue)
{
	if (convar == Cvar_He)	Cvar_He.GetString(Skin_He, sizeof(Skin_He));
	else if (convar == Cvar_Flash)	Cvar_Flash.GetString(Skin_Flash, sizeof(Skin_Flash));
	else if (convar == Cvar_Decoy)	Cvar_Decoy.GetString(Skin_Decoy, sizeof(Skin_Decoy));
	else if (convar == Cvar_Smoke)	Cvar_Smoke.GetString(Skin_Smoke, sizeof(Skin_Smoke));
	else if (convar == Cvar_Inc)	Cvar_Inc.GetString(Skin_Inc, sizeof(Skin_Inc));
	else if (convar == Cvar_Molotov)	Cvar_Molotov.GetString(Skin_Molotov, sizeof(Skin_Molotov));
}

public void OnMapStart() 
{ 
	// precache
	POKEBALL_VMODEL = PrecacheModel("models/akami/weapons/pokeball/v_pokeball.mdl", true);
	PrecacheModel(POKEBALL_WMODEL, true);
	
	// Download
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball.vmt");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_captains.vmt");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_captains.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_captains_normal.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_dusk.vmt");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_dusk.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_dusk_normal.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_exp.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_fast.vmt");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_fast.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_fast_normal.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_friend.vmt");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_friend.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_friend_normal.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_great.vmt");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_great.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_great_normal.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_green.vmt");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_green.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_green_normal.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_gs.vmt");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_gs.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_gs_normal.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_level.vmt");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_level.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_level_normal.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_lura_blue.vmt");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_lura_blue.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_lura_blue_normal.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_lura_green.vmt");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_lura_green.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_lura_green_normal.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_luxury.vmt");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_luxury.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_luxury_normal.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_master.vmt");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_master.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_master_normal.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_moon.vmt");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_moon.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_moon_normal.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_nest.vmt");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_nest.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_nest_normal.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_net.vmt");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_net.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_net_normal.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_normal.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_park.vmt");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_park.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_park_normal.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_premier.vmt");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_premier.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_premier_normal.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_quick.vmt");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_quick.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_quick_normal.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_rocket1.vmt");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_rocket1.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_rocket1_normal.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_rocket2.vmt");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_rocket2.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_rocket2_normal.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_safari.vmt");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_safari.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_safari_normal.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_timer.vmt");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_timer.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_timer_normal.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_ultra.vmt");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_ultra.vtf");
	AddFileToDownloadsTable("materials/akami/weapons/pokeball/pokeball_ultra_normal.vtf");
	AddFileToDownloadsTable("models/akami/weapons/pokeball/v_pokeball.dx90.vtx");
	AddFileToDownloadsTable("models/akami/weapons/pokeball/v_pokeball.mdl");
	AddFileToDownloadsTable("models/akami/weapons/pokeball/v_pokeball.vvd");
	AddFileToDownloadsTable("models/akami/weapons/pokeball/w_pokeball.dx90.vtx");
	AddFileToDownloadsTable("models/akami/weapons/pokeball/w_pokeball.mdl");
	AddFileToDownloadsTable("models/akami/weapons/pokeball/w_pokeball.phy");
	AddFileToDownloadsTable("models/akami/weapons/pokeball/w_pokeball.vvd");
}

public void OnClientPutInServer(int client)
{
	SDKHook(client, SDKHook_WeaponSwitchPost, WeaponDeployPost);
}

// V model
public void WeaponDeployPost(int client, int iWeapon) 
{
	char iWeaponClass[64];
	GetEntityClassname(iWeapon, iWeaponClass, sizeof(iWeaponClass));

	if(StrEqual(iWeaponClass, "weapon_hegrenade"))
	{
		// no skin
		if (StrEqual(Skin_He, "-1"))	return;
			
		// set model and skin
		SetEntProp(PlayerModelIndex[client], Prop_Send, "m_nModelIndex", POKEBALL_VMODEL);
		SetEntProp(iWeapon, Prop_Send, "m_nModelIndex", 0);
		DispatchKeyValue(PlayerModelIndex[client], "skin", Skin_He);
	}
	
	else if(StrEqual(iWeaponClass, "weapon_flashbang"))
	{
		// no skin
		if (StrEqual(Skin_Flash, "-1"))	return;
			
		// set model and skin
		SetEntProp(PlayerModelIndex[client], Prop_Send, "m_nModelIndex", POKEBALL_VMODEL);
		SetEntProp(iWeapon, Prop_Send, "m_nModelIndex", 0);
		DispatchKeyValue(PlayerModelIndex[client], "skin", Skin_Flash);
	}
	
	else if(StrEqual(iWeaponClass, "weapon_decoy"))
	{
		// no skin
		if (StrEqual(Skin_Decoy, "-1"))	return;
			
		// set model and skin
		SetEntProp(PlayerModelIndex[client], Prop_Send, "m_nModelIndex", POKEBALL_VMODEL);
		SetEntProp(iWeapon, Prop_Send, "m_nModelIndex", 0);
		DispatchKeyValue(PlayerModelIndex[client], "skin", Skin_Decoy);
	}
	
	else if(StrEqual(iWeaponClass, "weapon_smokegrenade"))
	{
		// no skin
		if (StrEqual(Skin_Smoke, "-1"))	return;
			
		// set model and skin
		SetEntProp(PlayerModelIndex[client], Prop_Send, "m_nModelIndex", POKEBALL_VMODEL);
		SetEntProp(iWeapon, Prop_Send, "m_nModelIndex", 0);
		DispatchKeyValue(PlayerModelIndex[client], "skin", Skin_Smoke);
	}
	
	else if(StrEqual(iWeaponClass, "weapon_incgrenade"))
	{
		// no skin
		if (StrEqual(Skin_Inc, "-1"))	return;
			
		// set model and skin
		SetEntProp(PlayerModelIndex[client], Prop_Send, "m_nModelIndex", POKEBALL_VMODEL);
		SetEntProp(iWeapon, Prop_Send, "m_nModelIndex", 0);
		DispatchKeyValue(PlayerModelIndex[client], "skin", Skin_Inc);
	}
	
	else if(StrEqual(iWeaponClass, "weapon_molotov"))
	{
		// no skin
		if (StrEqual(Skin_Molotov, "-1"))	return;
			
		// set model and skin
		SetEntProp(PlayerModelIndex[client], Prop_Send, "m_nModelIndex", POKEBALL_VMODEL);
		SetEntProp(iWeapon, Prop_Send, "m_nModelIndex", 0);
		DispatchKeyValue(PlayerModelIndex[client], "skin", Skin_Molotov);
	}
}

// Get model index and prevent server from crash
int Weapon_GetViewModelIndex(int client)
{
	int iIndex = -1;
	
	// Find entity and return index
	while ((iIndex = FindEntityByClassname2(iIndex, "predicted_viewmodel")) != -1)
	{
		int iOwner = GetEntPropEnt(iIndex, Prop_Data, "m_hOwner");
		if (iOwner != client)	continue;
		return iIndex;
	}
	return -1;
}

// Get entity name
int FindEntityByClassname2(int iStartEnt, char[] sClassname)
{
	while (iStartEnt > -1 && !IsValidEntity(iStartEnt)) 
		iStartEnt--;
	
	return FindEntityByClassname(iStartEnt, sClassname);
}

stock bool IsValidClient(int client)
{
	if (client <= 0) return false;
	if (client > MaxClients) return false;
	if (!IsClientConnected(client)) return false;
	return IsClientInGame(client);
}

// Drop model
public Action Event_Spawn(Event event, const char[] gEventName, bool iDontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	PlayerModelIndex[client] = Weapon_GetViewModelIndex(client);
}

public void OnEntityCreated(int entity, const char[] classname)
{
	if(IsValidEntity(entity)) SDKHook(entity, SDKHook_SpawnPost, OnEntitySpawned);
}

public void OnEntitySpawned(int entity)
{
	char class_name[64];
	GetEntityClassname(entity, class_name, 64);
	
	int owner = GetEntPropEnt(entity, Prop_Data, "m_hOwnerEntity");
	
	if(StrContains(class_name, "projectile") != -1 && IsValidEntity(entity) && IsValidClient(owner))
	{
		if(StrContains(class_name, "hegrenade") != -1)
		{
			// no skin
			if (StrEqual(Skin_He, "-1"))	return;
			
			// set model and skin
			SetEntityModel(entity, POKEBALL_WMODEL);
			DispatchKeyValue(entity, "skin", Skin_He);
		}
		
		else if(StrContains(class_name, "decoy") != -1)
		{
			// get cvar
			char pokeball_decoy[64];
			GetConVarString(FindConVar("pokeball_decoy"), pokeball_decoy, sizeof(pokeball_decoy));
			
			// no skin
			if (StrEqual(Skin_Decoy, "-1"))	return;
			
			// set model and skin
			SetEntityModel(entity, POKEBALL_WMODEL);
			DispatchKeyValue(entity, "skin", Skin_Decoy);
		}
		
		else if(StrContains(class_name, "flashbang") != -1)
		{
			// no skin
			if (StrEqual(Skin_Flash, "-1"))	return;
			
			// set model and skin
			SetEntityModel(entity, POKEBALL_WMODEL);
			DispatchKeyValue(entity, "skin", Skin_Flash);
		}
		
		else if(StrContains(class_name, "smoke") != -1)
		{
			// no skin
			if (StrEqual(Skin_Smoke, "-1"))	return;
			
			// set model and skin
			SetEntityModel(entity, POKEBALL_WMODEL);
			DispatchKeyValue(entity, "skin", Skin_Smoke);
		}
		
		else if(StrContains(class_name, "incgrenade") != -1)
		{
			// no skin
			if (StrEqual(Skin_Inc, "-1"))	return;
			
			// set model and skin
			SetEntityModel(entity, POKEBALL_WMODEL);
			DispatchKeyValue(entity, "skin", Skin_Inc);
		}
		
		else if(StrContains(class_name, "molotov") != -1)
		{
			// no skin
			if (StrEqual(Skin_Molotov, "-1"))	return;
			
			// set model and skin
			SetEntityModel(entity, POKEBALL_WMODEL);
			DispatchKeyValue(entity, "skin", Skin_Molotov);
		}
	}
}
