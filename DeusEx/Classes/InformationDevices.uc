//=============================================================================
// InformationDevices.
// From Reborn project
// + Добавлено условия для проверки отсутствия текста.
// + Информация выводится на оверлей.
//=============================================================================
class InformationDevices extends DeusExDecoration
	hidecategories(Karma,Force,Object)
	abstract;

var() name					textTag;
var() string				TextPackage;
//var() class <DataVaultImage> imageClass;
var() class <DataVaultImageInv> imageClass;

var Bool bSetText;
var Bool bAddToVault;					// True if we need to add this text to the DataVault
var String vaultString;
var DeusExPlayer aReader;				// who is reading this?
var String msgNoText;
var Bool bFirstParagraph;
var String ImageLabel;
var String AddedToDatavaultLabel;

var HudOverlay_info info;

function Frob(Actor Frobber, Inventory frobWith)
{
    local DeusExHUD myHUD;
    local DeusExPlayer p;
    local DeusExPlayerController pc;
    local ExtString es;
    local name checkNote;//
//    local DeusExGlobals gl;
//    local int x;

    p = DeusExPlayer(Frobber);
    aReader = p;

    if(p == none)
    {
        return;
    }

    pc = DeusExPlayerController(p.Controller);
    myHUD = DeusExHUD(pc.myHUD);

    es = ExtString(DynamicLoadObject(TextPackage$"."$textTag, class'Extension.ExtString'));
    if (es == none)
      {
				p.ClientMessage(msgNoText);
				return;
			} 
			else
			if (info != none)
			{
				p.ClientMessage("Debug: already have"@info);
				info.Destroy();
				return;
			}
			else
    	info = spawn(class'HudOverlay_info', PC);
			PC.myHUD.AddHudOverlay(info);
				DeusExHud(DeusExPlayerController(Level.GetLocalPlayerController()).myHUD).bDrawInfo=true;
			info.currentInfo=es;
			info.bDrawInfo=true;

      if (bAddToVault)
			{
				checkNote = aReader.GetNote(textTag);
				if (checkNote == 'None')
				{
				  log(checkNote);
					aReader.AddNote(es.text,, True, textTag);
				}
      }

      if ((imageClass != None) && (aReader != None))
      GivePlayerImage();
}

function GivePlayerImage()
{
	local Inventory image;

  if (aReader.FindInventoryType(imageClass) != none)
  {
  log (aReader.FindInventoryType(imageClass));
  return;
  }
  else
	image = spawn(imageClass, aReader);

	if (image != None)
	{
   image.GiveTo(aReader);//Frob(aReader, none);
   aReader.ClientMessage(Sprintf(AddedToDatavaultLabel, image.GetDescription()));
  }
}

// Удаляет оверлей из массива.
function tick(float deltatime)
{
    local DeusExPlayerController pc;

    pc = DeusExPlayerController(level.GetLocalPlayerController());

    if ((DeusExPlayer(pc.pawn).frobtarget != self) && (pc != none) && (info != none))
    	{
				DeusExHud(DeusExPlayerController(Level.GetLocalPlayerController()).myHUD).bDrawInfo=false;
				info.Destroy();
    	}
  super.tick(deltatime);
}


defaultproperties
{
    TextPackage="DeusExText"
    msgNoText="There's nothing interesting to read"
    ImageLabel="[Image: %s]"
    AddedToDatavaultLabel="Image %s added to DataVault"
    FragType=Class'PaperFragment'
    bPushable=False
}
