//
// "Received:" HUD overlay.
//

class HudOverlay_received extends DXRHudOverlay;


struct sReceivedItems
{
   var() Inventory anItem;
   var() int anItemCount;
};
var() array<sReceivedItems> recentItems; // DXR: Array of items for the player.

var localized string strReceived;
var color InfoLinkBG, InfoLinkText, InfoLinkTitles, InfoLinkFrame;

const MIN_OVERLAY_DELAY = 0.9;

function AddItem(Inventory invItem, int count)
{
    local int x;

    x = RecentItems.length;
    RecentItems.length = x + 1; // добавить 1 к длине массива
    RecentItems[x].anItem = invItem; // присвоить данные к элементу массива
    RecentItems[x].anItemCount = count;

    TimerRate += MIN_OVERLAY_DELAY;
}

event SetInitialState()
{
    local DeusExHUD h;

    SetTimer(FMax(MIN_OVERLAY_DELAY,recentItems.Length), false);

    Super.SetInitialState();

    h = DeusExHUD(level.GetLocalPlayerController().myHUD);
    InfoLinkBG = h.InfoLinkBG;
    InfoLinkText = h.InfoLinkText;
    InfoLinkTitles = h.InfoLinkTitles;
    InfoLinkFrame = h.InfoLinkFrame;
}

event Timer()
{
    Destroy();
}

event Destroyed()
{
    local int x;

    Super.Destroyed();

    if (DeusExPlayer(level.GetLocalPlayerController().Pawn) != None)
        DeusExPlayer(level.GetLocalPlayerController().Pawn).bSkipCrosshair = false;

    for(x=0; x<recentItems.length; x++)
    {
        if (recentItems[x].anItem != None)
            if (recentItems[x].anItem.IsA('Credits') || recentItems[x].anItem.IsA('NanoKey'))
                recentItems[x].anItem.Destroy();
    }
}

//
// Уведомляет игрока о том что получен предмет инвентаря.
// На основе кода из Reborn.
// 27/12/2017 : переделано в оверлей.
//
function Render(Canvas u)
{
    local float w,h;
    local int x;
    local texture border;
    local material ico;

    local string infoBuffer;

    dxc.SetCanvas(u);

    if (DeusExPlayer(level.GetLocalPlayerController().Pawn) != None)
        DeusExPlayer(level.GetLocalPlayerController().Pawn).bSkipCrosshair = true;

    u.SetDrawColor(255,255,255);
    u.Font = Font'DXFonts.DPix_7';//'DxFonts.FontMenuSmall_DS';
    u.Style=1;

//    w = 50+80 * RecentItems.Length;
    w = 40+80 * RecentItems.Length;
    h = 64;
    infoBuffer = StrReceived;

    u.SetOrigin(int((u.SizeX-w)/2), int((u.SizeY-h)/2));
    u.SetClip(w, h);

    u.DrawColor = InfoLinkBG;
    if (DeusExPlayerController(Level.GetLocalPlayerController()).bHUDBackgroundTranslucent)
        u.Style = ERenderStyle.STY_Translucent;
            else
        u.Style = ERenderStyle.STY_Normal;

    //TL
    u.SetPos(-13,-16);
    u.DrawTile(texture'DeusExUI.HUDWindowBackground_TL',63,16, 1,0,63,16);
    //L
    u.SetPos(-13,0);
    u.DrawTile(texture'DeusExUI.HUDWindowBackground_Left',63,h, 1,0,63,8);
    //BL
    u.SetPos(-13, u.ClipY);
    u.DrawTile(texture'DeusExUI.HUDWindowBackground_BL',63,16, 1,0,63,16);

    //T
    u.SetPos(50,-16);
    u.DrawTile(texture'DeusExUI.HUDWindowBackground_Top',w-51,16, 0,0,8,16);
    //M
    u.SetPos(50,0);
    u.DrawTile(texture'DeusExUI.HUDWindowBackground_Center',w-51,h, 0,0,8,8);
     //B
    u.SetPos(50,u.ClipY);
    u.DrawTile(texture'DeusExUI.HUDWindowBackground_Bottom',w-51,16, 0,0,8,16);
    u.SetOrigin(u.OrgX+u.ClipX-1,u.OrgY-16);
    u.SetClip(32,h+32);
    //TR
    u.SetPos(0,0);
    u.DrawTileClipped(texture'DeusExUI.HUDWindowBackground_TR',30,16, 1,0,31,16);
    //R
    u.SetPos(0,16);
    u.DrawTileClipped(texture'DeusExUI.HUDWindowBackground_Right',30,h, 1,0,31,8);
    //BR
    u.SetPos(0, u.ClipY-16);
    u.DrawTileClipped(texture'DeusExUI.HUDWindowBackground_BR',30,16, 1,0,31,16);

    u.SetOrigin(int((u.SizeX-w)/2), int((u.SizeY-h)/2));
    u.SetClip(w, h);

    if (DeusExPlayerController(Level.GetLocalPlayerController()).bHUDBordersVisible)
    {
        if (DeusExPlayerController(Level.GetLocalPlayerController()).bHUDBordersTranslucent)
            u.Style = ERenderStyle.STY_Translucent;
                else
            u.Style = ERenderStyle.STY_Alpha;

        u.DrawColor = InfoLinkFrame;

        u.SetPos(-14,-16);
        border = texture'DeusExUI.HUDWindowBorder_TL';
        u.DrawTile(border,64,16, 0,0,64,16);

        u.SetPos(-14,0);
        border = texture'DeusExUI.HUDWindowBorder_Left';
        u.DrawTile(border,64,h, 0,0,64,8);

        u.SetPos(-14, u.ClipY);
        border = texture'DeusExUI.HUDWindowBorder_BL';
        u.DrawIcon(border,1.0);

        u.SetPos(50,-16);
        border = texture'DeusExUI.HUDWindowBorder_Top';
        u.DrawTile(border,w-52,16, 0,0,8,16);


        u.SetPos(50,u.ClipY);
        border = texture'DeusExUI.HUDWindowBorder_Bottom';
        u.DrawTile(border,w-52,16, 0,0,8,16);

        u.SetPos(u.ClipX-3,-16);
        border = texture'DeusExUI.HUDWindowBorder_TR';
        u.DrawIcon(border,1.0);

        u.SetPos(u.OrgX+u.ClipX-3,u.OrgY);
        border = texture'DeusExUI.HUDWindowBorder_Right';
        u.DrawTileStretched(border,32,h);

        u.SetPos(u.ClipX-3, u.ClipY);
        border = texture'DeusExUI.HUDWindowBorder_BR';
        u.DrawIcon(border,1.0);
    }

        u.Style=1;
        u.DrawColor = InfoLinkTitles;
        u.SetOrigin(int((u.SizeX-w)/2), int((u.SizeY-h)/2));
        u.SetClip(w, h);
        u.SetPos(0,0);

        dxc.DrawTextJustified(infoBuffer,0,0,0,u.ClipX,u.ClipY);
        u.SetOrigin(u.OrgX, u.OrgY+8);

        for(x=0; x<recentItems.length; x++)
        {
            u.Style = 2;
            //u.SetPos(60+40*x, 0);
            u.SetPos(60+80*x, 0);
            if (recentItems[x].anItem.isA('DeusExPickup'))
            {
                u.SetDrawColor(255,255,255); // Исправлено, иконки были залиты текущим цветом.
                ico = DeusExPickup(recentItems[x].anItem).default.Icon;
                u.DrawIconEx(ico,1.0);
                u.Style=1;
                u.DrawColor = InfoLinkText;
                //dxc.DrawTextJustified(DeusExPickup(ReceivedItems[x].anItem).default.beltDescription,1,60+40*x,48,100+40*x,58);
                dxc.DrawTextJustified(DeusExPickup(recentItems[x].anItem).default.beltDescription $"["$ recentItems[x].anItemCount $"]",1,60+80*x,48,100+80*x,58);
            }
            if (recentItems[x].anItem.isA('DeusExWeapon'))
            {
                u.SetDrawColor(255,255,255); // Исправлено, иконки были залиты текущим цветом.
                ico = DeusExWeapon(recentItems[x].anItem).default.Icon;
                u.DrawIconEx(ico,1.0);
                u.Style=1;
                u.DrawColor = InfoLinkText;
                //dxc.DrawTextJustified(DeusExWeapon(ReceivedItems[x].anItem).default.beltDescription,1,60+40*x,48,100+40*x,58);
                dxc.DrawTextJustified(DeusExWeapon(recentItems[x].anItem).default.beltDescription $"["$ recentItems[x].anItemCount $ "]",1,60+80*x,48,100+80*x,58);
            }
            if (recentItems[x].anItem.isA('DeusExAmmo'))
            {
                u.SetDrawColor(255,255,255); // Исправлено, иконки были залиты текущим цветом.
                ico = DeusExAmmo(recentItems[x].anItem).default.Icon;
                u.DrawIconEx(ico,1.0);
                u.Style=1;
                u.DrawColor = InfoLinkText;
                //dxc.DrawTextJustified(DeusExWeapon(ReceivedItems[x].anItem).default.beltDescription,1,60+40*x,48,100+40*x,58);
                dxc.DrawTextJustified(DeusExAmmo(recentItems[x].anItem).default.beltDescription $"["$
                                                 recentItems[x].anItemCount * DeusExAmmo(recentItems[x].anItem).default.AmmoAmount $"]",1,60+80*x,48,100+80*x,58);
            }
        }
    u.reset();
    u.SetClip(u.sizeX,u.sizeY);
}




defaultproperties
{
    strReceived="RECEIVED:"
}
