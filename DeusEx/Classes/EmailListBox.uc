/**/
class EmailListBox extends GUI2K4MultiColumnListBox;

var() editconst EmailList aList; // Указатель на список.

function InitBaseList(GUIListBase LocalList)
{
	if ((aList == None || aList != LocalList) && EmailList(LocalList) != None)
		aList = EmailList(LocalList);

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
    	aList = EmailList(AddComponent(DefaultListClass)); //GUIMultiColumnList(AddComponent(DefaultListClass));
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
	DefaultListClass="DeusEx.EmailList"
	bBoundToParent=true
}