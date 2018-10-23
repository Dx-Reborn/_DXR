/* */

class DXRTabControl extends GUITabControl;

var() editconst string TabStyle;

/* Функция изменена, чтобы можно было добавить свой стиль оформления :D */
function GUITabPanel AddTab(string InCaption, string PanelClass, optional GUITabPanel ExistingPanel, optional string InHint, optional bool bForceActive)
{
    local class<GUITabPanel> NewPanelClass;

    local GUITabButton NewTabButton;
    local GUITabPanel  NewTabPanel;

    local int i;

    // Make sure this doesn't exist first
    for (i=0;i<TabStack.Length;i++)
    {
        if (TabStack[i].Caption ~= InCaption)
        {
            log("A tab with the caption"@InCaption@"already exists.");
            return none;
        }
    }

    if (ExistingPanel==None)
        NewPanelClass = class<GUITabPanel>(Controller.AddComponentClass(PanelClass));

    if ( (ExistingPanel!=None) || (NewPanelClass != None) )
    {
        if (ExistingPanel != None)
            NewTabPanel = GUITabPanel(AppendComponent(ExistingPanel,True));
        else if (NewPanelClass != None)
            NewTabPanel = GUITabPanel(AddComponent(PanelClass,True));

        if (NewTabPanel == None)
        {
            log("Could not create panel for"@NewPanelClass);
            return None;
        }

        if (NewTabPanel.MyButton != None)
            NewTabButton = NewTabPanel.MyButton;
        else
        {
            NewTabButton = new(none) class'GUITabButton';
            NewTabButton.bAutoShrink=false; //
            NewTabButton.StyleName = TABStyle; // Добавлено
            NewTabButton.FontScale = FNS_Small; // ...
            if (NewTabButton==None)
            {
                log("Could not create tab for"@NewPanelClass);
                return None;
            }

            NewTabButton.InitComponent(Controller, Self);
            NewTabButton.Opened(Self);
            NewTabPanel.MyButton = NewTabButton;
            if (!bDrawTabAbove)
            {
                NewTabPanel.MyButton.bBoundToParent = False;
                NewTabPanel.MyButton.Style = Controller.GetStyle("FlippedTabButton",NewTabPanel.FontScale);//
            }
        }

        NewTabPanel.MyButton.Hint           = Eval(InHint != "", InHint, NewTabPanel.Hint);
        NewTabPanel.MyButton.Caption        = Eval(InCaption != "", InCaption, NewTabPanel.PanelCaption);
        NewTabPanel.MyButton.OnClick        = InternalTabClick;
        NewTabPanel.MyButton.MyPanel        = NewTabPanel;
        NewTabPanel.MyButton.FocusInstead   = self;
        NewTabPanel.MyButton.bNeverFocus    = true;

        NewTabPanel.InitPanel();

        // Add the tab to controls
        TabStack[TabStack.Length] = NewTabPanel.MyButton;
        if ( (TabStack.Length==1 && bVisible) || (bForceActive) )
            ActivateTab(NewTabPanel.MyButton,true);
        else NewTabPanel.Hide();

        return NewTabPanel;

    }

    return none;
}

defaultproperties
{
//   bDockPanels=false
   TabStyle="STY_DXR_ButtonNavbar"//"STY_DXR_MediumButton"
   TabHeight=21
}

