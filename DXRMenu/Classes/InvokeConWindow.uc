class InvokeConWindow extends DxWindowTemplate;

var GUIButton btnSetFlags, btnEditFlags, btnOK;
var GUIListBox lstActors, lstCons, lstFlags;
var GUILabel lActors, lConvos, lFlags;

var ConDialogue conObj; // Pointer to selected ConDialogue.


function CreateMyControls()
{
  SetSize(400,548);

  lActors = new(none) class'GUILabel';
  lActors.bBoundToParent = true;
  lActors.TextColor = class'DXR_Menu'.static.GetPlayerInterfaceHDR(gl.MenuThemeIndex);
  lActors.caption = "Actors:";
  lActors.TextFont="UT2HeaderFont";
  lActors.bMultiLine = false;
  lActors.TextAlign = TXTA_Left;
  lActors.VertAlign = TXTA_Center;
  lActors.FontScale = FNS_Small;
 	lActors.WinHeight = 20;
  lActors.WinWidth = 120;
  lActors.WinLeft = 12;
  lActors.WinTop = 22;
	AppendComponent(lActors, true);

  lConvos = new(none) class'GUILabel';
  lConvos.bBoundToParent = true;
  lConvos.TextColor = class'DXR_Menu'.static.GetPlayerInterfaceHDR(gl.MenuThemeIndex);
  lConvos.caption = "Conversations:";
  lConvos.TextFont="UT2HeaderFont";
  lConvos.bMultiLine = false;
  lConvos.TextAlign = TXTA_Left;
  lConvos.VertAlign = TXTA_Center;
  lConvos.FontScale = FNS_Small;
 	lConvos.WinHeight = 20;
  lConvos.WinWidth = 120;
  lConvos.WinLeft = 270;
  lConvos.WinTop = 22;
	AppendComponent(lConvos, true);

  lFlags = new(none) class'GUILabel';
  lFlags.bBoundToParent = true;
  lFlags.TextColor = class'DXR_Menu'.static.GetPlayerInterfaceHDR(gl.MenuThemeIndex);
  lFlags.caption = "Required Flags + Value + Expiration:";
  lFlags.TextFont="UT2HeaderFont";
  lFlags.bMultiLine = false;
  lFlags.TextAlign = TXTA_Left;
  lFlags.VertAlign = TXTA_Center;
  lFlags.FontScale = FNS_Small;
 	lFlags.WinHeight = 20;
  lFlags.WinWidth = 420;
  lFlags.WinLeft = 12;
  lFlags.WinTop = 302;
	AppendComponent(lFlags, true);


	lstActors = new(none) class'GUIListBox';
//  lstActors.OnClick=InternalOnClick;
  lstActors.SelectedStyleName="STY_DXR_ListSelection";
  lstActors.StyleName = "STY_DXR_Listbox";
  lstActors.bBoundToParent = true;
  lstActors.OnChange = ListSelectionChanged;
  lstActors.WinHeight = 262;
  lstActors.WinWidth = 252;
  lstActors.WinLeft = 12;
  lstActors.WinTop = 38;
	AppendComponent(lstActors, true);

	lstCons = new(none) class'GUIListBox';
//  lstCons.OnClick=InternalOnClick;
  lstCons.SelectedStyleName="STY_DXR_ListSelection";
  lstCons.StyleName = "STY_DXR_Listbox";
  lstCons.bBoundToParent = true;
  lstCons.OnChange = ListSelectionChanged;
  lstCons.WinHeight = 262;
  lstCons.WinWidth = 252;
  lstCons.WinLeft = 270;
  lstCons.WinTop = 38;
	AppendComponent(lstCons, true);

	lstFlags = new(none) class'GUIListBox';
//  lstFlags.OnClick=InternalOnClick;
  lstFlags.SelectedStyleName="STY_DXR_ListSelection";
  lstFlags.StyleName = "STY_DXR_Listbox";
  lstFlags.bBoundToParent = true;
  lstFlags.WinHeight = 95;
  lstFlags.WinWidth = 530;
  lstFlags.WinLeft = 12;
  lstFlags.WinTop = 320;
	AppendComponent(lstFlags, true);


  btnOK = new(none) class'GUIButton';
  btnOK.FontScale = FNS_Small;
  btnOK.Caption = "Close";
  btnOK.StyleName="STY_DXR_MediumButton";
  btnOK.OnClick = ButtonActivated;
  btnOK.WinHeight = 21;
  btnOK.WinWidth = 129;
  btnOK.WinLeft = 415;
  btnOK.WinTop = 420;
	AppendComponent(btnOK, true);

  btnEditFlags = new(none) class'GUIButton';
  btnEditFlags.FontScale = FNS_Small;
  btnEditFlags.Caption = "Edit Flags";
  btnEditFlags.Hint = "Open list of game flags, where you can change values of flags. Can be also opened using ''ListFlags'' console command.";
  btnEditFlags.StyleName="STY_DXR_MediumButton";
  btnEditFlags.OnClick = ButtonActivated;
  btnEditFlags.WinHeight = 21;
  btnEditFlags.WinWidth = 129;
  btnEditFlags.WinLeft = 150;
  btnEditFlags.WinTop = 420;
	AppendComponent(btnEditFlags, true);

  btnSetFlags = new(none) class'GUIButton';
  btnSetFlags.FontScale = FNS_Small;
  btnSetFlags.Caption = "Set these Flags";
  btnSetFlags.Hint = "Set these flags, required for selected conversation.";
  btnSetFlags.StyleName="STY_DXR_MediumButton";
  btnSetFlags.OnClick = ButtonActivated;
  btnSetFlags.WinHeight = 21;
  btnSetFlags.WinWidth = 129;
  btnSetFlags.WinLeft = 8;
  btnSetFlags.WinTop = 420;
	AppendComponent(btnSetFlags, true);

	PopulateActorsList(); // список акторов...
	EnableButtons();
}

function bool ButtonActivated(GUIComponent Sender)
{
	switch(Sender)
	{
		case btnSetFlags:
			SetFlags();
			break;

		case btnEditFlags:
      Controller.OpenMenu("DXRMenu.DXRFlags");
			break;

		case btnOK:
			Controller.CloseMenu();
			break;

	}
	return true;
}

function ListSelectionChanged(GUIComponent Sender)
{
	local Object listObject;

	listObject = GUIListBox(sender).list.GetObject();  //ListWindow(list).GetRowClientObject(focusRowId);

	if (Sender == lstActors )
		PopulateConsList(Actor(listObject));
	else if (Sender == lstCons)
	{
	  conObj = ConDialogue(lstCons.list.GetObject());
		PopulateFlagsList(conObj); //(ConDialogue(listObject));
	}

	EnableButtons();
}


function PopulateActorsList()
{
	local Actor anActor;

	lstActors.list.Clear();

	// Loop through the conversations and add actors to 
	// the appropriate list window
	foreach playerOwner().AllActors(class'Actor', anActor)
	{
		// Check to see if there's any conversations
		if ((anActor.GetConList().length > 0) && (anActor.GetBindName() != ""))
		{
		  lstActors.list.Add(anActor.GetBindName(), anActor);
		}
	}
	lstActors.list.Sort();
}



function SetFlags()
{
	local ConDialogue con;
	local DeusExGameInfo flagbase;
	local int i;

	if ((lstCons.list.Elements.length == 0 ) || (lstCons.list.Get(true) == ""))
		return;

	con = ConDialogue(lstCons.list.GetObject());//GetRowClientObject(lstCons.GetSelectedRow()));
	flagBase = DeusExGameInfo(PlayerOwner().level.game);

	for (i=0; i<con.flagRefList.length; i++)
	{
	  flagBase.setBool(con.flagRefList[i].Name, con.flagRefList[i].Value);
	}
}

function PopulateConsList(Actor anActor)
{
	local int i;

	lstCons.list.Clear();

  for (i=0; i<anActor.GetConList().length; i++)
	{
	   lstCons.list.Add(ConDialogue(anActor.GetConList()[i]).Name, ConDialogue(anActor.GetConList()[i]));
	}

	// Sort the conversations by name
	lstActors.list.Sort();
}

function PopulateFlagsList(ConDialogue con)
{
  local int i;

  lstFlags.list.Clear();

  if (con != none)
  {
    for(i=0; i<con.FlagRefList.length; i++)
    {
       lstFlags.list.Add(con.FlagRefList[i].Name @ con.FlagRefList[i].value @ con.FlagRefList[i].Expiration);
    }
  }
	EnableButtons();
}


function EnableButtons()
{
  if (lstFlags.list.Elements.length < 1)
     btnSetFlags.DisableMe();
     else
     btnSetFlags.EnableMe();
}


defaultproperties
{
  WinTitle="Invoke conversation"

		leftEdgeCorrectorX=4
		leftEdgeCorrectorY=0
		leftEdgeHeight=441

		RightEdgeCorrectorX=545
		RightEdgeCorrectorY=20
		RightEdgeHeight=413

		TopEdgeCorrectorX=240
		TopEdgeCorrectorY=16
    TopEdgeLength=303

    TopRightCornerX=542
    TopRightCornerY=16

	Begin Object Class=FloatingImage Name=FloatingFrameBackground
		Image=Texture'ConWindowBackground'
		ImageRenderStyle=MSTY_Normal
		ImageStyle=ISTY_Scaled //PartialScaled
		ImageColor=(R=255,G=255,B=255,A=255)
		DropShadow=None
		WinWidth=540
		WinHeight=400 //229
		WinLeft=8
		WinTop=20
		RenderWeight=0.000003
		bBoundToParent=True
		bScaleToParent=True
								OnRendered=PaintOnBG
	End Object
	i_FrameBG=FloatingFrameBackground
}