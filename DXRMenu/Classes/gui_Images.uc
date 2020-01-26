/* Экран полученных изображений */

class gui_Images extends PlayerInterfacePanel;

var GUIImage imagesBG, ImgViewer;
var GUILabel Limages, LNoImages, lShowImages, lNewImage, lImageName;
var GuiButton bClear, bAdd;
var GUIListBox imageList;
var CheckBox_Personal cShowNotes;
var GUIStyles SelStyle;
var GUIEditBox n;

var bool bWaitingForClick;

/* Frames positioning */
var(leftPart) float lFrameX, lframeY, lfSizeX, lfSizeY;
var(midPart) float mFrameX, mframeY, mfSizeX, mfSizeY;
var(rightPart) float rFrameX, rframeY, rfSizeX, rfSizeY;

var(BleftPart) float lFrameXb, lframeYb, lfSizeXb, lfSizeYb;
var(BmidPart) float mFrameXb, mframeYb, mfSizeXb, mfSizeYb;
var(BrightPart) float rFrameXb, rframeYb, rfSizeXb, rfSizeYb;

var(Symbol) float oX, oY;

var localized string strNewImage, strShowNotes, strImages, strNoImages, strHowToUse, strAddNote;


function ShowPanel(bool bShow)
{
  super.ShowPanel(bShow);
  if (bShow) 
     PlayerOwner().pawn.PlaySound(Sound'Menu_OK',SLOT_Interface,0.25);
}

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    Super.Initcomponent(MyController, MyOwner);
    CreateMyControls();
}

function CreateMyControls()
{
  SelStyle = Controller.GetStyle("STY_DXR_ListSelection",FontScale); // Get style to draw listbox selection

  lImageName = new(none) class'GUILabel';
  lImageName.bBoundToParent = true;
  lImageName.TextColor = class'DXR_Menu'.static.GetPlayerInterfaceTextLabels(gl.MenuThemeIndex);
  lImageName.TextFont="UT2HeaderFont";
  lImageName.bMultiLine = false;
  lImageName.TextAlign = TXTA_Left;
  lImageName.VertAlign = TXTA_Center;
  lImageName.FontScale = FNS_Small;
    lImageName.WinHeight = 20;
  lImageName.WinWidth = 500;
  lImageName.WinLeft = 264;
  lImageName.WinTop = 32;
    AppendComponent(lImageName, true);
//  lImageName.caption="image name here";

  lNewImage = new(none) class'GUILabel';
  lNewImage.bBoundToParent = true;
  lNewImage.TextColor = class'DXR_Menu'.static.GetPlayerInterfaceTextLabels(gl.MenuThemeIndex);
  lNewImage.caption = strNewImage;
  lNewImage.TextFont="UT2HeaderFont";
  lNewImage.bMultiLine = false;
  lNewImage.TextAlign = TXTA_Left;
  lNewImage.VertAlign = TXTA_Center;
  lNewImage.FontScale = FNS_Small;
    lNewImage.WinHeight = 20;
  lNewImage.WinWidth = 223;
  lNewImage.WinLeft = 550;
  lNewImage.WinTop = 574;
  lNewImage.FocusInstead=cShowNotes;
    AppendComponent(lNewImage, true);

  cShowNotes = new(none) class'CheckBox_Personal';
  cShowNotes.bBoundToParent = true;
    cShowNotes.WinHeight = 16;
  cShowNotes.WinWidth = 16;
  cShowNotes.WinLeft = 325.000000;
  cShowNotes.WinTop = 575;//0;
  cShowNotes.OnChange=ShowNotesOnChange;
  AppendComponent(cShowNotes, true);

  lShowImages = new(none) class'GUILabel';
  lShowImages.bBoundToParent = true;
  lShowImages.TextColor = class'DXR_Menu'.static.GetPlayerInterfaceTextLabels(gl.MenuThemeIndex);
  lShowImages.caption = strShowNotes;
  lShowImages.TextFont="UT2HeaderFont";
  lShowImages.bMultiLine = false;
  lShowImages.TextAlign = TXTA_Left;
  lShowImages.VertAlign = TXTA_Center;
  lShowImages.FontScale = FNS_Small;
    lShowImages.WinHeight = 20;
  lShowImages.WinWidth = 150;
  lShowImages.WinLeft = 340;
  lShowImages.WinTop = 573;
  lShowImages.FocusInstead=cShowNotes;
    AppendComponent(lShowImages, true);
/* -- Просмотр изображения ------------------------------ */
  ImgViewer = new(none) class'GUIImage';
  ImgViewer.bBoundToParent = true;
  ImgViewer.RenderWeight = 0.5;
    ImgViewer.WinHeight = 512;
  ImgViewer.WinWidth = 512;
  ImgViewer.WinLeft = 32;
  ImgViewer.WinTop = 54;//0;
  ImgViewer.OnClick=InternalOnClick;
  ImgViewer.bAcceptsInput = true;
  ImgViewer.bCaptureMouse = false; //
  ImgViewer.bNeverFocus = true; //
//  ImgViewer.
    AppendComponent(ImgViewer, true);

/* ------------------------------------------------------ */
  imagesBG = new(none) class'GUIImage'; 
  imagesBG.Image=texture'DXR_ImagesBackground';
  imagesBG.bBoundToParent = true;
    imagesBG.WinHeight = 564;
  imagesBG.WinWidth = 768;
  imagesBG.WinLeft = 16;
  imagesBG.WinTop = 32;//0;
  imagesBG.tag = 75;
    AppendComponent(imagesBG, true);

  Limages = new(none) class'GUILabel';
  Limages.bBoundToParent = true;
  Limages.TextColor = class'DXR_Menu'.static.GetPlayerInterfaceHDR(gl.MenuThemeIndex);
  Limages.caption = strImages;
  Limages.TextFont="UT2HeaderFont";
  Limages.bMultiLine = false;
  Limages.TextAlign = TXTA_Left;
  Limages.VertAlign = TXTA_Center;
  Limages.FontScale = FNS_Small;
    Limages.WinHeight = 20;
  Limages.WinWidth = 120;
  Limages.WinLeft = 23;
  Limages.WinTop = 33;
    AppendComponent(Limages, true);

  LNoImages = new(none) class'GUILabel';
  LNoImages.bBoundToParent = true;
  LNoImages.TextColor = class'DXR_Menu'.static.GetPlayerInterfaceTextLabels(gl.MenuThemeIndex);
  LNoImages.caption = strNoImages;
  LNoImages.TextFont="UT2HeaderFont";
  LNoImages.bMultiLine = false;
  LNoImages.TextAlign = TXTA_Center;
  LNoImages.VertAlign = TXTA_Center;
  LNoImages.FontScale = FNS_Small;
    LNoImages.WinHeight = 20;
  LNoImages.WinWidth = 514;
  LNoImages.WinLeft = 33;
  LNoImages.WinTop = 288;
    AppendComponent(LNoImages, true);

  /*---Кнопки-------------------------------------------------*/
  bClear = new(none) class'GUIButton';
  bClear.FontScale = FNS_Small;
  bClear.Caption = strHowToUse;
  bClear.Hint = "Brief instruction on how to use notes system";
  bClear.StyleName="STY_DXR_ButtonNavbar";
  bClear.bBoundToParent = true;
  bClear.OnClick = InternalOnClick;
  bClear.WinHeight = 23;//22;
  bClear.WinWidth = 145;//100;
  bClear.WinLeft = 171;
  bClear.WinTop = 571;
    AppendComponent(bClear, true);

  bAdd = new(none) class'GUIButton';
  bAdd.FontScale = FNS_Small;
  bAdd.Caption = strAddNote;
  bAdd.Hint = "Add note to image. Store any text you like.";
  bAdd.StyleName="STY_DXR_ButtonNavbar";
  bAdd.bBoundToParent = true;
  bAdd.OnClick = InternalOnClick;
  bAdd.WinHeight = 23;//22;
  bAdd.WinWidth = 145;//100;
  bAdd.WinLeft = 26;
  bAdd.WinTop = 571;
    AppendComponent(bAdd, true);
  /*---!Кнопки------------------------------------------------*/

  imageList = new(none) class'GUIListBox';
  imageList.MyScrollBar.WinWidth = 16;
  imageList.SelectedStyleName="STY_DXR_ListSelection";
  imageList.StyleName = "STY_DXR_Listbox";
  imageList.bBoundToParent = true;
  imageList.WinHeight = 511;
  imageList.WinWidth = 214;
  imageList.WinLeft = 552;
  imageList.WinTop = 55;
    AppendComponent(imageList, true);
  imageList.OnChange = imageListChange;
  imageList.list.OnDrawItem = CustomDrawing;

    ApplyTheme();
    fillData();
}

// Override listbox drawing
function CustomDrawing(Canvas u, int Item, float X, float Y, float W, float H, bool bSelected, bool bPending)
{
  local string myStr;
  local float XL;

  myStr = imageList.list.GetItemAtIndex(Item);
  XL = len(myStr);

  if (bSelected) // Draw selection border
      SelStyle.Draw(u,MSAT_Pressed, X, Y-2, W, H+2);

  if (DatavaultImage(imageList.List.GetObjectAtIndex(Item)).bPlayerViewedImage == false)
  {
    u.font = font'FontHUDWingDings';
    u.Style = EMenuRenderStyle.MSTY_Normal;
    u.SetPos(imageList.ActualLeft() + 200, Y+1);
    u.DrawText("C");
  }
   if (XL > 30) // if image description longer than 20 characters...
       imageList.Style.DrawText(u,MenuState, imageList.ActualLeft() + 2, Y, imageList.ActualWidth(), H, TXTA_Left, Left(myStr, 21)$"...", imageList.FontScale);
   else  // or as usually
       imageList.Style.DrawText(u,MenuState, imageList.ActualLeft() + 2, Y, imageList.ActualWidth(), H, TXTA_Left, myStr, imageList.FontScale);
}

function fillData()
{
    local Inventory inv;

  imageList.List.Clear();

    inv = PlayerOwner().Pawn.Inventory;
    while (inv != None)
    {
   if (inv.IsA('DatavaultImage'))
    imageList.List.Add(inv.GetDescription(), inv);

        inv = inv.inventory;
    }
    imageListChange(none);

    if (imageList.List.ItemCount > 0)
      LNoImages.SetVisibility(false);
}

function imageListChange(GUIComponent Sender)
{
  // А почему Hint напрямую не хочешь?
  imagelist.ToolTip.SetTip(imageList.List.SelectedText());
  ImgViewer.image = DatavaultImage(imageList.List.GetObject()).imageTexture;
  lImageName.Caption = DatavaultImage(imageList.List.GetObject()).imageDescription;
}

function bool InternalOnClick (GUIComponent Sender)
{
  local int currentLeft, currentTop;
  local DatavaultImage img;

  img = DatavaultImage(imageList.List.GetObject());

  if (img != none)
  {
    if (Sender==bAdd)
    {
      bWaitingForClick = true;
      //img.AddImgNote("Test note", 8, 8);
    }
    if (Sender==bClear)
    {
      // Instructions for notes
    }
    if (Sender==ImgViewer)
    {
      DatavaultImage(imageList.List.GetObject()).bPlayerViewedImage = true;
      currentLeft = Controller.mouseX - ImgViewer.ClientBounds[0];
      currentTop = Controller.mouseY - ImgViewer.ClientBounds[1] + 48;
      AddNoteObject(currentLeft, currentTop, "Enter text here");
    }
  }
 return false;
}

function AddNoteObject(int locX, int locY, string myNote)
{
 if (bWaitingForClick)
 {
  n = new(none) class'GuiEditBox';

  n.StyleName="STY_DXR_EditBox";
  n.RenderWeight = 1.0;
  n.bCaptureMouse = true;
    n.bScaleToParent = true;
    n.bBoundToParent = true;
    n.bAutoSize = false;
    n.FontScale = FNS_Small;
    n.bMaskText = false;
    n.SetText(myNote);
    n.MaxWidth = 128;
    n.WinHeight = 20;
  n.WinWidth = 120;
  n.WinLeft = locX;
  n.WinTop = locY;
  n.Tag = 123;
  n.OnRightClick=NoteOnRightClick;
    AppendComponent(n, true);
  SetFocus(n);
 }
 bWaitingForClick = false;
}

/* Удалить заметку по правому клику мыши */
function bool NoteOnRightClick(GUIComponent Sender)
{
  if (Sender.Tag==123)
  RemoveComponent(Sender);

  return false;
}

function ShowNotesOnChange(GUIComponent Sender)
{
  local int i;

    for (i=0;i<Controls.Length;i++)
    {
      if (Controls[i].tag==123)
      Controls[i].setVisibility(cShowNotes.bChecked);
    }
}

/* local DatavaultImage mo;
    mo(imageList.GetObject()).AddImgNote(string id, locX, locY);*/



/*function isWithinViewer(out float currentLeft, out float currentTop)
{
   currentLeft = Controller.mouseX - ImgViewer.ClientBounds[0];
   currentTop = Controller.mouseY - ImgViewer.ClientBounds[1];
} */

function PaintFrames(canvas u)
{
  local float x,y;

  x = ActualLeft(); y = ActualTop();

  u.DrawColor = class'DXR_Menu'.static.GetPlayerInterfaceFrames(gl.MenuThemeIndex);
  u.Style = EMenuRenderStyle.MSTY_Translucent;

  u.SetPos(x + lFrameX, y + lframeY);
  u.drawtileStretched(texture'ImagesBorder_1', lfSizeX, lfSizeY);

  u.SetPos(x + mFrameX, y + mframeY);
  u.drawtileStretched(texture'ImagesBorder_2', mfSizeX, mfSizeY);

  u.SetPos(x + rFrameX, y + rframeY);
  u.drawtileStretched(texture'ImagesBorder_3', rfSizeX, rfSizeY);
/*-----------------*/
  u.SetPos(x + lFrameXb, y + lframeYb);
  u.drawtileStretched(texture'ImagesBorder_4', lfSizeXb, lfSizeYb);

  u.SetPos(x + mFrameXb, y + mframeYb); 
  u.drawtileStretched(texture'ImagesBorder_5', mfSizeXb, mfSizeYb); 

  u.SetPos(x + rFrameXb, y + rframeYb);
  u.drawtileStretched(texture'ImagesBorder_6', rfSizeXb, rfSizeYb);

/*------------------------------------------------------------------*/
  u.SetPos(X + oX, Y + oY);
  u.Font = font'FontHUDWingDings';
  u.DrawText("C");
}




defaultproperties
{
   strNewImage=" - New Image"
   strShowNotes="Show Notes"
   strImages="Images"
   strNoImages="No Images"
   strHowToUse="Now to use notes?"
   strAddNote="Add a note"

   oX = 534
   oY = 577

// Top frames (six textures used) //
 lFrameX=5
 lframeY=30
 lfSizeX=305
 lfSizeY=376

 mFrameX=310
 mframeY=30
 mfSizeX=359
 mfSizeY=100

 rFrameX=669
 rframeY=30
 rfSizeX=128
 rfSizeY=381

//bottom//

 lFrameXb=5
 lframeYb=406
 lfSizeXb=305
 lfSizeYb=261

 mFrameXb=310
 mframeYb=411
 mfSizeXb=423
 mfSizeYb=256

 rFrameXb=733
 rframeYb=411
 rfSizeXb=64
 rfSizeYb=256


  OnRendered=PaintFrames
}


