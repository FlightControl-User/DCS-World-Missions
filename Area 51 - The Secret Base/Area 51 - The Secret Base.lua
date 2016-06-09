
--[[
This is the Gori valley main mission lua file. 

It contains:
- the declaration of 8 missions, 4 for blue, 4 for red.
- the declaration of the spawning units within the battle scene.
- the declaration of SEAD defenses of the SAM units within the battle scene.
- the declaration of movement monitoring to avoid a large CPU usage.

Notes:
- Due to several bugs related to CARGO, it is currently impossible to model correctly the sling-load logic.
  I had to implement several workarounds to ensure that still a sling-load mission is possible to be working.
  Problems that can occur are that sometimes the cargos will not be available, though they will be visible for the pilot...  

--]]

-- MOOSE include files.



















-- *** RED ***

-- Russian ground vehicles defending Area 51
Spawn_RU_Ground = { 'RU GROUND 1', 'RU GROUND 2', 'RU GROUND 3', 'RU GROUND 4', 'RU GROUND 5' }
Spawn_RU_Ground_Route_1 = SPAWN:New( 'RU GROUND ROUTE 1' ):Limit( 16, 150 ):Schedule( 150, 0.5 ):RandomizeTemplate( Spawn_RU_Ground ):RandomizeRoute( 1, 0, 1500 )
Spawn_RU_Ground_Route_2 = SPAWN:New( 'RU GROUND ROUTE 2' ):Limit( 16, 150 ):Schedule( 150, 0.5 ):RandomizeTemplate( Spawn_RU_Ground ):RandomizeRoute( 1, 0, 1500 )
Spawn_RU_Ground_Route_3 = SPAWN:New( 'RU GROUND ROUTE 3' ):Limit( 16, 150 ):Schedule( 150, 0.5 ):RandomizeTemplate( Spawn_RU_Ground ):RandomizeRoute( 1, 0, 1500 )

-- Russian air units attacking Creech

Spawn_RU_MI_17M4_Attack_Creech = SPAWN:New( 'RU MI-17M4@AI-Attack Creech' ):Limit( 4, 24 ):Schedule( 300, 0.25 ):RandomizeRoute( 1, 1, 1000 )





-- *** BLUE ***

-- US ground vehicles attacking Area 51
Spawn_US_Ground = { 'US GROUND 1', 'US GROUND 2', 'US GROUND 3', 'US GROUND 4', 'US GROUND 5' }
Spawn_US_Ground_Route_1 = SPAWN:New( 'US GROUND ROUTE 1' ):Limit( 16, 150 ):Schedule( 150, 0.5 ):RandomizeTemplate( Spawn_US_Ground ):RandomizeRoute( 2, 0, 1500 )
Spawn_US_Ground_Route_2 = SPAWN:New( 'US GROUND ROUTE 2' ):Limit( 16, 150 ):Schedule( 150, 0.5 ):RandomizeTemplate( Spawn_US_Ground ):RandomizeRoute( 3, 0, 1500 )
Spawn_US_Ground_Route_3 = SPAWN:New( 'US GROUND ROUTE 3' ):Limit( 16, 150 ):Schedule( 150, 0.5 ):RandomizeTemplate( Spawn_US_Ground ):RandomizeRoute( 17, 0, 1500 )

Spawn_US_F5E_Creech_Defenses = SPAWN:New( 'US F-5E@AI-Creech Air Defenses' ):Limit( 4, 24 ):Schedule( 300, 0.25 ):RandomizeRoute( 1, 1, 1000 )

Spawn_US_Inf_Sgt = SPAWN:New( "US Infantry@AI-Staff Ground Troops" )

