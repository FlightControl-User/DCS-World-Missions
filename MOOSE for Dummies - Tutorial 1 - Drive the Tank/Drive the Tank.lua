
PlaneGroup = GROUP:FindByName( "Plane" )

ZoneTo = ZONE:New("ZONE")

--- @param Wrapper.Group#GROUP RoutedGroup
function ReRoute( VehicleGroup )

  --local FromCoord = VehicleGroup:GetCoordinate() -- Core.Point#COORDINATE
  --local FromWP = FromCoord:WaypointGround()

  local ZoneTo = ZoneTo -- Core.Zone#ZONE
  local ToCoord = ZoneTo:GetCoordinate()
  local ToWP = ToCoord:WaypointAir("BARO", POINT_VEC3.RoutePointType.TurningPoint,POINT_VEC3.RoutePointAction.TurningPoint,600,true)
  
  local TaskReRoute = VehicleGroup:TaskFunction( "ReRoute" )
  VehicleGroup:SetTaskWaypoint( ToWP, TaskReRoute )
  
  VehicleGroup:Route( { ToWP }, 0.5 )

end

ReRoute( PlaneGroup )
