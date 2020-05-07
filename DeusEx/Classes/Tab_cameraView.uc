/*
 ToDo:
 сделать еще чтобы камерой можно было вертеть непосредственно с помощью мыши как в invisible war? И с турельки так же самому стрелять.

 Например если над над изображением с камеры зажата правая кнопка мыши то камера/турель переключается в ручной режим управления (как в редакторе 
 уровней над 3d вьюпоинтом когда зажимаешь пкм то можно вертеть головой вокруг), и стрелять можно на левую кнопку. Как только игрок отпускает ПКМ
 камера/турель переключается назад на автопилот.
*/
class Tab_cameraView extends GUITabPanel;

// Корректор портала
var() int portalSizeX, portalSizeY, portalCorrectionX, portalCorrectionY, viewIndex;

var localized string CameraLabel,CameraStatusLabel,DoorStatusLabel,TurretStatusLabel;
var localized string ActiveWindowOptionsHeader,CameraOptionsHeader,PanZoomSpeedHeader;
var localized string OnLabel,OffLabel,DisabledLabel,AttackingAlliesLabel,AttackingEnemiesLabel;
var localized string AttackingEverythingLabel,NoSignalLabel,OpenLabel,ClosedLabel,LockedLabel,UnlockedLabel;

var DeusExPlayer player;
var() editconst NetworkTerminal winTerm;
var() editconst ElectronicDevices compOwner;
var() editconst securityCamera selectedCamera;
var() editconst AutoTurret turret;
var() editconst DeusExMover door;

var GUIDXRButton btnPanUp,btnPanDown, btnPanLeft, btnPanRight, btnZoomIn, btnZoomOut;
var GUILabel lOptions, lMovement, lPanSpeed, winTitle, winCameraStatus, winDoorStatus, winTurretStatus;
var GUIImage BackImage;

/* Кнопки выбора варианта и связанные с ними DXRChoiceInfo.
   Сначала создаем DXRChoiceInfo! */
var ComputerSecurityChoice_Turret Choice_Turret;
var ComputerSecurityChoice_Camera Choice_Camera;
var ComputerSecurityChoice_DoorOpen Choice_DoorOpen;
var ComputerSecurityChoice_DoorAccess Choice_DoorAccess;
var DXRChoiceInfo infoTurret, infoCamera, infoDoor, infoDoorAccess;
var DXRSpecialSlider winPanSlider;

var const int panSize;
var const float zoomSize;
var const int   numPanTicks;
var const float lowPanValue;
var const float highPanValue;
var() float panMod, camFOV;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    Super.Initcomponent(MyController, MyOwner);
    player = DeusExPlayer(PlayerOwner().pawn);

    winterm = ComputerScreenSecurity(PageOwner).winTerm; // Указатель на NetworkTerminal
    //log("Init Component--winterm is "@winterm);
    CreateControls();
}

function CreateControls()
{
    BackImage = new(none) class'GUIImage';
    BackImage.Image=texture'DXR_ComputerSecurityBG';
    BackImage.bBoundToParent = true;
    BackImage.WinHeight = 512;
    BackImage.WinWidth = 665;
    BackImage.WinLeft = 0;//55;
    BackImage.WinTop = 32;//0;
    AppendComponent(BackImage, true);

    winPanSlider = new(none) class'DXRSpecialSlider';
    winPanSlider.winLeft = 313; //368;
    winPanSlider.winTop = 178;
    winPanSlider.OnChange = SliderOnChange;
    AppendComponent(winPanSlider, true);
    winPanSlider.SetTicks(numPanTicks, lowPanValue, highPanValue);
    SliderOnChange(winPanSlider);

    /*-- Zoom in && Zoom out --------------------------------------*/
    btnZoomIn = new(none) class'GUIDXRButton';
    btnZoomIn.bBoundToParent = true;
    btnZoomIn.Button_Pressed = texture'SecurityButtonZoomIn_Pressed';
    btnZoomIn.Button_Normal = texture'SecurityButtonZoomIn_Normal';
    btnZoomIn.OnClick = InternalOnClick;
    btnZoomIn.WinHeight = 19;
    btnZoomIn.WinWidth = 25;
    btnZoomIn.winLeft = 323; //378;
    btnZoomIn.winTop = 63;
    AppendComponent(btnZoomIn, true);

    btnZoomOut = new(none) class'GUIDXRButton';
    btnZoomOut.bBoundToParent = true;
    btnZoomOut.Button_Pressed = texture'SecurityButtonZoomOut_Pressed';
    btnZoomOut.Button_Normal = texture'SecurityButtonZoomOut_Normal';
    btnZoomOut.OnClick = InternalOnClick;
    btnZoomOut.WinHeight = 19;
    btnZoomOut.WinWidth = 25;
    btnZoomOut.winLeft = 349; //404;
    btnZoomOut.winTop = 63;
    AppendComponent(btnZoomOut, true);

  /*-- Camera movement ------------------------------------------*/
    btnPanUp = new(none) class'GUIDXRButton';
    btnPanUp.bBoundToParent = true;
    btnPanUp.Button_Pressed = texture'SecurityButtonPanUp_Pressed';
    btnPanUp.Button_Normal = texture'SecurityButtonPanUp_Normal';
    btnPanUp.OnClick = InternalOnClick;
    btnPanUp.WinHeight = 19;
    btnPanUp.WinWidth = 25;
    btnPanUp.winLeft = 335;//390;
    btnPanUp.winTop = 90;
    AppendComponent(btnPanUp, true);

    btnPanDown = new(none) class'GUIDXRButton';
    btnPanDown.bBoundToParent = true;
    btnPanDown.Button_Pressed = texture'SecurityButtonPanDown_Pressed';
    btnPanDown.Button_Normal = texture'SecurityButtonPanDown_Normal';
    btnPanDown.OnClick = InternalOnClick;
    btnPanDown.WinHeight = 19;
    btnPanDown.WinWidth = 25;
    btnPanDown.winLeft = 335;//390;
    btnPanDown.winTop = 130;
    AppendComponent(btnPanDown, true);

    btnPanLeft = new(none) class'GUIDXRButton';
    btnPanLeft.bBoundToParent = true;
    btnPanLeft.Button_Pressed = texture'SecurityButtonPanLeft_Pressed';
    btnPanLeft.Button_Normal = texture'SecurityButtonPanLeft_Normal';
    btnPanLeft.OnClick = InternalOnClick;
    btnPanLeft.WinHeight = 19;
    btnPanLeft.WinWidth = 25;
    btnPanLeft.winLeft = 309;//364;
    btnPanLeft.winTop = 110;
    AppendComponent(btnPanLeft, true);

    btnPanRight = new(none) class'GUIDXRButton';
    btnPanRight.bBoundToParent = true;
    btnPanRight.Button_Pressed = texture'SecurityButtonPanRight_Pressed';
    btnPanRight.Button_Normal = texture'SecurityButtonPanRight_Normal';
    btnPanRight.OnClick = InternalOnClick;
    btnPanRight.WinHeight = 19;
    btnPanRight.WinWidth = 25;
    btnPanRight.winLeft = 361;//416;
    btnPanRight.winTop = 110;
    AppendComponent(btnPanRight, true);

    /*-- Text labels -----------------------------------*/
  lOptions = new(none) class'GUILabel';
  lOptions.bBoundToParent = true;
  lOptions.TextColor = class'Canvas'.static.MakeColor(255, 255, 255);
  lOptions.caption = ActiveWindowOptionsHeader;
  lOptions.TextFont="UT2HeaderFont";
  lOptions.bMultiLine = true;
  lOptions.TextAlign = TXTA_Left;
  lOptions.VertAlign = TXTA_Center;
  lOptions.FontScale = FNS_Small;
  lOptions.WinHeight = 20;
  lOptions.WinWidth = 267;
  lOptions.WinLeft = 11;//66;
  lOptions.WinTop = 38;
  AppendComponent(lOptions, true);

  lMovement = new(none) class'GUILabel';
  lMovement.bBoundToParent = true;
  lMovement.TextColor = class'Canvas'.static.MakeColor(255, 255, 255);
  lMovement.caption = CameraOptionsHeader;
  lMovement.TextFont="UT2HeaderFont";
  lMovement.bMultiLine = true;
  lMovement.TextAlign = TXTA_Left;
  lMovement.VertAlign = TXTA_Center;
  lMovement.FontScale = FNS_Small;
  lMovement.WinHeight = 20;
  lMovement.WinWidth = 160;
  lMovement.WinLeft = 295;//350;
  lMovement.WinTop = 38;
  AppendComponent(lMovement, true);

  lPanSpeed = new(none) class'GUILabel';
  lPanSpeed.bBoundToParent = true;
  lPanSpeed.TextColor = class'Canvas'.static.MakeColor(255, 255, 255);
  lPanSpeed.caption = PanZoomSpeedHeader;
  lPanSpeed.TextFont="UT2HeaderFont";
  lPanSpeed.bMultiLine = true;
  lPanSpeed.TextAlign = TXTA_Center;
  lPanSpeed.VertAlign = TXTA_Center;
  lPanSpeed.FontScale = FNS_Small;
  lPanSpeed.WinHeight = 28;
  lPanSpeed.WinWidth = 124;
  lPanSpeed.WinLeft = 297;//352;
  lPanSpeed.WinTop = 152;
  AppendComponent(lPanSpeed, true);

  /*---------------------------------------------------------------*/
  winTitle = new(none) class'GUILabel';
  winTitle.bBoundToParent = true;
  winTitle.TextColor = class'Canvas'.static.MakeColor(255, 255, 255);
//  winTitle.caption = "WinTitle";
  winTitle.TextFont="UT2HeaderFont";
  winTitle.bMultiLine = true;
  winTitle.TextAlign = TXTA_Left;
  winTitle.VertAlign = TXTA_Center;
  winTitle.FontScale = FNS_Small;
  winTitle.WinHeight = 20;
  winTitle.WinWidth = 500;
  winTitle.WinLeft = 6;//61;
  winTitle.WinTop = 205;
  AppendComponent(winTitle, true);

  winDoorStatus = new(none) class'GUILabel';
  winDoorStatus.bBoundToParent = true;
  winDoorStatus.TextColor = class'Canvas'.static.MakeColor(255, 255, 255);
//  winDoorStatus.caption = "winDoorStatus";
  winDoorStatus.TextFont="UT2HeaderFont";
  winDoorStatus.bMultiLine = true;
  winDoorStatus.TextAlign = TXTA_Left;
  winDoorStatus.VertAlign = TXTA_Center;
  winDoorStatus.FontScale = FNS_Small;
  winDoorStatus.WinHeight = 28;
  winDoorStatus.WinWidth = 300;
  winDoorStatus.WinLeft = 348;//403;
  winDoorStatus.WinTop = 504;
  AppendComponent(winDoorStatus, true);

  winCameraStatus = new(none) class'GUILabel';
  winCameraStatus.bBoundToParent = true;
  winCameraStatus.TextColor = class'Canvas'.static.MakeColor(255, 255, 255);
//  winCameraStatus.caption = "winCameraStatus";
  winCameraStatus.TextFont="UT2HeaderFont";
  winCameraStatus.bMultiLine = true;
  winCameraStatus.TextAlign = TXTA_Left;
  winCameraStatus.VertAlign = TXTA_Center;
  winCameraStatus.FontScale = FNS_Small;
  winCameraStatus.WinHeight = 20;
  winCameraStatus.WinWidth = 300;
  winCameraStatus.WinLeft = 9;//64;
  winCameraStatus.WinTop = 501;
  AppendComponent(winCameraStatus, true);

  winTurretStatus = new(none) class'GUILabel';
  winTurretStatus.bBoundToParent = true;
  winTurretStatus.TextColor = class'Canvas'.static.MakeColor(255, 255, 255);
//  winTurretStatus.caption = "winTurretStatus";
  winTurretStatus.TextFont="UT2HeaderFont";
  winTurretStatus.bMultiLine = true;
  winTurretStatus.TextAlign = TXTA_Left;
  winTurretStatus.VertAlign = TXTA_Center;
  winTurretStatus.FontScale = FNS_Small;
  winTurretStatus.WinHeight = 20;
  winTurretStatus.WinWidth = 300;
  winTurretStatus.WinLeft = 9;//64;
  winTurretStatus.WinTop = 515;
  AppendComponent(winTurretStatus, true);

  SetTimer(0.25, true);
}

function Timer()
{
  UpdateDoorStatus();
}

function CreateChoices()
{
  infoTurret = new(none) class'DXRChoiceInfo';
  infoTurret.WinLeft = 167;//222;
  infoTurret.WinTop = 62;
  AppendComponent(infoTurret, true);

  infoCamera = new(none) class'DXRChoiceInfo';
  infoCamera.WinLeft = 167;
  infoCamera.WinTop = 96;
  AppendComponent(infoCamera, true);

  infoDoor = new(none) class'DXRChoiceInfo';
  infoDoor.WinLeft = 167;
  infoDoor.WinTop = 130;
  AppendComponent(infoDoor, true);

  infoDoorAccess = new(none) class'DXRChoiceInfo';
  infoDoorAccess.WinLeft = 167;
  infoDoorAccess.WinTop = 164;
  AppendComponent(infoDoorAccess, true);

/*----------------------------------------------------------------------------*/

  Choice_Turret = new(none) class'ComputerSecurityChoice_Turret';
  Choice_Turret.WinLeft = 13;//68;
  Choice_Turret.WinTop = 62;
  Choice_Turret.Info = infoTurret;
  AppendComponent(Choice_Turret, true);
  Choice_Turret.SetCameraView(self);

  Choice_Camera = new(none) class'ComputerSecurityChoice_Camera';
  Choice_Camera.WinLeft = 13;
  Choice_Camera.WinTop = 96;
  Choice_Camera.Info = infoCamera;
  AppendComponent(Choice_Camera, true);
  Choice_Camera.SetCameraView(self);

  Choice_DoorOpen = new(none) class'ComputerSecurityChoice_DoorOpen';
  Choice_DoorOpen.WinLeft = 13;
  Choice_DoorOpen.WinTop = 130;
  Choice_DoorOpen.Info = infoDoor;
  AppendComponent(Choice_DoorOpen, true);
  Choice_DoorOpen.SetCameraView(self); // Это должно быть здесь. Если поставить перед AppendComponent, будет ошибка доступа к контроллеру.

  Choice_DoorAccess = new(none) class'ComputerSecurityChoice_DoorAccess';
  Choice_DoorAccess.WinLeft = 13;
  Choice_DoorAccess.WinTop = 164;
  Choice_DoorAccess.Info = infoDoorAccess;
  AppendComponent(Choice_DoorAccess, true);
  Choice_DoorAccess.SetCameraView(self);

   // Как в оригинале, котроль турели только на максимальном уровне навыка.
   if ((winTerm.GetSkillLevel()  < 2) && (winTerm.bHacked))
   {
      DisableTurretControl();
   }
}

function DisableTurretControl()
{
  if (Choice_Turret != none)
      Choice_Turret.DisableChoice();
}

function InternalOnRendered(canvas u)
{
  local material mt;

  mt = texPanner'DeusExControls.Controls.static';

  if (selectedCamera == none)
  {
     u.SetPos(ActualLeft() - portalCorrectionX, ActualTop() - portalCorrectionY);
     u.DrawTile(mt, 652, 272, 0, 128, 128, 128);
     u.SetPos(ActualLeft() - portalCorrectionX, ActualTop() - portalCorrectionY);
     u.DrawTile(TexPanner'DeusExControls.Controls.scrolling',652,272,0,0,64,64);
     return;
  }
  u.DrawActor(None, false, true); // Clear the z-buffer here
  u.DrawActor(None, false, true); // ... twice!
  u.DrawPortal(ActualLeft() - portalCorrectionX, ActualTop() - portalCorrectionY, portalSizeX, portalSizeY, selectedCamera, selectedCamera.Location, selectedCamera.Rotation,Camfov);
  u.ReSet();
}

function bool InternalOnClick(GUIComponent Sender)
{
    local bool bHandled;

    bHandled = True;

        switch(Sender)
        {
            case btnPanUp:
                PanCamera(IK_Up);
                break;

            case btnPanDown:
                PanCamera(IK_Down);
                break;

            case btnPanLeft:
                PanCamera(IK_Left);
                break;

            case btnPanRight:
                PanCamera(IK_Right);
                break;

            case btnZoomIn:
                PanCamera(IK_GreyPlus);
                break;

            case btnZoomOut: 
                PanCamera(IK_GreyMinus);
                break;

            default:
                bHandled = False;
                break;
        }

    if (bHandled)
        return True;
}

function PanCamera(Interactions.EInputKey key)
{
//  local bool bKeyHandled;
    local Rotator rot;
    local float fov;
    local float localPanMod;

    if (selectedCamera == None)
        return;

    localPanMod = panMod;

   if (controller.ShiftPressed)
        localPanMod = Max(localPanMod * 2, 5.0);

    rot = selectedCamera.DesiredRotation;
    fov = CamFov;

    switch(key)
    {
        case IK_Left:       
        rot.Yaw -= localPanMod * panSize * (fov / 90.0);
        break;

        case IK_Right:      
        rot.Yaw += localPanMod * panSize * (fov / 90.0);
        break;

        case IK_Up:         
        rot.Pitch += localPanMod * panSize * (fov / 90.0);
        break;

        case IK_Down:       
        rot.Pitch -= localPanMod * panSize * (fov / 90.0);
        break;

//      case IK_GreyPlus:
        case IK_Equals:     
        case IK_MouseWheelUp:
    fov -= localPanMod * zoomSize;
        break;

        case IK_GreyMinus:
        case IK_Minus:
        case IK_MouseWheelDown: // DXR: Mouse wheel added
    fov += localPanMod * zoomSize;
        break;
    }

    selectedCamera.DesiredRotation = rot;

    // limit the zoom level
    fov = FClamp(fov, 5, 90);
    camFOV = fov;
}

function bool InternalOnKeyEvent(out byte Key, out byte State, float delta)
{
    local Interactions.EInputKey iKey;

    iKey = EInputKey(Key);

    if ((State == 2) && (iKey == IK_RightMouse)) // Удержание левой кнопки мыши
    {

//    log("hold..."$iKey);
    }

    if (state == 1)
    {
        PanCamera(ikey);
    }
  return true;
}

function SliderOnChange(GUIComponent Sender)
{
  if (Sender==winPanSlider)
  {
    panMod = winPanSlider.Value;    
    }
}

/*----------------------------------------------------------------------------------------------------------------------------------*/
function ToggleCameraState()
{
    local SecurityCamera cam;

        cam = selectedCamera;

        if (cam != None)
        {
            if (cam.bActive)
                cam.UnTrigger(compOwner, player);
            else
                cam.Trigger(compOwner, player);

            // Make sure the camera isn't in bStasis=True
            // so it responds to our every whim.
            cam.bStasis = false;

            UpdateCameraStatus();
        }
}

function ToggleDoorLock()
{
    local DeusExMover M;

    if (door != None)
    {
        // be sure to lock/unlock all matching tagged doors
        foreach player.AllActors(class'DeusExMover', M, door.Tag)
            M.bLocked = !M.bLocked;

        UpdateDoorStatus();
    }
}

function TriggerDoor()
{
    local DeusExMover M;

    if (door != None)
    {
        // be sure to trigger all matching tagged doors
        foreach player.AllActors(class'DeusExMover', M, door.Tag)
            M.Trigger(compOwner, player);

        UpdateDoorStatus();
    }
}

function SetTurretState(bool bActive, bool bDisabled)
{
    if (turret != None)
    {
        turret.bActive   = bActive;
        turret.bDisabled = bDisabled;
        UpdateTurretStatus();
    }
}

function SetTurretTrackMode(bool bTrackPlayers, bool bTrackPawns)
{
    if (turret != None)
    {
        turret.bTrackPlayersOnly = bTrackPlayers;
        turret.bTrackPawnsOnly = bTrackPawns;
        UpdateTurretStatus();
    }
}
/*----------------------------------------------------------------------------------------------------------------------------------*/
function SetTitle(String newTitle)
{
    winTitle.Caption = newTitle;
}

function SetViewIndex(int newViewIndex)
{
    viewIndex = newViewIndex;
}

function HideCameraLabels()
{
    winCameraStatus.bVisible = false;
    winDoorStatus.bVisible = false;
    winTurretStatus.bVisible = false;
}

function UpdateCameraStatus()
{
/*  if (camera == None)
    {
        winCamera.EnableViewport(False);
        winCamera.Lower();
        btnCamera.SetStatic();
        SetTitle(NoSignalLabel);
        winCameraStatus.Hide();
        HideCameraLabels();
    }
    else
    {
        winCamera.SetViewportActor(camera);
        winCamera.EnableViewport(True);
        winCamera.SetDefaultTexture(None);
        winCamera.Lower();
        SetTitle(CameraLabel @ "|&" $ String(viewIndex + 1) @ ":" @ ComputerSecurity(compOwner).Views[viewIndex].titleString);
        winCameraStatus.Show();
        SetCameraStatus(camera.bActive);
    }*/
    if (selectedCamera != none)
    {
        SetTitle(CameraLabel @ String(viewIndex + 1) @ ":" @ ComputerSecurity(compOwner).Views[viewIndex].titleString);
        winCameraStatus.Show();
        SetCameraStatus(selectedCamera.bActive);
    }
}

function ShowTurretLabel(bool bNewShow)
{
    winTurretStatus.bVisible = bNewShow;
}

function UpdateTurretStatus()
{
    local string str;

    if (turret == None)
    {
        ShowTurretLabel(false);
    }
    else
    {
        ShowTurretLabel(true);

        str = TurretStatusLabel;

        if (turret.bDisabled)
            str = str @ DisabledLabel;

        else if (turret.bTrackPlayersOnly)
            str = str @ AttackingAlliesLabel;

        else if (turret.bTrackPawnsOnly)
            str = str @ AttackingEnemiesLabel;

        else
            str = str @ AttackingEverythingLabel;

        winTurretStatus.Caption = str;
    }
}

function SetCameraStatus(bool bOn)
{
    if (bOn)
        winCameraStatus.Caption = CameraStatusLabel @ OnLabel;
    else
        winCameraStatus.Caption = CameraStatusLabel @ OffLabel;
}

function ShowDoorLabel(bool bNewShow)
{
    winDoorStatus.bVisible = bNewShow;
}

function UpdateDoorStatus()
{
    local string str;

    if ((door == None) || (door.bDestroyed))
    {
        ShowDoorLabel(False);       
    }
    else
    {
        ShowDoorLabel(True);        

        str = DoorStatusLabel;

        if (door.KeyNum != 0)
            str = str @ OpenLabel;
        else
            str = str @ ClosedLabel;

        str = str $ ",";

        if (door.bLocked)
            str = str @ LockedLabel;
        else
            str = str @ UnlockedLabel;

        winDoorStatus.Caption = str;
    }
}



defaultproperties
{
    panSize=256
    zoomSize=2.00
    numPanTicks=9
    lowPanValue=1.00
    highPanValue=5.00

    camFOV=90

    ActiveWindowOptionsHeader="Active Window Options"
    CameraOptionsHeader="Camera Options"
    PanZoomSpeedHeader="Pan/Zoom Speed"
    CameraLabel="Camera"
    CameraStatusLabel="Camera:"
    DoorStatusLabel="Door:"
    TurretStatusLabel="Turret:"
    OnLabel="On"
    OffLabel="Off"
    DisabledLabel="Bypassed"
    AttackingAlliesLabel="Attacking Allies"
    AttackingEnemiesLabel="Attacking Enemies"
    AttackingEverythingLabel="Attacking Everything"
    NoSignalLabel="NO SIGNAL"
    OpenLabel="Open"
    ClosedLabel="Closed"
    LockedLabel="Locked"
    UnlockedLabel="Unlocked"

    onRendered=InternalOnRendered
    OnKeyEvent=InternalOnKeyEvent

    portalSizeX=652
    portalSizeY=272
    portalCorrectionX=-1//56
    portalCorrectionY=-223
}