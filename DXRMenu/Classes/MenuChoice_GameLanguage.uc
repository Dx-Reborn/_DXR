/*
  MenuChoice_GameLanguage
*/

class MenuChoice_GameLanguage extends DXREnumButton;
                                       

var String englishEnumText[4];
var int LangChoice;

function LoadSetting()
{
    local String Lang;
    local int enumIndex;

    Lang = class'GameManager'.static.GetGameLanguage();

    LangChoice = 0;

    for (enumIndex=0; enumIndex<arrayCount(enumText); enumIndex++)
    {
        if (EnglishEnumText[enumIndex] ~= Lang)
        {
            LangChoice = enumIndex;
            break;
        }   
    }
    SetValue(LangChoice);
    log(LangChoice);

}

function SaveSetting()
{
  local int val;

  val = GetValue();

    switch (val)
    {
      case 0:
           class'GameManager'.static.SetGameLanguage(englishEnumText[0]);
           class'GameManager'.static.SetGameIniString("Engine.Engine", "Language", englishEnumText[0]);

           log("Setting game language to: "$englishEnumText[0]);
      break;

      case 1:
           class'GameManager'.static.SetGameLanguage(englishEnumText[1]);
           class'GameManager'.static.SetGameIniString("Engine.Engine", "Language", englishEnumText[1]);

           log("Setting game language to: "$englishEnumText[1]);
      break;

      case 2:
           class'GameManager'.static.SetGameLanguage(englishEnumText[2]);
           class'GameManager'.static.SetGameIniString("Engine.Engine", "Language", englishEnumText[2]);

           log("Setting game language to: "$englishEnumText[2]);

      case 3:
           class'GameManager'.static.SetGameLanguage(englishEnumText[3]);
           class'GameManager'.static.SetGameIniString("Engine.Engine", "Language", englishEnumText[3]);

           log("Setting game language to: "$englishEnumText[3]);
      break;
    }

    SaveConfig();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    Hint="Changes the game language. You will need to restatr the game for changes to take effect"
    actionText="Game language"

    EnumText(0)="Russian"
    EnumText(1)="Default (int, usually English)"
    EnumText(2)="French/Français"
    EnumText(3)="German/Deutsche"

    englishEnumText(0)="rus"
    englishEnumText(1)="int"
    englishEnumText(2)="frt"
    englishEnumText(3)="det"
}





