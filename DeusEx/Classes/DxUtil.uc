//
// DxUtil: набор вспомогательных статических функций.
// Использование: class'DxUtil'.static.func()
// 48272

class DxUtil extends actor;

#exec obj load file=DeusExControls.utx

const bDebug = false;
const JPG_QUALITY = 95;

struct HtmlChar
{
    var string Plain;
    var string Coded;
};
var array<HtmlChar> SpecialChars;

var localized string January,February,March,April,May,June,July,August,September,October,November,December;
var localized string Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday;

/*  */
static function HSLToRGB(float h, float sl, float l, out float r, out float g, out float b)
{
    local float v;
    local float m;
    local float sv;
    local int sextant;
    local float fract, vsf, mid1, mid2;

    if (l <= 0.5)
        v = (l * (1.0 + sl));
    else
        v = (l + sl - l * sl);

    if (v <= 0)
    {
        r = 0.0;
        g = 0.0;
        b = 0.0;
    }
    else
    {
        m = l + l - v;
        sv = (v - m) / v;
        h *= 6.0;
        sextant = h;
        fract = h - sextant;
        vsf = v * sv * fract;
        mid1 = m + vsf;
        mid2 = v - vsf;

        switch(sextant)
        {
            case 0: r = v; g = mid1; b = m; break;
            case 1: r = mid2; g = v; b = m; break;
            case 2: r = m; g = v; b = mid1; break;
            case 3: r = m; g = mid2; b = v; break;
            case 4: r = mid1; g = m; b = v; break;
            case 5: r = v; g = m; b = mid2; break;
        }
    }
}


/* Взято из The Nameless Mod SDK */
static final function string GetMonthStr(int Month)
{
    switch(Month)
    {
    case 1:
        return default.January;
        break;
    case 2:
        return default.February;
        break;
    case 3:
        return default.March;
        break;
    case 4:
        return default.April;
        break;
    case 5:
        return default.May;
        break;
    case 6:
        return default.June;
        break;
    case 7:
        return default.July;
        break;
    case 8:
        return default.August;
        break;
    case 9:
        return default.September;
        break;
    case 10:
        return default.October;
        break;
    case 11:
        return default.November;
        break;
    case 12:
        return default.December;
        break;
    }
    return "";
}

static final function string GetDayOfWeekStr(int dayofWeek)
{
    switch(DayOfWeek)
    {
    case 1:
        return default.Sunday;
        break;
    case 2:
        return default.Monday;
        break;
    case 3:
        return default.Tuesday;
        break;
    case 4:
        return default.Wednesday;
        break;
    case 5:
        return default.Thursday;
        break;
    case 6:
        return default.Friday;
        break;
    case 7:
        return default.Saturday;
        break;
    }
    return "";
}

static final function string GetDayOfWeekRus(int dayofWeek)
{
    switch(DayOfWeek)
    {
    case 1:
        return default.Monday;
        break;
    case 2:
        return default.Tuesday;
        break;
    case 3:
        return default.Wednesday;
        break;
    case 4:
        return default.Thursday;
        break;
    case 5:
        return default.Friday;
        break;
    case 6:
        return default.Saturday;
        break;
    case 7:
        return default.Sunday; // последний день недели - воскресенье
        break;
    }
    return "";
}

/*-------------------------------------------------------------
  Прочитать JPG файл и передать его как текстуру
-------------------------------------------------------------*/
static function texture Jpg2Tex(string file)
{
  local bool temp;
  local texture tex;

  temp = class'GraphicsManager'.static.LoadTexture(file, tex);//, Outer);
  if ((tex.uSize == 0) || (tex.vSize == 0))
       return Texture'DeusExControls.Background.NoScreenshot';//Texture'CoreTexMisc.Glass.H_noise_A00';

  return tex;
}

static function material GetMeshTexture(Actor A, optional int TexNum)
{
  return class'ObjectManager'.static.GetActorMeshTexture(A, TexNum);
}

static function bool StopSound(Actor A, Sound S)
{
  if (A != none)
   return class'SoundManager'.static.StopSound(A, S);
}

/*-------------------------------------------------------------
  ConvertSpaces()
  Преобразовать пробелы в подчеркивание (_)
-------------------------------------------------------------*/
static function String ConvertSpaces(coerce String inString)
{
    local int index;
    local String outString;

    outString = "";

    for(index=0; index<Len(inString); index++)
    {
        if (Mid(inString, index, 1) == " ")
            outString = outString $ "_";
        else
            outString = outString $ Mid(inString, index, 1); 
    }

    return outString;
}

/*-------------------------------------------------------------
  Получить дату и время файла. При необходимости можно
  определить день недели, или убрать ненужное.
-------------------------------------------------------------*/
static function string GetFileTime(string file)
{
  local Times.SystemTime st;
  local Times.FileTime ft, lft;

  class'FileManager'.static.FileTime(file, ft);
  class'Times'.static.FileTimeToLocalFileTime(ft, lft);
  class'Times'.static.FileTimeToSystemTime(lft, st);

  return st.Year $ "." $ st.Month $ "." $ st.Day @ st.Hour $ ":" $ st.Minute $ ":" $ st.Second;
}

static function String TrimSpaces(String trimString)
{
    local int trimIndex;
    local int trimLength;

    if ( trimString == "" ) 
        return trimString;

    trimIndex = Len(trimString) - 1;
    while ((trimIndex >= 0) && (Mid(trimString, trimIndex, 1) == " ") )
        trimIndex--;

    if ( trimIndex < 0 )
        return "";

    trimString = Mid(trimString, 0, trimIndex + 1);

    trimIndex = 0;
    while((trimIndex < Len(trimString) - 1) && (Mid(trimString, trimIndex, 1) == " "))
        trimIndex++;

    trimLength = len(trimString) - trimIndex;
    trimString = Right(trimString, trimLength);

    return trimString;
}


/*-------------------------------------------------------------
  Преобразовать секунды в часы:минуты:секунды (секунды
  опционально). Из Unreal2
-------------------------------------------------------------*/
static final function string SecondsToTime(float TimeSeconds, optional bool bNoSeconds)
{
    local int Hours, Minutes, Seconds;
    local string HourString, MinuteString, SecondString;
    
    Seconds = int(TimeSeconds);
    Minutes = Seconds / 60;
    Hours   = Minutes / 60;
    Seconds = Seconds - (Minutes * 60);
    Minutes = Minutes - (Hours * 60);
    
    if( Seconds < 10 )
        SecondString = "0"$Seconds;
    else
        SecondString = string(Seconds);

    if( Minutes < 10 )
        MinuteString = "0"$Minutes;
    else
        MinuteString = string(Minutes);

    if( Hours < 10 )
        HourString = "0"$Hours;
    else
        HourString = string(Hours);

    if( bNoSeconds )
        return HourString$":"$MinuteString;
    else
        return HourString$":"$MinuteString$":"$SecondString;
}

/*-------------------------------------------------------------
  Передать путь к файлу, получить только его имя. Из Unreal2
  22/02/2018 -- вот и пригодилась функция :D
-------------------------------------------------------------*/
static function string StripPathFromFileName(string InName)
{
    local string FileName;
    local int Index, InLen, LastPos;

    if( Instr( InName, "\\" ) != -1 )
    {
        // find last slash
        InLen = Len(InName);
        for( Index=0; Index<InLen; Index++ )
        {
            if( Mid(InName, Index, 1) == "\\" )
                LastPos = Index;
        }
        if( LastPos > 0 )
            LastPos++;

        FileName = Mid( InName, LastPos );

        return FileName;
    }
    else
    {
        return InName;
    }
}

/*-------------------------------------------------------------
  То-же самое что и предыдущая
-------------------------------------------------------------*/
static function string StripMapPath(string s)
{
    local int p;

    p = len(s);
    while (p>0)
    {
        if (mid(s,p,1) == ".")
        {
            s = left(s,p);
            break;
        }
        else
         p--;
    }

    p = len(s);
    while (p>0)
    {
        if ( mid(s,p,1) == "\\" || mid(s,p,1) == "/" || mid(s,p,1) == ":" )
            return Right(s,len(s)-p-1);
        else
         p--;
    }

    return s;
}

/*-------------------------------------------------------------
  Адаптация из найденного примера на Java.
  Разделить строку и найти самую длинную часть
  в массиве.
-------------------------------------------------------------*/
static function int FindLongestPart(string myStr, out string long)
{
   local array<string> temp;
   local int i, init, index;

   split(myStr, "|", temp);
   init = len(temp[0]);

   for(i=0; i<temp.length; i++)
   {
     if (len(temp[i]) > init)
     {
        index = i;
        init = len(temp[i]);
     }
   }
   long = temp[index];
   return (len(temp[index]));
}

static function Color SGetColorScaled(float percent, optional byte A)
{
    local float mult;
    local Color col;

    if(A == 0)
        A=255;

    col.A=A;
    if (percent > 0.80)
    {
        col.r = 0;
        col.g = 255;
        col.b = 0;
    }
    else if (percent > 0.40)
    {
        mult = (percent-0.40)/(0.80-0.40);
        col.r = 255 + (0-255)*mult;
        col.g = 255;
        col.b = 0;
    }
    else if (percent > 0.10)
    {
        mult = (percent-0.10)/(0.40-0.10);
        col.r = 255;
        col.g = 0 + (255-0)*mult;
        col.b = 0;
    }
    else if (percent > 0)
    {
        col.r = 255;
        col.g = 0;
        col.b = 0;
    }
    else
    {
        col.r = 0;
        col.g = 0;
        col.b = 0;
    }

   return col;
}

/*-------------------------------------------------------------
  Created by Kaiser
  throwing this out there incase its useful for someone, and i
  thought its a function DX really should have had to
  begin with, its how i extracted parts of the strings for my bot

  Args: Original is the main string you want to check, leftcut
  is where you define the left side of where to split,
  rightcut is the same for the end of where to cut, offsets are
  for if you need to fine tine the points of where to cut for
  whatever reason.
-------------------------------------------------------------*/
static function string USplit(string Original, string LeftCut, string RightCut, optional int OffsetLeft, optional int OffsetRight)
{
    local int leftline, rightline;
    leftline = InStr(Original, LeftCut);
    leftline += Len(LeftCut);
    leftline += OffsetLeft;
    
    rightline = InStr(Original, RightCut);
    rightline += OffsetRight;
    
    return Mid(Original, leftline, rightline-leftline);
}

/*-------------------------------------------------------------
  Usplit("<message>blah</message>", "<message>","</message>");
  returns blah, for example
  another helpful function, returns the Original string but
  with every instance of Target replaced with ReplaceWith.
  later versions of unreal engine has this, so heres a 
  backported version for us
-------------------------------------------------------------*/
static function string URepl(string Original, string Target, string ReplaceWith)
{
    local string TempLeft, TempRight, OutMessage;

    OutMessage=Original;
    while (instr(caps(outmessage), Target) != -1)
    {
        tempRight=(right(OutMessage, (len(OutMessage)-instr(caps(OutMessage), Target))-Len(Target)));
        tempLeft=(left(OutMessage, instr(caps(OutMessage), Target)) );
        OutMessage=TempLeft $ ReplaceWith $ TempRight;
    }
    return OutMessage;
}


static function String CR()
{
    return Chr(13) $ Chr(10);
}

static final function String BuildPercentString(Float value)
{
    local string str;

    str = String(Int(Abs(value * 100.0)));
    if (value < 0.0)
        str = "-" $ str;
    else
        str = "+" $ str;

    return ("(" $ str $ "%)");
}

static function String FormatFloatString(float value, float precision)
{
    local string str;

    if (precision == 0.0)
        return "ERR";

    // build integer part
    str = String(Int(value));

    // build decimal part
    if (precision < 1.0)
    {
        value -= Int(value);
        str = str $ "." $ String(Int((0.5 * precision) + value * (1.0 / precision)));
    }
    return str;
}

/*-------------------------------------------------------------
  Возвращает группу текстуры
-------------------------------------------------------------*/
static function name GetMaterialGroup(Material hitMaterial)
{
    local array<string> parts;
    local string temp;

    temp = string(hitMaterial);
    Split(temp,".",parts);

    if(parts.length < 3)
    {
        if (bDebug)
        log("GetMaterialGroup return None from "$hitMaterial);

        return 'None';
    }
    else
    {
        if (bDebug)
        log("GetMaterialGroup return "$parts[1]);

        return class'ObjectManager'.static.StringToName(parts[1]);
    }
}

/*-------------------------------------------------------------
  Возвращает имя текстуры без пакета и группы
-------------------------------------------------------------*/
static function name GetMaterialName(Material hitMaterial)
{
    local array<string> parts;
    local string temp;

    temp = string(hitMaterial);
    Split(temp,".",parts);

    if(parts.length < 3)
    {
       if (bDebug)
       log("GetMaterialGroup return None from "$hitMaterial);

       return 'None';
    }
    else
    {
        if (bDebug)
        log("GetMaterialGroup return "$parts[2]);

        return class'ObjectManager'.static.StringToName(parts[2]);
    }
}

/*-------------------------------------------------------------
  Подготовить скриншот для сохранения. Скриншот создается заранее,
  чтобы избежать необходимости прятать меню и окна.
  Параметры: указатель на Level (XLevel), и куда сохранять.
-------------------------------------------------------------*/
static function PrepareShotForSaveGame(Level Level, string path)
{
  local texture shot;
  local DeusExGlobals gl;

  gl = class'DeusExGlobals'.static.GetGlobals();

    class'GraphicsManager'.static.TakeScreenShot(Level, shot);
    class'GraphicsManager'.static.ScaleTexture(shot, 512, 256, ScaleStretch);
    class'GraphicsManager'.static.SaveTextureJpeg(path$"\\ScreenShot.jpg", shot, JPG_QUALITY);

    gl.default.lastScreenShot = shot;
    //log(shot @ gl.default.lastScreenShot, 'ScreenShot');
}

/*-------------------------------------------------------------
  Replaces any occurences of HTML coded characters with their text representations
-------------------------------------------------------------*/
static function string HtmlStrip(string src)
{
    local int i;

  for (i=0; i<default.SpecialChars.Length; i++)
  {
    src = Repl(src, default.SpecialChars[i].Plain, default.SpecialChars[i].Coded);
  } 
  src = Repl(src, "<PLAYERNAME>", class'DeusExPlayer'.static.GetTruePlayerName());
  src = Repl(src, "<PLAYERFIRSTNAME>", class'DeusExPlayer'.static.GetPlayerFirstName());
    return src;
}

static function string HtmlStripB(string src)
{
  src = Repl(src, "<", "");
  src = Repl(src, ">", "");
    return src;
}

/*-------------------------------------------------------------
  VDiskRand2D()
  Random point on Disk in xy-plane.
  http://mathworld.wolfram.com/DiskPointPicking.html
  http://www.offtopicproductions.com/forum/viewtopic.php?f=36&t=12035&start=105
  Could be optimized.
-------------------------------------------------------------*/
final static function Vector VDiskRand2D(float DiskRadius)
{
   local float  Radius, Angle;
   local Vector Point;

   Radius = Sqrt(FRand())*DiskRadius;
   Angle  = FRand()*2.0*PI;

   Point.X = Radius*Cos(Angle);
   Point.Y = Radius*Sin(Angle);

   return Point;
}

/*-------------------------------------------------------------
  Converts a float value to a 0-255 byte, assuming a range of
  0.f to 1.f.
  
  inputFloat - float to convert
  bSigned - optional, assume a range of -1.f to 1.f
  returns byte value 0-255
-------------------------------------------------------------*/
static final function byte FloatToByte(float inputFloat, optional bool bSigned)
{
    if (bSigned)
    {
        // handle a 0.02f threshold so we can guarantee valid 0/255 values
        if (inputFloat > 0.98f)
        {
            return 255;
        }
        else
        if (inputFloat < -0.98f)
        {
            return 0;
        }
        else
        {
            return byte((inputFloat+1.f)*128.f);
        }
    }
    else
    {
        if (inputFloat > 0.98f)
        {
            return 255;
        }
        else
        if (inputFloat < 0.02f)
        {
            return 0;
        }
        else
        {
            return byte(inputFloat*255.f);
        }
    }
}

/*-------------------------------------------------------------
  Converts a 0-255 byte to a float value, to a range of 0.f
  to 1.f.

  inputByte - byte to convert
  bSigned - optional, spit out -1.f to 1.f instead
  returns newly converted value
-------------------------------------------------------------*/
static final function float ByteToFloat(byte inputByte, optional bool bSigned)
{
    if (bSigned)
    {
        return ((float(inputByte)/128.f)-1.f);
    }
    else
    {
        return (float(inputByte)/255.f);
    }
}


/*-------------------------------------------------------------
  Return file as array of bytes.
-------------------------------------------------------------*/
static function array<byte> GetFileAsArray(string path)
{
    local array<byte> bt;
    local int fileSize, handle;

//  log("Processing file: "$path);

    fileSize = class'FileManager'.static.FileSize(path);
      if (fileSize == -1)
      {
         log("ERROR: File Not found!");
         bt.length = 0;
         return bt;
      }
//  log("fileSize of "$path$" = "$fileSize);
    handle = class'FileManager'.static.FileOpen(path, false, false);
      if (handle == 0)
      {
         log("ERROR: Invalid handle!");
         bt.length = 0;
         return bt;
      }
  bt.length = fileSize;
  class'FileManager'.static.FileRead(handle, bt, 0, fileSize);
  class'FileManager'.static.FileClose(handle);

  return bt;
}

/*-------------------------------------------------------------
  Returns array of screen resolutions.
-------------------------------------------------------------*/
static function array<string> GetScreenResolutions(int bits)
{
    local array<GraphicsManager.Resolution> resl;
    local array<string> resolutions;
    local bool ret;
    local int i;

    ret = class'GraphicsManager'.static.GetResolutionList(resl, bits);

    if ((ret) && (resl.Length > 0))
    {
      resolutions.length = resl.length;

      for (i=0; i<resl.length; i++)
      {
      resolutions[i] = resl[i].Width $ "x" $ resl[i].Height;
        if (bDebug)
          log(resolutions[i]);
      }
      return resolutions;
    }
    else
    {
      resolutions.length = 0;
      resolutions[0]="800x600";

      return resolutions;
    }
}



defaultproperties
{
  SpecialChars(0)=(Plain="<P>",Coded=" ")
  SpecialChars(1)=(Plain="<JC>",Coded="")
  SpecialChars(2)=(Plain="<DC=255,255,255>",Coded="")
  SpecialChars(3)=(Plain="</B>",Coded="")
  SpecialChars(4)=(Plain="<B>",Coded="")
  SpecialChars(5)=(Plain="<COMMENT>",Coded="")
  SpecialChars(6)=(Plain="</COMMENT>",Coded="")
  SpecialChars(7)=(Plain="<FILE=",Coded="")
  SpecialChars(8)=(Plain="<EMAIL=",Coded="")

  January="January"
  February="February"
  March="March"
  April="April"
  May="May"
  June="June"
  July="July"
  August="August"
  September="September"
  October="October"
  November="November"
  December="December"

  Monday="Monday"
  Tuesday="Tuesday"
  Wednesday="Wednesday"
  Thursday="Thursday"
  Friday="Friday"
  Saturday="Saturday"
  Sunday="Sunday"
}
