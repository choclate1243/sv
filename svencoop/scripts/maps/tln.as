#include "point_checkpoint"
#include "cubemath/trigger_once_mp"

void MapInit()
{
	RegisterPointCheckPointEntity();
	RegisterTriggerOnceMpEntity();
	g_EngineFuncs.CVarSetFloat( "mp_hevsuit_voice", 1 );
}
