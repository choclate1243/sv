#include "anti_rush"

#include "beast/checkpoint_spawner"
#include "beast/teleport_zone"

const bool blAntiRushEnabled = false;
const bool blAllyNpcGodmode = true; // You wanna have a bad time? Disable this and you are REALLY not going to like what happens next. *D
const float flSurvivalVoteAllow = g_EngineFuncs.CVarGetFloat( "mp_survival_voteallow" );

void MapInit()
{
    RegisterCheckPointSpawnerEntity();

    if( blAntiRushEnabled )
        RegisterAntiRushEntity();

    if( g_Engine.mapname == "deliver1" )
	{
		g_SurvivalMode.SetStartOn( false );

		if( flSurvivalVoteAllow > 0 )
			g_EngineFuncs.CVarSetFloat( "mp_survival_voteallow", 0 );
	}
}

void MapActivate()
{
    g_EngineFuncs.ServerPrint( "Deliverance Version 1.0 - Download this campaign at scmapdb.com\n" );

    CBaseEntity@ pGodModeEffect;

    if( !blAllyNpcGodmode )
    {
        while( ( @pGodModeEffect = g_EntityFuncs.FindEntityByTargetname( pGodModeEffect, "haha_no_moar_restarts_xd" ) ) !is null )
            g_EntityFuncs.Remove( pGodModeEffect );
    }
}
// Temporary, delete after SC 5.25 update (when trigger_effect gets patched)
void MapStart()
{
    CBaseEntity@ pSci, pBarney, pFlyingOsprey;

    if( g_Game.GetGameVersion() < 525 && blAllyNpcGodmode )
    {
        while( ( @pSci = g_EntityFuncs.FindEntityByClassname( pSci, "monster_scientist" ) ) !is null )
            pSci.pev.takedamage = DAMAGE_NO;

        while( ( @pBarney = g_EntityFuncs.FindEntityByClassname( pBarney, "monster_barney" ) ) !is null )
            pBarney.pev.takedamage = DAMAGE_NO;

        while( ( @pFlyingOsprey = g_EntityFuncs.FindEntityByTargetname( pFlyingOsprey, "osprey1" ) ) !is null )
            pFlyingOsprey.pev.takedamage = DAMAGE_NO;
    }
}

void TurnOnSurvival(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	g_EngineFuncs.CVarSetFloat( "mp_survival_voteallow", flSurvivalVoteAllow ); // Revert to the original cvar setting as per server

	if( g_SurvivalMode.IsEnabled() && g_SurvivalMode.MapSupportEnabled() && !g_SurvivalMode.IsActive() )
		g_SurvivalMode.Activate( true );
}
// Bastard things won't trigger from bsp
void Osprey2ForceTakeoff(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
    g_EntityFuncs.FireTargets( "osprey2", null, null, useType, flValue, 0.0f );
}
