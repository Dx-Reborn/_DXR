//
// 
//

class MouseHUD extends DeusExBasicHUD;

// --== Адаптация DamageHUDDisplay.uc ==--
struct sIconInfo
{
	var class<DamageType>	damageType[3];
	var Texture	icon;
	var bool	bActive;
	var float	initTime;
	var float	hitDir;
	var bool	bHitCenter;
	var Color	color;
};

var int iconWidth, iconHeight, iconMargin;
var int arrowiconWidth, arrowiconHeight;
var float fadeTime;
var float absorptionPercent;
var sIconInfo iconInfo[7];

var localized String msgAbsorbed;

function SetData()
{
	// couldn't get these to work in the defaultproperties section
	// Тогда я тоже так оставлю.
	iconInfo[0].damageType[0] = class'DM_Shocked';
	iconInfo[0].icon = Texture'DamageIconElectricity';
	iconInfo[0].color.R = 0;
	iconInfo[0].color.G = 196;
	iconInfo[0].color.B = 255;
	iconInfo[1].damageType[0] = class'DM_EMP';
	iconInfo[1].icon = Texture'DamageIconEMP';
	iconInfo[1].color.R = 0;
	iconInfo[1].color.G = 196;
	iconInfo[1].color.B = 255;
	iconInfo[2].damageType[0] = class'DM_Burned';
	iconInfo[2].damageType[1] = class'DM_Flamed';
	iconInfo[2].damageType[2] = class'DM_Exploded';
	iconInfo[2].icon = Texture'DamageIconFire';
	iconInfo[2].color.R = 255;
	iconInfo[2].color.G = 96;
	iconInfo[2].color.B = 0;
	iconInfo[3].damageType[0] = class'DM_PoisonGas';
	iconInfo[3].damageType[1] = class'DM_TearGas';
	iconInfo[3].icon = Texture'DamageIconGas';
	iconInfo[3].color.R = 0;
	iconInfo[3].color.G = 196;
	iconInfo[3].color.B = 0;
	iconInfo[4].damageType[0] = class'DM_Drowned';
	iconInfo[4].damageType[1] = class'DM_HalonGas';
	iconInfo[4].icon = Texture'DamageIconOxygen';
	iconInfo[4].color.R = 0;
	iconInfo[4].color.G = 128;
	iconInfo[4].color.B = 255;
	iconInfo[5].damageType[0] = class'DM_Radiation';
	iconInfo[5].icon = Texture'DamageIconRadiation';
	iconInfo[5].color.R = 255;
	iconInfo[5].color.G = 255;
	iconInfo[5].color.B = 0;
	iconInfo[6].damageType[0] = class'DM_Shot';
	iconInfo[6].damageType[1] = class'DM_Sabot';
	iconInfo[6].icon = None;
	iconInfo[6].color.R = 255;
	iconInfo[6].color.G = 0;
	iconInfo[6].color.B = 0;
}


function AddDamageIcon(class <damageType> damageType, vector hitOffset)
{
	local int i, j;

	if (damageType != none)
	{
		setData();
		// save the icon info and startup time
		for (i=0; i<ArrayCount(iconInfo); i++)
		{
			for (j=0; j<ArrayCount(iconInfo[i].damageType); j++)
			{
				if (damageType == iconInfo[i].damageType[j])
				{
					iconInfo[i].bActive = True;
					iconInfo[i].initTime = playerowner.pawn.Level.TimeSeconds;
					iconInfo[i].hitDir = Rotator(hitOffset).Yaw;

					// check for special case non-locational damage
					if (hitOffset == vect(0,0,0))
						iconInfo[i].bHitCenter = True;

					// range it from 0 to 65535
					if (iconInfo[i].hitDir < 0)
						iconInfo[i].hitDir += 65536;

//					Show();
					break;
				}
			}
		}
	}
}

function SetPercent(float percent)
{
	absorptionPercent = percent;
}

function DrawDamageHUD(Canvas c)
{
	local int i;
	local float timestamp, alpha, maxalpha;
	local bool bVisible;
	local bool bCenter, bFront, bRear, bLeft, bRight;
	local color col;
	local string strInfo;
	local float strW, strH, strX, strY;

	bVisible = False;
	timestamp = playerowner.pawn.Level.TimeSeconds;

	c.Style=ERenderStyle.STY_Translucent;
	maxalpha = 0;

	// go through all the icons and draw them
	for (i=0; i<ArrayCount(iconInfo); i++)
	{
		if (iconInfo[i].bActive)
		{
			alpha = 1.0 - ((timestamp - iconInfo[i].initTime) / fadeTime);

			if (alpha > maxalpha)
				maxalpha = alpha;

			// if it's faded completely out, delete it
			if (alpha <= 0)
			{
				iconInfo[i].bActive = False;
				iconInfo[i].initTime = 0;
				iconInfo[i].hitDir = 0;
				iconInfo[i].bHitCenter = False;
			}
			else
			{
				// fade the color to black
				col = iconInfo[i].color;
				col.R = int(float(col.R) * alpha);
				col.G = int(float(col.G) * alpha);
				col.B = int(float(col.B) * alpha);
				c.DrawColor = col;

				// draw the icon
				if (iconInfo[i].icon != None)
				{
					//c.SetPos((c.SizeX-iconWidth)/2, i*(iconHeight+iconMargin));
          c.SetPos(11,155); // Сразу под компасом
					c.DrawIcon(iconInfo[i].icon,1);
//					c.DrawTexture((width-iconWidth)/2, i*(iconHeight+iconMargin), iconWidth, iconHeight, 0, 0, iconInfo[i].icon);
				}
				bVisible = True;

				// figure out what side we're hit on
				if (iconInfo[i].bHitCenter)
					bCenter = True;
				else
				{
					if ((iconInfo[i].hitDir > 53248) || (iconInfo[i].hitDir < 12288))
						bFront = True;
					if ((iconInfo[i].hitDir > 20480) && (iconInfo[i].hitDir < 45056))
						bRear = True;
					if ((iconInfo[i].hitDir > 4096) && (iconInfo[i].hitDir < 28672))
						bRight = True;
					if ((iconInfo[i].hitDir > 36864) && (iconInfo[i].hitDir < 61440))
						bLeft = True;
				}
			}
		}
	}

	// draw the location arrows
	col = iconInfo[ArrayCount(iconInfo)-1].color;
	col.R = int(float(col.R) * maxalpha);
	col.G = int(float(col.G) * maxalpha);
	col.B = int(float(col.B) * maxalpha);
	c.DrawColor = col;

//native(1284) final function DrawTexture(float destX, float destY,
	if (bFront)
		{
		c.setPos(iconMargin, ArrayCount(iconInfo)*(iconHeight+iconMargin));
		c.DrawIcon(Texture'DamageIconUp',1);
//		c.DrawTexture(iconMargin, ArrayCount(iconInfo)*(iconHeight+iconMargin), arrowiconWidth, arrowiconHeight, 0, 0, Texture'DamageIconUp');
		}
	if (bRear)
		{
		c.setPos(iconMargin, ArrayCount(iconInfo)*(iconHeight+iconMargin));
		c.DrawIcon(Texture'DamageIconDown',1);
//		c.DrawTexture(iconMargin, ArrayCount(iconInfo)*(iconHeight+iconMargin), arrowiconWidth, arrowiconHeight, 0, 0, Texture'DamageIconDown');
		}
	if (bLeft)
		{
		c.setPos(iconMargin, ArrayCount(iconInfo)*(iconHeight+iconMargin));
		c.DrawIcon(Texture'DamageIconLeft',1);
//		c.DrawTexture(iconMargin, ArrayCount(iconInfo)*(iconHeight+iconMargin), arrowiconWidth, arrowiconHeight, 0, 0, Texture'DamageIconLeft');
		}
	if (bRight)
		{
		c.setPos(iconMargin, ArrayCount(iconInfo)*(iconHeight+iconMargin));
		c.DrawIcon(Texture'DamageIconRight',1);
//		c.DrawTexture(iconMargin, ArrayCount(iconInfo)*(iconHeight+iconMargin), arrowiconWidth, arrowiconHeight, 0, 0, Texture'DamageIconRight');
		}
	if (bCenter)
		{
		c.setPos(iconMargin, ArrayCount(iconInfo)*(iconHeight+iconMargin));
		c.DrawIcon(Texture'DamageIconCenter',1);
//		c.DrawTexture(iconMargin, ArrayCount(iconInfo)*(iconHeight+iconMargin), arrowiconWidth, arrowiconHeight, 0, 0, Texture'DamageIconCenter');
		}

	// draw the damage absorption percent
	if (absorptionPercent != 0.0)
	{
		col.R = 0;
		col.G = int(255.0 * maxalpha);
		col.B = 0;
//		gc.EnableTranslucentText(True);
		c.DrawColor=col;
		c.Font=Font'FontMenuHeaders_DS';
		strInfo = Sprintf(msgAbsorbed, Int(absorptionPercent * 100.0));

    c.StrLen(strInfo, strW, strH);
//		gc.GetTextExtent(0, strW, strH, strInfo);

		strX = (c.SizeX - strW) / 2;
		strY = c.SizeY - (arrowIconHeight + strH) / 2;
		c.SetPos(strX, strY);
		c.DrawText(strInfo);
//		gc.DrawText(strX, strY, strW, strH, strInfo);
	}

	if (!bVisible)
	{
		bFront = False;
		bRear = False;
		bLeft = False;
		bRight = False;
		absorptionPercent = 0.0;
	}
c.SetClip(c.sizeX, c.sizeY);
c.Reset();
}




simulated event PostRender(Canvas C)
{
   Super.PostRender(C);

	 DrawDamageHUD(C);
}


defaultproperties
{
    IconWidth=24
    IconHeight=24
    iconMargin=2
    arrowiconWidth=64
    arrowiconHeight=64
    fadeTime=2.00
    msgAbsorbed="%d%% Absorb"
}
