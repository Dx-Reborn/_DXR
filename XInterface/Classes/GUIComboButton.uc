// ====================================================================
//  Class:  XInterface.GUIComboButton
//
//  Written by Joe Wilcox
//  (c) 2002, Epic Games, Inc.  All Rights Reserved
// ====================================================================

class GUIComboButton extends GUIVertScrollButton;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super(GUIScrollButtonBase).Initcomponent(MyController, MyOwner);
}


defaultproperties
{
	ImageIndex=7
	bRepeatClick=false
	OnClickSound=CS_Edit
    StyleName="ComboButton"
}
