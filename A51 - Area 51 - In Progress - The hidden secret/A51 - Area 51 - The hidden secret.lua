-- USAF Agressors Ground Defenses

do -- SPAWN for RED, the attacking groups!

  -- SPAWN creates new GROUP objects in the sim in various ways.

  -- Setup a list of template names in AG_Templates.
  AG_Templates =
    { 'AG-Ground TEMP #001',
      'AG-Ground TEMP #002',
      'AG-Ground TEMP #003',
      'AG-Ground TEMP #004',
      'AG-Ground TEMP #005',
      'AG-Ground TEMP #006',
      'AG-Ground TEMP #007',
      'AG-Ground TEMP #008',
      'AG-Ground TEMP #009',
      'AG-Ground TEMP #010',
      'AG-Ground TEMP #011',
      'AG-Ground TEMP #012'
    }
  
  
  -- Setup a ZONE_POLYGON object SpawnZone. 
  -- with the name the zone SpawnZone.
  -- using the waypoints of the group "SPAWNZONE".
  SpawnZone = ZONE_POLYGON:New( "SpawnZone", GROUP:FindByName( "SPAWNZONE" ) )
  
  
  -- Setup a SPAWN object AG_Ground_Zone.
  -- With the group name "AG-Ground Zone", which is a late activated group.
  AG_Ground_Zone = SPAWN:New( "AG-Ground Zone" )

  -- Maximum 30 units alive at the same time, 40 groups in stock.
  AG_Ground_Zone:InitLimit( 30, 40 )

  -- Randomize from the list AG_Templates when spawning.
  AG_Ground_Zone:InitRandomizeTemplate( AG_Templates )

  -- Randomize the positions of the new spawned GROUP objects in SpawnZone.
  AG_Ground_Zone:InitRandomizeZones( { SpawnZone } )

  -- Schedule every 450 seconds a new GROUP with a 50% variation, so between 90 and 810 seconds.
  AG_Ground_Zone:SpawnScheduled( 450, 0.80 )
  
  
  -- Setup a SPAWN object AG-Ground_001.
  -- With the group name "AG-Ground #001", which is a late activated group.
  AG_Ground_001 = SPAWN:New( "AG-Ground #001" )
  
  -- Maximum 12 units alive at the same time, 60 groups in stock.
  AG_Ground_001:InitLimit( 12, 60 )
  
  -- Randomize from the list AG_Templates when spawning.
  AG_Ground_001:InitRandomizeTemplate( AG_Templates )
  
  -- Randomize the routes, starting from WP 1, till the last WP, within a radius of 8000 meters.
  AG_Ground_001:InitRandomizeRoute( 1, 0, 8000 )
  
  -- Schedule every 800 seconds a new GROUP with a 50% variation, so between 400 and 1200 seconds.
  AG_Ground_001:SpawnScheduled( 800, 0.5 )
  --:InitArray( 290, 50, 30, 40 ) -- disabled due to bug in DCS world MP.
  
  
  -- Same
  AG_Ground_002 = SPAWN
    :New( "AG-Ground #002" )
    :InitLimit( 12, 60 )
    :InitRandomizeTemplate( AG_Templates )
    :InitRandomizeRoute( 1, 0, 8000 )
    --:InitArray( 345, 50, 30, 40 )
    :SpawnScheduled( 800, 0.5 )
  
  
  -- Same
  AG_Ground_003 = SPAWN
    :New( "AG-Ground #003" )
    :InitLimit( 12, 60 )
    :InitRandomizeTemplate( AG_Templates )
    :InitRandomizeRoute( 1, 0, 8000 )
    --:InitArray( 15, 50, 30, 40 )
    :SpawnScheduled( 800, 0.5 )
  
  
  -- Same
  AG_Ground_004 = SPAWN
    :New( "AG-Ground #004" )
    :InitLimit( 12, 60 )
    :InitRandomizeTemplate( AG_Templates )
    :InitRandomizeRoute( 1, 0, 8000 )
    --:InitArray( 30, 50, 30, 40 )
    :SpawnScheduled( 800, 0.5 )

end

do -- SPAWN for BLUE.


  -- SPAWN creates new GROUP objects in the sim in various ways.

  -- Setup a list of template names in US_Templates.
  US_Templates =
    { 'US-Ground TEMP #001',
      'US-Ground TEMP #002',
      'US-Ground TEMP #003',
      'US-Ground TEMP #004',
      'US-Ground TEMP #005'
    }

  -- Setup a SPAWN object US_Ground_001.
  -- With the group name US-Ground #001, which is a late activated group.
  US_Ground_001 = SPAWN:New( "US-Ground #001" )
  
  -- Maximum 4 units alive at the same time, 30 groups in stock.
  US_Ground_001:InitLimit( 4, 30 )
  
  -- Randomize from the list US_Templates when spawning.
  US_Ground_001:InitRandomizeTemplate( US_Templates )
  
  -- Randomize the routes, starting from WP 1, till the last WP, within a radius of 8000 meters.
  US_Ground_001:InitRandomizeRoute( 1, 0, 8000 )

  -- Schedule every 900 seconds a new GROUP with a 100% variation, so between 0 and 900 seconds.
  US_Ground_001:SpawnScheduled( 900, 1 )

  -- Pre-defined visible groups are not synced to the clients when activated.
  --:InitArray( 30, 50, 30, 40 ) is not used due to a bug in DCS world MP. 


  -- Same fo US_Ground_002.  
  US_Ground_002 = SPAWN
    :New( "US-Ground #002" )
    :InitLimit( 4, 30 )
    :InitRandomizeTemplate( US_Templates )
    :InitRandomizeRoute( 1, 0, 8000 )
    --:InitArray( 345, 50, 30, 40 )
    :SpawnScheduled( 900, 1 )

end





do -- SPAWN Tanker for RED

  US_AWACS_Spawn = SPAWN
    :New( "AG A2A Tanker" )
    :InitLimit( 1, 4 )
    :InitRepeatOnLanding()
    :SpawnScheduled( 120, 0.4)

end




do -- GROUP for BLUE of the COMMAND CENTER.
 
  -- A GROUP is a wrapper class of a group object in the sim.
  
  -- Setup a GROUP object US_HQ. 
  US_HQ = GROUP:FindByName( "US HQ" )

end


do -- COMMANDCENTER for BLUE.

  -- A COMMANDCENTER governs MISSIONs and facilitates communication to players.
  -- A real object in the sim is a command center.
  
  -- Setup a COMMANDCENTER object US_CC.
  -- With the GROUP object US_HQ, which is the real object in the sim.
  -- With the CC name "Command".
  US_CC = COMMANDCENTER:New( US_HQ, "Command" )

end


do -- SCORING for RED and BLUE.

  -- SCORING governs the allocation of points or penalties upon player achievements.
  -- Default achievements are the destruction of targets.
  -- Points are calculated taking the threat level of the target and the level of unit the player was in.
  -- So destroys done by a player with a less capable airplane destroying dangerous targets, gives more scores.
  -- A file name can be given that writes the player achievements to a csv file.

  -- Setup a SCORING object Scoring.
  -- With a file name NTTR - Area 51.
  
  Scoring = SCORING:New( "NTTR - Area 51" )

end
  

do -- MISSION for blue, the main mission.

  -- MISSION governs a logical mission consisting of tasks and other activities for a coalition.
  -- Multiple MISSION objects can be allocated for one COMMANDCENTER object.
  
  -- Setup a MISSION object US_M1.
  -- For the COMMANDCENTER object US_CC.
  -- With the mission name "Uncover".
  -- With a priority "High".
  -- With a mission briefing.
  -- For the blue coalition.

  US_M1 = MISSION
    :New( US_CC, "Uncover", "High",
      "Ground forces are on their way towards the valleys Tonopah Test Range Airfield.\n" ..
      "Engage with the enemy and try to eliminate as much as possible the identified ground forces!\n" ..
      "Expect some heavy resistance in the area!\n" ..
      "You'll see some SEAD, CAS and BAI taskings appear. Those are tasks defined by the command center 'Command'.\n" ..
      "Just be aware that this is a dynamic environment, so, the FACs may report changes on the battlefield resulting in task changes.\n" ..
      "Select a task using the radio menu (F10) to join one of these tasks and destroy the targets.\n" ..
      "Use the Task Reports to get an overview of the different tasks.\n" ..
      "A missile trainer is active to train your missile evading skills.\n" ..
      "The FAC can designate targets for you through laser, to use laser guided rockets.\n"
      , coalition.side.BLUE )
    
  
  -- Setup extra scores to be granted when mission goals (tasks) are met.  
  US_M1:AddScoring( Scoring )
  
  US_M2 = MISSION
    :New( US_CC, "Shield", "Tactical",
      "Ground forces are on their way towards the valleys Tonopah Test Range Airfield.\n" ..
      "A2A defenses are expected to depart from Tonapah!\n" ..
      "Expect some heavy resistance in the area!\n" ..
      "Provide air support and engage any airborne intruder."
      , coalition.side.BLUE )
    
  
  -- Setup extra scores to be granted when mission goals (tasks) are met.  
  US_M2:AddScoring( Scoring )
  
  
end





do -- SET_GROUP for BLUE of the FACs.

  -- SET_GROUP is a collection of GROUP objects, with dynamic filtering.
  -- So when GROUP objects are created, deleted, the collection will be automatically updated.
  
  US_FAC = SET_GROUP:New()
  
  -- Filter the blue coalition groups.
  US_FAC:FilterCoalitions( "blue" )

  -- Filter only those groups that start with the name "US Attack".
  US_FAC:FilterPrefixes( "US FAC" )

  -- Setup Dynamic filtering.
  US_FAC:FilterStart()
  
end

do -- DETECTION_AREAS for blue.

  -- DETECTION_AREAS is a detection algorithm that detects targets using a SET_GROUP object 
  -- having group objects that have units with detection capabilities.
  -- Detected units are grouped within AREAS using a specified radius in meters.

  -- Define a new DETECTION_AREAS object US_A2G_Detection.
  -- With the SET_GROUP object collection US_Fac, that contains the FAC groups detecting the enemy units.
  -- With a grouping radius of 3000 meters.
  US_A2G_Detection = DETECTION_AREAS:New( US_FAC, 3000 )
  --US_A2G_Detection:InitDetectVisual( true )
  --US_A2G_Detection:InitDetectRWR( true )
  --US_A2G_Detection:InitDetectOptical( true )
  --US_A2G_Detection:InitDetectIRST( true )
  --US_A2G_Detection:InitDetectDLINK( true )
  --US_Detection:SetDistanceProbability( 0.9 )

end


do -- SET_GROUP for BLUE of the FACs.

  -- SET_GROUP is a collection of GROUP objects, with dynamic filtering.
  -- So when GROUP objects are created, deleted, the collection will be automatically updated.
  
  US_Ewr = SET_GROUP:New()
  
  -- Filter the blue coalition groups.
  US_Ewr:FilterCoalitions( "blue" )

  -- Filter only those groups that start with the name "US Attack".
  US_Ewr:FilterPrefixes( "US EWR" )

  -- Setup Dynamic filtering.
  US_Ewr:FilterStart()
  
end





do -- DETECTION_AREAS for blue.

  -- DETECTION_AREAS is a detection algorithm that detects targets using a SET_GROUP object 
  -- having group objects that have units with detection capabilities.
  -- Detected units are grouped within AREAS using a specified radius in meters.

  -- Define a new DETECTION_AREAS object US_A2A_Detection.
  -- With the SET_GROUP object collection US_Awacs, that contains the AWACS groups detecting the enemy units.
  -- With a grouping radius of 15000 meters.
  US_A2A_Detection = DETECTION_AREAS:New( US_Ewr, 15000 )
  US_A2A_Detection:InitDetectRadar( true )

end


do -- SET_GROUP for BLUE of the Attackers

  -- SET_GROUP is a collection of GROUP objects, with dynamic filtering.
  -- We setup an A2G US_A2G_Attack object collection.
  -- So when GROUP objects are created, deleted, the collection will be automatically updated.
  
  US_A2G_Attack = SET_GROUP:New()

  -- Filter the blue coalition groups.
  US_A2G_Attack:FilterCoalitions( "blue" )

  -- Filter only those groups that start with the name "US Attack".
  US_A2G_Attack:FilterPrefixes( "US A2G Attack" )

  -- Setup Dynamic filtering.
  US_A2G_Attack:FilterStart()

end


do -- SET_GROUP for BLUE of the Attackers

  -- SET_GROUP is a collection of GROUP objects, with dynamic filtering.
  -- We setup an A2A US_A2A_Attack object collection.
  -- So when GROUP objects are created, deleted, the collection will be automatically updated.
  
  US_A2A_Attack = SET_GROUP:New()

  -- Filter the blue coalition groups.
  US_A2A_Attack:FilterCoalitions( "blue" )

  -- Filter only those groups that start with the name "US Attack".
  US_A2A_Attack:FilterPrefixes( "US A2A Attack" )

  -- Setup Dynamic filtering.
  US_A2A_Attack:FilterStart()

end


do -- TASK_A2G_DISPATCHER for BLUE

  -- TASK_A2G_DISPATCHER scans the detection results, and dispatches new A2G tasks to the BLUE players to eliminate detected targets.
  -- With the MISSION object US_M1, which is the main mission.
  -- With the SET_GROUP object US_Attack, which contains a collection of the player planes and other attack units (like ground).
  -- With the DETECTION_AREAS object US_Detection, which contains the detections grouped per AREA with a defined radius.

  TaskA2GDispatcher = TASK_A2G_DISPATCHER:New( US_M1, US_A2G_Attack, US_A2G_Detection )

end


do -- TASK_A2A_DISPATCHER for BLUE

  TaskA2ADispatcher = TASK_A2A_DISPATCHER:New( US_M2, US_A2A_Attack, US_A2A_Detection )

end  


do -- DESIGNATE for BLUE

  -- DESIGNATE will perform target designation and mark targets by FAC presence.
  -- 
  -- DESIGNATE has an easy setup, and multiple DESIGNATE objects are defined here.
  -- Note that the same detection object is used for both designate objects!
  
  -- Create a new DesignateSu25T object from DESIGNATE. 
  -- With the US COMMANDCENTER object US_CC.
  -- With the DETECTION_AREAS detection object US_Detection.
  -- With the SET_GROUP collection object US_Attack, which are the attacking blue planes.
  -- With the MISSION object US_M1, which is the main mission.
  DesignateSu25T = DESIGNATE:New( US_CC, US_A2G_Detection, US_A2G_Attack, US_M1 )

  -- For the SU-25T, setup laser code 1113.
  DesignateSu25T:SetLaserCodes(  1113 )

  -- This makes the DESIGNATE appear in the menu under the mission named "Designate for SU-25T".
  DesignateSu25T:SetDesignateName( "SU-25T" )

  -- DESIGNATE documentation can be found at:
  -- http://flightcontrol-master.github.io/MOOSE/Documentation/Designate.html

end


do -- GCICAP for RED

  -- A2ADispatcher is a GCICAP object for the RED coalition.
  --
  -- This will search for the relevant objects starting with the name prefixes at the required locations,
  -- and will define a GCICAP defense system, which is setup for the RED coalition, 
  -- because the EWR is setup from those groups that start with the name "AG-Ewr", and these are of the RED coalition.
  --
  -- For each airbases indicated as RED, it will search for airplane templates that start with the name "AG-Defenses".
  --
  -- Airplane templates are groups that have one (RED) plane and have the late activated flag switched on.
  -- Each template can have a different payload, skin, skill level and plane type etc.
  -- GCICAP will spawn new planes at each airbase, taking a random template from the list.
  --
  -- A CAP zone is drawn as a polygon, by means of a group placed in the mission with the late activated flag on.
  -- The group starts with the group name "AG-Cap" and its waypoints define the polygon zone.
  --
  -- The CAP limit is set to 2, so maximum 2 CAP groups will be airborne. 
  -- By default, CAP is checked to be spawned between 180 and 600 seconds.
  --
  -- An intruder grouping radius is set to 6000 meters (6km).
  -- So intruder within 6km are considered one target out of x units.
  --
  -- The engage radius is set to 30000 meters, which means that any airborne defender without a task assigned,
  -- (like returning planes or CAP planes), will come as a candidate to engage any intruder within 30km range.
  --
  -- A GCI engage radius is set to 70km. So only GCI will commence for defense, when the intruder is within 70km.
  --
  AG_AI_A2A_Dispatcher = AI_A2A_GCICAP:New( { "AG EWR" }, { "AG A2A AI" }, { "AG-Cap" }, 2, 6000, 30000, 70000 )

  -- Disable the tactical display. This is 
  AG_AI_A2A_Dispatcher:SetTacticalDisplay( false )

  -- Change the default takeoff methods.
  AG_AI_A2A_Dispatcher:SetDefaultTakeoffFromParkingHot()
  AG_AI_A2A_Dispatcher:SetDefaultLandingAtRunway()
  
  -- Set the fuel limit to 30%, when out of fuel the plane will fly home.
  AG_AI_A2A_Dispatcher:SetDefaultFuelThreshold( 0.30 )

  -- When an airborne CAP plane is out of fuel (less than 30% left in the bank), it will refuel to the Tanker, if present.
  -- Otherwise it will return home.
  AG_AI_A2A_Dispatcher:SetDefaultTanker( "AG A2A Tanker" )
  
  -- Take 300 seconds as a time it takes to get a new plane airborne, to calculate:
  --   - The intercept point.
  --   - The optimal airbase to GCI from.
  AG_AI_A2A_Dispatcher:SetIntercept( 300 )
  
  -- When planes are further away than 70km from the Home base, disengage.
  AG_AI_A2A_Dispatcher:SetDisengageRadius( 70000 )

  -- There is more in AI_A2A_GCICAP, which you can find here:
  -- http://flightcontrol-master.github.io/MOOSE/Documentation/AI_A2A_Dispatcher.html

end


do -- GCICAP for BLUE

  -- Using the AI_A2A_GCICAP
  
  US_A2A_Dispatcher = AI_A2A_GCICAP:New( { "US EWR" }, { "US A2A Defense" }, nil, nil, 6000, 30000, 70000 )

  -- Disable the tactical display. This is 
  US_A2A_Dispatcher:SetTacticalDisplay( false )

  -- Change the default takeoff methods.
  US_A2A_Dispatcher:SetDefaultTakeoffFromParkingHot()
  US_A2A_Dispatcher:SetDefaultLandingAtRunway()
  
  -- Set the fuel limit to 30%, when out of fuel the plane will fly home.
  US_A2A_Dispatcher:SetDefaultFuelThreshold( 0.30 )

  -- Take 300 seconds as a time it takes to get a new plane airborne, to calculate:
  --   - The intercept point.
  --   - The optimal airbase to GCI from.
  US_A2A_Dispatcher:SetIntercept( 300 )
  
  -- When planes are further away than 70km from the Home base, disengage.
  US_A2A_Dispatcher:SetDisengageRadius( 70000 )

end

do -- MISSILETRAINER for BLUE

  -- Setup the MISSILETRAINER which monitors and reports on any airborne missile to the players.
  -- With a range of 100 meters to destroy the missile if near a blue player.
  -- With a briefing text.
  MissileTrainer = MISSILETRAINER:New( 100, "Missiles will be destroyed for training when they reach your plane." )

  -- MISSILETRAINER documentation can be found at:
  -- http://flightcontrol-master.github.io/MOOSE/Documentation/MissileTrainer.html

end

do -- SPAWN AWACS for BLUE

  US_AWACS_Spawn = SPAWN
    :New( "US EWR AWACS" )
    :InitLimit( 1, 4 )
    :InitRepeatOnLanding()
    :OnSpawnGroup(
      function( AwacsGroup )
        US_AWACS_Zone = ZONE_GROUP:New( "Zone AWACS", AwacsGroup, 10000 )
        US_A2A_Dispatcher:SetSquadronCap( "Creech AFB", US_AWACS_Zone, 4000, 7500, 600, 800, 1000, 1200, "BARO" )
        US_A2A_Dispatcher:SetSquadronCapInterval( "Creech AFB", 1, 60, 120 )  
      end
    )
    :SpawnScheduled( 120, 0.4)

end
