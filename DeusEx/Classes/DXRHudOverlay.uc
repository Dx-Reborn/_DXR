class DXRHudOverlay extends HUDOverlay;

var transient DxCanvas dxc;

event PreBeginPlay()
{
    if (dxc == None)
        dxc = DeusExHUD(Level.GetLocalPlayerController().myHUD).dxc;

    Super.PreBeginPlay();
}