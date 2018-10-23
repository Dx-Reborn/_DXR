/*  */
class DXRSaveListBox extends GUI2K4MultiColumnListBox;

var() editconst DXRSaveList aList; // ”казатель на список.

function InitBaseList(GUIListBase LocalList)
{
	if ((aList == None || aList != LocalList) && DXRSaveList(LocalList) != None)
		aList = DXRSaveList(LocalList); //GUIMultiColumnList(LocalList);

	if ( ColumnHeadings.Length > 0 )
		aList.ColumnHeadings = ColumnHeadings;

	Header.MyList = aList;
	Super.InitBaseList(LocalList);

}

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(MyController, MyOwner);

    if (DefaultListClass!="")
    {
    	aList = DXRSaveList(AddComponent(DefaultListClass)); //GUIMultiColumnList(AddComponent(DefaultListClass));
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
	DefaultListClass="DXRMenu.DXRSaveList"
}