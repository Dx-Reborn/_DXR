/* —писок навыков */
class DXRSkillsListBox extends GUI2K4MultiColumnListBox;

var() editconst DXRSkillsList aList; // ”казатель на список.

function InitBaseList(GUIListBase LocalList)
{
	if ((aList == None || aList != LocalList) && DXRSkillsList(LocalList) != None)
		aList = DXRSkillsList(LocalList); 

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
    	aList = DXRSkillsList(AddComponent(DefaultListClass));
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
	DefaultListClass="DXRMenu.DXRSkillsList"
}