//=============================================================================
// Lockpick.
//=============================================================================
class Lockpick extends SkilledTool;

function Sound GetBringUpSound()
{
    local DeusExGlobals gl;
    local sound sound;

    if (bPostTravel)
        return None;

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetLockpickBringUp(gl.WS_Preset);
        if (sound != None)
        return sound;
        else
        return Super.GetBringUpSound();
    }
    else return Super.GetBringUpSound();
}

function Sound GetPutDownSound()
{
    local DeusExGlobals gl;
    local sound sound;

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetLockpickPutDown(gl.WS_Preset);
        if (sound != None)
        return sound;
        else
        return Super.GetPutDownSound();
    }
    else return Super.GetPutDownSound();
}

function Sound GetUseSound()
{
    local DeusExGlobals gl;
    local sound sound;

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetLockpickUseSound(gl.WS_Preset);
        if (sound != None)
        return sound;
        else
        return Super.GetUseSound();
    }
    else return Super.GetUseSound();
}


defaultproperties
{
   AttachmentClass=class'EmptyAttachment'

   UseSound=Sound'DeusExSounds.Generic.LockpickRattling'
   LandSound=Sound'DeusExSounds.Generic.PlasticHit2'

   maxCopies=20
   Description="A disposable lockpick. The tension wrench is steel, but appropriate needles are formed from fast congealing polymers.||<UNATCO OPS FILE NOTE AJ006-BLACK> Here's what they don't tell you: despite the product literature, you can use a standard lockpick to bypass all but the most high-class nanolocks. -- Alex Jacobson <END NOTE>"
   ItemName="Lockpick"
   beltDescription="LOCKPICK"
   PlayerViewOffset=(X=15.00,Y=10.00,Z=-15.00)

   Icon=Texture'DeusExUI.Icons.BeltIconLockPick'
   largeIcon=Texture'DeusExUI.Icons.LargeIconLockPick'
   largeIconWidth=45
   largeIconHeight=44

   Mesh=Mesh'DeusExItems.Lockpick'
   PickupViewMesh=Mesh'DeusExItems.Lockpick'
   FirstPersonViewMesh=Mesh'DeusExItems.LockpickPOV'

   CollisionRadius=11.750000
   CollisionHeight=1.900000
   Mass=20.000000
   Buoyancy=10.000000
}