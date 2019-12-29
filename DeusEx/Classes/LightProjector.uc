//------------------------------------
#exec obj load file=DeusExStaticMeshes

class LightProjector extends DynamicProjector;


defaultproperties
{
    ProjTexture=Texture'DXR_FX.Effects.flashlight5'
    MaterialBlendingOp=PB_Modulate
    FrameBufferBlendingOp=PB_Add
    MaxTraceDistance=2600
    bClipBSP=True
    bProjectOnUnlit=false //True
    bGradient=True
    bProjectOnAlpha=false //True
    bProjectOnParallelBSP=True
    bProjectActor=false // 
    FOV=3 //32
}
