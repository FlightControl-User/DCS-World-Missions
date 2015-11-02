MISSIONSCHEDULER.Start()
MISSIONSCHEDULER.ReportMenu()
MISSIONSCHEDULER.ReportMissionsFlash( 10 )

SpawnTest = SPAWN:New( 'TEST' ):Schedule( 1, 1, 15, 0.4 ):Repeat()

SpawnTestPlane = SPAWN:New( 'TESTPLANE' ):Schedule( 1, 1, 15, 0.4 ):RepeatOnLanding()

SpawnTestShipPlane = SPAWN:New( 'SHIPPLANE' ):Schedule( 1, 1, 15, 0.4 ):RepeatOnLanding()

SpawnTestShipHeli = SPAWN:New( 'SHIPHELI' ):Schedule( 1, 1, 15, 0.4 ):RepeatOnLanding()

SpawnCH53E = SPAWN:New( 'VEHICLE' )
