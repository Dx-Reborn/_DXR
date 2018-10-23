//------------------------------------
#exec obj load file=DeusExStaticMeshes

class LightProjector extends DynamicProjector;


defaultproperties
{
    ProjTexture=Texture'DeusExStaticMeshes.Misc.FlashLightGlow'
    MaterialBlendingOp=PB_Modulate
    FrameBufferBlendingOp=PB_Add
    MaxTraceDistance=1600
    bClipBSP=True
    bProjectOnUnlit=false //True
    bGradient=True
    bProjectOnAlpha=false //True
    bProjectOnParallelBSP=True
    bLightChanged=false //True
    FOV=2 //32
}
