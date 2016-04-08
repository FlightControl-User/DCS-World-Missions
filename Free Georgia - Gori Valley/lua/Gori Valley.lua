
--- Gori Valley Mission
--
-- This is the Gori valley main mission lua file. 
-- It contains:
-- 
-- * the declaration of 8 missions, 4 for blue, 4 for red.
-- * the declaration of the spawning units within the battle scene.
-- * the declaration of SEAD defenses of the SAM units within the battle scene.
-- * the declaration of movement monitoring to avoid a large CPU usage.
-- 
-- Notes:
-- * Due to several bugs related to CARGO, it is currently impossible to model correctly the sling-load logic.
--  I had to implement several workarounds to ensure that still a sling-load mission is possible to be working.
--  Problems that can occur are that sometimes the cargos will not be available, though they will be visible for the pilot...  
--  
--  @module Gori_Valley
--  @author FlightControl



-- MOOSE include files.
Include.File( "Mission" )
Include.File( "Client" )
Include.File( "DeployTask" )
Include.File( "PickupTask" )
Include.File( "DestroyGroupsTask" )
Include.File( "DestroyRadarsTask" )
Include.File( "DestroyUnitTypesTask" )
Include.File( "GoHomeTask" )
Include.File( "Spawn" )
Include.File( "Movement" )
Include.File( "Sead" )
Include.File( "CleanUp" )
Include.File( "Group" )
Include.File( "Unit" )
Include.File( "Zone" )
Include.File( "Escort" )


-- CCCP COALITION UNITS

-- Russian helicopters engaging the battle field in Gori Valley
Spawn_RU_KA50 = SPAWN:New( 'RU KA-50@HOT-Patriot Attack' ):Limit( 1, 24 ):RandomizeRoute( 1, 1, 8000 ):CleanUp( 180 ):SpawnScheduled( 600, 0.2 )
Spawn_RU_MI28N = SPAWN:New( 'RU MI-28N@HOT-Ground Attack' ):Limit( 1, 24 ):RandomizeRoute( 1, 1, 2000 ):CleanUp( 180 ):SpawnScheduled( 600, 0.2 )
Spawn_RU_MI24V = SPAWN:New( 'RU MI-24V@HOT-Ground Attack' ):Limit( 1, 24 ):RandomizeRoute( 1, 1, 2000 ):CleanUp( 180 ):SpawnScheduled( 600, 0.2 )

-- Russian helicopters deploying troops in the battle field in Gori Valley
Spawn_RU_MI26_Infantry = SPAWN:New( 'RU MI-26@HOT-Transport Infantry' ):Limit( 2, 8 ):RandomizeRoute( 2, 2, 200 ):CleanUp( 180 ):SpawnScheduled( 900, 0.2 )
Spawn_RU_MI26_Troops = SPAWN:New( 'RU MI-26 Troops' ):Limit( 8, 80 ):RandomizeTemplate( { "RU MI-26 Infantry Alpha", "RU MI-26 Infantry Beta", "RU MI-26 Infantry Gamma" } ):RandomizeRoute( 1, 0, 5000 )

Spawn_RU_MI26_East = SPAWN:New( 'RU MI-26@HOT-SAM Transport East' ):Limit( 1, 8 ):RandomizeRoute( 2, 2, 200 ):CleanUp( 180 ):SpawnScheduled( 900, 0.2 )
Spawn_RU_MI26_SAM_East = SPAWN:New( 'RU MI-26 SAM East' ):Limit( 4, 20 ):RandomizeTemplate( { "RU MI-26 SAM East 1", "RU MI-26 SAM East 2", "RU MI-26 SAM East 3" } ):RandomizeRoute( 1, 0, 2000 )

Spawn_RU_MI26_West = SPAWN:New( 'RU MI-26@HOT-SAM Transport West' ):Limit( 1, 8 ):RandomizeRoute( 2, 2, 200 ):CleanUp( 180 ):SpawnScheduled( 900, 0.2 )
Spawn_RU_MI26_SAM_West = SPAWN:New( 'RU MI-26 SAM West' ):Limit( 4, 20 ):RandomizeTemplate( { "RU MI-26 SAM West 1", "RU MI-26 SAM West 2", "RU MI-26 SAM West 3" } ):RandomizeRoute( 1, 0, 2000 )

-- Russian planes attacking ground units in Gori Valley and defending air space over the mountains.
Spawn_RU_SU25T = SPAWN:New( 'RU SU-25T@RAMP-Patriot Attack' ):Limit( 3, 24 ):RandomizeRoute( 1, 1, 200 ):CleanUp( 180 ):SpawnScheduled( 300, 0.25 )
Spawn_RU_SU27 = SPAWN:New( 'RU SU-27@RAMP-Air Support East' ):Limit( 3, 24 ):RandomizeRoute( 1, 1, 4000 ):CleanUp( 180 ):SpawnScheduled( 300, 0.3 )
Spawn_RU_MIG29S = SPAWN:New( 'RU MIG-29S@RAMP-Air Defense West' ):Limit( 3, 24 ):RandomizeRoute( 1, 1, 4000 ):CleanUp( 180 ):SpawnScheduled( 450, 0.4 )

-- Russian planes escorting the SU25T attack forces
Spawn_RU_Escort_SU25T_Beslan = SPAWN:New( 'RU SU-30@HOT-Escort SU-25T Beslan' ):RandomizeRoute( 1, 1, 2000 )

-- Russian helicopters escorting general rescue mission.
Spawn_RU_MI28N_Escort = SPAWN:New( 'RU MI-28N*HOT-Rescue General Escort' ):RandomizeRoute( 3, 1, 500 )

-- Russian ground troops attacking Gori Valley
Spawn_RU_Troops = { 'RU Attack Gori 1', 'RU Attack Gori 2', 'RU Attack Gori 3', 'RU Attack Gori 4', 'RU Attack Gori 5', 'RU Attack Gori 6', 'RU Attack Gori 7', 'RU Attack Gori 8', 'RU Attack Gori 9', 'RU Attack Gori 10' }
Spawn_RU_Troops_Left = SPAWN:New( 'RU Attack Gori Left' )
                            :Limit( 20, 150 )
                            :RandomizeTemplate( Spawn_RU_Troops )
                            :RandomizeRoute( 1, 1, 2000 )
                            :Array( 349, 30, 20, 20 )
                            :SpawnScheduled( 90, 1 )
                            
Spawn_RU_Troops_Middle = SPAWN:New( 'RU Attack Gori Middle' )
                              :Limit( 20, 150 )
                              :RandomizeTemplate( Spawn_RU_Troops )
                              :RandomizeRoute( 1, 1, 2000 )
                              :Array( 260, 50, 20, 25 )
                              :SpawnScheduled( 90, 1 )
                              
Spawn_RU_Troops_Right = SPAWN:New( 'RU Attack Gori Right' )
                             :Limit( 20, 150 )
                             :RandomizeTemplate( Spawn_RU_Troops )
                             :RandomizeRoute( 1, 1, 2000 )
                             :Array( 238, 50, 20, 25 )
                             :SpawnScheduled( 90, 1 )

-- Russian low altitude SA systems defending the mountains.
Spawn_RU_Defend_Mountains_A = SPAWN:New( 'RU Defend Mountains A' ):Limit( 2, 4 ):RandomizeRoute( 0, 0, 5000 ):Array( 90, 2, 10, 10 ):SpawnScheduled( 180, 0.5 )
Spawn_RU_Defend_Mountains_B = SPAWN:New( 'RU Defend Mountains B' ):Limit( 2, 4 ):RandomizeRoute( 0, 0, 5000 ):Array( 90, 2, 10, 10 ):SpawnScheduled( 180, 0.5 )
Spawn_RU_Defend_Mountains_C = SPAWN:New( 'RU Defend Mountains C' ):Limit( 2, 4 ):RandomizeRoute( 0, 0, 5000 ):Array( 90, 2, 10, 10 ):SpawnScheduled( 180, 0.5 )



-- Limit the amount of simultaneous moving units on the ground to prevent lag.
Movement_RU_Troops = MOVEMENT:New( { 'RU Attack Gori Left', 'RU Attack Gori Middle', 'RU Attack Gori Right', 'RU MI-26 Troops' }, 40 )

-- BLUE COALITION UNITS



-- NATO helicopters deploying troops within the battle field.
Spawn_US_CH47D1 = SPAWN:New( 'US CH-47D@RAMP Troop Deployment 1' ):Limit( 1, 8 ):RandomizeRoute( 1, 0, 200 ):CleanUp( 180 ):SpawnScheduled( 900, 0.2 )
Spawn_US_CH47D2 = SPAWN:New( 'US CH-47D@RAMP-Troop Deployment 2' ):Limit( 1, 8 ):RandomizeRoute( 1, 0, 200 ):CleanUp( 180 ):SpawnScheduled( 900, 0.2 )

Spawn_US_CH47Troops = SPAWN:New( 'US CH-47D Troops' ):Limit( 8, 80 ):RandomizeTemplate( { "US Infantry Defenses A", "US Infantry Defenses B", "US Infantry Defenses C", "DE Infantry Defenses D", "DE Infantry Defenses E" } ):RandomizeRoute( 1, 0, 4000 )


-- NATO helicopters engaging in the battle field.
Spawn_BE_KA50 = SPAWN:New( 'BE KA-50@RAMP-Ground Defense' ):Limit( 1, 24 ):RandomizeRoute( 1, 1, 2000 ):CleanUp( 180 ):SpawnScheduled( 600, 0.5 )


Spawn_US_AH64D = SPAWN:New( 'US AH-64D@RAMP-Ground Recon' ):Limit( 1, 20 ):RandomizeRoute( 1, 1, 2000 ):CleanUp( 180 ):SpawnScheduled( 900, 0.5 )

-- NATO planes attacking Russian ground units and defending airspace
Spawn_BE_F16A = SPAWN:New( 'BE F-16A@RAMP-Air Support Mountains' ):Limit( 2, 20 ):RandomizeRoute( 1, 1, 6000 ):RepeatOnEngineShutDown():CleanUp( 180 ):SpawnScheduled( 1200, 0.5 )
Spawn_US_F16C = SPAWN:New( 'US F-16C@RAMP-Sead Gori' ):Limit( 1, 20 ):RandomizeRoute( 1, 1, 6000 ):RepeatOnEngineShutDown():CleanUp( 180 ):SpawnScheduled( 1200, 0.5 )
Spawn_US_F15C = SPAWN:New( 'US F-15C@RAMP-Air Support Mountains' ):Limit( 2, 24 ):RandomizeRoute( 1, 1, 5000 ):RepeatOnEngineShutDown():CleanUp( 180 ):SpawnScheduled( 1200, 0.5 )
Spawn_US_F14A_Intercept = SPAWN:New( 'US F-14A@RAMP-Intercept' ):Limit( 2, 24 ):RandomizeRoute( 1, 1, 6000 ):CleanUp( 180 ):SpawnScheduled( 1200, 0.4 )
Spawn_US_A10C_Ground_Defense = SPAWN:New( 'US A-10C*HOT-Ground Defense' ):Limit( 2, 10 ):RandomizeRoute( 1, 1, 2000 ):RepeatOnEngineShutDown():CleanUp( 180 ):SpawnScheduled( 1200, 0.4 )
Spawn_US_A10C_Ground_Attack_West = SPAWN:New( 'US A-10C*RAMP-Ground Attack West' ):Limit( 2, 10 ):RandomizeRoute( 1, 1, 2000 ):RepeatOnEngineShutDown():CleanUp( 180 ):SpawnScheduled( 1200, 0.4 )

-- NATO Helicopters escorting rescue mission.
Spawn_NL_AH64A_Escort = SPAWN:New( 'NL AH-64A@HOT-Escort Rescue Agent' ):RandomizeRoute( 2, 1, 500 )

-- NATO planes escorting the A-10Cs
Spawn_US_F16A_Escort_A10C_Kutaisi = SPAWN:New( 'BE F-16A@HOT-Escort A10C Kutaisi' ):RandomizeRoute( 1, 1, 5000 )

-- NATO Tank Platoons invading Tskinvali
Spawn_US_Platoon = { 'US Tank Platoon 1', 'US Tank Platoon 2', 'US Tank Platoon 3', 'US Tank Platoon 4', 'US Tank Platoon 5', 'US Tank Platoon 6', 'US Tank Platoon 7', 'US Tank Platoon 8', 'US Tank Platoon 9', 'US Tank Platoon 10', 'US Tank Platoon 11', 'US Tank Platoon 12', 'US Tank Platoon 13' }

Spawn_US_Platoon_Left = SPAWN:New( 'US Tank Platoon Left' )
                             :Limit( 20, 150 )
                             :RandomizeTemplate( Spawn_US_Platoon )
                             :RandomizeRoute( 3, 1, 2000 )
                             :Array( 76, 30, 15, 35 )
                             :SpawnScheduled( 90, 1 )
                             
Spawn_US_Platoon_Middle = SPAWN:New( 'US Tank Platoon Middle' )
                               :Limit( 20, 150 )
                               :RandomizeTemplate( Spawn_US_Platoon )
                               :RandomizeRoute( 3, 1, 2000 )
                               :Array( 160, 30, 15, 35 )
                               :SpawnScheduled( 90, 1 )
                               
Spawn_US_Platoon_Right = SPAWN:New( 'US Tank Platoon Right' )
                              :Limit( 20, 150 )
                              :RandomizeTemplate( Spawn_US_Platoon )
                              :RandomizeRoute( 1, 1, 2000 )
                              :Array( 90, 50, 15, 35 )
                              :SpawnScheduled( 90, 1 )

-- NATO Tank Platoons defending the Patriot Batteries
Spawn_US_Patriot_Defense = { 'US Tank Platoon 1', 'US Tank Platoon 2', 'US Tank Platoon 3', 'US Tank Platoon 4', 'US Tank Platoon 5', 'US Tank Platoon 6', 'US Tank Platoon 7', 'US Tank Platoon 8', 'US Tank Platoon 9', 'US Tank Platoon 10', 'US Tank Platoon 11', 'US Tank Platoon 12', 'US Tank Platoon 13' }
Spawn_US_Defense_Left = SPAWN:New( 'US Patriot Defenses 1' ):Limit( 4, 30 ):RandomizeTemplate( Spawn_US_Patriot_Defense ):RandomizeRoute( 3, 0, 1000 ):Array( 3, 15, 10, 30 ):SpawnScheduled( 600, 0.4 )
Spawn_US_Defense_Middle = SPAWN:New( 'US Patriot Defenses 2' ):Limit( 4, 30 ):RandomizeTemplate( Spawn_US_Patriot_Defense ):RandomizeRoute( 3, 0, 1000 ):Array( 3, 15, 10, 30 ):SpawnScheduled( 600, 0.4 )
Spawn_US_Defense_Right = SPAWN:New( 'US Patriot Defenses 3' ):Limit( 4, 30 ):RandomizeTemplate( Spawn_US_Patriot_Defense ):RandomizeRoute( 3, 0, 1000 ):Array( 3, 15, 10, 30 ):SpawnScheduled( 600, 0.4 )

-- NATO low air defenses in the mountains
US_Defend_Mountains_A = SPAWN:New( 'US Defend Mountains A' ):Limit( 2, 10 ):RandomizeRoute( 1, 0, 5000 ):Array( 90, 5, 10, 20 ):SpawnScheduled( 180, 0.5 )
US_Defend_Mountains_B = SPAWN:New( 'US Defend Mountains B' ):Limit( 2, 10 ):RandomizeRoute( 1, 0, 5000 ):Array( 90, 5, 10, 20 ):SpawnScheduled( 180, 0.5 )
US_Defend_Mountains_C = SPAWN:New( 'US Defend Mountains C' ):Limit( 2, 10 ):RandomizeRoute( 1, 0, 5000 ):Array( 90, 5, 10, 20 ):SpawnScheduled( 180, 0.5 )

-- Limit the amount of simultaneous moving units on the ground to prevent lag.
Movement_US_Platoons = MOVEMENT:New( { 'US Tank Platoon Left', 'US Tank Platoon Middle', 'US Tank Platoon Right', 'US CH-47D Troops' }, 40 )


-- SEAD DEFENSES

-- CCCP SEAD Defenses
SEAD_RU_SAM_Defenses = SEAD:New( { 'RU SA-6 Kub', 'RU SA-6 Defenses', 'RU MI-26 Troops', 'RU Attack Gori' } )

-- NATO SEAD Defenses
SEAD_Patriot_Defenses = SEAD:New( { 'US SAM Patriot', 'US Tank Platoon', 'US CH-47D Troops' } )

-- Keep some airports clean
CLEANUP_Airports = CLEANUP:New( { 'CLEAN Tbilisi', 'CLEAN Vaziani', 'CLEAN Kutaisi', 'CLEAN Sloganlug', 'CLEAN Beslan', 'CLEAN Mozdok', 'CLEAN Nalchik' }, 10 )



-- MISSIONS PART:CCCP MISSION

do -- CCCP Transport Mission to activate the SA-6 radar installations.

	SA6Activation = { 
		[ "RU Activation SA-6 Moskva" ] 	= { "RU SA-6 Kub Moskva", false },
		[ "RU Activation SA-6 Niznij" ] 	= { "RU SA-6 Kub Niznij", false },
		[ "RU Activation SA-6 Yaroslavl" ] 	= { "RU SA-6 Kub Yaroslavl", false }
	}

	function DeploySA6TroopsGoal( Mission, Client )


		-- Check if the cargo is all deployed for mission success.
		for CargoID, CargoData in pairs( CARGOS ) do
			if CargoData.CargoGroupName then
				CargoGroup = Group.getByName( CargoData.CargoGroupName )
				if CargoGroup then
					-- Check if the group is ready to activate an SA-6.
					local CurrentLandingZoneID = routines.IsPartOfGroupInZones( CargoGroup, Mission:GetTask( 2 ).LandingZones.LandingZoneNames ) -- The second task is the Deploytask to measure mission success upon
					if CurrentLandingZoneID then
						if SA6Activation[CurrentLandingZoneID][2] == false then
							trigger.action.setGroupAIOn( Group.getByName( SA6Activation[CurrentLandingZoneID][1] ) )
							SA6Activation[CurrentLandingZoneID][2] = true
							MESSAGE:New( "Message to all airborne units: we have another of our SA-6 air defense systems armed.", 
										 "Mission Command:", 60, "RED/SA6Defense" ):ToRed()
							MESSAGE:New( "Our satellite systems are detecting additional CCCP SA-6 air defense activities near Tskinvali. To all airborne units: Take care!!!", 
							             "Mission Command:", 60, "BLUE/SA6Defense" ):ToBlue()
							Mission:GetTask( 2 ):AddGoalCompletion( "SA6 activated", SA6Activation[CurrentLandingZoneID][1], 1 ) -- Register SA6 activation as part of mission goal.
						end
					end
				end
			end
		end
	end

	local Mission_Red_SA6 = MISSION:New( 'Russia Transport Troops SA-6', 'Operational', 'Transport troops from the control center to one of the SA-6 SAM sites to activate their operation.', 'CCCP' )
	Mission_Red_SA6:AddGoalFunction( DeploySA6TroopsGoal )

	Mission_Red_SA6:AddClient( CLIENT:New( 'Operational: Deploy Troops to SA-6 (RU MI-8MTV2-1@HOT)' ):Transport() )
	Mission_Red_SA6:AddClient( CLIENT:New( 'Operational: Deploy Troops to SA-6 (RU MI-8MTV2-2@HOT)' ):Transport() )
	Mission_Red_SA6:AddClient( CLIENT:New( 'Operational: Deploy Troops to SA-6 (RU MI-8MTV2-3@RAMP)' ):Transport() )
	Mission_Red_SA6:AddClient( CLIENT:New( 'Operational: Deploy Troops to SA-6 (RU MI-8MTV2-4@RAMP)' ):Transport() )
	
	local CargoTable = {}
	local EngineerNames = { "команда железа", "команда орла", "свобода команда", "команда цель" }

	Cargo_Pickup_Zone_Alpha = CARGO_ZONE:New( 'Russia Alpha Pickup Zone', 'Russia Alpha Control Center' ):BlueSmoke()
    Cargo_Pickup_Zone_Beta = CARGO_ZONE:New( 'Russia Beta Pickup Zone', 'Russia Beta Control Center' ):RedSmoke()

	for CargoItem = 1, 2 do
		CargoTable[CargoItem] = CARGO_GROUP:New( 'Engineers', 'Team ' .. EngineerNames[CargoItem], 
		                                          math.random( 70, 100 ) * 2, 
												  'RU Infantry Alpha',  
												  Cargo_Pickup_Zone_Alpha )
	end

	for CargoItem = 3, 4 do
		CargoTable[CargoItem] = CARGO_GROUP:New( 'Engineers', 'Team ' .. EngineerNames[CargoItem], 
		                                          math.random( 70, 100 ) * 2, 
												  'RU Infantry Beta',  
												  Cargo_Pickup_Zone_Beta )
	end

	-- Assign the Pickup Task
	
	local PickupTask = PICKUPTASK:New( 'Engineers', CLIENT.ONBOARDSIDE.LEFT )
	PickupTask:FromZone( Cargo_Pickup_Zone_Alpha )
	PickupTask:FromZone( Cargo_Pickup_Zone_Beta )
	PickupTask:InitCargo( CargoTable )
	Mission_Red_SA6:AddTask( PickupTask, 1 )

	RU_Activation_SA6_Moskva = CARGO_ZONE:New( "RU Activation SA-6 Moskva", "RU SA-6 Transport Moskva" ):RedFlare()
	RU_Activation_SA6_Niznij = CARGO_ZONE:New( "RU Activation SA-6 Niznij", "RU SA-6 Transport Niznij" ):WhiteFlare()
	RU_Activation_SA6_Yaroslavl = CARGO_ZONE:New( "RU Activation SA-6 Yaroslavl", "RU SA-6 Transport Yaroslavl" ):YellowFlare()
	
	-- Assign the Deploy Task
	local SA6ActivationZones = { "RU Activation SA-6 Moskva", "RU Activation SA-6 Niznij", "RU Activation SA-6 Yaroslavl" }
	local SA6ActivationZonesSmokeUnits = { "RU SA-6 Transport Moskva", "RU SA-6 Transport Niznij", "RU SA-6 Transport Yaroslavl" }
	
	local DeployTask = DEPLOYTASK:New( 'Engineers' )
	DeployTask:ToZone( RU_Activation_SA6_Moskva )
	DeployTask:ToZone( RU_Activation_SA6_Niznij )
	DeployTask:ToZone( RU_Activation_SA6_Yaroslavl )
	DeployTask:SetGoalTotal( 3 )
	DeployTask:SetGoalTotal( 3, "SA6 activated" )
	Mission_Red_SA6:AddTask( DeployTask, 2 )
	
	MISSIONSCHEDULER.AddMission( Mission_Red_SA6 )
	
end

do -- CCCP - Destroy Patriots
	local Mission = MISSION:New( 'Patriots', 'Primary', 'Our intelligence reports that 3 Patriot SAM defense batteries are located near Ruisi, Kvarhiti and Gori.', 'CCCP'  )

  local function Escort_SU25T_Beslan( Client )
    local EscortGroup = Spawn_RU_Escort_SU25T_Beslan:ReSpawn(1)
    local Escort = ESCORT:New( Client, EscortGroup, "Escort железо (SU-30)" )
  end
  
	Mission:AddClient( CLIENT:New( 'Primary: Patriot Attack (RU KA-50-1@HOT)', "Execute a CAS in Gori Valley, eliminating the Patriot launchers and other ground vehicles. Patriot batteries are at waypoint 2 to 4. Beware approaching NATO air support from the east and the west. Fly low and slow, and scan the area before engaging." ) )
	Mission:AddClient( CLIENT:New( 'Primary: Patriot Attack (RU KA-50-2@HOT)', "Execute a CAS in Gori Valley, eliminating the Patriot launchers and other ground vehicles. Patriot batteries are at waypoint 2 to 4. Beware approaching NATO air support from the east and the west. Fly low and slow, and scan the area before engaging.") )
	Mission:AddClient( CLIENT:New( 'Primary: Patriot Attack (RU KA-50-3@RAMP)', "Execute a CAS in Gori Valley, eliminating the Patriot launchers and other ground vehicles. Patriot batteries are at waypoint 2 to 4. Beware approaching NATO air support from the east and the west. Fly low and slow, and scan the area before engaging." ) )
	Mission:AddClient( CLIENT:New( 'Primary: Patriot Attack (RU KA-50-4@RAMP)', "Execute a CAS in Gori Valley, eliminating the Patriot launchers and other ground vehicles. Patriot batteries are at waypoint 2 to 4. Beware approaching NATO air support from the east and the west. Fly low and slow, and scan the area before engaging.") )

	Mission:AddClient( CLIENT:New( 'Primary: Patriot Attack (RU SU-25T-1@HOT)', "Fly to the south and execute a CAS in Gori Valley, eliminating the Patriot launchers and other ground vehicles. Patriot batteries are at waypoint 2 to 4. Beware approaching NATO air support from the east and the west. Expect heavy AAA and air defense ground units within Gori Valley." )
	                         :Alive( Escort_SU25T_Beslan ) )
	Mission:AddClient( CLIENT:New( 'Primary: Patriot Attack (RU SU-25T-2@HOT)', "Fly to the south and execute a SEAD attack in Gori Valley, eliminating the Patriot radars and other ground air defenses. Patriot batteries are at waypoint 2 to 4. Beware approaching NATO air support from the east and the west. Expect heavy AAA and air defense ground units within Gori Valley." )
	                         :Alive(  Escort_SU25T_Beslan ) )
	Mission:AddClient( CLIENT:New( 'Primary: Patriot Attack (RU SU-25T-3@RAMP)', "Fly to the south and execute a CAS in Gori Valley, eliminating the Patriot launchers and other ground vehicles. Patriot batteries are at waypoint 2 to 4. Beware approaching NATO air support from the east and the west. Expect heavy AAA and air defense ground units within Gori Valley." )
	                         :Alive( Escort_SU25T_Beslan ) )
	Mission:AddClient( CLIENT:New( 'Primary: Patriot Attack (RU SU-25T-4@RAMP)', "Fly to the south and execute a SEAD attack in Gori Valley, eliminating the Patriot radars and other ground air defenses. Patriot batteries are at waypoint 2 to 4. Beware approaching NATO air support from the east and the west. Expect heavy AAA and air defense ground units within Gori Valley." )
	                         :Alive( Escort_SU25T_Beslan ) )

	Mission:AddClient( CLIENT:New( 'Support: Air Defense West (RU MIG-29S-1@HOT)', "Provide CAP support by flying to the south over the mountains and engage with any unidentified aircraft. Protect our Su-25T planes from any unexpected air threats." ..
							                                                                   "NATO airbases are in red alert. NATO air defenses are on their way to Gori Valley." ) )
	Mission:AddClient( CLIENT:New( 'Support: Air Defense West (RU MIG-29S-2@HOT)', "Provide CAP support by flying to the south over the mountains and engage with any unidentified aircraft. Protect our Su-25T planes from any unexpected air threats." ..
							                                                                    "NATO airbases are in red alert. NATO air defenses are on their way to Gori Valley." ) )
	Mission:AddClient( CLIENT:New( 'Support: Air Defense West (RU MIG-29S-3@RAMP)', "Provide CAP support by flying to the south over the mountains and engage with any unidentified aircraft. Protect our Su-25T planes from any unexpected air threats." ..
							                                                                    "NATO airbases are in red alert. NATO air defenses are on their way to Gori Valley." ) )
	Mission:AddClient( CLIENT:New( 'Support: Air Defense West (RU MIG-29S-4@RAMP)', "Provide CAP support by flying to the south over the mountains and engage with any unidentified aircraft. Protect our Su-25T planes from any unexpected air threats." ..
							                                                                    "NATO airbases are in red alert. NATO air defenses are on their way to Gori Valley." ) )

	Mission:AddClient( CLIENT:New( 'Support: Air Support East (RU SU-27-1@HOT)', "Provide CAP support by flying to the south over the mountains and engage with any unidentified aircraft. Protect our Su-25T planes from any unexpected air threats." ..
							                                                                 "NATO airbases are in red alert. NATO air defenses are on their way to Gori Valley." ) )
	Mission:AddClient( CLIENT:New( 'Support: Air Support East (RU SU-27-2@HOT)', "Provide CAP support by flying to the south over the mountains and engage with any unidentified aircraft. Protect our Su-25T planes from any unexpected air threats." ..
							                                                                 "NATO airbases are in red alert. NATO air defenses are on their way to Gori Valley." ) )
	Mission:AddClient( CLIENT:New( 'Support: Air Support East (RU SU-27-3@RAMP)', "Provide CAP support by flying to the south over the mountains and engage with any unidentified aircraft. Protect our Su-25T planes from any unexpected air threats." ..
							                                                                  "NATO airbases are in red alert. NATO air defenses are on their way to Gori Valley." ) )
	Mission:AddClient( CLIENT:New( 'Support: Air Support East (RU SU-27-4@RAMP)', "Provide CAP support by flying to the south over the mountains and engage with any unidentified aircraft. Protect our Su-25T planes from any unexpected air threats." ..
							                                                                  "NATO airbases are in red alert. NATO air defenses are on their way to Gori Valley." ) )

	Mission:AddClient( CLIENT:New( 'Support: Air Patrol (RU MIG-21-1@HOT)', "Provide CAP support by flying to the south over the mountains and engage with any unidentified aircraft. Protect our Su-25T planes from any unexpected air threats." ..
							                                                            "NATO airbases are in red alert. NATO air defenses are on their way to Gori Valley." ) )
	Mission:AddClient( CLIENT:New( 'Support: Air Patrol (RU MIG-21-2@HOT)', "Provide CAP support by flying to the south over the mountains and engage with any unidentified aircraft. Protect our Su-25T planes from any unexpected air threats." ..
							                                                            "NATO airbases are in red alert. NATO air defenses are on their way to Gori Valley." ) )

	local DESTROYGROUPSTASK = DESTROYGROUPSTASK:New( 'Patriots', 'Patriot Batteries', { 'US SAM Patriot' }, 75  ) -- 75% of a patriot battery needs to be destroyed to achieve mission success...
	DESTROYGROUPSTASK:SetGoalTotal( 3 )
	Mission:AddTask( DESTROYGROUPSTASK, 1 )
	
	MISSIONSCHEDULER.AddMission( Mission )
end

do -- CCCP - The Rescue of the Russian General

  local function EventAliveEscort( Client )
    local EscortGroupHelicopter = Spawn_RU_MI28N_Escort:ReSpawn(1)
    local EscortHelicopters = ESCORT:New( Client, EscortGroupHelicopter, "Escort спасение (MI-28N)" )
  end

	local Mission = MISSION:New( 'Rescue General', 'Tactical', 'Our intelligence has received a remote signal. We believe it is a very important Russian General that was captured by Georgia. Go out there and rescue him! Ensure you stay out of the battle zone, keep south. Waypoint 4 is the location of our Russian General.', 'CCCP'  )

	Russia_Rescue_General_1 = CLIENT:New( 'Tactical: Rescue General (RU MI-8MTV2-1@HOT)', 
	                                      "Two MI-28N helicopters (Callsign 206) will lead the best route to the rescue place and are available for Air Support. " .. 
	                                      "Use the radio menu (F10) Escort options to take control of the MI-28N Air Support helicopters actions! " .. 
	                                      "Beyond waypoint 3 they will scan and attack any NATO air defenses on the route, to ensure a safe rescue behind enemy lines. " ..
										                    "Radio Communication with the two MI-28N helicopters is on VHF 136.2 AM Mhz. Configure your R-863 radio to match the frequency in the MI-8 to have situational awareness." ):Transport():Alive( EventAliveEscort )
	
	Russia_Rescue_General_2 = CLIENT:New( 'Tactical: Rescue General (RU MI-8MTV2-2@HOT)', 
	                                      "Two MI-28N helicopters (Callsign 206) will lead the best route to the rescue place. " .. 
	                                      "Use the radio menu (F10) Escort options to take control of the MI-28N Air Support helicopters actions! " .. 
	                                      "Beyond waypoint 3 they will scan and attack any NATO air defenses on the route, to ensure a safe rescue behind enemy lines. " ..
										                    "Radio Communication with the two MI-28N helicopters is on VHF 136.2 AM Mhz. Configure your R-863 radio to match the frequency in the MI-8 to have situational awareness." ):Transport():Alive( EventAliveEscort ) 
	
	Mission:AddClient( Russia_Rescue_General_1 )
	Mission:AddClient( Russia_Rescue_General_2 )
	
	Russian_General_Hiding_Zone = CARGO_ZONE:New( 'General Hiding Zone', 'General Hiding House' ):GreenFlare()
	Russian_General = CARGO_GROUP:New( 'Russian General', 'General Baluyevsky', math.random( 70, 100 ), 'Russian General',  Russian_General_Hiding_Zone )
	
	-- Assign the Pickup Task
	local PickupTask = PICKUPTASK:New( 'Russian General', CLIENT.ONBOARDSIDE.FRONT )
	PickupTask:FromZone( Russian_General_Hiding_Zone )
	PickupTask:InitCargo( { Russian_General } )
	Mission:AddTask( PickupTask, 1 ) 

	Tskinvali_Headquarters = CARGO_ZONE:New( 'Tskinvali Headquarters', 'Russia Command Center' ):RedSmoke()

		-- Assign the Deploy Tasks
	local DeployTask = DEPLOYTASK:New( 'Russian General' )
	DeployTask:ToZone( Tskinvali_Headquarters )
	DeployTask:SetGoalTotal( 1 )
	Mission:AddTask( DeployTask, 2 )

	-- Assign the GoHome Task
	local GoHomeTask = GOHOMETASK:New( 'Russia MI-8MTV2 Troops Transport Home Base' )
	Mission:AddTask( GoHomeTask, 3 )
	
	MISSIONSCHEDULER.AddMission( Mission )

end

do -- CCCP - Deliver packages to secret agent
	local Mission = MISSION:New( 'Package Delivery', 'Operational', 'In order to be in full control of the situation, we need you to deliver a very important package at a secret location. Fly undetected through the NATO defenses and deliver the secret package. The secret agent is located at waypoint 4.', 'CCCP'  )

	local KA50Client1 = CLIENT:New( 'Operational: Package Delivery (RU KA-50-1@HOT)' ):Transport()
	local KA50Client2 = CLIENT:New( 'Operational: Package Delivery (RU KA-50-2@HOT)' ):Transport()
	local KA50Client3 = CLIENT:New( 'Operational: Package Delivery (RU KA-50-3@RAMP)' ):Transport()
	local KA50Client4 = CLIENT:New( 'Operational: Package Delivery (RU KA-50-4@RAMP)' ):Transport()
	
	Mission:AddClient( KA50Client1 )
	Mission:AddClient( KA50Client2 )
	Mission:AddClient( KA50Client3 )
	Mission:AddClient( KA50Client4 )
	
	CCCP_Package_Delivery_Zone = CARGO_ZONE:New( 'Russia Secret Drop Zone', 'Secret Agent Armed House' ):RedSmoke()

	Cargo_Package = CARGO_PACKAGE:New( 'Map', 'Secret Map to Infiltrate Defenses', 0.1, KA50Client1 )

	local DeployTask = DEPLOYTASK:New( 'Map' )
	DeployTask:ToZone( CCCP_Package_Delivery_Zone )
	DeployTask:InitCargo( { Cargo_Package } )
	DeployTask:SetGoalTotal( 1 )
	Mission:AddTask( DeployTask, 1 )

	-- Assign the GoHome Task
	local GoHomeTask = GOHOMETASK:New( 'Russia Alpha' )
	Mission:AddTask( GoHomeTask, 2 )

	MISSIONSCHEDULER.AddMission( Mission )
end

-- NATO MISSIONS

do -- NATO - Transport Mission to activate the NATO Patriot Defenses

	PatriotActivation = { 
		[ "US Patriot Battery 1 Activation" ] = { "US SAM Patriot Zerti", false },
		[ "US Patriot Battery 2 Activation" ] = { "US SAM Patriot Zegduleti", false },
		[ "US Patriot Battery 3 Activation" ] = { "US SAM Patriot Gvleti", false }
	}

	function DeployPatriotTroopsGoal( Mission, Client )


		-- Check if the cargo is all deployed for mission success.
		for CargoID, CargoData in pairs( CARGOS ) do
			if CargoData.CargoGroupName then
				CargoGroup = Group.getByName( CargoData.CargoGroupName )
				if CargoGroup then
					-- Check if the cargo is ready to activate
					CurrentLandingZoneID = routines.IsPartOfGroupInZones( CargoGroup, Mission:GetTask( 2 ).LandingZones.LandingZoneNames ) -- The second task is the Deploytask to measure mission success upon
					if CurrentLandingZoneID then
						if PatriotActivation[CurrentLandingZoneID][2] == false then
							-- Now check if this is a new Mission Task to be completed...
							trigger.action.setGroupAIOn( Group.getByName( PatriotActivation[CurrentLandingZoneID][1] ) )
							PatriotActivation[CurrentLandingZoneID][2] = true
							MESSAGE:New( "Message to all airborne units! The " .. PatriotActivation[CurrentLandingZoneID][1] .. " is armed. Our air defenses are now stronger.", 
							             "Mission Command:", 60, "BLUE/PatriotDefense" ):ToBlue()
							MESSAGE:New( "Our satellite systems are detecting additional NATO air defenses. To all airborne units: Take care!!!", 
										 "Mission Command:", 60, "RED/PatriotDefense" ):ToRed()
							Mission:GetTask( 2 ):AddGoalCompletion( "Patriots activated", PatriotActivation[CurrentLandingZoneID][1], 1 ) -- Register Patriot activation as part of mission goal.
						end
					end
				end
			end
		end
	end

	local Mission = MISSION:New( 'NATO Transport Troops', 'Operational', 'Transport 3 groups of air defense engineers from our barracks "Gold" and "Titan" to each patriot battery control center to activate our air defenses.', 'NATO' )
	Mission:AddGoalFunction( DeployPatriotTroopsGoal )
	
	Mission:AddClient( CLIENT:New( 'Operational: Deploy Troops (US UH-1H-1@HOT)', 'Transport 3 groups of air defense engineers from our barracks "Gold" and "Titan" to each patriot battery control center to activate our air defenses.' ):Transport() )
  Mission:AddClient( CLIENT:New( 'Operational: Deploy Troops (US UH-1H-2@HOT)', 'Transport 3 groups of air defense engineers from our barracks "Gold" and "Titan" to each patriot battery control center to activate our air defenses.' ):Transport() )
	Mission:AddClient( CLIENT:New( 'Operational: Deploy Troops (US UH-1H-3@RAMP)', 'Transport 3 groups of air defense engineers from our barracks "Gold" and "Titan" to each patriot battery control center to activate our air defenses.' ):Transport() )
	Mission:AddClient( CLIENT:New( 'Operational: Deploy Troops (US UH-1H-4@RAMP)', 'Transport 3 groups of air defense engineers from our barracks "Gold" and "Titan" to each patriot battery control center to activate our air defenses.' ):Transport() )

	local CargoTable = {}
	local EngineerNames = { "Controller", "Expert", "Radar", "Electrician" }

	NATO_Gold_Pickup_Zone = CARGO_ZONE:New( 'NATO Gold Pickup Zone', 'NATO Gold Coordination Center' ):BlueSmoke()
    NATO_Titan_Pickup_Zone = CARGO_ZONE:New( 'NATO Titan Pickup Zone', 'NATO Titan Coordination Center' ):RedSmoke()

	for CargoItem = 1, 2 do
		CargoTable[CargoItem] = CARGO_GROUP:New( 'NATO Engineers', 'Engineering Team ' .. EngineerNames[CargoItem], 
		                                          math.random( 70, 100 ) * 2, 
												  'US Infantry Gold',  
												  NATO_Gold_Pickup_Zone )
	end

	for CargoItem = 3, 4 do
		CargoTable[CargoItem] = CARGO_GROUP:New( 'NATO Engineers', 'Engineering Team ' .. EngineerNames[CargoItem], 
		                                          math.random( 70, 100 ) * 2, 
												  'US Infantry Titan',  
												  NATO_Titan_Pickup_Zone )
	end

	local PickupTask = PICKUPTASK:New( 'NATO Engineers', CLIENT.ONBOARDSIDE.RIGHT )
	PickupTask:FromZone( NATO_Gold_Pickup_Zone )
	PickupTask:FromZone( NATO_Titan_Pickup_Zone )
	PickupTask:InitCargo( CargoTable )
	Mission:AddTask( PickupTask, 1 )

	US_Patriot_Battery_1_Activation = CARGO_ZONE:New( "US Patriot Battery 1 Activation", "US SAM Patriot - Battery 1 Control" ):WhiteFlare()
	US_Patriot_Battery_2_Activation = CARGO_ZONE:New( "US Patriot Battery 2 Activation", "US SAM Patriot - Battery 2 Control" ):WhiteFlare()
	US_Patriot_Battery_3_Activation = CARGO_ZONE:New( "US Patriot Battery 3 Activation", "US SAM Patriot - Battery 3 Control" ):WhiteFlare()
	
	local DeployTask = DEPLOYTASK:New( 'NATO Engineers' )
	DeployTask:ToZone( US_Patriot_Battery_1_Activation )
	DeployTask:ToZone( US_Patriot_Battery_2_Activation )
	DeployTask:ToZone( US_Patriot_Battery_3_Activation )
	DeployTask:SetGoalTotal( 3 )
	DeployTask:SetGoalTotal( 3, "Patriots activated" )
	Mission:AddTask( DeployTask, 2 )

	MISSIONSCHEDULER.AddMission( Mission )
end

do -- NATO Destroy Mission SA-6 Batteries
	local Mission = MISSION:New( 'SA-6 SAMs', 'Primary', 'Our intelligence reports that 3 SA-6 SAM defense batteries are located near Didmukha, Khetagurov and Berula. Eliminate the Russian SAMs.', 'NATO'  )

  local function Escort_A10C_Kutaisi( Client )
    local EscortGroup = Spawn_US_F16A_Escort_A10C_Kutaisi:ReSpawn(1)
    local Escort = ESCORT:New( Client, EscortGroup, "Escort Air Defenses (F-16A)" )
  end

	Mission:AddClient( CLIENT:New( 'Primary: Attack Air Defenses (BE KA-50-1@HOT)', "Execute a CAS in Gori Valley, eliminating the SA-6 launchers and other ground vehicles. Waypoint 2 to 4 are your primary targets. Beware approaching CCCP air support from the north and the west. Fly low and slow, and scan the area before engaging. Good luck!" ) )
	Mission:AddClient( CLIENT:New( 'Primary: Attack Air Defenses (BE KA-50-2@HOT)', "Execute a CAS in Gori Valley, eliminating the SA-6 launchers and other ground vehicles. Waypoint 2 to 4 are your primary targets. Beware approaching CCCP air support from the north and the west. Fly low and slow, and scan the area before engaging. Good luck!" ) )
	Mission:AddClient( CLIENT:New( 'Primary: Attack Air Defenses (BE KA-50-3@RAMP)', "Execute a CAS in Gori Valley, eliminating the SA-6 launchers and other ground vehicles. Waypoint 2 to 4 are your primary targets. Beware approaching CCCP air support from the north and the west. Fly low and slow, and scan the area before engaging. Good luck!" ) )
	Mission:AddClient( CLIENT:New( 'Primary: Attack Air Defenses (BE KA-50-4@RAMP)', "Execute a CAS in Gori Valley, eliminating the SA-6 launchers and other ground vehicles. Waypoint 2 to 4 are your primary targets. Beware approaching CCCP air support from the north and the west. Fly low and slow, and scan the area before engaging. Good luck!" ) )

	Mission:AddClient( CLIENT:New( 'Primary: Attack Air Defenses (US A-10A-1@HOT)', "Fly to the west and execute a CAS in Gori Valley, eliminating the SA-6 launchers and other ground vehicles. Waypoint 2 to 4 are your primary targets. Beware approaching CCCP air support from the north and the west. Expect heavy AAA and air defense ground units within Gori Valley." ) )
	Mission:AddClient( CLIENT:New( 'Primary: Attack Air Defenses (US A-10A-2@HOT)', "Fly to the west and execute a CAS in Gori Valley, eliminating the SA-6 launchers and other ground vehicles. Waypoint 2 to 4 are your primary targets. Beware approaching CCCP air support from the north and the west. Expect heavy AAA and air defense ground units within Gori Valley." ) )
	Mission:AddClient( CLIENT:New( 'Primary: Attack Air Defenses (US A-10A-3@RAMP)', "Fly to the west and execute a CAS in Gori Valley, eliminating the SA-6 launchers and other ground vehicles. Waypoint 2 to 4 are your primary targets. Beware approaching CCCP air support from the north and the west. Expect heavy AAA and air defense ground units within Gori Valley." ) )
	Mission:AddClient( CLIENT:New( 'Primary: Attack Air Defenses (US A-10A-4@RAMP)', "Fly to the west and execute a CAS in Gori Valley, eliminating the SA-6 launchers and other ground vehicles. Waypoint 2 to 4 are your primary targets. Beware approaching CCCP air support from the north and the west. Expect heavy AAA and air defense ground units within Gori Valley." ) )

	Mission:AddClient( CLIENT:New( 'Primary: Attack Air Defenses (GE SU-25T-1@HOT)', "Fly to the west and execute a SEAD attack in Gori Valley, eliminating the SA-6 radars. Waypoint 2 to 4 are your primary targets. Beware approaching CCCP air support from the north and the west. Expect heavy AAA and air defense ground units within Gori Valley." ) )
	Mission:AddClient( CLIENT:New( 'Primary: Attack Air Defenses (GE SU-25T-2@HOT)', "Fly to the west and execute a SEAD attack in Gori Valley, eliminating the SA-6 radars. Waypoint 2 to 4 are your primary targets. Beware approaching CCCP air support from the north and the west. Expect heavy AAA and air defense ground units within Gori Valley." ) )
	Mission:AddClient( CLIENT:New( 'Primary: Attack Air Defenses (GE SU-25T-3@RAMP)', "Fly to the west and execute a SEAD attack in Gori Valley, eliminating the SA-6 radars. Waypoint 2 to 4 are your primary targets. Beware approaching CCCP air support from the north and the west. Expect heavy AAA and air defense ground units within Gori Valley." ) )
	Mission:AddClient( CLIENT:New( 'Primary: Attack Air Defenses (GE SU-25T-4@RAMP)', "Fly to the west and execute a SEAD attack in Gori Valley, eliminating the SA-6 radars. Waypoint 2 to 4 are your primary targets. Beware approaching CCCP air support from the north and the west. Expect heavy AAA and air defense ground units within Gori Valley." ) )

	Mission:AddClient( CLIENT:New( 'Primary: Attack Air Defenses (US A-10C-1@HOT)', "Fly to the east and execute a CAS in Gori Valley, eliminating the SA-6 launchers and other ground vehicles. Waypoint 2 to 4 are your primary targets. Beware approaching CCCP air support from the north and the west. Expect heavy AAA and air defense ground units within Gori Valley." )
	                         :Alive(Escort_A10C_Kutaisi) )
	Mission:AddClient( CLIENT:New( 'Primary: Attack Air Defenses (US A-10C-2@HOT)', "Fly to the east and execute a CAS in Gori Valley, eliminating the SA-6 launchers and other ground vehicles. Waypoint 2 to 4 are your primary targets. Beware approaching CCCP air support from the north and the west. Expect heavy AAA and air defense ground units within Gori Valley." )
	                         :Alive(Escort_A10C_Kutaisi) )
	Mission:AddClient( CLIENT:New( 'Primary: Attack Air Defenses (US A-10C-3@RAMP)', "Fly to the east and execute a CAS in Gori Valley, eliminating the SA-6 launchers and other ground vehicles. Waypoint 2 to 4 are your primary targets. Beware approaching CCCP air support from the north and the west. Expect heavy AAA and air defense ground units within Gori Valley." )
	                         :Alive(Escort_A10C_Kutaisi) )
	Mission:AddClient( CLIENT:New( 'Primary: Attack Air Defenses (US A-10C-4@RAMP)', "Fly to the east and execute a CAS in Gori Valley, eliminating the SA-6 launchers and other ground vehicles. Waypoint 2 to 4 are your primary targets. Beware approaching CCCP air support from the north and the west. Expect heavy AAA and air defense ground units within Gori Valley." )
	                         :Alive(Escort_A10C_Kutaisi) )

	Mission:AddClient( CLIENT:New( 'Support: Air Patrol (US F-15C-1@HOT)', "Fly to the east and provide CAP of supporting A-10A and A-10C planes. Waypoint 1 follows direction Gori Valley. Waypoint 2 to 4 is your CAP area in the mountains in the North. Beware of approaching CCCP air support from the north and the west. Expect heavy AAA and air defenses within Gori Valley. Land at Kutaisi." ) )
	Mission:AddClient( CLIENT:New( 'Support: Air Patrol (US F-15C-2@HOT)', "Fly to the east and provide CAP of supporting A-10A and A-10C planes. Waypoint 1 follows direction Gori Valley. Waypoint 2 to 4 is your CAP area in the mountains in the North. Beware of approaching CCCP air support from the north and the west. Expect heavy AAA and air defenses within Gori Valley. Land at Kutaisi." ) )
	Mission:AddClient( CLIENT:New( 'Support: Air Patrol (US F-15C-3@RAMP)', "Fly to the east and provide CAP of supporting A-10A and A-10C planes. Waypoint 1 follows direction Gori Valley. Waypoint 2 to 4 is your CAP area in the mountains in the North. Beware of approaching CCCP air support from the north and the west. Expect heavy AAA and air defenses within Gori Valley. Land at Kutaisi." ) )
	Mission:AddClient( CLIENT:New( 'Support: Air Patrol (US F-15C-4@RAMP)', "Fly to the east and provide CAP of supporting A-10A and A-10C planes. Waypoint 1 follows direction Gori Valley. Waypoint 2 to 4 is your CAP area in the mountains in the North. Beware of approaching CCCP air support from the north and the west. Expect heavy AAA and air defenses within Gori Valley. Land at Kutaisi." ) )

	Mission:AddClient( CLIENT:New( 'Support: Air Patrol (FR MIRAGE-2000-1@HOT)', "Fly to the east and provide CAP while defending our A-10A and A-10C planes moving towards Gori Valley. Beware of approaching CCCP air support from the north and the west. Expect heavy AAA and air defenses within Gori Valley. Land at Kutaisi." ) )
	Mission:AddClient( CLIENT:New( 'Support: Air Patrol (FR MIRAGE-2000-2@HOT)', "Fly to the east and provide CAP while defending our A-10A and A-10C planes moving towards Gori Valley. Beware of approaching CCCP air support from the north and the west. Expect heavy AAA and air defenses within Gori Valley. Land at Kutaisi." ) )
	Mission:AddClient( CLIENT:New( 'Support: Air Patrol (FR MIRAGE-2000-3@RAMP)', "Fly to the east and provide CAP while defending our A-10A and A-10C planes moving towards Gori Valley. Beware of approaching CCCP air support from the north and the west. Expect heavy AAA and air defenses within Gori Valley. Land at Kutaisi." ) )
	Mission:AddClient( CLIENT:New( 'Support: Air Patrol (FR MIRAGE-2000-4@RAMP)', "Fly to the east and provide CAP while defending our A-10A and A-10C planes moving towards Gori Valley. Beware of approaching CCCP air support from the north and the west. Expect heavy AAA and air defenses within Gori Valley. Land at Kutaisi." ) )

	
	Mission:AddClient( CLIENT:New( 'Support: Air Patrol (FR C-101CC-1@HOT)', "Fly to Gori Valley and attack ground defenses, while defending our A-10A and A-10C planes. Beware of approaching CCCP air support from the north and the west. Expect heavy AAA and air defenses within Gori Valley. Land at Kutaisi." ) )
	Mission:AddClient( CLIENT:New( 'Support: Air Patrol (FR C-101CC-2@HOT)', "Fly to Gori Valley and attack ground defenses, while defending our A-10A and A-10C planes. Beware of approaching CCCP air support from the north and the west. Expect heavy AAA and air defenses within Gori Valley. Land at Tbilisi." ) )
	
	local DESTROYGROUPSTASK = DESTROYGROUPSTASK:New( 'SA-6 SAMs', 'SA-6 SAM Batteries', { 'RU SA-6 Kub' } )
	DESTROYGROUPSTASK:SetGoalTotal( 3 )
	Mission:AddTask( DESTROYGROUPSTASK, 1 )
	
	MISSIONSCHEDULER.AddMission( Mission )
end

do -- NATO "Fury" Sling Load Mission

	function DeployCargoGoal( Mission, Client )
		if routines.IsUnitInZones( Client:GetDCSGroup():getUnit(1), 'Cargo 1 - Arrival' ) ~= nil then
			Mission:GetTask( 2 ):AddGoalCompletion( "Cargo sling load", "Cargo", 1 ) 
		end
	end

	local Mission = MISSION:New( 'NATO Sling Load', 'Operational', 'Fly to the cargo pickup zone at Dzegvi or Kaspi, and sling the cargo to Soganlug airbase.', 'NATO' )
	Mission:AddGoalFunction( DeployCargoGoal )
	
	Mission:AddClient( CLIENT:New( 'Operational: Transport Cargo (BE UH-1H-1*HOT)', 'Fly to Dzegvi or Kaspi and hook-up cargo, sling the cargo to Soganlug airbase. Smoke signals will be given upon arrival. Important note: Due to a bug in DCS World since version 1.2.12, this sling load mission cannot be correctly governed. The Cargo arrival and position cannot be measured anymore, thus, only your helicopter will be measured for the moment. Mission success will only be dependent on the position of your helicopter until this bug is fixed by Eagle Dynamics.' ) )
  Mission:AddClient( CLIENT:New( 'Operational: Transport Cargo (BE UH-1H-2*HOT)', 'Fly to Dzegvi or Kaspi and hook-up cargo, sling the cargo to Soganlug airbase. Smoke signals will be given upon arrival. Important note: Due to a bug in DCS World since version 1.2.12, this sling load mission cannot be correctly governed. The Cargo arrival and position cannot be measured anymore, thus, only your helicopter will be measured for the moment. Mission success will only be dependent on the position of your helicopter until this bug is fixed by Eagle Dynamics.' ) )
	Mission:AddClient( CLIENT:New( 'Operational: Transport Cargo (BE UH-1H-3*RAMP)', 'Fly to Dzegvi or Kaspi and hook-up cargo, sling the cargo to Soganlug airbase. Smoke signals will be given upon arrival. Important note: Due to a bug in DCS World since version 1.2.12, this sling load mission cannot be correctly governed. The Cargo arrival and position cannot be measured anymore, thus, only your helicopter will be measured for the moment. Mission success will only be dependent on the position of your helicopter until this bug is fixed by Eagle Dynamics.' ) )
  Mission:AddClient( CLIENT:New( 'Operational: Transport Cargo (BE UH-1H-4*RAMP)', 'Fly to Dzegvi or Kaspi and hook-up cargo, sling the cargo to Soganlug airbase. Smoke signals will be given upon arrival. Important note: Due to a bug in DCS World since version 1.2.12, this sling load mission cannot be correctly governed. The Cargo arrival and position cannot be measured anymore, thus, only your helicopter will be measured for the moment. Mission success will only be dependent on the position of your helicopter until this bug is fixed by Eagle Dynamics.' ) )
	
	NATO_Sling_Load_Pickup_Zone = CARGO_ZONE:New( 'NATO Sling Load Pickup Zone', 'Georgia Cargo Pickup Guard' ):BlueSmoke()
	NATO_Sling_Load = CARGO_SLINGLOAD:New( 'Ammunition', 'Ammunition Boxes', 400, 'NATO Sling Load Pickup Zone', 'Georgia Cargo Guard', country.id.GEORGIA )

	
	local PickupTask = PICKUPTASK:New( 'Ammunition', CLIENT.ONBOARDSIDE.FRONT )
	PickupTask:FromZone( NATO_Sling_Load_Pickup_Zone  )
	PickupTask:InitCargo( { NATO_Sling_Load } )
	Mission:AddTask( PickupTask, 1 )

	NATO_Sling_Load_Deploy_Zone = CARGO_ZONE:New( 'NATO Sling Load Deploy Zone', 'Georgia Cargo Deploy Guard' ):BlueSmoke()
	
	local DeployTask = DEPLOYTASK:New( 'Ammunition' )
	DeployTask:ToZone( NATO_Sling_Load_Deploy_Zone  )
	DeployTask:SetGoalTotal( 1 )
	Mission:AddTask( DeployTask, 2 )

	MISSIONSCHEDULER.AddMission( Mission )
end

do -- NATO - Rescue secret agent from the woods

  local function EventAliveEscort( Client )
    local EscortGroupHelicopter = Spawn_NL_AH64A_Escort:ReSpawn(1)
    local EscortHelicopters = ESCORT:New( Client, EscortGroupHelicopter, "Escort Rescue (AH-64A)" )
  end



	local Mission = MISSION:New( 'Rescue secret agent', 'Tactical', 
	                             "In order to be in full control of the situation, we need you to rescue a secret agent behind enemy lines. " .. 
	                             "Avoid the Russian defenses and rescue the agent. Keep south until Khasuri, and keep your eyes open for any SAM presence. " .. 
								               "The agent is located at waypoint 4 on your kneeboard.", 'NATO'  )

	NATO_Rescue_Secret_Agent_1 = CLIENT:New( 'Tactical: Rescue Secret Agent (DE MI-8MTV2-1@HOT)', 
	                                         "Two AH-64A helicopters (Callsign Pontiac 9-1) will lead the best route to the rescue place and are available for Air Support. " .. 
	                                         "Use the radio menu (F10) Escort options to take control of the MI-28N Air Support helicopters actions! " .. 
	                                         "Beyond waypoint 3 they will attack any Russian air defenses to ensure a safe rescue behind enemy lines. " ..
											                     "Radio Communication with the two AH-64A helicopters is on VHF 132.4 AM Mhz. Configure your R-863 radio to match the frequency." ):Transport():Alive( EventAliveEscort )
	NATO_Rescue_Secret_Agent_2 = CLIENT:New( 'Tactical: Rescue Secret Agent (DE MI-8MTV2-2@HOT)', 
	                                         "Two KA-50 helicopters (Callsign Pontiac 9-1) will lead the best route to the rescue place and are available for Air Support. " .. 
	                                         "Use the radio menu (F10) Escort options to take control of the MI-28N Air Support helicopters actions! " .. 
	                                         "Beyond waypoint 3 they will attack any Russian air defenses to ensure a safe rescue behind enemy lines. " ..
											                     "Radio Communication with the two AH-64A helicopters is on VHF 132.4 AM Mhz. Configure your R-863 radio to match the frequency." ):Transport():Alive( EventAliveEscort )
	
	Mission:AddClient( NATO_Rescue_Secret_Agent_1 )
	Mission:AddClient( NATO_Rescue_Secret_Agent_2 )

	NATO_Secret_Agent_Hiding_Zone = CARGO_ZONE:New( 'NATO secret agent hiding zone', 'Isolated Watch Tower' ):BlueSmoke()
	NATO_Secret_Agent = CARGO_GROUP:New( 'Secret Agent', 'Ryszard Kukliński', math.random( 70, 100 ), 'NATO Secret Agent',  NATO_Secret_Agent_Hiding_Zone )
	
	-- Assign the Pickup Task
	local PickupTask = PICKUPTASK:New( 'Secret Agent', CLIENT.ONBOARDSIDE.FRONT )
	PickupTask:FromZone( NATO_Secret_Agent_Hiding_Zone )
	PickupTask:InitCargo( { NATO_Secret_Agent } )
	Mission:AddTask( PickupTask, 1 ) 

	Gori_Headquarters = CARGO_ZONE:New( 'Gori Headquarters Drop Zone', 'Gori Headquarters' ):RedSmoke()

		-- Assign the Deploy Tasks
	local DeployTask = DEPLOYTASK:New( 'Secret Agent' )
	DeployTask:ToZone( Gori_Headquarters )
	DeployTask:SetGoalTotal( 1 )
	Mission:AddTask( DeployTask, 2 )

	-- Assign the GoHome Task
	local GoHomeTask = GOHOMETASK:New( 'NATO Gori Home Bases' )
	Mission:AddTask( GoHomeTask, 3 )
	
	MISSIONSCHEDULER.AddMission( Mission )
end



-- MISSION SCHEDULER STARTUP
MISSIONSCHEDULER.Start()
MISSIONSCHEDULER.ReportMenu()
MISSIONSCHEDULER.ReportMissionsFlash( 120 )
MISSIONSCHEDULER.ReportMissionsHide()

env.info( "Gori Valley.lua loaded" )

