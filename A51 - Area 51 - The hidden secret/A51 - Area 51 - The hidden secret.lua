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

AG_Ground_001 = SPAWN
  :New( "AG-Ground #001" )
  :InitLimit( 20, 60 )
  :InitRandomizeTemplate( AG_Templates )
  :InitRandomizeRoute( 1, 0, 8000 )
  :InitArray( 290, 50, 30, 40 )
  :SpawnScheduled( 450, 1 )
  
AG_Ground_002 = SPAWN
  :New( "AG-Ground #002" )
  :InitLimit( 20, 60 )
  :InitRandomizeTemplate( AG_Templates )
  :InitRandomizeRoute( 1, 0, 8000 )
  :InitArray( 345, 50, 30, 40 )
  :SpawnScheduled( 450, 1 )
  
AG_Ground_003 = SPAWN
  :New( "AG-Ground #003" )
  :InitLimit( 20, 60 )
  :InitRandomizeTemplate( AG_Templates )
  :InitRandomizeRoute( 1, 0, 8000 )
  :InitArray( 15, 50, 30, 40 )
  :SpawnScheduled( 450, 1 )
  
AG_Ground_004 = SPAWN
  :New( "AG-Ground #004" )
  :InitLimit( 20, 60 )
  :InitRandomizeTemplate( AG_Templates )
  :InitRandomizeRoute( 1, 0, 8000 )
  :InitArray( 30, 50, 30, 40 )
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
  :InitLimit( 10, 30 )
  :InitRandomizeTemplate( US_Templates )
  :InitRandomizeRoute( 1, 0, 8000 )
  :InitArray( 30, 50, 30, 40 )
  :SpawnScheduled( 900, 1 )
  
US_Ground_002 = SPAWN
  :New( "US-Ground #002" )
  :InitLimit( 10, 30 )
  :InitRandomizeTemplate( US_Templates )
  :InitRandomizeRoute( 1, 0, 8000 )
  :InitArray( 345, 50, 30, 40 )
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
        "Expect some heavy resistance in the area!"
      , coalition.side.BLUE )
  :AddScoring( Scoring )

US_FAC = SET_GROUP:New():FilterPrefixes( "US FAC" ):FilterCoalitions( "blue" ):FilterStart()

US_Detection = DETECTION_AREAS:New( US_FAC, 3000 )

US_Attack = SET_GROUP:New():FilterCoalitions( "blue" ):FilterPrefixes( "US Attack" ):FilterStart()

TaskDispatcher = TASK_A2G_DISPATCHER:New( US_M1, US_Attack, US_Detection )


MissileTrainer = MISSILETRAINER:New( 100, "Missiles will be destroyed for training when they reach your plane." )
