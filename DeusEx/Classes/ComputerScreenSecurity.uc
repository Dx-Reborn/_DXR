/* */

class ComputerScreenSecurity extends ComputerUIWindow;

var DeusExPlayer player;
var() DXRTabControl pmTabs;
var() GUITabPanel winCameras[3];
var GUIButton bExit, btnSpecial;

var localized string ButtonLabelSpecial, ButtonLabelExit;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    Super.InitComponent(MyController, MyOwner);

    player = DeusExPlayer(playerOwner().pawn);

    pmTabs = new(none) class'DXRTabControl';
    pmTabs.WinWidth = 665;//800.00;
    pmTabs.WinHeight = 32.0;
    pmTabs.bBoundToParent = true;
    pmTabs.bAcceptsInput = true;
    pmTabs.bDockPanels = true;
    pmTabs.bFillSpace = true;
    pmTabs.TabStyle = "STY_DXR_MediumButton";
    AppendComponent(pmTabs, true);

    GUIHeader(Controls[0]).DockedTabs = pmTabs;
    pmTabs.bScaleToParent = false;

    bExit = new(none) class'GUIButton';
    bExit.FontScale = FNS_Small;
    bExit.Caption = ButtonLabelExit;
    //bExit.Hint = "Exit";
    bExit.StyleName = "STY_DXR_MediumButton";
    bExit.bBoundToParent = true;
    bExit.OnClick = InternalOnClick;
    bExit.WinHeight = 23;
    bExit.WinWidth = 93;
    bExit.WinLeft = 570;
    bExit.WinTop = 565;
    AppendComponent(bExit, true);
}

function bool InternalOnClick(GUIComponent Sender)
{
  if (Sender==bExit)
      CloseScreen("LOGOUT");

  if (Sender==btnSpecial)
      CloseScreen("SPECIAL");

  return true;
}

function InternalOnRendered(canvas u)
{
 local bool bDone;

   if (!bDone)
   {
    WinLeft = controller.ResX/2 - 400;
    WinTop = controller.ResY/2 - 320;
    bDone = true;
   }
}

//  Initialize the cameras
// ----------------------------------------------------------------------

function InitCameras()
{
    local int cameraIndex;
    local name mytag;
    local SecurityCamera camera;
    local AutoTurret turret;
    local DeusExMover door;
    local int numCameras; // Возьмем кол-во камер их терминала наблюдения.

    numCameras = ArrayCount(ComputerSecurity(compOwner).Views);
    for (cameraIndex=0; cameraIndex<numCameras; cameraIndex++)
    {
      winCameras[cameraIndex] = pmTabs.AddTab(ComputerSecurity(compOwner).Views[cameraIndex].titleString,"DeusEx.Tab_cameraView");

      Tab_CameraView(winCameras[cameraIndex]).compOwner = Computers(compOwner);
      Tab_CameraView(winCameras[cameraIndex]).selectedCamera = none;

        mytag = ComputerSecurity(compOwner).Views[cameraIndex].cameraTag;
        if (mytag != '')
        {
            foreach player.AllActors(class'SecurityCamera', camera, mytag)
            {
                // force the camera to wake up
                camera.bStasis = false;
                Tab_CameraView(winCameras[cameraIndex]).selectedCamera = camera;
            }
        }

        Tab_CameraView(winCameras[cameraIndex]).turret = None;
        mytag = ComputerSecurity(compOwner).Views[cameraIndex].turretTag;
        if (mytag != '')
            foreach player.AllActors(class'AutoTurret', turret, mytag)
                Tab_CameraView(winCameras[cameraIndex]).turret = turret;

        Tab_CameraView(winCameras[cameraIndex]).door = None;
        mytag = ComputerSecurity(compOwner).Views[cameraIndex].doorTag;
        if (mytag != '')
            foreach player.AllActors(class'DeusExMover', door, mytag)
                Tab_CameraView(winCameras[cameraIndex]).door = door;

                Tab_CameraView(winCameras[cameraIndex]).SetViewIndex(cameraIndex);
                Tab_CameraView(winCameras[cameraIndex]).UpdateCameraStatus();
                Tab_CameraView(winCameras[cameraIndex]).UpdateTurretStatus();
                Tab_CameraView(winCameras[cameraIndex]).UpdateDoorStatus();
                // Это важно, когда все данные уже обновлены и инициализированы!
                Tab_CameraView(winCameras[cameraIndex]).CreateChoices();
                Tab_CameraView(winCameras[cameraIndex]).winTerm = self.winTerm;
    }

    // Select the first security camera
//  SelectFirstCamera();
}

function SetCompOwner(ElectronicDevices newCompOwner)
{
    Super.SetCompOwner(newCompOwner);
    InitCameras();
}

function SetNetworkTerminal(NetworkTerminal newTerm)
{
//  local int x, n;

    Super.SetNetworkTerminal(newTerm);
//  n = ArrayCount(ComputerSecurity(compOwner).Views);

    if (winTerm.AreSpecialOptionsAvailable())
    {
        btnSpecial = new(none) class'GUIButton';
        btnSpecial.Caption = ButtonLabelSpecial;
        btnSpecial.FontScale = FNS_Small;
        btnSpecial.StyleName = "STY_DXR_MediumButton";
        btnSpecial.bBoundToParent = true;
        btnSpecial.OnClick = InternalOnClick;
        btnSpecial.WinHeight = 23;
        btnSpecial.WinWidth = 168;
        btnSpecial.WinLeft = 400;
        btnSpecial.WinTop = 565;
        AppendComponent(btnSpecial, true);
    }

    // Check the user's skill level and possibly disable the Turret button
    // if the user Hacked into the computer.
    //
    // Turrets are only usable at Advanced or higher 
/*  if ((winTerm.GetSkillLevel()  < 2) && (winTerm.bHacked))
    {

  }*/
/*   for (x=0; x<n; x++)
   {
     Tab_CameraView(winCameras[x]).winTerm = newTerm;
   }*/
        //choiceWindows[3].DisableChoice();
}




defaultproperties
{
  ButtonLabelSpecial="Special Options"
  ButtonLabelExit="Close"

  Begin Object class=GUIHeader name=dxHeader
        Caption=""
//      StyleName="STY_DXR_Navbar"
        WinWidth=665
        WinHeight=2.0 //32.0
        WinLeft=-6.00
        WinTop= -5.00
        bBoundToParent=true
        DockAlign=PGA_None
    End Object
    Controls(0)=dxHeader

        WinWidth=800.0
        WinHeight=600.0

    OnRendered=InternalOnRendered

}

