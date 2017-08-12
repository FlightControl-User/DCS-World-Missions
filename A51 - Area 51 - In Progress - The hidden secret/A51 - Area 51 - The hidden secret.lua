-- USAF Agressors Ground Defenses

AG_Templates =
  { 'AG-Ground TEMP #001',
    'AG-Ground TEMP #002',
    'AG-Ground TEMP #003',
    'AG-Ground TEMP #004',
    'AG-Ground TEMP #005',
    'AG-Ground TEMP #006',
    'AG-Ground TEMP #007',
    'AG-Ground TEMP #008'
  }


SpawnZone = ZONE_POLYGON:New( "SpawnZone", GROUP:FindByName( "SPAWNZONE" ) )


AG_Ground_Zone = SPAWN
  :New( "AG-Ground Zone" )
  :InitLimit( 10, 40 )
  :InitRandomizeTemplate( AG_Templates )
  :InitRandomizeZones( { SpawnZone } )
  :SpawnScheduled( 600, 1 )
  

AG_Ground_001 = SPAWN
  :New( "AG-Ground #001" )
  :InitLimit( 12, 60 )
  :InitRandomizeTemplate( AG_Templates )
  :InitRandomizeRoute( 1, 0, 8000 )
  --:InitArray( 290, 50, 30, 40 )
  :SpawnScheduled( 450, 1 )
  

AG_Ground_002 = SPAWN
  :New( "AG-Ground #002" )
  :InitLimit( 12, 60 )
  :InitRandomizeTemplate( AG_Templates )
  :InitRandomizeRoute( 1, 0, 8000 )
  --:InitArray( 345, 50, 30, 40 )
  :SpawnScheduled( 450, 1 )
  

AG_Ground_003 = SPAWN
  :New( "AG-Ground #003" )
  :InitLimit( 12, 60 )
  :InitRandomizeTemplate( AG_Templates )
  :InitRandomizeRoute( 1, 0, 8000 )
  --:InitArray( 15, 50, 30, 40 )
  :SpawnScheduled( 450, 1 )
  

AG_Ground_004 = SPAWN
  :New( "AG-Ground #004" )
  :InitLimit( 12, 60 )
  :InitRandomizeTemplate( AG_Templates )
  :InitRandomizeRoute( 1, 0, 8000 )
  --:InitArray( 30, 50, 30, 40 )
  :SpawnScheduled( 450, 1 )


US_Templates =
  { 'US-Ground TEMP #001',
    'US-Ground TEMP #002',
    'US-Ground TEMP #003',
    'US-Ground TEMP #004',
    'US-Ground TEMP #005'
  }

US_Ground_001 = SPAWN
  :New( "US-Ground #001" )
  :InitLimit( 4, 30 )
  :InitRandomizeTemplate( US_Templates )
  :InitRandomizeRoute( 1, 0, 8000 )
  --:InitArray( 30, 50, 30, 40 )
  :SpawnScheduled( 900, 1 )
  
US_Ground_002 = SPAWN
  :New( "US-Ground #002" )
  :InitLimit( 4, 30 )
  :InitRandomizeTemplate( US_Templates )
  :InitRandomizeRoute( 1, 0, 8000 )
  --:InitArray( 345, 50, 30, 40 )
  :SpawnScheduled( 900, 1 )

-- Setup the Human Player Part

-- Define the MISSION

US_HQ = GROUP:FindByName( "US HQ" )

US_CC = COMMANDCENTER:New( US_HQ, "Command" )

Scoring = SCORING:New( "NTTR - Area 51" )

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
  :AddScoring( Scoring )

US_FAC = SET_GROUP:New():FilterPrefixes( "US FAC" ):FilterCoalitions( "blue" ):FilterStart()

US_Detection = DETECTION_AREAS:New( US_FAC, 3000 )

US_Attack = SET_GROUP:New():FilterCoalitions( "blue" ):FilterPrefixes( "US Attack" ):FilterStart()

TaskDispatcher = TASK_A2G_DISPATCHER:New( US_M1, US_Attack, US_Detection )

MissileTrainer = MISSILETRAINER:New( 100, "Missiles will be destroyed for training when they reach your plane." )

Designate = DESIGNATE:New( US_CC, US_Detection, US_Attack, US_M1 )
Designate:GenerateLaserCodes()


---- AI GCICAP for RED

A2ADispatcher = AI_A2A_GCICAP:New( { "AG-Ewr" }, { "AG-Defenses" }, { "AG-Cap" }, 2, 6000, 30000, 70000 )

A2ADispatcher:SetTacticalDisplay( false )

A2ADispatcher:SetDefaultTakeoffFromParkingCold()
A2ADispatcher:SetDefaultLandingAtRunway()
A2ADispatcher:SetDefaultFuelThreshold( 0.30 )
A2ADispatcher:SetIntercept( 300 )
A2ADispatcher:SetDisengageRadius( 70000 )
A2ADispatcher:SetDefaultTanker("AG-Tanker")
