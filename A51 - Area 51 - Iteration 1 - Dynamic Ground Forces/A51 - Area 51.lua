
AG_Ground_Templates = {
  "AG-Ground Template #001",
  "AG-Ground Template #002",
  "AG-Ground Template #003",
  "AG-Ground Template #004",
  "AG-Ground Template #005",
  "AG-Ground Template #006",
  "AG-Ground Template #007",
  "AG-Ground Template #008"
}

AG_Ground_001_Spawn = SPAWN:New( "AG-Ground #001" )

AG_Ground_001_Spawn:InitLimit( 12, 40 )
AG_Ground_001_Spawn:InitRandomizeTemplate( AG_Ground_Templates )
AG_Ground_001_Spawn:InitRandomizeRoute( 7, 0, 8000 )
AG_Ground_001_Spawn:InitArray( 330, 2, 50, 10 )
AG_Ground_001_Spawn:SpawnScheduled( 360, 0.8 )

AG_Ground_002_Spawn = SPAWN:New( "AG-Ground #002" )
AG_Ground_002_Spawn:InitLimit( 12, 40 )
AG_Ground_002_Spawn:InitRandomizeTemplate( AG_Ground_Templates )
AG_Ground_002_Spawn:InitRandomizeRoute( 4, 0, 8000 )
AG_Ground_002_Spawn:InitArray( 330, 2, 50, 10 )
AG_Ground_002_Spawn:SpawnScheduled( 360, 0.8 )

AG_Ground_003_Spawn = SPAWN:New( "AG-Ground #003" )
AG_Ground_003_Spawn:InitLimit( 12, 40 )
AG_Ground_003_Spawn:InitRandomizeTemplate( AG_Ground_Templates )
AG_Ground_003_Spawn:InitRandomizeRoute( 3, 0, 8000 )
AG_Ground_003_Spawn:InitArray( 330, 2, 50, 10 )
AG_Ground_003_Spawn:SpawnScheduled( 360, 0.8 )

AG_Ground_004_Spawn = SPAWN:New( "AG-Ground #004" )
AG_Ground_004_Spawn:InitLimit( 12, 40 )
AG_Ground_004_Spawn:InitRandomizeTemplate( AG_Ground_Templates )
AG_Ground_004_Spawn:InitRandomizeRoute( 4, 0, 8000 )
AG_Ground_004_Spawn:InitArray( 330, 2, 50, 10 )
AG_Ground_004_Spawn:SpawnScheduled( 360, 0.8 )


US_HQ = GROUP:FindByName( "US-HQ #001" )

US_CC = COMMANDCENTER:New( US_HQ, "Command")

US_M1 = MISSION:New(US_CC, "A2G Training", "Primary", 
                    "You've joined this training mission. Attack as many ground targets as possible.", 
                    coalition.side.BLUE )
                    
US_Attack = SET_GROUP:New():FilterCoalitions("blue"):FilterPrefixes("US-Attack"):FilterStart()


US_EWR = SET_GROUP:New():FilterCoalitions( "blue" ):FilterPrefixes( "US-EWR" ):FilterStart()

US_Detection = DETECTION_AREAS:New( US_EWR, 1500 )

US_A2G_Task_Dispatcher = TASK_A2G_DISPATCHER:New( US_M1, US_Attack, US_Detection )

