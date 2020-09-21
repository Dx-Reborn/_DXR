/*------------------------------------------------------
   DXCanvas from Reborn Project
   Contains text parser and some useful functions.
------------------------------------------------------*/

class DXCanvas extends Object 
                       Transient;

var Canvas c;
var color TeleTypeTextColor;
var string CursorChar;

function SetCanvas(Canvas inc)
{
    c=inc;
}

function TextSize(string text, out float x, out float y)
{
    local float holdx, holdy;
    local float width, height;

    holdx = c.FontScaleX;
    holdy = c.FontScaleY;

    c.FontScaleX=1.0;
    c.FontScaleY=1.0;

    c.TextSize(text,width,height);
    x = width * holdx;
    y = height * holdy;

    c.FontScaleX=holdx;
    c.FontScaleY=holdy;
}

function DrawTextTeletype(string text, string newline, float time, float rate)
{
    local float holdx, holdy, holdxclip, xstep, ystep, R,G,B;// alpha;
    local int x, y, z, strlen;
    local array<string> mytext;
    local string temp;

    if(time <= 0.0)
    {
        return;
    }

    holdxclip = c.ClipX;

    c.ReplaceText(text,newline,"|");
    c.WrapStringToArray(text,mytext,c.ClipX-c.CurX,"|");


    z=0;
    for(x=0; x<mytext.length; x++)
    {
        c.TextSize(mytext[x],xstep,ystep);
        strlen = Len(mytext[x]);
        xstep /= strlen;

        holdx=c.CurX;
        holdy=c.CurY;

        for(y=0; y<strlen; y++)
        {
            temp = Mid(mytext[x],y,1);
            if(time-(z*rate) > 0)
            {
                R = time-(z*rate);
                R = FClamp(R, 0.0, 1.0);
                R *= TeleTypeTextColor.R;

                G = time-(z*rate);
                G = FClamp(G, 0.0, 1.0);
                G *= TeleTypeTextColor.G;

                B = time-(z*rate);
                B = FClamp(B, 0.0, 1.0);
                B *= TeleTypeTextColor.B;

                c.SetDrawColor(R,G,B);
                //c.DrawColor = TeleTypeTextColor;
                c.DrawTextClipped(temp);
                c.SetPos(c.CurX+xstep,holdy);
            }
            else
            {
                //c.SetDrawColor(255,255,255);
                c.DrawColor = TeleTypeTextColor;
                c.DrawTextClipped(CursorChar);
                c.SetPos(c.CurX+xstep,holdy);
                return;
            }
            z++;
        }

        if((x+1) == mytext.length && time%0.5 >= 0.25)
        {
            //c.SetDrawColor(255,255,255);
            c.DrawColor = TeleTypeTextColor;
            c.DrawTextClipped(CursorChar);
            c.SetPos(c.CurX+xstep,holdy);
        }

        c.SetPos(holdx,holdy+ystep);
    }
}

function Vector DrawText(string text, optional string newline)
{
    local Vector dimensions;
    local float holdx, holdy, ystep;
    local int x;
    local array<string> mytext;

    dimensions.X = c.ClipX-c.CurX;
    dimensions.Y = c.CurY;
    dimensions.Z = 0;

    if(newline == "")
    {
        newline = "|";
    }

    c.ReplaceText(text,newline,"|");
    c.WrapStringToArray(text,mytext,c.ClipX-c.CurX,"|");

    c.TextSize("Accept",holdx,ystep);

    for(x=0; x<mytext.length; x++)
    {
        holdx=c.CurX;
        holdy=c.CurY;

        c.DrawTextClipped (mytext[x]);
        c.SetPos(holdx,holdy+ystep);
    }

    dimensions.Y = c.CurY - dimensions.Y;

    return dimensions;
}

function DrawTextJustified(string text, byte justification, float x1, float y1, float x2, float y2)
{
    local float width, height;
    local float ypos;
    local float holdx, holdy;

    holdx=c.CurX;
    holdy=c.CurY;

    c.StrLen(text, width, height);

    ypos=y1+((y2-y1-height)/2.0);   //always center vertically

    switch(justification)
    {
        case 0:
            c.SetPos(x1,ypos);
            break;
        case 1:
            c.SetPos(x1+((x2-x1-width)/2.0),ypos);
            break;
        case 2:
            c.SetPos(x2-width,ypos);
            break;
    }

    c.DrawTextClipped(text,false);

    c.SetPos(holdx,holdy);
}

function DrawTileStretched(material mat, float width, float height)
{
    local float usize, vsize;
    local float holdx, holdy;
    local float tempy;

    holdx=c.CurX;
    holdy=c.CurY;

    usize=mat.MaterialUSize();
    vsize=mat.MaterialVSize();

    tempy=c.CurY;
    DrawTileClipped(mat, usize/2, vsize/2, 0, 0, usize/2, vsize/2);
    c.SetPos(c.CurX,holdy);
    DrawTileClipped(mat, width-usize, vsize/2, (usize/2)-1, 0, 1, vsize/2);
    c.SetPos(c.CurX,holdy);
    DrawTileClipped(mat, usize/2, vsize/2, usize/2, 0, usize/2, vsize/2);

    tempy+=vsize/2;
    c.SetPos(holdx,tempy);
    DrawTileClipped(mat, usize/2, height-vsize, 0, (vsize/2)-1, usize/2, 1);
    c.SetPos(c.CurX,tempy);
    DrawTileClipped(mat, width-usize, height-vsize, (usize/2)-1, (vsize/2)-1, 1, 1);
    c.SetPos(c.CurX,tempy);
    DrawTileClipped(mat, usize/2, height-vsize, usize/2, (vsize/2)-1, usize/2, 1);

    tempy+=height-vsize;
    c.SetPos(holdx,tempy);
    DrawTileClipped(mat, usize/2, vsize/2, 0, vsize/2, usize/2, vsize/2);
    c.SetPos(c.CurX,tempy);
    DrawTileClipped(mat, width-usize, vsize/2, (usize/2)-1, vsize/2, 1, vsize/2);
    c.SetPos(c.CurX,tempy);
    DrawTileClipped(mat, usize/2, vsize/2, usize/2, vsize/2, usize/2, vsize/2);

    c.SetPos(holdx,holdy);
}

function DrawTileClipped( Material Mat, float XL, float YL, float U, float V, float UL, float VL )
{
    local float x, y;
    local float left,top,bottom,right;
    local float newxl, newyl, newu, newv, newul, newvl;
    local float oldxl, oldyl;
    local float usize, vsize;

    usize=mat.MaterialUSize();
    vsize=mat.MaterialVSize();

    left = c.CurX;
    top = c.CurY;
    right = left + XL;
    bottom = top + YL;

    if(bottom < 0 || right < 0)
    {
        return;
    }


    x=c.CurX;
    y=c.CurY;

    newxl=xl;
    newyl=yl;
    newu=u;
    newv=v;
    newul=ul;
    newvl=vl;

    if(left < 0)
    {
        newxl=xl+left;
        x=0;
        newu=u+((usize-u)*(1-(newxl/xl)));
        newul=(u+ul)-newu;
    }

    if(right > c.ClipX)
    {
        oldxl=newxl;
        newxl-=(right-c.ClipX);
        newul=(newxl/oldxl)*ul;
    }

    if(top < 0)
    {
        newyl=yl+top;
        y=0;
        newv=v+((vsize-v)*(1-(newyl/yl)));
        newvl=(v+vl)-newv;
    }

    if(bottom > c.ClipY)
    {
        oldyl=newyl;
        newyl-=(bottom-c.ClipY);
        newvl=(newyl/oldyl)*vl;
    }

    c.SetPos(x,y);
    c.DrawTile(mat,newxl,newyl,newu,newv,newul,newvl);
}

function DrawVertical(float X, float height)
{
    local float cX,cY;

    cx = c.CurX;
    cy = c.CurY;
    c.SetPos(X,cy);
    c.DrawRect(texture'solid',1,height);
    c.SetPos(cx,cy);
}

function DrawLine(int direction, float size)
{
    local float cx,cy;
    CX = c.CurX;
    CY = c.CurY;

    switch (direction)
    {
        case 0:
            c.CurY-=Size;
            c.DrawVertical(c.CurX,size);
            break;
        case 1:
            c.DrawVertical(c.CurX,size);
            break;
        case 2:
            c.CurX-=Size;
            c.DrawHorizontal(c.CurY,size);
            break;
        case 3:
            c.DrawHorizontal(c.CurY,size);
            break;
    }
    c.CurX = CX;
    c.CurY = CY;
}

function SetPos(float X, float Y)
{
    c.SetPos(X,Y);
}

function DrawHorizontal(float y, float width)
{
    local float cx,cy;

    cx = c.CurX;
    cy = c.CurY;
    c.SetPos(cx,y);
    c.DrawRect(texture'solid',width,1);
    c.SetPos(cx,cy);
}

function DrawBox(float width, float height)
{
    local float cx,cy;

    cx = c.CurX;
    cy = c.CurY;
    c.DrawRect(texture'solid',width,1);
    c.SetPos(cx,cy+1);
    c.DrawRect(texture'solid',1,height-1);
    c.SetPos(cx+width,cy);
    c.DrawRect(texture'solid',1,height+1);
    c.SetPos(cx,cy+height);
    c.DrawRect(texture'solid',width,1);
    c.SetPos(cx,cy);
}

function NoDrawParseText(string text)
{
    local string result, char, tag, attrib, value;
    local array<string> parts;
    local int x, slen, ctr, pos, R, G, B;
    local float w, h, XL, YL;
    local bool bTag, bCenter;

    c.TextSize("ABCgjyXYZ",w,h);

    slen = Len(text);
    bTag=false;
    bCenter=false;
    ctr=0;
    result="";

    for(x=0; x<slen; x++)
    {
        char = Mid(text,x,1);
        if(char == "<")
        {
            bTag=true;

            if(Mid(text,x+1,1) == "")
            {
                c.SetPos(0,c.CurY+h);

                c.StrLen(result, XL, YL);
                c.SetPos(0,c.CurY+YL);

                bCenter=false;
                result="";
            }
            if(Mid(text,x+1,1) == "P")
            {
                c.SetPos(0,c.CurY+h);


                c.StrLen(result, XL, YL);
                c.SetPos(0,c.CurY+YL);

                bCenter=false;
                result="";
            }
            else if(Mid(text,x+1,2) == "DC")
            {
                pos = InStr(Mid(text,x+1),">");
                tag = Mid(text,x+1,pos);

                Divide(tag,"=",attrib,value);
                Split(value,",",parts);

                R=int(parts[0]);
                G=int(parts[1]);
                B=int(parts[2]);

                c.SetDrawColor(R,G,B);
            }
            else if(Mid(text,x+1,2) == "JC")
            {
                bCenter=true;
            }
            else if(Mid(text,x+1,1) == "B")
            {
                //no bold font, GG ISA, GG
            }
            pos = InStr(Mid(text,x+1),">");
            x += pos;
        }

        if(bTag == false)
        {
            result $= char;
            ctr++;
        }
        else
        {
            if(char == ">")
            {
                bTag=false;
            }
        }
    }
}

function DrawParseText(string text)
{
    local string result, char, tag, attrib, value;
    local array<string> parts;
    local int x, slen, ctr, pos, R, G, B;
    local float w, h, XL, YL;
    local bool bTag, bCenter;

    c.TextSize("ABCgjyXYZ",w,h);

    slen = Len(text);
    bTag=false;
    bCenter=false;
    ctr=0;
    result="";

    for(x=0; x<slen; x++)
    {
        char = Mid(text,x,1);
        if(char == "<")
        {
            bTag=true;

            if(Mid(text,x+1,1) == "P")
            {
                c.SetPos(0,c.CurY+h);

                if(bCenter == false)
                {
                    DrawText(result, "|");
                }
                else
                {
                    c.StrLen(result, XL, YL);
                    DrawTextJustified(result, 1, 0, c.CurY, c.ClipX, c.CurY+YL);
                }

                bCenter=false;
                result="";
            }
            else if(Mid(text,x+1,2) == "DC")
            {
                pos = InStr(Mid(text,x+1),">");
                tag = Mid(text,x+1,pos);

                Divide(tag,"=",attrib,value);
                Split(value,",",parts);

                R=int(parts[0]);
                G=int(parts[1]);
                B=int(parts[2]);

                c.SetDrawColor(R,G,B);
            }
            else if(Mid(text,x+1,2) == "JC")
            {
                bCenter=true;
            }
            else if(Mid(text,x+1,1) == "B")
            {
                //no bold font, GG ISA, GG
            }
            pos = InStr(Mid(text,x+1),">");
            x += pos;
        }

        if(bTag == false)
        {
            result $= char;
            ctr++;
        }
        else
        {
            if (char == ">")
            {
                bTag=false;
            }
        }
    }

    if(bCenter == false)
    {
        DrawText(result, "|");
    }
    else
    {
        c.StrLen(result, XL, YL);
        DrawTextJustified(result, 1, 0, c.CurY, c.ClipX, c.CurY+YL);
    }
}


defaultproperties
{
  TeleTypeTextColor=(R=255,G=255,B=255,A=255) // white by default
  CursorChar="_" // Can be more than one char.
}