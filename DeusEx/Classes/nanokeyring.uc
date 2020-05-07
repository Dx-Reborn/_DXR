//=============================================================================
// NanoKeyRing
//
// NanoKeyRing object.  In order to make things easier
// on the player, when the player picks up a key it's added 
// to the list of keys stored in the keyring
//
// 18/01/2018: список ключей переделан в динамический массив.
//=============================================================================

class NanoKeyRing extends SkilledTool;

var localized string NoKeys;
var localized string KeysAvailableLabel;

struct SNanoKeyStruct
{
    var() name             KeyID;
    var() localized String Description;
};

var() travel array<SNanoKeyStruct> NanoKeys; // ключи в динамическом массиве

event TravelPreAccept()
{
  // None
}

event TravelPostAccept()
{
    local inventory Item;

    item = Pawn(Owner).FindInventoryType(class);
    if (Item != None)
    {
       Pawn(Owner).DeleteInventory(Item);
       Item.Destroy();
       GiveTo(Pawn(Owner));
    }
    else
       GiveTo(Pawn(Owner));

    bPostTravel = true;
    PutBackInHand(); // “ебе особое приглашение нужно?!
}

function Sound GetBringUpSound()
{
    local DeusExGlobals gl;
    local sound sound;

    if (bPostTravel)
        return None;

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetKeyRingBringUp(gl.WS_Preset);
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
        sound = class'DXRWeaponSoundManager'.static.GetKeyRingPutDown(gl.WS_Preset);
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
        sound = class'DXRWeaponSoundManager'.static.GetKeyRingUseSound(gl.WS_Preset);
        if (sound != None)
        return sound;
        else
        return Super.GetUseSound();
    }
    else return Super.GetUseSound();
}


// ----------------------------------------------------------------------
// GetPlayer()
// ----------------------------------------------------------------------
function DeusExPlayer GetPlayer()
{
    return DeusExPlayer(Owner);
}

// ----------------------------------------------------------------------
// HasKey()
//
// Checks to see if we have the keyname passed in
// ----------------------------------------------------------------------
function bool HasKey(Name KeyToLookFor)
{
    local Bool bHasKey;
    local int x;

    bHasKey = False;

  for(x=0; x<NanoKeys.Length; x++)
  {
      if(NanoKeys[x].KeyID == KeyToLookFor)
      {
          bHasKey=true;
      }
  }
    return bHasKey;
}

// ----------------------------------------------------------------------
// GiveKey()
//
// Adds a key to our array
// ----------------------------------------------------------------------
function GiveKey(Name newKeyID, String newDescription)
{
    local int x, a;

    if (GetPlayer() != None)
    {
        // First check to see if the player already has this key
        if (HasKey(newKeyID))
            return;

    x = NanoKeys.Length;
    NanoKeys.Length = x + 1; // добавить 1 к длине массива
    NanoKeys[x].KeyID = newKeyID; // присвоить данные к элементу массива
    NanoKeys[x].Description = newDescription;

    a = GetPlayer().NanoKeys.Length;
    GetPlayer().NanoKeys.Length = a + 1; // добавить 1 к длине массива
    GetPlayer().NanoKeys[a].KeyID = newKeyID; // присвоить данные к элементу массива
    GetPlayer().NanoKeys[a].Description = newDescription;
    }
}


// ----------------------------------------------------------------------
// RemoveKey()
// ----------------------------------------------------------------------
function RemoveKey(Name KeyToRemove)
{
   local int x;

   if (GetPlayer() != None)
   {
      for (x=0; x<NanoKeys.Length; x++)
      {
         if (NanoKeys[x].KeyID == KeyToRemove)
             NanoKeys.Remove(x,1);
      }
   }
}

// ----------------------------------------------------------------------
// RemoveAllKeys()
// ----------------------------------------------------------------------
function RemoveAllKeys()
{
    NanoKeys.Length = 0;
}


// ----------------------------------------------------------------------
// GetKeyCount()
// ----------------------------------------------------------------------
function int GetKeyCount()
{
    return NanoKeys.Length;
}



// ----------------------------------------------------------------------
state UseIt
{
    function PutDown()
    {
        
    }

Begin:
    PlaySound(GetuseSound(), SLOT_None,1.5);
    PlayAnim('UseBegin',, 0.1);
    FinishAnim();
    LoopAnim('UseLoop',, 0.1);
    GotoState('StopIt');
}
// ----------------------------------------------------------------------
state StopIt
{
    function PutDown()
    {
        
    }

Begin:
    PlayAnim('UseEnd',, 0.1);
    GotoState('Idle', 'DontPlaySelect');
}

function GetKeysFromPockets()
{
  local int x;

  NanoKeys.Length = 0;
  NanoKeys.Length = DeusExPlayer(Owner).NanoKeys.Length;

   for (x=0; x<NanoKeys.Length; x++)
   {
      NanoKeys[x].KeyID = DeusExPlayer(Owner).NanoKeys[x].KeyID; // присвоить данные к элементу массива
      NanoKeys[x].Description = DeusExPlayer(Owner).NanoKeys[x].Description;
   }
}

function BringUp()
{
  GetKeysFromPockets();
    if (!IsInState('Idle'))
        GotoState('Idle');
}

function string GetDescription()
{
  return Description $"||"$ KeysAvailableLabel $ GetKeyCount();
}

function bool UpdateInfo(Object winInfo)
{
    local int keyCount, i;

    if (winInfo == None)
        return False;

//  winInfo.SetTitle(itemName);
    GUIScrollTextBox(winInfo).SetContent(KeysAvailableLabel);
    GUIScrollTextBox(winInfo).AddText("_____________________________________");

    if (GetPlayer() != None)
    {
    for (i=0;i<NanoKeys.Length;i++)
    {
       GUIScrollTextBox(winInfo).AddText("  " $ NanoKeys[i].Description);
       keyCount++;
    }
  }
    if (keyCount > 0)
    {
    GUIScrollTextBox(winInfo).AddText("_____________________________________");
        GUIScrollTextBox(winInfo).AddText(Description);
    }
    else
    {
        GUIScrollTextBox(winInfo).SetContent("");
//      winInfo.SetTitle(itemName);
        GUIScrollTextBox(winInfo).AddText(NoKeys);
    }
    return true;
}


defaultproperties
{
    UseSound=Sound'DeusExSounds.Generic.KeysRattling'
    Description="A nanokey ring can read and store the two-dimensional molecular patterns from different nanokeys, and then recreate those patterns on demand."
    NoKeys="No Nano Keys Available!"
    KeysAvailableLabel="Nano Keys Available: "
    ItemName="Nanokey Ring"
    beltDescription="KEY RING"

    Mesh=Mesh'DeusExItems.NanoKeyRing'
    PickupViewMesh=Mesh'DeusExItems.NanoKeyRing'
    FirstPersonViewMesh=Mesh'DeusExItems.NanoKeyRingPOV'

    CollisionRadius=5.510000
    CollisionHeight=4.690000
    Mass=10.000000
    Buoyancy=5.000000
    PlayerViewOffset=(X=16.00,Y=15.00,Z=-16.00),
    Icon=Texture'DeusExUI.Icons.BeltIconNanoKeyRing'
    largeIcon=Texture'DeusExUI.Icons.LargeIconNanoKeyRing'
    largeIconWidth=47
    largeIconHeight=44
    bDisplayableInv=false

    AttachmentClass=class'NanoKeyRingAtt'
    bCanHaveMultipleCopies=false     // if player can possess more than one of this
}
