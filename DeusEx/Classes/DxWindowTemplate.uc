/*--------------------------------------------
  Шаблон для окошек в стиле Deus Ex.
  По умолчанию настроены заголовок и фон.
  Требуемые компоненты (кнопки, списки и т.п.)
  создаются в соответствующей функции.

  21/06/2018: теперь есть цветная вставка
  в заголовке, а заголовок задается через
  WinTitle.

  07/07/2018: Добавлена поддержка цветовых
  тем.
--------------------------------------------*/
class DxWindowTemplate extends floatingwindow;

#exec OBJ LOAD FILE=DeusExUI.u

var(Left) float leftEdgeCorrectorX, leftEdgeCorrectorY, leftEdgeHeight;
var(Right) float RightEdgeCorrectorX, RightEdgeCorrectorY, RightEdgeHeight;
var(Top) float TopEdgeCorrectorX, TopEdgeCorrectorY, TopEdgeLength;
var(TopCorner) float TopRightCornerX, TopRightCornerY;
var(Bubble) float bubbleCorrectorX, bubbleCorrectorY, bubbleWidthCorrector;
var texture LeftEdgeTexture, RightEdgeTexture, TopEdgeTexture, cornerTexture;
var(Shadow) float ShadowPosX, ShadowPosY, ShadowSizeX, ShadowSizeY;
var() localized string WinTitle;
var() DeusExGlobals gl;
var() bool bNoBorders, bUseShadow;
var(Shadow) eMenuRenderStyle ShadowStyle;
var(Shadow) material ShadowMat;

function SetSize(float Height, float width)
{
   WinHeight = Height; WinWidth = width;
   DefaultHeight = Height; DefaultWidth = width;
   MaxPageHeight = Height; MaxPageWidth = width;
   MinPageHeight = Height; MinPageWidth = width;
}

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
   Super.InitComponent(MyController, MyOwner);
   gl = class'DeusExGlobals'.static.GetGlobals();

   CreateMyControls();
   ApplyTheme();
}

function ApplyTheme()
{
   local GUIStyles wtf;

   foreach AllObjects(class'GUIStyles', wtf) // it works! :D
   {
      if (wtf != none)
          wtf.initialize();
   }
   if (i_FrameBG != none)
       i_FrameBG.ImageColor = class'DXR_Menu'.static.GetMenuBackground(gl.MenuThemeIndex);

   if (DeusExPlayerController(PlayerOwner()).bMenusTranslucent)
   {
      if (i_FrameBG != none)
          i_FrameBG.ImageRenderStyle = MSTY_Translucent;
   }
   else
      if (i_FrameBG != none)
          i_FrameBG.ImageRenderStyle = MSTY_Alpha;

}

function CreateMyControls();
function CancelSettings();

function bool InternalOnClick(GUIComponent Sender)
{  
   return false;
}

function AddSystemMenu();

function bool AlignFrame(Canvas C)
{
   if (bVisible)
       winleft = (controller.resX/2) - (MaxPageWidth/2);
   else
       winleft = -2000;

   return bInit;
}

function PaintOnHeader(Canvas C)
{
   local texture icon;

   /* Цветная вставка*/
   icon = texture'DXR_MenuTitleBubble';
   C.SetPos(t_WindowTitle.ActualLeft() + bubbleCorrectorX, t_WindowTitle.ActualTop() + bubbleCorrectorY);
   c.DrawColor = class'DXR_Menu'.static.GetMenuHeaderBubble(gl.MenuThemeIndex);  //C.SetDrawColor(0,255,217);
   C.DrawTileStretched(icon, t_WindowTitle.ActualWidth() - bubbleWidthCorrector, 32);

   /* Значок Deus Ex */
   icon = texture'DeusExSmallIcon';
   C.SetPos(t_WindowTitle.ActualLeft() + 8, t_WindowTitle.ActualTop() + 3);
   C.SetDrawColor(255,255,255);
   icon.bMasked = false;
   C.DrawIcon(icon, 1);

   /* Новый текст заголовка окна, поскольку начальный мы только что закрыли. */
   C.font = font'DxFonts.HR_9';
   C.SetPos(t_WindowTitle.ActualLeft() + 26, t_WindowTitle.ActualTop() + 6);
   c.drawColor = class'DXR_Menu'.static.GetMenuHeaderText(gl.MenuThemeIndex);//C.SetDrawColor(255,255,255);
   C.drawText(WinTitle, false);
}

    

function PaintOnBG(canvas u)
{
   if (bNoBorders)
       return;

   /* Левая граница */
   u.SetPos(ActualLeft() + leftEdgeCorrectorX, ActualTop() + leftEdgeCorrectorY);
   u.DrawColor = class'DXR_Menu'.static.GetMenuBorders(gl.MenuThemeIndex);
   u.Style = eMenuRenderStyle.MSTY_Normal;
   u.DrawTileStretched(LeftEdgeTexture, 4, leftEdgeHeight);

   /* Правая граница */
   u.SetPos(ActualLeft() + RightEdgeCorrectorX, ActualTop() + RightEdgeCorrectorY);
   u.Style = eMenuRenderStyle.MSTY_Normal;
   u.DrawTileStretched(RightEdgeTexture, 4, RightEdgeHeight);

   /* Верхняя граница */
   u.SetPos(ActualLeft() + TopEdgeCorrectorX, ActualTop() + TopEdgeCorrectorY);
   u.Style = eMenuRenderStyle.MSTY_Normal;
   u.DrawTileStretched(TopEdgeTexture, TopEdgeLength, 4);

   /* Верхний правый угол */
   u.SetPos(ActualLeft() + TopRightCornerX, ActualTop() + TopRightCornerY);
   u.Style = eMenuRenderStyle.MSTY_Normal;
   u.DrawIcon(cornerTexture, 1);
}

function bool FloatingPreDraw(canvas u)
{
   Super.FloatingPreDraw(u);

   // DXR: Render the shadow if required!
   if (bUseShadow)
   {
       if (ShadowMat != None)
       {
           u.DrawColor = i_FrameBG.ImageColor;
           u.Reset();
           u.SetPos(ActualLeft() + ShadowPosX, ActualTop() + ShadowPosY);
           u.Style = ShadowStyle;
           u.DrawTileStretched(ShadowMat,ShadowSizeX, ShadowSizeY);
       }
   }
   return false;
}

//[ToDo] DXR: Render everything while moving the window, not only that frame!
/*function FloatingRendered(Canvas u)
{
   if (!bMoving)
       return;

   u.SetPos(FClamp(Controller.MouseX - MouseOffset[0], 0.0, Controller.ResX - ActualWidth()),
            FClamp(Controller.MouseY - MouseOffset[1], 0.0, Controller.ResY - ActualHeight()));
   u.SetDrawColor(255,255,255,255);
   u.DrawTileStretched(Controller.WhiteBorder, ActualWidth(), ActualHeight());
} */


event Opened(GUIComponent Sender)                   // Called when the Menu Owner is opened
{
   if (ParentPage != none)
       ParentPage.bVisible=false;

   super.Opened(Sender);
}

event Closed(GUIComponent Sender, bool bCancelled)  // Called when the Menu Owner is closed
{
   if (ParentPage != none)
       ParentPage.bVisible=true;

   Super.Closed(Sender, bCancelled);
}

function bool OnCanClose(optional bool bCancelled)
{
   if (bCancelled)
       CancelSettings();

   return Super.OnCanClose(bCancelled);
}

function SetMouseCursorIndex(int index);




defaultproperties
{
   ShadowStyle=MSTY_Normal
   ShadowSizeX=520
   ShadowSizeY=280

   ShadowPosX=-60
   ShadowPosY=-55

   bNoBorders=false
   bUseShadow=false

   openSound=sound'DeusExSounds.UserInterface.Menu_Activate'
   CloseSound=sound'DeusExSounds.UserInterface.Menu_Cancel'

   ShadowMat=Shader'DeusExUIExtra.Interface.YNMS_SH1';

   TopEdgeTexture=texture'MenuRightBorder_Top'
   LeftEdgeTexture=texture'DXR_MenuLeftBorder'
   RightEdgeTexture=texture'DXR_MenuRightBorder'

   cornerTexture=texture'MenuRightBorder_TopRight'
   leftEdgeHeight=200
   RightEdgeHeight=200
   TopEdgeLength=200
   bubbleWidthCorrector=5

   bRequire640x480=false//true

   HeaderMouseCursorIndex=0

   bPersistent=false
   bAllowedAsLast=true

   DefaultHeight=354
   DefaultWidth=264

   MaxPageHeight=354
   MaxPageWidth=264
   MinPageHeight=354
   MinPageWidth=264
   bResizeWidthAllowed=false
   bResizeHeightAllowed=false

    // Background image
    Begin Object Class=FloatingImage Name=FloatingFrameBackground
        Image=Texture'menumainbackground_dxr'
        ImageRenderStyle=MSTY_Translucent
        ImageStyle=ISTY_Tiled
        ImageColor=(R=255,G=255,B=255,A=255)
        DropShadow=None
        WinWidth=256
        WinHeight=333 //229
        WinLeft=8
        WinTop=20
        RenderWeight=0.000003
        bBoundToParent=True
        bScaleToParent=True
        OnRendered=PaintOnBG
    End Object
    i_FrameBG=FloatingFrameBackground
    // Header
    Begin Object Class=GUIHeader Name=TitleBar
        WinWidth=0.98
        WinHeight=128
        WinLeft=-2
        WinTop=-3
        RenderWeight=0.1
        FontScale=FNS_Small
        bUseTextHeight=false
        bAcceptsInput=True
        bNeverFocus=true //False
        bBoundToParent=true
        bScaleToParent=true
        OnMousePressed=FloatingMousePressed
        OnMouseRelease=FloatingMouseRelease
        OnRendered=PaintOnHeader
        ScalingType=SCALE_ALL
    StyleName="STY_DXR_DXWinHeader";
    Justification=TXTA_Left
    End Object
    t_WindowTitle=TitleBar
}