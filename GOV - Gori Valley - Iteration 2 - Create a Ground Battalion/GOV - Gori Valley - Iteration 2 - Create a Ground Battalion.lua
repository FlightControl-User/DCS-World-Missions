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
  :InitLimit(40,150)
  :InitRandomizeTemplate( Spawn_RU_Troops )
  :InitRandomizeRoute( 1, 1, 2000 )
  :InitArray( 349, 30, 20, 30 )
  :SpawnScheduled( 30, 1 )

Spawn_RU_Troops_Middle = SPAWN
  :New( "RU Attack Gori Middle" )
  :InitLimit( 40, 150 )
  :InitRandomizeTemplate( Spawn_RU_Troops )
  :InitRandomizeRoute( 1, 1, 2000 )
  :InitArray( 260, 50, 20, 25 )
  :SpawnScheduled( 30, 1 )

Spawn_RU_Troops_Right = SPAWN
  :New( "RU Attack Gori Right" )
  :InitLimit( 40, 150 )
  :InitRandomizeTemplate( Spawn_RU_Troops )
  :InitRandomizeRoute( 1, 1, 2000 )
  :InitArray( 238, 50, 20, 25 )
  :SpawnScheduled( 30, 1 )
  