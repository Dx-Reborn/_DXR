//
// DeusExPickupInv : все съедобные и используемые предметы инвентаря.
// Поскольку Powerups нативные, то я не знаю, как они работают на уровне C++. 
// Броня и подобные предметы будут переделаны под этот класс.
//

class DeusExPickupInv extends RuntimePickup abstract;

function bool UpdateInfo(Object winInfo)
{
	local string str;

	if (winInfo == None)
		return false;

	GUIScrollTextBox(winInfo).SetContent("");
//	winInfo.SetTitle(itemName);
	GUIScrollTextBox(winInfo).SetContent(Description $ "||");

	if (bCanHaveMultipleCopies)
	{
		// Print the number of copies
		str = CountLabel @ String(NumCopies);
		GUIScrollTextBox(winInfo).AddText(str);
	}
	return true;
}


// ----------------------------------------------------------------------
// UseOnce()
// Subtract a use, then destroy if out of uses
// ----------------------------------------------------------------------
function UseOnce()
{
	local DeusExPlayer player;

	player = DeusExPlayer(Owner);
	NumCopies--;

	if (!IsA('SkilledTool'))
		GotoState('DeActivated');

	if (NumCopies <= 0)
	{
		if (player.inHand == Self)
			player.PutInHand(None);
		Destroy();
	}
	else
	{
		UpdateBeltText();
	}
}

function UpdateBeltText()
{
	// Stub for now...
}

simulated function BreakItSmashIt(class<fragment> FragType, float size) 
{
	local int i;
	local DeusExFragment s;

	for (i=0; i<Int(size); i++) 
	{
		s = DeusExFragment(Spawn(FragType, Owner));
		if (s != None)
		{
			s.Instigator = Instigator;
			s.CalcVelocity(Velocity,0);
			s.SetDrawScale(((FRand() * 0.05) + 0.05) * size);
			s.Skins[0] = GetMeshTexture();

			// play a good breaking sound for the first fragment
			if (i == 0)
				s.PlaySound(sound'GlassBreakSmall', SLOT_None,,, 768);
		}
	}

	Destroy();
}

singular function BaseChange()
{
	Super.BaseChange();

	// Make sure we fall if we don't have a base
	if ((base == None) && (Owner == None))
		SetPhysics(PHYS_Falling);
}


// ----------------------------------------------------------------------
// HandlePickupQuery()
//
// If the bCanHaveMultipleCopies variable is set to True, then we want
// to stack items of this type in the player's inventory.
// ----------------------------------------------------------------------

function bool HandlePickupQuery(inventory Item)
{
	local DeusExPlayer player;
	local Inventory anItem;
//	local Bool bAlreadyHas;
	local Bool bResult;

	if (Item.class == class)
	{
		player = DeusExPlayer(Owner);
		bResult = False;

		// Check to see if the player already has one of these in 
		// his inventory
		anItem = player.FindInventoryType(Item.class);
		log("found in inventory ? = "$anItem);

		if ((anItem != None) && (bCanHaveMultipleCopies))
		{
			// don't actually put it in the hand, just add it to the count
			NumCopies += DeusExPickupInv(item).NumCopies;
		player.ClientMessage("NumCopies="@NumCopies);

			if ((MaxCopies > 0) && (NumCopies > MaxCopies))
			{
				NumCopies -= DeusExPickupInv(item).NumCopies;
				player.ClientMessage(msgTooMany);

				// abort the pickup
				return True;
			}
			bResult = True;
		}

		if (bResult)
		{
			player.ClientMessage(PickupMessage @ Item.itemName, 'Pickup');

			// Destroy me!
			Item.Destroy();
		}
		else
		{
			bResult = Super.HandlePickupQuery(Item);
		}

		// Update object belt text
		if (bResult)			
			UpdateBeltText();	

		return bResult;
	}

	if ( Inventory == None )
		return false;

	return Inventory.HandlePickupQuery(Item);
}

event RenderOverlays(canvas Canvas)
{
	if ( (Instigator == None) || (Instigator.Controller == None))
		return;
 	super.RenderOverlays(Canvas);
  bDrawingFirstPerson = true;
  Canvas.DrawActor(self, false, true);
  bDrawingFirstPerson = false;
}

function PlayLandingSound()
{
	if (LandSound != None)
	{
		if (Velocity.Z <= -200)
		{
			PlaySound(LandSound, SLOT_None, TransientSoundVolume,, 768);
			class'EventManager'.static.AISendEvent(self,'LoudNoise', EAITYPE_Audio, TransientSoundVolume, 768);
		}
	}
}

function material GetMeshTexture(optional int texnum)
{
  return class'dxutil'.static.GetMeshTexture(self, texnum);
}


auto state Pickup
{
	// if we hit the ground fast enough, break it, smash it!!!
	function Landed(Vector HitNormal)
	{
		Super.Landed(HitNormal);

		if (bBreakable)
			if (VSize(Velocity) > 400)
				BreakItSmashIt(fragType, (CollisionRadius + CollisionHeight) / 2);
	}
}


/* ------------------------------------------------------------------------------------------------
   These functions will set or return required variables (we can't add variables to native
   classes like Actor)
------------------------------------------------------------------------------------------------ */
function int GetinvSlotsX()         // Number of horizontal inv. slots this item takes
{return invSlotsX;}

function int GetinvSlotsY()         // Number of vertical inv. slots this item takes
{return invSlotsY;}

function bool	GetInObjectBelt()     // Is this object actually in the object belt?
{return bInObjectBelt;}

function SetToObjectBelt(optional int position)     // Is this object actually in the object belt?
{bInObjectBelt = true;}

function int GetbeltPos()           // Position on the object belt
{return beltPos;}

function SetbeltPos(int position)           // Position on the object belt
{beltPos = position;}

function string GetbeltDescription()  // Description used on the object belt
{return beltdescription;}

function float GetlargeIconWidth()
{return largeIconWidth;}

function float GetlargeIconHeight()
{return largeIconHeight;}

function int GetinvPosX() // X position on the inventory window
{return invPosX;}

function int GetinvPosY() // Y position on the inventory window
{return invPosY;}

function SetinvPosX(int position) // X position on the inventory window
{invPosX = position;}

function SetinvPosY(int position) // Y position on the inventory window
{invPosY = position;}

function texture GetIcon()
{return icon;}

function texture GetLargeIcon()
{return largeIcon;}

function string GetDescription()
{
   return description$"||"$CountLabel@numcopies;
}


defaultproperties
{
    FragType=Class'GlassFragment'
}