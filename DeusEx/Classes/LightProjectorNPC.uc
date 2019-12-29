//------------------------------------
#exec obj load file=DeusExStaticMeshes

class LightProjectorNPC extends DynamicProjector;


defaultproperties
{
    ProjTexture=Texture'DeusExStaticMeshes.Misc.FlashLightGlow'
//    ProjTexture=Texture'DXR_FX.Effects.flashlight5'
    MaterialBlendingOp=PB_Modulate
    FrameBufferBlendingOp=PB_Add
    MaxTraceDistance=1200
    bClipBSP=True
    bProjectOnUnlit=false //True
    bGradient=True
    bProjectOnAlpha=false //True
    bProjectOnParallelBSP=True
    bProjectActor=false // 
    FOV=3 //32
}
