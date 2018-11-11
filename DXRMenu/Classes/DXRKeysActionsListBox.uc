/*  */
class DXRKeysActionsListBox extends GUI2K4MultiColumnListBox;

var() editconst DXR_ka_List aList; // ”казатель на список.

function InitBaseList(GUIListBase LocalList)
{
	if ((aList == None || aList != LocalList) && DXR_ka_List(LocalList) != None)
		aList = DXR_ka_List(LocalList);

	if ( ColumnHeadings.Length > 0 )
		aList.ColumnHeadings = ColumnHeadings;

	Header.MyList = aList;
	Super.InitBaseList(LocalList);

	      log(Controls[0]);
	      controls[0].WinWidth = 16;

}

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(MyController, MyOwner);

    if (DefaultListClass!="")
    {
    	aList = DXR_ka_List(AddComponent(DefaultListClass));
        if (aList==None)
        {
        	log(Class$".InitComponent - Could not create default list ["$DefaultListClass$"]");
            return;
        }
    }

	if (aList == None)
	{
		Warn("Could not initialize list!");
		return;
	}

    InitBaseList(aList);

	if (bFullHeightStyle)
		aList.Style=None;
}


defaultproperties
{
	DefaultListClass="DXRMenu.DXR_ka_List"
}