/**/
class ComputerUIWindow extends DxWindowTemplate;

var() NetworkTerminal             winTerm;
var() ElectronicDevices           compOwner;			// what computer owns this window?
var String                      escapeAction;		// Action to invoke when Escape pressed
var localized string ComputerNodeFunctionLabel;


function ChangeAccount()
{
}

function SetCompOwner(ElectronicDevices newCompOwner)
{
	compOwner = newCompOwner;

//	if ((winStatus != None) && (compOwner.IsA('Computers')))
//		winStatus.SetText("Daedalus:GlobalNode:" $ Computers(compOwner).GetNodeAddress() $ "/" $ ComputerNodeFunctionLabel);
}

function CloseScreen(String action)
{
	if (winTerm != None)
		winTerm.CloseScreen(action);
}

function SetNetworkTerminal(NetworkTerminal newTerm)
{
	winTerm = newTerm;
}

function bool AlignFrame(Canvas C)
{
	return bInit;
}


event Opened(GUIComponent Sender)                   // Called when the Menu Owner is opened
{
  super(floatingwindow).Opened(Sender);
/*  if (ParentPage != none)
  ParentPage.bVisible=false;*/
}

event Closed(GUIComponent Sender, bool bCancelled)  // Called when the Menu Owner is closed
{
  super(floatingwindow).Closed(Sender, bCancelled);
/*  if (ParentPage != none)
  ParentPage.bVisible=true;*/
}

function bool InternalOnKeyEvent(out byte Key, out byte State, float delta)
{
	local Interactions.EInputKey iKey;

	iKey = EInputKey(Key);

	if (iKey == IK_Escape)
			CloseScreen(escapeAction);
  return true;
}

defaultproperties
{
  onKeyEvent=InternalOnKeyEvent
}