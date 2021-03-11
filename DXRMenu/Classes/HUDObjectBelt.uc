/*
   A container for toolbelt items.
*/
class HUDObjectBelt extends GUIPanel;

const AMOUNT_OF_TOOLBELT_SLOTS = 10;

var GUIPanel winSlots;                // Window containing slots
var HUDObjectSlot objects[AMOUNT_OF_TOOLBELT_SLOTS];

var int KeyRingSlot;
var bool bInteractive;

var DeusExPlayer player;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    Super.Initcomponent(MyController, MyOwner);
    player = DeusExPlayer(PlayerOwner().pawn);

    // Hardcoded size, baby!
    WinWidth = 541;
    WinHeight = 69;
//    SetSize(541, 69);
    
    CreateSlots();
    CreateNanoKeySlot();

    PopulateBelt();
}

function CreateSlots()
{
    local int i, p;
//    local RadioBoxWindow winRadio;

    // Radio window used to contain objects so they can be selected
    // with the mouse on the inventory screen.

/*    winRadio = RadioBoxWindow(NewChild(Class'RadioBoxWindow'));
    winRadio.SetSize(504, 54);
    winRadio.SetPos(10, 6);
    winRadio.bOneCheck = False;*/

    winSlots = new class'GUIPanel'; //TileWindow(winRadio.NewChild(Class'TileWindow'));

    for (i=0; i<AMOUNT_OF_TOOLBELT_SLOTS; i++)
    {
        p = 51 * i;
        objects[i] = new class'HUDObjectSlot'; // HUDObjectSlot(winSlots.NewChild(Class'HUDObjectSlot'));
        //objects[i].WinLeft = 56 + p;
        objects[i].WinTop = 0;
        AppendComponent(objects[i], true);
        objects[i].SetObjectNumber(i);
        //objects[i].Lower();

        // Last item is a little shorter
/*        if (i == 0)
        {
            objects[i].WinWidth = 44;
            objects[i].WinLeft = 566;
        }*/
    }
    AlignObjects();
}

function AlignObjects()
{
    local int i;
    local float aY;

    aY = -51.0;

    for (i=0; i<AMOUNT_OF_TOOLBELT_SLOTS; i++)
    {
        objects[i].WinLeft = aY +=51;

        // Last item is a little shorter
        if (i == 0)
        {
            objects[i].WinWidth = 44;
            objects[i].WinLeft = 510;
        }
    }
}



/* 
   The last object slot contains the NanoKeyRing, which lets the user
   easily open doors for which they have the code (Know the code!)
*/
function CreateNanoKeySlot()
{
    if (player != None)
    {
        if (player.KeyRing != None)
        {
            objects[KeyRingSlot].SetItem(player.KeyRing);
            objects[KeyRingSlot].AllowDragging(false);
        }
    }
}

/*
   Looks through the player's inventory and rebuilds the object belt
   based on the inventory items.  This needs to be done after a load game
*/
function PopulateBelt()
{
    local Inventory anItem;

    for (anItem=player.Inventory; anItem!=None; anItem=anItem.Inventory)
        if (anItem.bInObjectBelt)
            AddObjectToBelt(anItem, anItem.GetBeltPos(), true);
}

/*---------------------------------------------------------------------------*/

function AssignWinInv(PersonaScreenInventory newWinInventory)
{
/*    local Int slotIndex;

    // Update the individual slots
    for (slotIndex=0; slotIndex<10; slotIndex++)
        objects[slotIndex].AssignWinInv(newWinInventory);*/

    UpdateInHand();
}



/*
   Called when the player's "inHand" variable changes
*/
function UpdateInHand()
{
    local int slotIndex;
    
    // highlight the slot and unhighlight the other slots
    if ((player != None) && (!bInteractive))
    {
        for (slotIndex=0; slotIndex<ArrayCount(objects); slotIndex++)
        {
            // Highlight the object in the player's hand
            if ((player.inHand != None) && (objects[slotIndex].item == player.inHand))
                objects[slotIndex].HighlightSelect(true);
            else
                objects[slotIndex].HighlightSelect(false);

            if ((player.inHandPending != None) && (objects[slotIndex].item == player.inHandPending))
                objects[slotIndex].SetToggle(true);
            else
                objects[slotIndex].SetToggle(false);
        }
    }
}


function SetVisibility(bool bNewVisibility)
{
    bVisible = bNewVisibility;
}


function SetInteractive(bool bNewInteractive)
{
    bInteractive = bNewInteractive;
}


function ClearPosition(int pos)
{
    if (IsValidPos(pos))
        objects[pos].SetItem(None);
}


function ClearBelt()
{
    local int beltPos;

    for(beltPos=0; beltPos<10; beltPos++)
        ClearPosition(beltPos);
}


function bool AddObjectToBelt(Inventory newItem, int pos, bool bOverride)
{
    local int  i;
    local bool retval;

    retval = true;

    if ((newItem != None ) && (newItem.GetIcon() != None))
    {
        // If this is the NanoKeyRing, force it into slot 0
        if (newItem.IsA('NanoKeyRing'))
        {
            ClearPosition(0);
            pos = 0;
        }

        if (!IsValidPos(pos))
        {
            for (i=1; IsValidPos(i); i++)
                if (objects[i].GetItem() == None)
                    break;
            if (!IsValidPos(i))
            {
                if (bOverride)
                    pos = 1;
            }
            else
            {
                pos = i;
            }
        }

        if (IsValidPos(pos))
        {
            // If there's already an object here, remove it
            if (objects[pos].GetItem() != None)
                RemoveObjectFromBelt(objects[pos].GetItem());

            objects[pos].SetItem(newItem);
        }
        else
        {
            retval = false;
        }
    }
    else
        retval = false;

    // The inventory item needs to know it's in the object
    // belt, as well as the location inside the belt.  This is used
    // when traveling to a new map.

    if (retVal)
    {
        newItem.bInObjectBelt = true;
        newItem.SetBeltPos(pos);
    }

    UpdateInHand();

    return (retval);
}


function RemoveObjectFromBelt(Inventory item)
{
    local int i;

    for (i=1; IsValidPos(i); i++)
    {
        if (objects[i].GetItem() == item)
        {
            objects[i].SetItem(None);
            item.bInObjectBelt = False;
            item.setbeltPos(-1);
            break;
        }
    }
}


function bool IsValidPos(int pos)
{
    // Don't allow NanoKeySlot to be used
    if ((pos >= 0) && (pos < 10))
        return true;
    else
        return false;
}


function Inventory GetObjectFromBelt(int pos)
{
    if (IsValidPos(pos))
        return (objects[pos].GetItem());
    else
        return (None);
}

















