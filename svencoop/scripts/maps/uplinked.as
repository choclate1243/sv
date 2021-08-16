/* Uplinked script 
Allows an optional transition from hl_c11_a5 to the start of this campaign
via vote or directly.
- Outerbeast */

// Set to true whether you want to skip voting and change the level to hl_u12 anyways //
const bool blVoteSkip = false;
// --------------------------------------------------------------------------------- //

HLUplinked@ g_hluplinked = @HLUplinked();

const bool blPlayerSpawnHookRegister = g_Hooks.RegisterHook( Hooks::Player::PlayerSpawn, PlayerSpawnHook( @g_hluplinked.OnPlayerSpawn ) );

final class HLUplinked
{
    HLUplinked() { }

    protected dictionary trgr, default_chglvl, ul_chglvl, vote, clip;
    protected bool blInitialised = false;

    HookReturnCode OnPlayerSpawn(CBasePlayer@ pPlayer)
    {
        if( pPlayer.IsConnected() && !blInitialised )
            blInitialised = InitUplinkedTransition();

        return HOOK_CONTINUE;
    }

    bool InitUplinkedTransition()
    {
        CBaseEntity@ pOldChangeLevel = g_EntityFuncs.FindEntityByClassname( pOldChangeLevel, "trigger_changelevel" );

        if( pOldChangeLevel is null )
            return false;
        // None of this works, I reckon setting flag is a one time thing in Spawn(). Must create a fresh instance xC
/*         pOldChangeLevel.pev.spawnflags |= 2;
        pOldChangeLevel.pev.targetname = "hl_c12_map";
        pOldChangeLevel.pev.origin.z -= 500.0f;
        pOldChangeLevel.Respawn(); // Damnit, thought this would do it. Apparently not. */

        trgr =
        {
            { "model", "" + pOldChangeLevel.pev.model },
            { "origin", "0 16 0" }
        };
        trgr["target"] = !blVoteSkip ? "hl_u12_vote" : "uplinked";

        default_chglvl = // Purpose: See- Line 32-36
        {
            { "model", "" + pOldChangeLevel.pev.model },
            { "origin", "0 0 -500" },
            { "targetname", "hl_c12_map" },
            { "map", "hl_c12" },
            { "keep_inventory", "1" },
            { "spawnflags", "2" }
        };

        ul_chglvl =
        {
            { "model", "" + pOldChangeLevel.pev.model },
            { "origin", "0 0 -500" },
            { "targetname", "uplinked" },
            { "map", "hl_u12" },
            { "keep_inventory", "1" },
            { "spawnflags", "2" }
        };

        vote =
        {
            { "targetname", "hl_u12_vote" },
            { "target", "hl_u12_vote" },
            { "message", "Want to play extended chapter?" },
            { "target", "uplinked" },
            { "noise", "uplinked"  },
            { "netname", "hl_c12_map" },
            { "m_iszYesString", "Yes. Uplinked" },
            { "m_iszNoString", "No. Lambda Bunker" },
            { "frags", "20" },
            { "health", "51" }
        };

        clip =
        {
            { "model", "" + pOldChangeLevel.pev.model },
            { "rendermode", "2" },
            { "renderamt", "0" }
        };

        CBaseEntity@ pTrigger = g_EntityFuncs.CreateEntity( "trigger_once", trgr );
        CBaseEntity@ pULChangeLevel = g_EntityFuncs.CreateEntity( "trigger_changelevel", ul_chglvl );
        CBaseEntity@ pDefaultChangeLevel = g_EntityFuncs.CreateEntity( "trigger_changelevel", default_chglvl );
        CBaseEntity@ pVote = g_EntityFuncs.CreateEntity( "trigger_vote", vote );
        g_EntityFuncs.CreateEntity( "func_wall", clip );
        g_EntityFuncs.Remove( pOldChangeLevel );

        return ( pTrigger !is null && 
                pULChangeLevel !is null && 
                pDefaultChangeLevel !is null &&
                pVote !is null );
    }

    ~HLUplinked() { }
}