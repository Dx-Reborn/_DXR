/* ---------------------------------------------------------------------
  Список содержимого карманов моего любимого JC )))

  Проблема: кнопка вкладки упорно не хочет никуда сдвигаться.
  Решение: сдвинуть сам фон относительно кнопок ))
--------------------------------------------------------------------- */

class gui_Inventory extends PlayerInterfacePanel;

#exec obj load file=MoverSFX

var GUIImage iInv, iKeys, iAmmo;
var GUIListBox invList;
var GUIButton btnEquip, btnUse, btnDrop, btnChangeAmmo;
var PersonaItemButton selectedItem;			// Currently Selected Inventory item

var HUDObjectSlot selectedSlot;
var HUDObjectSlot objects[10];

var GUILabel lInventory, lMoney, lMoneyAmount, winStatus; // Инвентарь, деньги, кол-во.
var GUILabel lCheckKeys, lCheckAmmo, winItemName;
var GUIScrollTextBox tDesc;

var int	invButtonHeight;
var	int invButtonWidth;

var int	smallInvHeight;									// Small Inventory Button Heigth
var int	smallInvWidth;									// Small Inventory Button Width

// Drag and Drop Stuff
var bool bDragging;
var InventoryButton dragButton;							// Button we're dragging around
var InventoryButton lastDragOverButton;
//var Window       lastDragOverWindow;
//var Window       destroyWindow;							// Used to defer window destroy

//var PersonaInventoryItemButton testItem;

var localized String InventoryTitleText,EquipButtonLabel,UnequipButtonLabel,UseButtonLabel,DropButtonLabel,ChangeAmmoButtonLabel;
var localized String NanoKeyRingInfoText,NanoKeyRingLabel,DroppedLabel,AmmoLoadedLabel,WeaponUpgradedLabel,CannotBeDroppedLabel;
var localized String AmmoInfoText,AmmoTitleLabel,NoAmmoLabel, strNoKeys, strCredits;

/* Frames positioning */
var(leftPart) float lFrameX, lframeY, lfSizeX, lfSizeY;
var(midPart) float mFrameX, mframeY, mfSizeX, mfSizeY;
var(rightPart) float rFrameX, rframeY, rfSizeX, rfSizeY;

var(BleftPart) float lFrameXb, lframeYb, lfSizeXb, lfSizeYb;
var(BmidPart) float mFrameXb, mframeYb, mfSizeXb, mfSizeYb;
var(BrightPart) float rFrameXb, rframeYb, rfSizeXb, rfSizeYb;


function ShowPanel(bool bShow)
{
  super.ShowPanel(bShow);

 	player.winInv = self;

  if (bShow) // как в GMDX )))
     PlayerOwner().pawn.PlaySound(Sound'MetalDrawerOpen',,0.25);

  EnableButtons();
}

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.Initcomponent(MyController, MyOwner);
	player = DeusExPlayer(PlayerOwner().pawn);

	CreateMyControls();
  invListChange(none);
}

function CreateMyControls()
{
  invList = new(none) class'GUIListBox';
//  invList.OnClick=InternalOnClick;
  invList.SelectedStyleName="STY_DXR_ListSelection";
  invList.StyleName = "STY_DXR_Listbox";
  invList.bBoundToParent = true;
  invList.OnChange=invListChange;
  invList.WinHeight = 125;
  invList.WinWidth = 212;
  invList.WinLeft = 780;//20;
  invList.WinTop = 82;
	AppendComponent(invList, true);
/*--------------------------------------------------------------------------------------------------*/
  btnEquip = new(none) class'GUIButton';
  btnEquip.FontScale = FNS_Small;
  btnEquip.Caption = EquipButtonLabel;
  btnEquip.Hint = "Equip or Unequip selected inventory item";
  btnEquip.StyleName="STY_DXR_ButtonNavbar";
  btnEquip.bBoundToParent = true;
  btnEquip.OnClick = InternalOnClick;
  btnEquip.WinHeight = 22;
  btnEquip.WinWidth = 87;
  btnEquip.WinLeft = 42;
  btnEquip.WinTop = 445;
	AppendComponent(btnEquip, true);

  btnUse = new(none) class'GUIButton';
  btnUse.FontScale = FNS_Small;
  btnUse.Caption = UseButtonLabel;
  btnUse.Hint = "Use selected inventory item";
  btnUse.StyleName="STY_DXR_ButtonNavbar";
  btnUse.bBoundToParent = true;
  btnUse.OnClick = InternalOnClick;
  btnUse.WinHeight = 22;
  btnUse.WinWidth = 76;
  btnUse.WinLeft = 130;
  btnUse.WinTop = 445;
	AppendComponent(btnUse, true);

  btnDrop = new(none) class'GUIButton';
  btnDrop.FontScale = FNS_Small;
  btnDrop.Caption = DropButtonLabel;
  btnDrop.Hint = "Drop selected inventory item if possible";
  btnDrop.StyleName="STY_DXR_ButtonNavbar";
  btnDrop.bBoundToParent = true;
  btnDrop.OnClick = InternalOnClick;
  btnDrop.WinHeight = 22;
  btnDrop.WinWidth = 76;
  btnDrop.WinLeft = 207;
  btnDrop.WinTop = 445;
	AppendComponent(btnDrop, true);

  btnChangeAmmo = new(none) class'GUIButton';
  btnChangeAmmo.FontScale = FNS_Small;
  btnChangeAmmo.Caption = ChangeAmmoButtonLabel;
  btnChangeAmmo.Hint = "Change ammo type for selected weapon";
  btnChangeAmmo.StyleName="STY_DXR_ButtonNavbar";
  btnChangeAmmo.bBoundToParent = true;
  btnChangeAmmo.OnClick = InternalOnClick;
  btnChangeAmmo.WinHeight = 22;
  btnChangeAmmo.WinWidth = 78;
  btnChangeAmmo.WinLeft = 284;
  btnChangeAmmo.WinTop = 445;
	AppendComponent(btnChangeAmmo, true);

/*--------------------------------------------------------------------------------------------------*/
  tDesc = new(none) class'GUIScrollTextBox';
  tDesc.StyleName="STY_DXR_DeusExScrollTextBox";
  tDesc.bBoundToParent = true;
  tDesc.FontScale=FNS_Small;
	tDesc.WinHeight = 270;
  tDesc.WinWidth = 340;
  tDesc.WinLeft = 425;
  tDesc.WinTop = 78;
  tDesc.bRepeat = false;//true;
  tDesc.bNoTeletype = true;
  tDesc.EOLDelay = 0.01;//75;
  tDesc.CharDelay = 0.01;
  tDesc.RepeatDelay = 3.0;
	AppendComponent(tDesc, true);

  iInv = new(none) class'GUIImage'; 
  iInv.Image=texture'DXR_Inventory';
  iInv.bBoundToParent = true;
	iInv.WinHeight = 600;
  iInv.WinWidth = 800;
  iInv.WinLeft = 0;
  iInv.WinTop = 32;
  iInv.tag = 75;
	AppendComponent(iInv, true);
/*--------------------------------------------------------------------------------------------------*/
  lInventory = new(none) class'GUILabel';
  lInventory.bBoundToParent = true;
  lInventory.TextColor = class'DXR_Menu'.static.GetPlayerInterfaceHDR(gl.MenuThemeIndex);
  lInventory.caption = InventoryTitleText;
  lInventory.TextFont="UT2HeaderFont";
  lInventory.FontScale = FNS_Small;
 	lInventory.WinHeight = 21;
  lInventory.WinWidth = 93;
  lInventory.WinLeft = 42;
  lInventory.WinTop = 42;
	AppendComponent(lInventory, true);

  lMoney = new(none) class'GUILabel';
  lMoney.bBoundToParent = true;
  lMoney.TextAlign = TXTA_Right;
  lMoney.TextColor = class'DXR_Menu'.static.GetPlayerInterfaceTextLabels(gl.MenuThemeIndex);
  lMoney.caption = strCredits;
  lMoney.TextFont="UT2HeaderFont";
  lMoney.FontScale = FNS_Small;
 	lMoney.WinHeight = 21;
  lMoney.WinWidth = 129;
  lMoney.WinLeft = 156;
  lMoney.WinTop = 42;
	AppendComponent(lMoney, true);

  lMoneyAmount = new(none) class'GUILabel';
  lMoneyAmount.bBoundToParent = true;
  lMoneyAmount.TextAlign = TXTA_Center;
  lMoneyAmount.TextColor = class'DXR_Menu'.static.GetPlayerInterfaceTextLabels(gl.MenuThemeIndex);
  lMoneyAmount.caption = "Placeholder";
  lMoneyAmount.TextFont="UT2HeaderFont";
  lMoneyAmount.FontScale = FNS_Small;
 	lMoneyAmount.WinHeight = 21;
  lMoneyAmount.WinWidth = 73;
  lMoneyAmount.WinLeft = 288;
  lMoneyAmount.WinTop = 42;
	AppendComponent(lMoneyAmount, true);

	// Сообщение
  winStatus = new class'GUILabel';
  winStatus.bBoundToParent = true;
  winStatus.TextAlign = TXTA_Left;
  winStatus.TextColor = class'DXR_Menu'.static.GetPlayerInterfaceTextLabels(gl.MenuThemeIndex);
  winStatus.caption = "Message";
  winStatus.TextFont="UT2SmallFont";
  winStatus.FontScale = FNS_Small;
 	winStatus.WinHeight = 21;
  winStatus.WinWidth = 344;
  winStatus.WinLeft = 423;
  winStatus.WinTop = 354;
	AppendComponent(winStatus, true);

	// Название выбранного предмета инвентаря
	winItemName = new class'GUILabel';
  winItemName.bBoundToParent = true;
  winItemName.TextAlign = TXTA_Center;
  winItemName.TextColor = class'DXR_Menu'.static.GetPlayerInterfaceTextLabels(gl.MenuThemeIndex);
  winItemName.caption = "Header";
  winItemName.TextFont="UT2HeaderFont";
  winItemName.FontScale = FNS_Small;
 	winItemName.WinHeight = 21;
  winItemName.WinWidth = 344;
  winItemName.WinLeft = 423;
  winItemName.WinTop = 56;
	AppendComponent(winItemName, true);
/*-- Ключики ---------------------------------------------------------------------------------------*/
	iKeys = new(none) class'GUIImage';
	iKeys.image = texture'LargeIconNanoKeyRing';
	iKeys.bBoundToParent = true;
  iKeys.bAcceptsInput = true;
	iKeys.WinLeft = 426;//423;
	iKeys.WinTop = 407;//431;//423;
 	iKeys.WinHeight = 53;
  iKeys.WinWidth = 53;
  iKeys.OnClickSound = CS_Click;
  iKeys.OnClick = InternalOnClick;
	AppendComponent(iKeys, true);

  lCheckKeys = new(none) class'GUILabel';
  lCheckKeys.bBoundToParent = true;
  lCheckKeys.TextColor = class'DXR_Menu'.static.GetPlayerInterfaceTextLabels(gl.MenuThemeIndex);
  lCheckKeys.caption = NanoKeyRingInfoText;
  lCheckKeys.TextFont="UT2SmallFont";
  lCheckKeys.bMultiLine = true;
  lCheckKeys.TextAlign = TXTA_Center;
  lCheckKeys.VertAlign = TXTA_Center;
  lCheckKeys.FontScale = FNS_Small;
 	lCheckKeys.WinHeight = 51;
  lCheckKeys.WinWidth = 100;
  lCheckKeys.WinLeft = 480;
  lCheckKeys.WinTop = 400;//424;
	AppendComponent(lCheckKeys, true);
/*-- Боеприпасы ------------------------------------------------------------------------------------*/
  lCheckAmmo = new(none) class'GUILabel';
  lCheckAmmo.bBoundToParent = true;
  lCheckAmmo.TextColor = class'DXR_Menu'.static.GetPlayerInterfaceTextLabels(gl.MenuThemeIndex);
  lCheckAmmo.caption = AmmoInfoText;
  lCheckAmmo.TextFont="UT2SmallFont";
  lCheckAmmo.bMultiLine = true;
  lCheckAmmo.TextAlign = TXTA_Center;
  lCheckAmmo.VertAlign = TXTA_Center;
  lCheckAmmo.FontScale = FNS_Small;
 	lCheckAmmo.WinHeight = 51;
  lCheckAmmo.WinWidth = 100;
  lCheckAmmo.WinLeft = 609;
  lCheckAmmo.WinTop = 400;//424;
	AppendComponent(lCheckAmmo, true);

	iAmmo = new(none) class'GUIImage';
	iAmmo.image = texture'LargeIconAmmoShells';
	iAmmo.bBoundToParent = true;
  iAmmo.bAcceptsInput = true;
	iAmmo.WinLeft = 725;//715;
	iAmmo.WinTop = 407;//431;//423;
 	iAmmo.WinHeight = 53;
  iAmmo.WinWidth = 53;
  iAmmo.OnClickSound = CS_Click;
  iAmmo.OnClick = InternalOnClick;
	AppendComponent(iAmmo, true);

  ApplyTheme();
	fillList();
  SetMoney();
  CreateInventoryButtons();
  CreateToolBeltSlots();
}

// ----------------------------------------------------------------------
// CreateSlots()
//
// Creates the Slots 
// ----------------------------------------------------------------------
function CreateToolBeltSlots()
{
	local int i, p;

	for (i=0; i<10; i++)
	{
	  p = 51 * i;
		objects[i] = new class'HUDObjectSlot';
		objects[i].WinTop = 486;
		objects[i].WinLeft = 56 + p;
		objects[i].WinInv = self;
		//objects[i].OnClick = InternalOnClick;
		AppendComponent(objects[i], true);
		objects[i].SetObjectNumber(i);

		// Last item is a little shorter
		if (i == 0)
		{
			objects[i].WinWidth = 44;
      objects[i].WinLeft = 566;
		}
		// Заполнить...
    if (DeusExPlayer(PlayerOwner().pawn).belt[i] != none)
	      Objects[i].SetItem(DeusExPlayer(PlayerOwner().pawn).belt[i]);
	}
}


function SetMoney()
{
  lMoneyAmount.caption = string(DeusExPlayer(PlayerOwner().pawn).credits);
}

function ListNanoKeys()
{
  local int i;
  local DeusExPlayer p;

  p = DeusExPlayer(PlayerOwner().pawn);

  tDesc.SetContent(NanoKeyRingLabel);

  if (p.NanoKeys.Length == 0)
  {
   tDesc.AddText(strNoKeys);
  }
  else
    {
      for (i=0;i<p.NanoKeys.Length;i++)
      {
         tDesc.AddText(p.NanoKeys[i].Description);
      }
    }
}

function fillList()
{
	local Inventory inv;

  invList.List.Clear();

	inv = PlayerOwner().Pawn.Inventory;
	while (inv != None)
	{
//	  log("Adding inventory to list...");
    invList.List.Add(inv.ItemName, inv, inv.GetDescription());
		inv = inv.inventory;
	}
}

function invListChange(GUIComponent Sender)
{
  tDesc.SetContent(invList.List.GetExtra());
}


function bool InternalOnClick(GUIComponent Sender)
{
  if (Sender==iKeys)
  {
    ListNanoKeys();
  }

  if (Sender==btnEquip)
  {
    EquipSelectedItem();
    EnableButtons();
    return true;
/*   inv = Inventory(invList.List.GetObject());
   DeusExPlayer(PlayerOwner().pawn).Weapon=none;
   DeusExPlayer(PlayerOwner().pawn).PutInHand(inv);*/
  }

  if (Sender==btnUse)
  {
    UseSelectedItem();
  }

  if (Sender==btnDrop)
  {
     DropSelectedItem();
  }
	return true;
}

function PaintFrames(canvas u)
{
  local float x,y;

  x = ActualLeft(); y = ActualTop();

  u.DrawColor = class'DXR_Menu'.static.GetPlayerInterfaceFrames(gl.MenuThemeIndex);
  u.Style = EMenuRenderStyle.MSTY_Translucent;

  u.SetPos(x + lFrameX, y + lframeY);
  u.drawtileStretched(texture'InventoryBorder_1', lfSizeX, lfSizeY);

  u.SetPos(x + mFrameX, y + mframeY);
  u.drawtileStretched(texture'InventoryBorder_2', mfSizeX, mfSizeY);

  u.SetPos(x + rFrameX, y + rframeY);
  u.drawtileStretched(texture'InventoryBorder_3', rfSizeX, rfSizeY);
/*-----------------*/
  u.SetPos(x + lFrameXb, y + lframeYb);
  u.drawtileStretched(texture'InventoryBorder_4', lfSizeXb, lfSizeYb);

  u.SetPos(x + mFrameXb, y + mframeYb);
  u.drawtileStretched(texture'InventoryBorder_5', mfSizeXb, mfSizeYb);

  u.SetPos(x + rFrameXb, y + rframeYb);
  u.drawtileStretched(texture'InventoryBorder_6', rfSizeXb, rfSizeYb);
}

// ----------------------------------------------------------------------
// CalculateItemPosition()
//
// Calculates exactly where this item belongs in the window based on 
// the position passed in (relative to "winItems") and the inventory 
// item.  
//
// Returns TRUE if this is a valid drop slot (not out of bounds)
// ----------------------------------------------------------------------

function bool CalculateItemPosition(Inventory item,float pointX,float pointY,out int slotX,out int slotY)
{
	local int invWidth;
	local int invHeight;
	local int adjustX;
	local int adjustY;
	local bool bResult;

	bResult = True;

	// First get the width and height of the inventory icon
	invWidth  = item.GetlargeIconWidth();
	invHeight = item.GetlargeIconHeight();

	// Calculate the first square that represents where this object is
	adjustX = 0;
	adjustY = 0;

	if (invWidth > invButtonWidth)
		adjustX = ((invWidth/2) - (invButtonWidth / 2));

	if (invWidth > invButtonwidth)
		adjustY = ((invHeight/2) - (invButtonHeight /2));

	// Check to see if we're outside the range of where the 
	// slots are located.
	if ((pointX - adjustX) > (invButtonWidth  * player.maxInvCols))
	{
		slotX = player.maxInvCols - 1;
		if (slotX < 0)
			slotX = 0;

		bResult = False;
	}
	else
	{
		slotX = (pointX - adjustX) / invButtonWidth;

		if (slotX < 0)
			slotX = 0;
	}
	if ((pointY - adjustY) > (invButtonHeight * player.maxInvRows))
	{
		slotY = player.maxInvRows - 1;
		bResult = False;
	}
	else
	{
		slotY = (pointY - adjustY) / invButtonHeight;
	}
	return bResult;
}


// ----------------------------------------------------------------------
// InventoryDeleted()
//
// Called when some external force needs to remove an inventory 
// item from the player. For instance, when an item is "used" and it's
// a single-use item, it destroys itself, which will ultimately 
// result in this ItemDeleted() call.
// ----------------------------------------------------------------------

function InventoryDeleted(Inventory item)
{
	if (item != None)
	{
		// Remove the item from the screen
		RemoveItem(item);
	}
}

// ----------------------------------------------------------------------
// RemoveItem()
//
// Removes this item from the screen.  If this is the selected item, 
// does some additional processing.
// ----------------------------------------------------------------------
function RemoveItem(Inventory item)
{
//	local Window itemWindow;
  local int i;

	if (item == None)
		return;

	// Remove it from the object belt
//	invBelt.RemoveObject(item);

	if ((selectedItem != None) && (item == selectedItem.GetClientObject()))
	{
		RemoveSelectedItem();
	}
	else
	{
		// Loop through the PersonaInventoryItemButtons looking for a match
    for (i=0;i<Controls.Length;i++)
    {
       if (controls[i].IsA('PersonaInventoryItemButton'))
		    if (PersonaInventoryItemButton(Controls[i]).GetClientObject() == item)
		    {
	        PersonaInventoryItemButton(Controls[i]).free();
//	        class'ObjectManager'.static.Destroy(PersonaInventoryItemButton(Controls[i]));
          break;
		    }
    }

/*		itemWindow = winItems.GetTopChild();
		while( itemWindow != None )
		{
			if (itemWindow.GetClientObject() == item)
			{
				DeferDestroy(itemWindow);
//				itemWindow.Destroy();
				break;
			}
			
			itemWindow = itemWindow.GetLowerSibling();
		}*/
	}
}


// ----------------------------------------------------------------------
// CreateInventoryButtons()
//
// Loop through all the Inventory items and draw them in our Inventory 
// grid as buttons
//
// As we're doing this, we're going to regenerate the inventory grid
// stored in the player, since it sometimes (very rarely) gets corrupted
// and this is a nice hack to make sure it stays clean should that
// occur.  Ooooooooooo did I say "nice hack"?
// ----------------------------------------------------------------------
function CreateInventoryButtons()
{
	local Inventory anItem;
	local PersonaInventoryItemButton newButton;

	// First, clear the player's inventory grid.
	player.ClearInventorySlots();

	// Iterate through the inventory items, creating a unique button for each
	anItem = player.Inventory;

	while(anItem != None)
	{
		if (anItem.bDisplayableInv)
		{
			// Create another button
			newButton = new class'PersonaInventoryItemButton';
			newButton.OnClick = InventoryClick;
			AppendComponent(newButton, true);
			newButton.SetClientObject(anItem);
			newButton.SetInventoryWindow(Self);

			// If the item has a large icon, use it.  Otherwise just use the 
			// smaller icon that's also shared by the object belt 

			if ( anItem.GetlargeIcon() != None )
			{
				newButton.SetIcon(anItem.GetlargeIcon());
				newButton.SetIconSize(anItem.GetlargeIconWidth(), anItem.GetlargeIconHeight());
			}
			else
			{
				newButton.SetIcon(anItem.Geticon());
				newButton.SetIconSize(smallInvWidth, smallInvHeight);
			}
			log("Set size of button: "@(invButtonWidth  * anItem.GetinvSlotsX()) + 1@ (invButtonHeight * anItem.GetinvSlotsY()) + 1);
			newButton.SetSize((invButtonWidth  * anItem.GetinvSlotsX()) + 1, (invButtonHeight * anItem.GetinvSlotsY()) + 1);

			// Okeydokey, update the player's inventory grid with this item.
			player.SetInvSlots(anItem, 1);

			// If this item is currently equipped, notify the button
			if (anItem == player.inHand)
				newButton.SetEquipped(true);

			// If this inventory item already has a position, use it.
			if (( anItem.GetinvPosX() != -1 ) && ( anItem.GetinvPosY() != -1 ))
			{
				SetItemButtonPos(newButton, anItem.GetinvPosX(), anItem.GetinvPosY());
			}
			else
			{
				// Find a place for it.
				if (player.FindInventorySlot(anItem))
					SetItemButtonPos(newButton, anItem.GetinvPosX(), anItem.GetinvPosY());
				else
					newButton.free();//Destroy();		// Shit!
			}
		}
//    log("item.InvPosX="$anItem.GetinvPosX() @ "item.InvPosY="$anItem.GetinvPosY());
		anItem = anItem.Inventory;
	}	
}

function bool InventoryClick(GUIComponent Sender)
{
  if (Sender.IsA('PersonaItemButton'))
  {
    SelectInventory(PersonaItemButton(Sender));
    return true;
  }
}

function SelectInventory(PersonaItemButton buttonPressed)
{
	local Inventory anItem;

	// Don't do extra work.
	if (buttonPressed != None) 
	{
		if (selectedItem != buttonPressed)
		{
			// Deselect current button
			if (selectedItem != None)
				selectedItem.SelectButton(False);

			selectedItem = buttonPressed;

			ClearSpecialHighlights();
			HighlightSpecial(Inventory(selectedItem.GetClientObject()));
//			SelectObjectBeltItem(Inventory(selectedItem.GetClientObject()), True);

			selectedItem.SelectButton(True);

			anItem = Inventory(selectedItem.GetClientObject());

//			if (anItem != None)
//				anItem.UpdateInfo(winInfo);

			EnableButtons();
		}
	}
	else
	{
		if (selectedItem != None)
			PersonaInventoryItemButton(selectedItem).SelectButton(False);

//		if (selectedSlot != None)
//			selectedSlot.SetToggle(False);

		selectedItem = None;
	}
}

function ClearSpecialHighlights()
{
  local int i;

  for (i=0;i<Controls.Length;i++)
  {
    if (controls[i].IsA('PersonaInventoryItemButton'))
    PersonaInventoryItemButton(controls[i]).ResetFill();
  }

/*	local Window itemWindow;
	local PersonaInventoryItemButton itemButton;
	local Inventory anItem;

	// Loop through all our children and check to see if 
	// we have a match.

	itemWindow = winItems.GetTopChild();
	while( itemWindow != None )
	{
		itemButton = PersonaInventoryItemButton(itemWindow);
		if (itemButton != None)
		{
			itemButton.ResetFill();
		}

		itemWindow = itemWindow.GetLowerSibling();
	}*/
}

function SetItemButtonPos(PersonaInventoryItemButton moveButton, int slotX, int slotY)
{
	moveButton.dragPosX = slotX;
	moveButton.dragPosY = slotY;

	moveButton.SetPos(moveButton.dragPosX * (invButtonWidth), moveButton.dragPosY * (invButtonHeight));
}

function EnableButtons()
{
	local Inventory inv;

	// Make sure all the buttons exist!
	if ((btnChangeAmmo == None) || (btnDrop == None) || (btnEquip == None) || (btnUse == None))
		return;

	if ( selectedItem == None )
	{
		btnChangeAmmo.DisableMe();
		btnDrop.DisableMe();
		btnEquip.DisableMe();
		btnUse.DisableMe();
	}
	else
	{
		btnChangeAmmo.EnableMe();
		btnEquip.EnableMe();
		btnUse.EnableMe();
		btnDrop.EnableMe();

		inv = Inventory(selectedItem.GetClientObject());

		if (inv != None)
		{
			// Anything can be dropped, except the NanoKeyRing
			btnDrop.EnableMe();

			if (inv.IsA('WeaponModInv'))
			{
				btnChangeAmmo.DisableMe();
				btnUse.DisableMe();
			}
			else if (inv.IsA('NanoKeyRingInv'))
			{
				btnChangeAmmo.DisableMe();
				btnDrop.DisableMe();
				btnEquip.DisableMe();
				btnUse.DisableMe();
			}
			// Augmentation Upgrade Cannisters cannot be used
			// on this screen
			else if ( inv.IsA('AugmentationUpgradeCannisterInv') )
			{
				btnUse.DisableMe();
				btnChangeAmmo.DisableMe();
			}
			// Ammo can't be used or equipped
			else if (inv.IsA('Ammunition'))
			{
				btnUse.DisableMe();
				btnEquip.DisableMe();
			}
			else 
			{
				if ((inv == player.inHand ) || (inv == player.inHandPending))
					btnEquip.Caption = UnequipButtonLabel;
				else
					btnEquip.Caption = EquipButtonLabel;
			}

			// If this is a weapon, check to see if this item has more than 
			// one type of ammo in the player's inventory that can be
			// equipped.  If so, enable the "AMMO" button.
			if ( inv.IsA('DeusExWeaponInv') )
			{
				btnUse.DisableMe();

				if (DeusExWeaponInv(inv).NumAmmoTypesAvailable() < 2 )
					btnChangeAmmo.DisableMe();
			}
			else
			{
				btnChangeAmmo.DisableMe();
			}
		}
		else
		{
			btnChangeAmmo.DisableMe();
			btnDrop.DisableMe();
			btnEquip.DisableMe();
			btnUse.DisableMe();
		}
	}
}

/*-- Equip && UnEquip -------------------------------------------------------------------------------------------*/
function EquipSelectedItem()
{
	local Inventory inv;

	// If the object's in-hand, then unequip
	// it.  Otherwise put this object in-hand.

	inv = Inventory(selectedItem.GetClientObject());
	
	if ( inv != None )
	{
		// Make sure the Binoculars aren't activated.
		if ((player.inHand != None) && (player.inHand.IsA('BinocularsInv')))
			BinocularsInv(player.inHand).Activate();
		else if ((player.inHandPending != None) && (player.inHandPending.IsA('BinocularsInv')))
			BinocularsInv(player.inHandPending).Activate();

		if ((inv == player.inHand) || (inv == player.inHandPending))
		{
			UnequipItemInHand();
		}
		else
		{
			player.PutInHand(inv);
			PersonaInventoryItemButton(selectedItem).SetEquipped(True);
		}
		EnableButtons();
	}
}

function UnequipItemInHand()
{
	if ((PersonaInventoryItemButton(selectedItem) != None) && ((player.inHand != None) || (player.inHandPending != None)))
	{
		player.PutInHand(None);
		player.SetInHandPending(None);

		PersonaInventoryItemButton(selectedItem).SetEquipped(False);
		EnableButtons();
	}
}
/*-- !Equip && UnEquip ------------------------------------------------------------------------------------------*/

function DropSelectedItem()
{
	local Inventory anItem;
	local int numCopies;

	if (selectedItem == None)
		return;

	if (Inventory(selectedItem.GetClientObject()) != None)
	{
		// Now drop it, unless this is the NanoKeyRing
		if (!Inventory(selectedItem.GetClientObject()).IsA('NanoKeyRingInv'))
		{
			anItem = Inventory(selectedItem.GetClientObject());

			// If this is a DeusExPickup, keep track of the number of copies
			if (anItem.IsA('DeusExPickupInv'))
				numCopies = DeusExPickupInv(anItem).NumCopies;

			// First make sure the player can drop it!
			if (player.DropItem(anItem, True))
			{
				// Make damn sure there's nothing pending
				if ((player.inHandPending == anItem) || (player.inHand == anItem))
					player.SetInHandPending(None);

				// Remove the item, but first check to see if it was stackable
				// and there are more than 1 copies available

				if ( (!anItem.IsA('DeusExPickupInv')) || (anItem.IsA('DeusExPickupInv') && (numCopies <= 1)))
				{
					RemoveSelectedItem();
				}
				// Send status message
				winStatus.Caption = class'Actor'.static.Sprintf(DroppedLabel, anItem.itemName);

				// Update the object belt
			//	invBelt.UpdateBeltText(anItem);
			}
			else
			{
				winStatus.Caption = class'Actor'.static.Sprintf(CannotBeDroppedLabel, anItem.itemName);
			}
		}
	}
}

function RemoveSelectedItem()
{
	local Inventory inv;

	if (selectedItem == None)
		return;

	inv = Inventory(selectedItem.GetClientObject());

	if (inv != None)
	{
		// Destroy the button
		selectedItem.free(); //Destroy();
//		class'ObjectManager'.static.Destroy(selectedItem);
		selectedItem = None;

		// Remove it from the object belt
//		invBelt.RemoveObject(inv);

		// Remove it from the inventory screen
		UnequipItemInHand();

		ClearSpecialHighlights();

		SelectInventory(None);

		tDesc.SetContent(""); //winInfo.Clear();
		EnableButtons();
	}
}

function UseSelectedItem()
{
	local Inventory inv;
	local int numCopies;

	inv = Inventory(selectedItem.GetClientObject());

	if (inv != None)
	{
		// If this item was equipped in the inventory screen, 
		// make sure we set inHandPending to None so it's not
		// drawn when we exit the Inventory screen

		if (player.inHandPending == inv)
			player.SetInHandPending(None);

		// If this is a binoculars, then it needs to be equipped
		// before it can be activated
		if (inv.IsA('BinocularsInv')) 
			player.PutInHand(inv);

		inv.Activate();

		// Check to see if this is a stackable item, and keep track of 
		// the count
		if ((inv.IsA('DeusExPickupInv')) && (DeusExPickupInv(inv).bCanHaveMultipleCopies))
			numCopies = DeusExPickupInv(inv).NumCopies - 1;
		else
			numCopies = 0;

		// Update the object belt
//		invBelt.UpdateBeltText(inv);

		// Refresh the info!
//		if (numCopies > 0)
	//		UpdateWinInfo(inv);
	}
}


function MoveItemButton(PersonaInventoryItemButton anItemButton, int col, int row)
{
	player.SetInvSlots(Inventory(anItemButton.GetClientObject()), 0);
	player.PlaceItemInSlot(Inventory(anItemButton.GetClientObject()), col, row );
	SetItemButtonPos(anItemButton, col, row);
}

function ReturnButton(PersonaInventoryItemButton anItemButton)
{
	local Inventory inv;

	inv = Inventory(anItemButton.GetClientObject());

	player.PlaceItemInSlot(inv, inv.GetinvPosX(), inv.GetinvPosY());
	SetItemButtonPos(anItemButton, inv.GetinvPosX(), inv.GetinvPosY());
}

function HighlightSpecial(Inventory item)
{
	if (item != None)
	{
		if (item.IsA('WeaponModInv'))
			HighlightModWeapons(WeaponModInv(item));
//		else if (item.IsA('DeusExAmmoInv'))
//			HighlightAmmoWeapons(DeusExAmmoInv(item));
	}
}

// ----------------------------------------------------------------------
// Highlights/Unhighlights any weapons that can be upgraded with the 
// weapon mod passed in
// ----------------------------------------------------------------------
function HighlightModWeapons(WeaponModInv weaponMod)
{
  local int i;
  local inventory anItem;
	local PersonaInventoryItemButton itemButton;

  for (i=0;i<Controls.Length;i++)
  {
    if (controls[i].IsA('PersonaInventoryItemButton'))
    {
      itemButton = PersonaInventoryItemButton(controls[i]);
		  if (itemButton != None)
      {
			  anItem = Inventory(itemButton.GetClientObject());
			  if ((anItem != None) && (anItem.IsA('DeusExWeaponInv')))
			  {
				  if ((weaponMod != None) && (weaponMod.CanUpgradeWeapon(DeusExWeaponInv(anItem))))
				  {
					  itemButton.HighlightWeapon(True);
				  }
			  }
        else
        {
				   itemButton.ResetFill();
        }
		  }
    }
  }

//    PersonaInventoryItemButton(controls[i]).ResetFill();
/*	local Window itemWindow;
	local PersonaInventoryItemButton itemButton;
	local Inventory anItem;

	// Loop through all our children and check to see if 
	// we have a match.

	itemWindow = winItems.GetTopChild();
	while( itemWindow != None )
	{
		itemButton = PersonaInventoryItemButton(itemWindow);
		if (itemButton != None)
		{
			anItem = Inventory(itemButton.GetClientObject());
			if ((anItem != None) && (anItem.IsA('DeusExWeapon')))
			{
				if ((weaponMod != None) && (weaponMod.CanUpgradeWeapon(DeusExWeapon(anItem))))
				{
					itemButton.HighlightWeapon(True);
				}
			}
			else
			{
				itemButton.ResetFill();
			}
		}	
		itemWindow = itemWindow.GetLowerSibling();
	}*/
}



function StartButtonDrag(InventoryButton newDragButton)
{
	// Show the object belt
	dragButton = newDragButton;

	ClearSpecialHighlights();

	if (dragButton.IsA('PersonaInventoryItemButton'))
	{
		SelectInventory(None);

		// Clear the space used by this button in the grid so we can
		// still place the button here. 
		player.SetInvSlots(Inventory(dragButton.GetClientObject()), 0);
	}
	else
	{
		// Make sure no hud icon is selected
		if (selectedSlot != None)
			selectedSlot.SetToggle(False);
	}

	bDragging  = True;
}

event bool ToggleChanged(GUIComponent button, bool bNewToggle)
{
	if (button.IsA('HUDObjectSlot') && (bNewToggle))
	{
		if ((selectedSlot != None) && (selectedSlot != HUDObjectSlot(button)))
			selectedSlot.HighlightSelect(False);

		selectedSlot = HUDObjectSlot(button);

		// Only allow to be highlighted if the slot isn't empty
		if (selectedSlot.item != None)
		{
			selectedSlot.HighlightSelect(bNewToggle);
//			SelectInventoryItem(selectedSlot.item);
		}
		else
		{
			selectedSlot = None;
		}
	}
//	else if (button.IsA('PersonaCheckboxWindow'))
//	{
//		DeusExPlayer(PlayerOwner().pawn).bShowAmmoDescriptions = bNewToggle;
//		DeusExPlayer(PlayerOwner().pawn).SaveConfig();
//		UpdateAmmoDisplay();
//	}

	EnableButtons();

	return True;
}





defaultproperties
{
    invButtonHeight=63//53
    invButtonWidth=63//53

    smallInvHeight=35
    smallInvWidth=40

    InventoryTitleText="Inventory"
    EquipButtonLabel="Equip"
    UnequipButtonLabel="Unequip"
    UseButtonLabel="Use"
    DropButtonLabel="Drop"
    ChangeAmmoButtonLabel="Change Ammo"
    NanoKeyRingInfoText="Click icon to see a list of Nano Keys."
    NanoKeyRingLabel="Keys: %s"
    DroppedLabel="%s dropped"
    AmmoLoadedLabel="%s loaded"
    WeaponUpgradedLabel="%s upgraded"
    CannotBeDroppedLabel="%s cannot be dropped here"
    AmmoInfoText="Click icon to see a list of Ammo."
    AmmoTitleLabel="Ammunition"
    NoAmmoLabel="No Ammo Available"
    strCredits="Credits:"
    strNoKeys="No keys!"
/*----------------------------------------------------------------*/

 lFrameX=0
 lframeY=31
 lfSizeX=310
 lfSizeY=331

 mFrameX=310
 mframeY=31
 mfSizeX=233
 mfSizeY=331

 rFrameX=543
 rframeY=31
 rfSizeX=256
 rfSizeY=331
/////////////////

 lFrameXb=0
 lframeYb=361
 lfSizeXb=310
 lfSizeYb=256

 mFrameXb=310
 mframeYb=361
 mfSizeXb=256
 mfSizeYb=256

 rFrameXb=566
 rframeYb=361
 rfSizeXb=233
 rfSizeYb=256

    bBoundToParent=true
    OnRendered=PaintFrames
}
