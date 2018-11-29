/*  */
class DXRConListBox extends GUI2K4MultiColumnListBox;

var() editconst DXRConList aList; // ”казатель на список.

function InitBaseList(GUIListBase LocalList)
{
	if ((aList == None || aList != LocalList) && DXRConList(LocalList) != None)
		aList = DXRConList(LocalList);

	if (ColumnHeadings.Length > 0)
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
    	aList = DXRConList(AddComponent(DefaultListClass));
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
	DefaultListClass="DXRMenu.DXRConList"
}