Include.File( "Mission" )
Include.File( "Client" )
Include.File( "DeployTask" )
Include.File( "PickupTask" )
Include.File( "SlingLoadHookTask" )
Include.File( "SlingLoadUnHookTask" )
Include.File( "DestroyGroupsTask" )
Include.File( "DestroyRadarsTask" )
Include.File( "DestroyUnitTypesTask" )
Include.File( "GoHomeTask" )
Include.File( "Spawn" )
Include.File( "Movement" )
Include.File( "Sead" )
Include.File( "CleanUp" )


--- NATO

do -- USA destroy air defenses

	local Mission = MISSION:New( 'Destroy SA-10', 'Primary', 'Destroy the enemy SA-10 batteries at Anapa airport. Once the SA-10 batteries are out, USA infantry forces can progress to Anapa from the north, and the airbase can be finally captured', 'NATO'  )

	Mission:AddClient( CLIENT:New( 'TF1 US A-10C@AIR Destroy SA-10 1' ) )
	Mission:AddClient( CLIENT:New( 'TF1 US A-10C@AIR Destroy SA-10 2' ) )
	Mission:AddClient( CLIENT:New( 'TF1 US A-10C@HOT Destroy SA-10 3' ) )
	Mission:AddClient( CLIENT:New( 'TF1 US A-10C@HOT Destroy SA-10 4' ) )
	Mission:AddClient( CLIENT:New( 'TF1 US A-10C@RAMP Destroy SA-10 5' ) )
	Mission:AddClient( CLIENT:New( 'TF1 US A-10C@RAMP Destroy SA-10 6' ) )
	Mission:AddClient( CLIENT:New( 'TF1 BE KA-50@HOT Destroy SA-10 1' ) )
	Mission:AddClient( CLIENT:New( 'TF1 BE KA-50@HOT Destroy SA-10 2' ) )
	Mission:AddClient( CLIENT:New( 'TF1 BE KA-50@RAMP Destroy SA-10 3' ) )
	Mission:AddClient( CLIENT:New( 'TF1 BE KA-50@RAMP Destroy SA-10 4' ) )

	local DestroyGroupsTask = DESTROYRADARSTASK:New( { 'Russia SA-10 Battery Array' } ) 
	DestroyGroupsTask:SetGoalTotal( 2 )
	Mission:AddTask( DestroyGroupsTask, 1 )

	MISSIONSCHEDULER.AddMission( Mission )

end



do -- USA destroy Su-34 ship attack forces

	local Mission = MISSION:New( 'Destroy Su-34 Ship Attack', 'Secondary', 'Su-34 planes are approaching from the east. They pose an enormous threat to our fleet. Destroy them before they engage anti-radar weapons to destroy our carrier and ships!', 'NATO'  )

	Mission:AddClient( CLIENT:New( 'TF2 US F-15C@HOT Destroy SU-34 1' ) )
	Mission:AddClient( CLIENT:New( 'TF2 US F-15C@HOT Destroy SU-34 2' ) )
	Mission:AddClient( CLIENT:New( 'TF2 US F-15C@HOT Destroy SU-34 3' ) )
	Mission:AddClient( CLIENT:New( 'TF2 US F-15C@HOT Destroy SU-34 4' ) )
	Mission:AddClient( CLIENT:New( 'TF2 US F-15C@AIR Destroy SU-34 5' ) )
	Mission:AddClient( CLIENT:New( 'TF2 US F-15C@AIR Destroy SU-34 6' ) )

	local DestroyGroupsTask = DESTROYGROUPSTASK:New( 'anti ship air defenses', 'Su-34 squadrons', { 
		'TF1 RU Su-34 Krymsk@AI - Attack Ships' } 
	)

	DestroyGroupsTask:SetGoalTotal( 5 )
	Mission:AddTask( DestroyGroupsTask, 1 )
	
	MISSIONSCHEDULER.AddMission( Mission )

end

do -- NATO destroy SA-6 / SA-11 DEFENSES TO ANAPA
	local Mission = MISSION:New( 'Destroy SAMs', 'Operational', 'Destroy the Russian mobile SAM sites between Gudauata and Anapa. Their elimination will ease our F-15C, A-10A and A-10C airstrikes and air attack from Gudauata.', 'NATO'  )

	Mission:AddClient( CLIENT:New( 'TF3 US A-10A@HOT Destroy SA-6/11 1' ) )
	Mission:AddClient( CLIENT:New( 'TF3 US A-10A@HOT Destroy SA-6/11 2' ) )
	Mission:AddClient( CLIENT:New( 'TF3 US A-10A@RAMP Destroy SA-6/11 3' ) )
	Mission:AddClient( CLIENT:New( 'TF3 US A-10A@RAMP Destroy SA-6/11 4' ) )
	Mission:AddClient( CLIENT:New( 'TF3 US A-10C@HOT Destroy SA-6/11 1' ) )
	Mission:AddClient( CLIENT:New( 'TF3 US A-10C@HOT Destroy SA-6/11 2' ) )
	Mission:AddClient( CLIENT:New( 'TF3 US A-10C@RAMP Destroy SA-6/11 3' ) )
	Mission:AddClient( CLIENT:New( 'TF3 US A-10C@RAMP Destroy SA-6/11 4' ) )
	Mission:AddClient( CLIENT:New( 'TF3 GE SU-25T@HOT Destroy SA-6/11 1' ) )
	Mission:AddClient( CLIENT:New( 'TF3 GE SU-25T@HOT Destroy SA-6/11 2' ) )
	Mission:AddClient( CLIENT:New( 'TF3 GE SU-25T@RAMP Destroy SA-6/11 3' ) )
	Mission:AddClient( CLIENT:New( 'TF3 GE SU-25T@RAMP Destroy SA-6/11 4' ) )
	Mission:AddClient( CLIENT:New( 'TF3 GE SU-25T@AIR Destroy SA-6/11 5' ) )
	Mission:AddClient( CLIENT:New( 'TF3 GE SU-25T@AIR Destroy SA-6/11 6' ) )

	local DestroyGroupRadarsTask = DESTROYUNITTYPESTASK:New( 'SAM sites', 'Kub 1S91 and Buk SR 9S18M1 search radars', { 'RU SA-6 - Middle Defenses', 'RU SA-11 - South Defenses' }, { 'Kub 1S91 str', 'SA-11 Buk SR 9S18M1' } )
	
	DestroyGroupRadarsTask:SetGoalTotal( 18 )
	Mission:AddTask( DestroyGroupRadarsTask, 1 )
	
	MISSIONSCHEDULER.AddMission( Mission )
	
end

do -- USA Deploy troops to battle zone

DefenseActivation = { 
	{ "Georgian SA-3 Defense System", false },
	{ "Georgian Early Warning Radar (EWR) Callsign Warrior", false },
	{ "Georgian SA-11 Defense System", false }
}

	function ActivateDefenses( Mission, Client )

		-- Check if the cargo is all deployed for mission success.
		for CargoID, CargoData in pairs( Mission._Cargos ) do
			if Group.getByName( CargoData.CargoGroupName ) then
				local CargoGroup = Group.getByName( CargoData.CargoGroupName )
				if CargoGroup then
					-- Check if the cargo is ready to activate the nearby units.
					CurrentLandingZoneID = _TransportValidateUnitInZone( CargoGroup:getUnits()[1], Mission:GetTask( 2 ).LandingZones ) -- The second task is the Deploytask to measure mission success upon
					if CurrentLandingZoneID then
						env.info( "CurrentLandingZoneID = " .. CurrentLandingZoneID )
						if DefenseActivation[CurrentLandingZoneID][2] == false then
							trigger.action.setGroupAIOn( Group.getByName( DefenseActivation[CurrentLandingZoneID][1] ) )
							DefenseActivation[CurrentLandingZoneID][2] = true
							MessageToBlue( "Mission Command: Message to all airborne units! The " .. DefenseActivation[CurrentLandingZoneID][1] .. " is armed. Our air defenses are now stronger.", 60, "BLUE/Defense" )
							MessageToRed( "Mission Command: Our satellite systems are detecting additional NATO air defenses. To all airborne units: Take care!!!", 60, "RED/Defense" )
						end
					end
				end
			end
		end
	end
	
	local Mission = MISSION:New( 'Activate Air Defenses', 'Operational', 'Transport troops from the "Gamma" control center to the battle zone.', 'NATO' )
	Mission:AddGoalFunction( ActivateDefenses )
	
	local Client
	
	Client = CLIENT:New( 'TF4 BE UH-1H@HOT Deploy Infantry 1' )
	Client:Transport()
	Mission:AddClient( Client )

	Client = CLIENT:New( 'TF4 BE UH-1H@HOT Deploy Infantry 2' )
	Client:Transport()
	Mission:AddClient( Client )

	Client = CLIENT:New( 'TF4 BE UH-1H@RAMP Deploy Infantry 3' )
	Client:Transport()
	Mission:AddClient( Client )

	Client = CLIENT:New( 'TF4 BE UH-1H@RAMP Deploy Infantry 4' )
	Client:Transport()
	Mission:AddClient( Client )

	local EngineerNames = { "Charlie", "Fred", "Sven", "Prosper", "Godfried", "Adam", "Freddy", "Saskia", "Karolina", "Levente", "Urbanus", "Helena", "Teodora", "Timea", "John", "Ibrahim", "Christine", "Carl", "Monika" }

	local CargoTable = {}
	for CargoItem = 1, 8 do
		Mission:AddCargo( "Team " .. CargoItem .. ": " .. EngineerNames[math.random(1, #EngineerNames)] .. ' and ' .. EngineerNames[math.random(1, #EngineerNames)], CARGO_TYPE.ENGINEERS, math.random( 70, 120 ) * 2, 'US Troop Barracks Gamma', 'US Invasion Infantry', 'US Troops Gamma' )
	end

	-- Assign the Pickup Task
	local PickupTask = PICKUPTASK:New( 'USA Troops Gamma pickup zone', CARGO_TYPE.ENGINEERS, CLIENT.ONBOARDSIDE.RIGHT )
	PickupTask:AddSmokeRed( 'US Troop Barracks Gamma' )
	Mission:AddTask( PickupTask, 1 )

	local DeployZones = { "US Deployment Zone Alpha", "US Deployment Zone Beta", "US Deployment Zone Gamma" }
	local DeployZonesSmokeUnits = { "US Deployment Zone Alpha Transport", "US Deployment Zone Beta Transport", "US Deployment Zone Gamma Transport" }	
	-- Assign the Deploy Task
	local DeployTask = DEPLOYTASK:New( DeployZones, CARGO_TYPE.ENGINEERS )
	DeployTask:AddSmokeRed( DeployZonesSmokeUnits )
	DeployTask:SetGoalTotal( 3 )
	Mission:AddTask( DeployTask, 2 )
	
	MISSIONSCHEDULER.AddMission( Mission )
	
end


--- CCCP

do


end

do -- Russia destroy northern USA ship
	local Mission = MISSION:New( 'Destroy Ships', 'Primary', 'A large infantry invasion is progressing to Anapa from the North. USA infantry is being deployed by USA Navy helicopters unloading the ships. Destroy the ships further to the North. Beware of mobile SAMs and the ship defenses. Fly low and slow!', 'Russia'  )

	Mission:AddClient( CLIENT:New( 'TF1 RU SU-25T@HOT Northern Ships 1' ) )
	Mission:AddClient( CLIENT:New( 'TF1 RU SU-25T@HOT Northern Ships 2' ) )
	Mission:AddClient( CLIENT:New( 'TF1 RU SU-25T@RAMP Northern Ships 3' ) )
	Mission:AddClient( CLIENT:New( 'TF1 RU SU-25T@RAMP Northern Ships 4' ) )

	local DestroyGroupsTask = DESTROYGROUPSTASK:New( 'infantry deploying ships', 'destroyers', { 'US Ship North' } )
	DestroyGroupsTask:SetGoalTotal( 3 )
	Mission:AddTask( DestroyGroupsTask, 1 )
	
	MISSIONSCHEDULER.AddMission( Mission )
	
end

do -- Russia destroy USA helicopter infantry landing forces
	local Mission = MISSION:New( 'Destroy CH-53E helicopters', 'Tactical', 'The USA is deploying infantry forces with CH-53E helicopters. Destroy the helicoptes to prevent further unloading of USA infantry forces from the ships.', 'Russia'  )

	Mission:AddClient( CLIENT:New( 'TF2 RU MIG-29S@HOT Helicopters 1' ) )
	Mission:AddClient( CLIENT:New( 'TF2 RU MIG-29S@HOT Helicopters 2' ) )
	Mission:AddClient( CLIENT:New( 'TF2 RU MIG-29S@RAMP Helicopters 3' ) )
	Mission:AddClient( CLIENT:New( 'TF2 RU MUG-29S@RAMP Helicopters 4' ) )
	Mission:AddClient( CLIENT:New( 'TF2 RU SU-27@HOT Helicopters 1' ) )
	Mission:AddClient( CLIENT:New( 'TF2 RU SU-27@HOT Helicopters 2' ) )
	Mission:AddClient( CLIENT:New( 'TF2 RU SU-27@RAMP Helicopters 3' ) )
	Mission:AddClient( CLIENT:New( 'TF2 RU SU-27@RAMP Helicopters 4' ) )
	Mission:AddClient( CLIENT:New( 'TF2 RU SU-33@HOT Helicopters 1' ) )
	Mission:AddClient( CLIENT:New( 'TF2 RU SU-33@HOT Helicopters 2' ) )
	Mission:AddClient( CLIENT:New( 'TF2 RU SU-33@RAMP Helicopters 3' ) )
	Mission:AddClient( CLIENT:New( 'TF2 RU SU-33@RAMP Helicopters 4' ) )

	local DestroyGroupsTask = DESTROYGROUPSTASK:New( 'USA transport helicopters', 'helicopters', { 'US CH-53E Air AI - Infantry Transport' } )
	DestroyGroupsTask:SetGoalTotal( 9 )
	Mission:AddTask( DestroyGroupsTask, 1 )
	
	MISSIONSCHEDULER.AddMission( Mission )
end

do -- Stop the upcoming infantry
	local Mission = MISSION:New( 'Destroy Infantry', 'Operational', 'The USA is deploying infantry forces with CH-53E helicopters, which are progressing to Anapa. Defend our airbase from the upcoming USA infantry!', 'Russia'  )

	Mission:AddClient( CLIENT:New( 'TF3 RU KA-50@HOT Infantry 1' ) )
	Mission:AddClient( CLIENT:New( 'TF3 RU KA-50@HOT Infantry 2' ) )
	Mission:AddClient( CLIENT:New( 'TF3 RU KA-50@RAMP Infantry 3' ) )
	Mission:AddClient( CLIENT:New( 'TF3 RU KA-50@RAMP Infantry 4' ) )
	Mission:AddClient( CLIENT:New( 'TF3 RU SU-25T@HOT Infantry 1' ) )
	Mission:AddClient( CLIENT:New( 'TF3 RU SU-25T@HOT Infantry 2' ) )
	Mission:AddClient( CLIENT:New( 'TF3 RU SU-25T@RAMP Infantry 3' ) )
	Mission:AddClient( CLIENT:New( 'TF3 RU SU-25T@RAMP Infantry 4' ) )
	Mission:AddClient( CLIENT:New( 'TF3 RU SU-27@HOT Infantry 1' ) )
	Mission:AddClient( CLIENT:New( 'TF3 RU SU-27@HOT Infantry 2' ) )
	Mission:AddClient( CLIENT:New( 'TF3 RU SU-27@RAMP Infantry 3' ) )
	Mission:AddClient( CLIENT:New( 'TF3 RU SU-27@RAMP Infantry 4' ) )
	
	local DestroyGroupsTask = DESTROYGROUPSTASK:New( 'USA Infantry', 'infantry vehicles', { 'US CH-53E Infantry Left', 'US CH-53E Infantry Right' } )
	DestroyGroupsTask:SetGoalTotal( 30 )
	Mission:AddTask( DestroyGroupsTask, 1 )
	
	MISSIONSCHEDULER.AddMission( Mission )
	
end

do -- Russia Rescue workers from oil platforms
	local Mission = MISSION:New( 'Rescue oil rig workers', 'Operational', 'Russian workers are still on the Oil Rigs in the sea. Fly to the west and rescue them. They will use a red smoke signal when you approach the oil rigs. Note that we are not sure in which oil rig exactly the workers are. Search for the red smoke, fly to the oil rig, and rescue the workers by landing on the oil rig. Fly back to Gelend and land in the zone indicated by a red smoke signal. Good luck!', 'Russia' )
--	Mission:AddGoal( MissionGoal )
	
	local Client
	
	Client = CLIENT:New( 'TF4 RU MI-8@HOT Rescue Oil Workers 1' )
	Client:Transport()
	Mission:AddClient( Client )

	Client = CLIENT:New( 'TF4 RU MI-8@HOT Rescue Oil Workers 2' )
	Client:Transport()
	Mission:AddClient( Client )

	Client = CLIENT:New( 'TF4 RU MI-8@RAMP Rescue Oil Workers 3' )
	Client:Transport()
	Mission:AddClient( Client )

	Client = CLIENT:New( 'TF4 RU MI-8@RAMP Rescue Oil Workers 4' )
	Client:Transport()
	Mission:AddClient( Client )

	local CargoTable = {}
	for CargoItem = 1, 2 do
		Mission:AddCargo( 'Oil workers ' .. CargoItem, CARGO_TYPE.ENGINEERS, math.random( 70, 120 ) * 2, nil, 'RU Oil Rig Workers', 'Oil Rig Workers Deployment #011' )
	end

	-- Assign the Pickup Task
	local PickupTask = PICKUPTASK:New( 'Oil Rig #011', CARGO_TYPE.ENGINEERS, CLIENT.ONBOARDSIDE.FRONT )
	PickupTask:AddSmokeRed( 'RU Oil Rig #011', 50 )
	Mission:AddTask( PickupTask, 1 )

	-- Assign the Deploy Task
	local DeployTask = DEPLOYTASK:New( 'RU Anapa Rescue Workers', CARGO_TYPE.ENGINEERS )
	DeployTask:AddSmokeRed( 'RU Workers Rescue Vehicle' )
	DeployTask:SetGoalTotal( 1 )
	Mission:AddTask( DeployTask, 2 )

	MISSIONSCHEDULER.AddMission( Mission )
	
end


--MusicRegister( 'REC1', 'Ashes to Ashes.ogg', 4 * 60 + 24 )
--MusicRegister( 'REC1', 'Black Dog.ogg', 4 * 60 + 57 )
--MusicRegister( 'REC1', 'Everybodys Got To Learn Sometime.ogg', 4 * 60 + 15 )
--MusicRegister( 'REC1', 'Long Cool Woman.ogg', 3 * 60 + 14 )
--MusicRegister( 'REC1', 'Take It As It Comes.ogg', 2 * 60 + 14 )
--MusicRegister( 'REC1', 'The Wall Street Shuffle.ogg', 3 * 60 + 51 )
--MusicRegister( 'REC1', 'Heroes.ogg', 3 * 60 + 37 )


-- RU Su-30
SpawnRU_SU30 = SPAWN:New( 'RU SU-30@AI Patrol SAM Area' ):Limit( 3, 30 ):Schedule( 900, 0.4 ):RandomizeRoute( 1, 1, 6000 )

-- FR Mirage
SpawnFR_MIRAGE = SPAWN:New( 'TF3 FR MIRAGE 2000-5@AI CAP' ):Limit( 2, 30 ):Schedule( 900, 0.4 ):RandomizeRoute( 3, 1, 3000 )

-- RU KA-50 Defense 1 AI #
SpawnRU_KA50 = SPAWN:New( 'TF3 RU KA-50@AI Ground Defense' ):Limit( 1, 10 ):Schedule( 600, 0.4 ):RandomizeRoute( 1, 1, 3000 )

-- RU MI-28N Defense 2 AI #
SpawnRU_MI28N = SPAWN:New( 'TF3 RU MI-28N@AI Ground Defense' ):Limit( 1, 20 ):Schedule( 900, 0.4 ):RandomizeRoute( 1, 1, 3000 )

-- RU Su-25T - AI Ground Defense
SpawnRU_SU25T = SPAWN:New( 'TF3 RU SU-25T@AI Ground Defense' ):Limit( 1, 5 ):Schedule( 450, 0.4 ):RandomizeRoute( 1, 1, 3000 ):RepeatOnEngineShutDown()

-- US F-15C
SpawnUS_F117A = SPAWN:New( 'TF2 US F-117A@AI PINPOINT' ):Limit( 1, 5 ):Schedule( 1200, 0.7 ):RandomizeRoute( 1, 1, 4000 )

-- US FA-18C SEAD
SpawnUS_FA18C_SEAD = SPAWN:New( 'TF1 US FA-18C@AI Destroy SA-10' ):Limit( 1, 6 ):Schedule( 900, 0.2 ):RandomizeRoute( 2, 1, 3000 )

-- US FA-18C Air Defenses
SpawnUS_FA18C_CAP = SPAWN:New( 'TF1 US FA-18C@AI Helicopter Escort' ):Limit( 3, 16 ):Schedule( 350, 0.2 ):RandomizeRoute( 2, 1, 3000 )

-- US A-10A
SpawnUS_A10A = SPAWN:New( 'TF3 US A-10A@AI Destroy SA-6/11' ):Limit( 2, 20 ):Schedule( 600, 0.5 ):RandomizeRoute( 3, 1, 3000 )

-- GE SU-25T
SpawnGE_SU25T = SPAWN:New( 'TF3 GE SU-25T@AI Destroy SA-6/11' ):Limit( 1, 8 ):Schedule( 30, 0.5 ):RandomizeRoute( 1, 1, 10000 )

-- US AH-1W
SpawnUS_AH1W = SPAWN:New( 'TF1 US AH-1W Farp AI - Attack Anapa' ):Limit( 2, 20 ):Schedule( 750, 0.3 ):RandomizeRoute( 2, 1, 6000 )

-- BE KA-50
SpawnBE_KA50 = SPAWN:New( 'TF1 BE KA-50@AI Attack AA' ):Limit( 2, 20 ):Schedule( 900, 0.6 ):RandomizeRoute( 3, 1, 3000 )

-- RU Su-34 - AI Ship Attack
SpawnRU_SU34 = SPAWN:New( 'TF1 RU Su-34 Krymsk@AI - Attack Ships' ):Limit( 2, 3 ):Schedule( 1800, 0.4 ):SpawnUncontrolled():RandomizeRoute( 1, 1, 3000 ):RepeatOnEngineShutDown()

--- Infantry forces spawned from a Carrier
SpawnCH53ELeft  = SPAWN:New( 'US CH-53E Infantry Left' ):RandomizeTemplate( { 'US IFV M2A2 Bradley', 'US APC M1126 Stryker ICV', 'US MBT M1A2 Abrams', 'US APC LVTP-7', 'US IFV LAV-25' } ):RandomizeRoute( 1, 3, 2000 )
SpawnCH53ERight = SPAWN:New( 'US CH-53E Infantry Right' ):RandomizeTemplate( { 'US IFV M2A2 Bradley', 'US APC M1126 Stryker ICV', 'US MBT M1A2 Abrams', 'US APC LVTP-7', 'US IFV LAV-25' } ):RandomizeRoute( 2, 1, 3000 )
SpawnCH53EWest = SPAWN:New( 'US CH-53E Infantry West' ):RandomizeTemplate( { 'US IFV M2A2 Bradley', 'US APC M1126 Stryker ICV', 'US MBT M1A2 Abrams', 'US APC LVTP-7', 'US IFV LAV-25' } ):RandomizeRoute( 1, 3, 2000 )
SpawnMI26 = SPAWN:New( 'RU MI-26 Infantry' ):RandomizeTemplate( { 'RU IFV BMP-2', 'RU IFV BMD-1',  'RU IFV BMP-3' } ):RandomizeRoute( 2, 1, 3000 )

--- CCCP SEAD Defenses
SEAD_SA10_Defenses = SEAD:New( { 'Russia SA-10 Battery Array #001' } )
SEAD_SA11_Defenses_Anapa = SEAD:New( { 'RU SA-11 BUK Air Defense #001' } )
SEAD_SA8_Defenses = SEAD:New( { 'RU SA-8 Airbase Defense' } )
SEAD_SAM_Defenses_South = SEAD:New( { 'RU SA-6 - Middle Defenses', 'RU SA-11 - South Defenses' } )


--- NATO SEAD Defenses
SEAD_Hawk_Defenses = SEAD:New( { 'US Hawk Battery' } )
SEAD_Roland_Defenses = SEAD:New( { 'DE SAM Roland ADS' } )
SEAD_Ship_Defenses = SEAD:New( { 'US Ship North', 'US Ship West' } )

MOVEMENT_CH53E = MOVEMENT:New( { 'US CH-53E Infantry Left', 'US CH-53E Infantry Right', 'US CH-53E Infantry West' }, 20 )
MOVEMENT_MI26 = MOVEMENT:New( { 'RU MI-26 Infantry' }, 10 )

-- MISSION SCHEDULER STARTUP
MISSIONSCHEDULER.Start()
MISSIONSCHEDULER.ReportMenu()
MISSIONSCHEDULER.ReportMissionsFlash( 120 )

env.info( "Anapa Airbase.lua loaded." )
