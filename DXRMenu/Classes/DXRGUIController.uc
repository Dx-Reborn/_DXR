class DXRGUIController extends DeusExGUIController;


defaultproperties
{
    Begin Object Class=DxFonts.fntUT2k4Menu Name=GUIMenuFont
    End Object
    FontStack(0)=fntUT2k4Menu'GUIMenuFont'

    Begin Object Class=DxFonts.fntUT2k4Default Name=GUIDefaultFont
    End Object
    FontStack(1)=fntUT2k4Default'GUIDefaultFont'

    Begin Object Class=DxFonts.fntUT2k4Large Name=GUILargeFont
    End Object
    FontStack(2)=fntUT2k4Large'GUILargeFont'

    Begin Object Class=DxFonts.fntUT2k4Header Name=GUIHeaderFont
    End Object
    FontStack(3)=fntUT2k4Header'GUIHeaderFont'

    Begin Object Class=DxFonts.fntUT2k4Small Name=GUISmallFont
    End Object
    FontStack(4)=fntUT2k4Small'GUISmallFont'

    Begin Object Class=DxFonts.fntUT2k4MidGame Name=GUIMidGameFont
    End Object
    FontStack(5)=fntUT2k4MidGame'GUIMidGameFont'

    Begin Object Class=DxFonts.fntUT2k4SmallHeader Name=GUISmallHeaderFont
    End Object
    FontStack(6)=fntUT2k4SmallHeader'GUISmallHeaderFont'

    Begin Object Class=DxFonts.fntUT2k4ServerList Name=GUIServerListFont
    End Object
    FontStack(7)=fntUT2k4ServerList'GUIServerListFont'

    Begin Object Class=DxFonts.fntUT2k4IRC Name=GUIIRCFont
    End Object
    FontStack(8)=fntUT2K4IRC'GUIIRCFont'

    Begin Object Class=DxFonts.fntUT2K4MainMenu Name=GUIMainMenuFont
    End Object
    FontStack(9)=fntUT2K4MainMenu'GUIMainMenuFont'

    Begin Object Class=DxFonts.fntUT2K4Medium Name=GUIMediumMenuFont
    End Object
    FontStack(10)=GUIMediumMenuFont

    Begin Object Class=DxFonts.fntSpecial Name=GUISpecialFont
    End Object
    FontStack(11)=GUISpecialFont


    FONT_NUM=12
//	FONT_NUM=11

    MouseOverSound=sound'DeusExSounds.UserInterface.Menu_Focus'
    ClickSound		=sound'DeusExSounds.UserInterface.Menu_Press'
    EditSound			=none //sound'DeusExSounds.UserInterface.Menu_Slider'
    UpSound=none		//		=sound'DeusExSounds.UserInterface.'
    DownSound=none //			=sound'DeusExSounds.UserInterface.Menu_Activate'
		DragSound			=sound'DeusExSounds.UserInterface.Menu_Slider'
    FadeSound			=sound'DeusExSounds.UserInterface.Menu_OK'

    /* Все курсоры уменьшены примерно в три раза */
//  MouseCursors(0)=material'DeusExCursor.DeusExCursor_Main'          // Arrow
    MouseCursors(0)=TexScaler'DeusExCursor.DeusExCursor_main_0_5'          // Arrow
    MouseCursors(1)=TexScaler'DeusExCursor.ResizeAll_SC'       // SizeAll
    MouseCursors(2)=TexScaler'DeusExCursor.ResizeSWNE_SC'       // Size NE SW
    MouseCursors(3)=TexScaler'DeusExCursor.Resize_SC'   // Size NS
    MouseCursors(4)=TexScaler'DeusExCursor.ResizeNWSE_SC'       // Size NW SE
    MouseCursors(5)=TexScaler'DeusExCursor.ResizeHorz_SC'       // Size WE
//  MouseCursors(6)=TexScaler'DeusExCursor.Cursors.Pointer'          // Wait
    
//    MouseCursorOffset(0)=(X=0.5,Y=0.5,Z=0) // Смещение курсора

		DblClickWindow=0.5 // How long do you have for a double click//0.05
		                    // было 0.5. Пришлось уменьшить, иначе диалоги проматывались слишком быстро.
    bFixedMouseSize=true // Избавляет от проблемы с изменяющим размеры курсором :)

    ImageList(0)=Material'2K4Menus.Controls.checkboxball_b'
    ImageList(1)=Material'2K4Menus.NewControls.ComboListDropDown'
    ImageList(2)=Material'2K4Menus.Newcontrols.LeftMark'
    ImageList(3)=Material'2K4Menus.Newcontrols.RightMark'
    ImageList(4)=Material'2K4Menus.Controls.plus_b'
    ImageList(5)=Material'2K4Menus.Controls.minus_b'
    ImageList(6)=texture'pinkmasktex'//Material'2K4Menus.NewControls.UpMark'
    ImageList(7)=texture'pinkmasktex' //Material'2K4Menus.NewControls.DownMark'


    DefaultStyleNames(4)="DXRMenu.STY_DXR_ScrollZone"
    DefaultStyleNames(37)="DXRMenu.STY_DXR_MenuSlider"
    DefaultStyleNames(42)="DXRMenu.STY_DXR_Hint"
    //DefaultStyleNames(43)="DXRMenu.STY_DXR_SliderBar"
    DefaultStyleNames(51)="DXRMenu.STY_DXR_VertUpButton"
    DefaultStyleNames(52)="DXRMenu.STY_DXR_VertDownButton"
    DefaultStyleNames(53)="DXRMenu.STY_DXR_VertGrip"
    DefaultStyleNames(55)="DXRMenu.STY_DXR_SectionHeaderTop"
    DefaultStyleNames(56)="DXRMenu.STY_DXR_SectionHeaderBar"
    DefaultStyleNames(60)="DXRMenu.STY_DXR_DeusExSquareButton"
    DefaultStyleNames(61)="DXRMenu.STY_DXR_DeusExRectButton"
    DefaultStyleNames(62)="DXRMenu.STY_DXR_DeusExEditBox"
    DefaultStyleNames(63)="DXRMenu.STY_DXR_DeusExListBox"
    DefaultStyleNames(64)="DXRMenu.STY_DXR_DeusExScrollTextBox"
    DefaultStyleNames(65)="DXRMenu.STY_DXR_DeusExCheckBox"
    DefaultStyleNames(66)="DXRMenu.STY_DXR_DeusExHealButton"
    DefaultStyleNames(67)="DXRMenu.STY_DXR_DXSubTitles"
    DefaultStyleNames(68)="DXRMenu.STY_DXR_ConChoice"
    DefaultStyleNames(69)="DXRMenu.STY_DXR_ConLabel"
    DefaultStyleNames(70)="DXRMenu.STY_DXR_DXWinHeader"
//    DefaultStyleNames(71)="DXRMenu.STY_DXR_ScrollZone"
    DefaultStyleNames(71)="DXRMenu.STY_DXR_MediumButton"
    DefaultStyleNames(72)="DXRMenu.STY_DXR_ListBox"
    DefaultStyleNames(73)="DXRMenu.STY_DXR_ListSelection"
    DefaultStyleNames(74)="DXRMenu.STY_DXR_EditBox"
    DefaultStyleNames(75)="DXRMenu.STY_DXR_ArrowButton_Right"
    DefaultStyleNames(76)="DXRMenu.STY_DXR_ArrowButton_Left"
    DefaultStyleNames(77)="DXRMenu.STY_DXR_EditBox_NoBG"
    DefaultStyleNames(78)="DXRMenu.STY_DXR_Navbar"
    DefaultStyleNames(79)="DXRMenu.STY_DXR_ButtonNavbar"
    DefaultStyleNames(80)="DXRMenu.STY_DXR_MenuCheckBox"
    DefaultStyleNames(81)="DXRMenu.STY_DXR_ImgBorder"
    DefaultStyleNames(82)="DXRMenu.STY_DXR_AugBorder"
    DefaultStyleNames(83)="DXRMenu.STY_DXR_DeusExScrollTextBox_ex"
    STYLE_NUM=84
}