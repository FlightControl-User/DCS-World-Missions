
Tank = SPAWN:New( "Tank" )

Zones = { ZONE:New( "ZONE1" ), ZONE:New( "ZONE2" ), ZONE:New( "ZONE3" ) }

TankGroup = Tank:Spawn()

function RouteTank()

  TankGroup:WayPointInitialize()
  local ToZone = Zones[ math.random( 1, #Zones ) ]
  local RouteTask = TankGroup:TaskRouteToZone( ToZone, false, 72, "Vee" )
  local WayPointTask = TankGroup:WayPointFunction( 1, 1, "RouteTank" )
  local CombinedTask = TankGroup:TaskCombo( { RouteTask, WayPointTask } )
  TankGroup:SetTask( RouteTask, 1 )

end

Test = AI_A2A_GCICAP:NewWithBorder(EWRPrefixes,TemplatePrefixes,BorderPrefix,CapPrefixes,CapLimit,GroupingRadius,EngageRadius,GciRadius,Resources)
