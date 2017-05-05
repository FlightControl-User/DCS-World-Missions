--- Gori Valley designed with the MOOSE framework for DCS World.
-- Author: FlightControl


-- CCCP COALITION UNITS

-- Russian helicopters engaging the battle field in Gori Valley
Spawn_RU_KA50 = SPAWN
  :New( "RU KA-50@HOT-Patriot Attack" )
  :InitLimit( 1, 24 ) 
  :InitRandomizeRoute( 1, 1, 8000 )
  :InitCleanUp( 180 )
  :SpawnScheduled( 1200, 0.2 )

-- Russian ground troops attacking Gori Valley
Spawn_RU_Troops =
  { 'RU Attack Gori 1',
    'RU Attack Gori 2',
    'RU Attack Gori 3',
    'RU Attack Gori 4',
    'RU Attack Gori 5',
    'RU Attack Gori 6',
    'RU Attack Gori 7',
    'RU Attack Gori 8',
    'RU Attack Gori 9',
    'RU Attack Gori 10'
  }

Spawn_RU_Troops_Left = SPAWN
  :New( "RU Attack Gori Left" )
  :InitLimit( 15, 40 )
  :InitRandomizeTemplate( Spawn_RU_Troops )
  :InitRandomizeRoute( 1, 1, 2000 )
  :InitArray( 349, 30, 20, 30 )
  :SpawnScheduled( 30, 1 )

Spawn_RU_Troops_Middle = SPAWN
  :New( "RU Attack Gori Middle" )
  :InitLimit( 15, 40 )
  :InitRandomizeTemplate( Spawn_RU_Troops )
  :InitRandomizeRoute( 1, 1, 2000 )
  :InitArray( 260, 50, 20, 25 )
  :SpawnScheduled( 30, 1 )

Spawn_RU_Troops_Right = SPAWN
  :New( "RU Attack Gori Right" )
  :InitLimit( 15, 40 )
  :InitRandomizeTemplate( Spawn_RU_Troops )
  :InitRandomizeRoute( 1, 1, 2000 )
  :InitArray( 238, 50, 20, 25 )
  :SpawnScheduled( 30, 1 )
  

-- NATO Tank Platoons invading Tskinvali

Spawn_US_Platoon =
  { 'US Tank Platoon 1',
    'US Tank Platoon 2',
    'US Tank Platoon 3',
    'US Tank Platoon 4',
    'US Tank Platoon 5',
    'US Tank Platoon 6',
    'US Tank Platoon 7',
    'US Tank Platoon 8',
    'US Tank Platoon 9',
    'US Tank Platoon 10',
    'US Tank Platoon 11',
    'US Tank Platoon 12',
    'US Tank Platoon 13'
  }

Spawn_US_Platoon_Left = SPAWN
  :New( 'US Tank Platoon Left' )
  :InitLimit( 15, 40 )
  :InitRandomizeTemplate( Spawn_US_Platoon )
  :InitRandomizeRoute( 3, 1, 2000 )
  :InitArray( 76, 30, 15, 35 )
  :SpawnScheduled( 30, 1 )

Spawn_US_Platoon_Middle = SPAWN
  :New( 'US Tank Platoon Middle' )
  :InitLimit( 15, 40 )
  :InitRandomizeTemplate( Spawn_US_Platoon )
  :InitRandomizeRoute( 3, 1, 2000 )
  :InitArray( 160, 30, 15, 35 )
  :SpawnScheduled( 30, 1 )

Spawn_US_Platoon_Right = SPAWN
  :New( 'US Tank Platoon Right' )
  :InitLimit( 15, 40 )
  :InitRandomizeTemplate( Spawn_US_Platoon )
  :InitRandomizeRoute( 1, 1, 2000 )
  :InitArray( 90, 50, 15, 35 )
  :SpawnScheduled( 30, 1 )

-- Define a HeadQuarter that will be the Command Center.
HQGroup_US = GROUP:FindByName( "US HQ" )
CC_US = COMMANDCENTER:New( HQGroup_US, "Gori" )

-- Define the Recce groups that will detect the upcoming ground forces.
M1_RecceSet_US = SET_GROUP:New():FilterCoalitions("blue"):FilterPrefixes( "US M1 Recce" ):FilterStart()

M1_ReccePatrolArray = {}
M1_RecceSpawn_US = SPAWN
  :New( "US M1 Recce - AH-64D@RAMP-Ground Recon" )
  :InitLimit( 2, 10 )
  :SpawnScheduled( 60, 0.4 )
  :OnSpawnGroup(
    function( SpawnGroup )
      local M1_ReccePatrolZoneWP = GROUP:FindByName( "M1 Patrol Zone" )
      local M1_ReccePatrolZone = ZONE_POLYGON:New( "PatrolZone", M1_ReccePatrolZoneWP )
      local M1_ReccePatrol = AI_PATROL_ZONE:New( M1_ReccePatrolZone, 30, 50, 50, 100 )
      M1_ReccePatrolArray[#M1_ReccePatrolArray+1] = M1_ReccePatrol
      
      M1_ReccePatrol:SetControllable( SpawnGroup )
      M1_ReccePatrol:__Start( 10 ) -- It takes a bit of time for the Recce to start
    end
   )


-- Define the detection method, we'll use here AREA detection.
M1_DetectionAreas_US = DETECTION_AREAS:New( M1_RecceSet_US, 3000 )
M1_DetectionAreas_US:BoundDetectedZones()

M1_Attack_US = SET_GROUP:New():FilterCoalitions("blue"):FilterPrefixes( "US M1 Attack" ):FilterStart()

local M1 = MISSION
  :New( CC_US, "SAM-6","Primary","Destroy SAM-6 batteries", coalition.side.RED )

-- Define the Task dispatcher that will define the tasks based on the detected targets.
M1_TaskA2GDispatcher_US = TASK_A2G_DISPATCHER:New( M1, M1_Attack_US, M1_DetectionAreas_US )


-- Define a HeadQuarter that will be the Command Center.
HQGroup_RU = GROUP:FindByName( "Russia Command Center" )
CC_RU = COMMANDCENTER:New( HQGroup_RU, "Tskinvali" )


do -- RU Transport Task Engineers

  local Mission = MISSION
    :New( CC_RU, "Engineers SA-6", "Operational", "Transport 3 engineering teams to each SA-6 launch zone.", coalition.side.RED )

  M4_HeloSetGroup = SET_GROUP:New():FilterPrefixes( "RU M4 Transport SA6" ):FilterStart()

  SetCargo = SET_CARGO:New():FilterTypes( { "RU M4 Engineers" } ):FilterStart()

  EngineersCargoAlpha = CARGO_GROUP:New( GROUP:FindByName( "RU M4 Engineers Alpha" ), "RU M4 Engineers", "Team Alpha", 500 )
  EngineersCargoBeta = CARGO_GROUP:New( GROUP:FindByName( "RU M4 Engineers Beta" ), "RU M4 Engineers", "Team Beta", 500 )
  EngineersCargoGamma = CARGO_GROUP:New( GROUP:FindByName( "RU M4 Engineers Gamma" ), "RU M4 Engineers", "Team Gamma", 500 )


  CargoTransportTask = TASK_CARGO_TRANSPORT:New( Mission, M4_HeloSetGroup, "Transport SA-6 Engineers", SetCargo )
  
  Zone_SA6_1 = ZONE_GROUP:New( "SA6_1", GROUP:FindByName( "RU SA-6 Kub Moskva" ), 500 ) 
  Zone_SA6_2 = ZONE_GROUP:New( "SA6_1", GROUP:FindByName( "RU SA-6 Kub Niznij" ), 500 ) 
  Zone_SA6_3 = ZONE_GROUP:New( "SA6_1", GROUP:FindByName( "RU SA-6 Transport Yaroslavl" ), 500 )  
  
  CargoTransportTask:AddDeployZone( Zone_SA6_1 )
  CargoTransportTask:AddDeployZone( Zone_SA6_2 )
  CargoTransportTask:AddDeployZone( Zone_SA6_3 )

end


