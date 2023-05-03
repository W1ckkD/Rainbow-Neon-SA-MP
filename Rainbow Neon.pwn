/*  
	RAINBOW NEONS
    WICKED GAMING
   
   Ikaw na bahala mag pagana 
*/

//Di na to updated, just an old script, so you better do the rest
//VehicleInfo variables
vRNeon,
vRNeonEnabled

//BTW, add the 2 columns sa sql mo for rneon at rneonenabled

//Global Variable
new SetRNeonsColorTimer[MAX_VEHICLES];
new vRainbowNeons[MAX_VEHICLES][2] = {INVALID_OBJECT_ID, ...};

//RainbowNeon
SetVehicleRainbowNeons(vehicleid, modelid)
{
	if(VehicleInfo[vehicleid][vID] > 0)
	{
		if(18647 <= modelid <= 18652)
		{
		    DestroyDynamicObject(vRainbowNeons[vehicleid][0]);
		    DestroyDynamicObject(vRainbowNeons[vehicleid][1]);
			
			if(VehicleInfo[vehicleid][vRNeon] && VehicleInfo[vehicleid][vRNeonEnabled])
		    {
		        new
					Float:x,
					Float:y,
					Float:z;
	
				GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, x, y, z);
	
				vRainbowNeons[vehicleid][0] = CreateDynamicObject(modelid, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
				vRainbowNeons[vehicleid][1] = CreateDynamicObject(modelid, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
	
				AttachDynamicObjectToVehicle(vRainbowNeons[vehicleid][0], vehicleid, -x / 2.8, 0.0, -0.6, 0.0, 0.0, 0.0);
				AttachDynamicObjectToVehicle(vRainbowNeons[vehicleid][1], vehicleid, x / 2.8, 0.0, -0.6, 0.0, 0.0, 0.0);
			}
		}
	}
}

	if(VehicleInfo[vehicleid][vRNeon] && VehicleInfo[vehicleid][vRNeonEnabled])
	{
		SetRNeonsColorTimer[vehicleid] = SetTimerEx("SetRNeonsColor", 100, false, "ii", vehicleid, 0);
    }
	
	
	VehicleInfo[vehicleid][vRNeon] = cache_get_field_content_int(0, "rneon");
	VehicleInfo[vehicleid][vRNeonEnabled] = cache_get_field_content_int(0, "rneonenabled");
	

			if(VehicleInfo[vehicleid][vRNeon])
	        {
				if(!VehicleInfo[vehicleid][vRNeonEnabled]) VehicleInfo[vehicleid][vRNeonEnabled] = 1;
				else VehicleInfo[vehicleid][vRNeonEnabled] = 0;
				
				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET rneonenabled = %i WHERE id = %i", VehicleInfo[vehicleid][vRNeonEnabled], VehicleInfo[vehicleid][vID]);
				mysql_tquery(connectionID, queryBuffer);
			
				SetRNeonsColorTimer[vehicleid] = SetTimerEx("SetRNeonsColor", 1000, false, "ii", vehicleid, 0);
			}
			

				else if(!strcmp(param, "rainbow", true))
				{
					if(VehicleInfo[vehicleid][vNeon]) return SCM(playerid, COLOR_SYNTAX, "Remove the neon that's already installed to set this feature");
					if(VehicleInfo[vehicleid][vNeonEnabled]) return 1;
					if(VehicleInfo[vehicleid][vRNeon]) return SCM(playerid, COLOR_SYNTAX, "This vehicle has rainbow neon already.");
					
					VehicleInfo[vehicleid][vRNeon] = 1;
					VehicleInfo[vehicleid][vRNeonEnabled] = 0;
					
					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET rneon = 1, rneonenabled = 0 WHERE id = %i", VehicleInfo[vehicleid][vID]);
					mysql_tquery(connectionID, queryBuffer);
					
					GivePlayerCash(playerid, -50000);
					GameTextForPlayer(playerid, "~r~-$50000", 50000, 1);
					
					SCM(playerid, COLOR_YELLOW, "You have paid $50000 for rainbow neon. You can use /rneon to toggle your rainbow neon.");
				}

forward SetRNeonsColor(vehicleid, time);
public SetRNeonsColor(vehicleid, time)
{
	if(VehicleInfo[vehicleid][vRNeonEnabled])
	{
		switch(time)
		{
			case 0: {
			   SetVehicleRainbowNeons(vehicleid, 18652);
				SetRNeonsColorTimer[vehicleid] = SetTimerEx("SetRNeonsColor", 1000, false, "ii", vehicleid, 1);
			}
			case 1: {
		 		  SetVehicleRainbowNeons(vehicleid, 18651);
				SetRNeonsColorTimer[vehicleid] = SetTimerEx("SetRNeonsColor", 1000, false, "ii", vehicleid, 2);
			}
			case 2: {
		   	SetVehicleRainbowNeons(vehicleid, 18650);
				SetRNeonsColorTimer[vehicleid] = SetTimerEx("SetRNeonsColor", 1000, false, "ii", vehicleid, 3);
			}
			case 3: {
			    SetVehicleRainbowNeons(vehicleid, 18649);
				SetRNeonsColorTimer[vehicleid] = SetTimerEx("SetRNeonsColor", 1000, false, "ii", vehicleid, 4);
			}
			case 4: {
		   		SetVehicleRainbowNeons(vehicleid, 18648);
				SetRNeonsColorTimer[vehicleid] = SetTimerEx("SetRNeonsColor", 1000, false, "ii", vehicleid, 5);
			}
			case 5: {
			    SetVehicleRainbowNeons(vehicleid, 18647);
				SetRNeonsColorTimer[vehicleid] = SetTimerEx("SetRNeonsColor", 1000, false, "ii", vehicleid, 0);
			}
		}
	}
}
CMD:rneon(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
	if((FactionInfo[PlayerInfo[playerid][pFaction]][fType] != FACTION_MECHANIC))
		return SCM(playerid, COLOR_SYNTAX, "You must be a mechanic to use this command.");
	if(PlayerInfo[playerid][pDuty] == 0) return SCM(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	if(!vehicleid) return SCM(playerid, COLOR_SYNTAX, "You are not inside of any vehicle.");
	if(VehicleInfo[vehicleid][vRNeon] != 1) return SCM(playerid, COLOR_SYNTAX, "This vehicle has no rainbow neon installed.");
	if(!VehicleInfo[vehicleid][vRNeonEnabled])
	{
	    VehicleInfo[vehicleid][vRNeonEnabled] = 1;
		KillTimer(SetRNeonsColorTimer[vehicleid]); //i might've forgot somewhere where this needs to be, just do it lol prox ka naman
	    GameTextForPlayer(playerid, "~g~RainbowNeon activated", 3000, 3);
	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s presses a button to activate their rainbow neon tubes.", GetRPName(playerid));
	}
	else
	{
	    VehicleInfo[vehicleid][vRNeonEnabled] = 0;
	    GameTextForPlayer(playerid, "~r~RainbowNeon deactivated", 3000, 3);
	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s presses a button to deactivate their rainbow neon tubes.", GetRPName(playerid));
	}
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET rneonenabled = %i WHERE id = %i", VehicleInfo[vehicleid][vRNeonEnabled], VehicleInfo[vehicleid][vID]);
	mysql_tquery(connectionID, queryBuffer);
	SetRNeonsColorTimer[vehicleid] = SetTimerEx("SetRNeonsColor", 100, false, "ii", vehicleid, 0);
	return 1;
}
			