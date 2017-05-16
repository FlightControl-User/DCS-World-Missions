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
CC_US = COMMANDCENTER:New( GROUP:FindByName( "US HQ" ), "Gori" )


do -- BLUE automatic detection 


  NATO_M1 = MISSION
    :New( CC_US, "Destroy SAM-6","Primary","Destroy SAM-6 batteries", coalition.side.BLUE )

  -- Define the Recce groups that will detect the upcoming ground forces.
  local NATO_M1_RecceSet_US = SET_GROUP:New():FilterCoalitions("blue"):FilterPrefixes( "M1 US Recce" ):FilterStart()
  
  local NATO_M1_ReccePatrolArray = {}
  local NATO_M1_RecceSpawn_US = SPAWN
    :New( "M1 US Recce@RAMP" )
    :InitLimit( 2, 10 )
    :SpawnScheduled( 60, 0.4 )
    :InitCleanUp( 300 )
    :OnSpawnGroup(
      function( SpawnGroup )
        local M1_ReccePatrolZoneWP = GROUP:FindByName( "M1 US Patrol Zone@ZONE" )
        local M1_ReccePatrolZone = ZONE_POLYGON:New( "PatrolZone", M1_ReccePatrolZoneWP )
        local M1_ReccePatrol = AI_PATROL_ZONE:New( M1_ReccePatrolZone, 30, 50, 50, 100 )
        NATO_M1_ReccePatrolArray[#NATO_M1_ReccePatrolArray+1] = M1_ReccePatrol
        
        M1_ReccePatrol:SetControllable( SpawnGroup )
        M1_ReccePatrol:__Start( 10 ) -- It takes a bit of time for the Recce to start
      end
     )
  
  
  -- Define the detection method, we'll use here AREA detection.
  local NATO_M1_DetectionAreas_US = DETECTION_AREAS:New( NATO_M1_RecceSet_US, 1500 )
  --M1_DetectionAreas_US:BoundDetectedZones()
  
  local NATO_M1_Attack_US = SET_GROUP:New():FilterCoalitions("blue"):FilterPrefixes( "M1 US Attack" ):FilterStart()
  
  -- Define the Task dispatcher that will define the tasks based on the detected targets.
  NATO_M1_TaskA2GDispatcher = TASK_A2G_DISPATCHER:New( NATO_M1, NATO_M1_Attack_US, NATO_M1_DetectionAreas_US )

end


do -- NATO Transport Task Engineers

  NATO_M4_Patriots = MISSION
    :New( CC_US, 
          "Engineers Patriots", 
          "Operational", 
          "Transport 3 engineering teams to three strategical Patriot launch sites. " ..
            "The launch sites are not yet complete and need some special launch codes to be delivered. " ..
            "The engineers have the knowledge to install these launch codes. " ..
            "Pickup Engineers Alpha, Beta and Gamma from their current location, and drop them near the Patriot launchers. " ..
            "Deployment zones have been defined at each Patriot location.", 
          coalition.side.BLUE )

  local NATO_M4_HeloSetGroup = SET_GROUP:New():FilterPrefixes( "M4 US Patriot Transport" ):FilterStart()

  local NATO_M4_SetCargo = SET_CARGO:New():FilterTypes( { "Patriot Engineers" } ):FilterStart()

  local EngineersCargo1 = CARGO_GROUP:New( GROUP:FindByName( "M4 US Engineers Bear" ), "Patriot Engineers", "Team Bear", 500 )
  local EngineersCargo2 = CARGO_GROUP:New( GROUP:FindByName( "M4 US Engineers Moose" ), "Patriot Engineers", "Team Moose", 500 )
  local EngineersCargo3 = CARGO_GROUP:New( GROUP:FindByName( "M4 US Engineers Falcon" ), "Patriot Engineers", "Team Falcon", 500 )


  local CargoTransportTask = TASK_CARGO_TRANSPORT:New( NATO_M4_Patriots, NATO_M4_HeloSetGroup, "Transport SA-6 Engineers", NATO_M4_SetCargo )
  
  -- These are the groups of the SA-6 batteries.
  local Patriots1 = GROUP:FindByName( "M4 US Patriot North" ):SetAIOff()
  local Patriots2 = GROUP:FindByName( "M4 US Patriot West" ):SetAIOff()
  local Patriots3 = GROUP:FindByName( "M4 US Patriot East" ):SetAIOff()
  
  -- Each SA-6 battery has a zone of type ZONE_GROUP. That makes these zone moveable as they drive around the battle field!
  local Zone_Patriots1 = ZONE_GROUP:New( "Patriots North", Patriots1, 500 )
  local Zone_Patriots2 = ZONE_GROUP:New( "Patriots West", Patriots2, 500 )
  local Zone_Patriots3 = ZONE_GROUP:New( "Patriots East", Patriots3, 500 ) 
  
  -- Add to the CargoTransportTask these SA-6 battery zones.
  CargoTransportTask:AddDeployZone( Zone_Patriots1 )
  CargoTransportTask:AddDeployZone( Zone_Patriots2 )
  CargoTransportTask:AddDeployZone( Zone_Patriots3 )


  --- OnAfter Transition Handler for Event CargoDeployed.
  -- This event will handle after deployment the activation of the SA-6 site.
  -- @function [parent=#TASK_CARGO_TRANSPORT] OnAfterCargoDeployed
  -- @param Tasking.Task_CARGO#TASK_CARGO_TRANSPORT self
  -- @param #string From The From State string.
  -- @param #string Event The Event string.
  -- @param #string To The To State string.
  -- @param Wrapper.Unit#UNIT TaskUnit The Unit (Client) that Deployed the cargo. You can use this to retrieve the PlayerName etc.
  -- @param Core.Cargo#CARGO Cargo The Cargo that got PickedUp by the TaskUnit. You can use this to check Cargo Status.
  -- @param Core.Zone#ZONE DeployZone The zone where the Cargo got Deployed or UnBoarded.
  function CargoTransportTask:OnAfterCargoDeployed( From, Event, To, TaskUnit, Cargo, DeployZone )
    self:E( { From, Event, To, TaskUnit, Cargo, DeployZone } )
  
    local DeployZoneName = DeployZone:GetName()
    local CargoName = Cargo:GetName()
  
  
    CC_US:MessageToCoalition( 
      string.format( "Engineers %s are successfully transported to patriot site %s.", 
                     CargoName, 
                     DeployZoneName 
                   ) 
    )
    
    if DeployZoneName == Zone_Patriots1:GetName() then
      if Patriots1 and not Patriots1:IsAlive() then
        Patriots1:SetAIOn()
      end
    end

    if DeployZoneName == Zone_Patriots2:GetName() then
      if Patriots2 and not Patriots2:IsAlive() then
        Patriots2:SetAIOn()
      end
    end

    if DeployZoneName == Zone_Patriots3:GetName() then
      if Patriots3 and not Patriots3:IsAlive() then
        Patriots3:SetAIOn()
      end
    end
    
    if self:IsAllCargoTransported() then
      self:Success()
      NATO_M4_Patriots:Complete()
    end
  end

end



-- Define a HeadQuarter that will be the Command Center.
CC_RU = COMMANDCENTER:New( GROUP:FindByName( "Russia Command Center" ), "Tskinvali" )



do -- CCCP 

  CCCP_M1 = MISSION
    :New( CC_RU, 
          "Destroy Patriots",
          "Primary",
          "Destroy Patriot batteries.", 
          coalition.side.RED
        )

  -- Define the Recce groups that will detect the upcoming ground forces.
  local CCCP_M1_RecceSet_RU = SET_GROUP:New():FilterCoalitions("red"):FilterPrefixes( "M1 RU Recce" ):FilterStart()
  
  local CCCP_M1_ReccePatrolArray = {}
  local CCCP_M1_RecceSpawn = SPAWN
    :New( "M1 RU Recce AH-64@HOT" )
    :InitLimit( 2, 10 )
    :SpawnScheduled( 60, 0.4 )
    :OnSpawnGroup(
      function( SpawnGroup )
        local M1_ReccePatrolZoneWP = GROUP:FindByName( "M1 RU Patrol Zone@ZONE" )
        local M1_ReccePatrolZone = ZONE_POLYGON:New( "PatrolZone", M1_ReccePatrolZoneWP )
        local M1_ReccePatrol = AI_PATROL_ZONE:New( M1_ReccePatrolZone, 30, 50, 50, 100 )
        CCCP_M1_ReccePatrolArray[#CCCP_M1_ReccePatrolArray+1] = M1_ReccePatrol
        
        M1_ReccePatrol:SetControllable( SpawnGroup )
        M1_ReccePatrol:__Start( 20 ) -- It takes a bit of time for the Recce to start
      end
     )
  
  
  -- Define the detection method, we'll use here AREA detection.
  local CCCP_M1_DetectionAreas_RU = DETECTION_AREAS:New( CCCP_M1_RecceSet_RU, 1500 )
  --M1_DetectionAreas_US:BoundDetectedZones()
  
  local CCCP_M1_Attack_RU = SET_GROUP:New():FilterCoalitions("red"):FilterPrefixes( "M1 RU Attack" ):FilterStart()
  CCCP_M1_Attack_RU:Flush()
  
  
  -- Define the Task dispatcher that will define the tasks based on the detected targets.
  CCCP_M1_TaskA2GDispatcher = TASK_A2G_DISPATCHER:New( CCCP_M1, CCCP_M1_Attack_RU, CCCP_M1_DetectionAreas_RU )

end

do -- CCCP Transport Task Engineers

  CCCP_M4_SA6 = MISSION
    :New( CC_RU, 
          "Engineers SA-6", 
          "Operational", 
          "Transport 3 engineering teams to three strategical SA-6 launch sites. " ..
            "The launch sites are not yet complete and need some special launch codes to be delivered. " ..
            "The engineers have the knowledge to install these launch codes. " ..
            "Pickup Engineers Alpha, Beta and Gamma from their current location, and drop them near the SA-6 launchers. " ..
            "Deployment zones have been defined at each SA-6 location.", 
          coalition.side.RED )

  local CCCP_M4_HeloSetGroup = SET_GROUP:New():FilterPrefixes( "RU SA6 Transport" ):FilterStart()

  local CCCP_M4_SA6_SetCargo = SET_CARGO:New():FilterTypes( { "SA6 Engineers" } ):FilterStart()

  local EngineersCargoAlpha = CARGO_GROUP:New( GROUP:FindByName( "M4 RU Engineers Alpha" ), "SA6 Engineers", "Team Alpha", 500 )
  local EngineersCargoBeta = CARGO_GROUP:New( GROUP:FindByName( "M4 RU Engineers Beta" ), "SA6 Engineers", "Team Beta", 500 )
  local EngineersCargoGamma = CARGO_GROUP:New( GROUP:FindByName( "M4 RU Engineers Gamma" ), "SA6 Engineers", "Team Gamma", 500 )


  local CargoTransportTask = TASK_CARGO_TRANSPORT:New( CCCP_M4_SA6, CCCP_M4_HeloSetGroup, "Transport SA-6 Engineers", CCCP_M4_SA6_SetCargo )
  
  -- These are the groups of the SA-6 batteries.
  local SA6_1 = GROUP:FindByName( "M4 RU SA6 Kub Moskva" ):SetAIOff()
  local SA6_2 = GROUP:FindByName( "M4 RU SA6 Kub Niznij" ):SetAIOff()
  local SA6_3 = GROUP:FindByName( "M4 RU SA6 Kub Yaroslavl" ):SetAIOff()
  
  -- Each SA-6 battery has a zone of type ZONE_GROUP. That makes these zone moveable as they drive around the battle field!
  local Zone_SA6_1 = ZONE_GROUP:New( "SA6 Moskva", SA6_1, 500 )
  local Zone_SA6_2 = ZONE_GROUP:New( "SA6 Niznij", SA6_2, 500 )
  local Zone_SA6_3 = ZONE_GROUP:New( "SA6 Yaroslavl", SA6_3, 500 ) 
  
  -- Add to the CargoTransportTask these SA-6 battery zones.
  CargoTransportTask:AddDeployZone( Zone_SA6_1 )
  CargoTransportTask:AddDeployZone( Zone_SA6_2 )
  CargoTransportTask:AddDeployZone( Zone_SA6_3 )


  --- OnAfter Transition Handler for Event CargoDeployed.
  -- This event will handle after deployment the activation of the SA-6 site.
  -- @function [parent=#TASK_CARGO_TRANSPORT] OnAfterCargoDeployed
  -- @param Tasking.Task_CARGO#TASK_CARGO_TRANSPORT self
  -- @param #string From The From State string.
  -- @param #string Event The Event string.
  -- @param #string To The To State string.
  -- @param Wrapper.Unit#UNIT TaskUnit The Unit (Client) that Deployed the cargo. You can use this to retrieve the PlayerName etc.
  -- @param Core.Cargo#CARGO Cargo The Cargo that got PickedUp by the TaskUnit. You can use this to check Cargo Status.
  -- @param Core.Zone#ZONE DeployZone The zone where the Cargo got Deployed or UnBoarded.
  function CargoTransportTask:OnAfterCargoDeployed( From, Event, To, TaskUnit, Cargo, DeployZone )
    self:E( { From, Event, To, TaskUnit, Cargo, DeployZone } )
  
    local DeployZoneName = DeployZone:GetName()
    local CargoName = Cargo:GetName()
  
  
    CC_RU:MessageToCoalition( 
      string.format( "Engineers %s are successfully transported to SA-6 site %s.", 
                     CargoName, 
                     DeployZoneName 
                   ) 
    )
    
    if DeployZoneName == Zone_SA6_1:GetName() then
      if SA6_1 and not SA6_1:IsAlive() then
        SA6_1:SetAIOn()
      end
    end

    if DeployZoneName == Zone_SA6_2:GetName() then
      if SA6_2 and not SA6_2:IsAlive() then
        SA6_2:SetAIOn()
      end
    end

    if DeployZoneName == Zone_SA6_3:GetName() then
      if SA6_3 and not SA6_3:IsAlive() then
        SA6_3:SetAIOn()
      end
    end
    
    if self:IsAllCargoTransported() then
      self:Success()
      CCCP_M4_SA6:Complete()
    end
  end

end

MissileTrainer = MISSILETRAINER:New( 100, "Helps with missile tracking" )


