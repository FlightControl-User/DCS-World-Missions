--- Anapa Airbase Mission
--
-- This is the Anapa Airbase main mission lua file.
-- It contains:
--
-- * the declaration of 8 missions, 4 for blue, 4 for red.
-- * the declaration of the spawning units within the battle scene.
-- * the declaration of SEAD defenses of the SAM units within the battle scene.
-- * certain human player groups are escorted by other AI groups.
--
-- Notes:
-- * Due to several bugs related to CARGO, it is currently impossible to model correctly the sling-load logic.
--  I had to implement several workarounds to ensure that still a sling-load mission is possible to be working.
--  Problems that can occur are that sometimes the cargos will not be available, though they will be visible for the pilot...
--
--  @module Gori_Valley
--  @author FlightControl
--
Include.File( "Mission" )
Include.File( "Client" )
Include.File( "DeployTask" )
Include.File( "PickupTask" )
Include.File( "DestroyGroupsTask" )
Include.File( "DestroyRadarsTask" )
Include.File( "DestroyUnitTypesTask" )
Include.File( "GoHomeTask" )
Include.File( "Spawn" )
Include.File( "Movement" )
Include.File( "Sead" )
Include.File( "CleanUp" )
Include.File( "Scheduler" )


--- TODO: Need to fix problem with CountryPrefix
function Transport_TakeOff( HeliGroup, CountryPrefix )

  if CountryPrefix == 'RU' then
    HeliGroup:MessageToRed( 'Reporting ... Initiating infantry deployment.', 15 )
  else
    HeliGroup:MessageToBlue( 'Reporting ... Initiating infantry deployment.', 15 )
  end
end

--- @param Group#GROUP HeliGroup
function Transport_Reload( HeliGroup, CountryPrefix, CargoShip )
  HeliGroup:F( { CountryPrefix, CargoShip } )

  if CountryPrefix == 'RU' then
    HeliGroup:MessageToRed( "Reloading infantry.", 15 )
    local LandingZone = ZONE:New( "RU Reload")
    local DCSTaskLand = HeliGroup:TaskLandAtZone( LandingZone, 30, true )
     HeliGroup:PushTask( DCSTaskLand )
  else
    HeliGroup:MessageToBlue( "Reloading infantry.", 15 )
    local CargoShipGroup = GROUP:NewFromName( CargoShip )
  
    if CargoShipGroup:IsAlive() then
      local OrbitTask  = HeliGroup:TaskOrbitCircleAtVec2( CargoShipGroup:GetPointVec2(), 10, 0 )
      local ControlledOrbitTask = HeliGroup:TaskControlled( OrbitTask, HeliGroup:TaskCondition( nil, nil, nil, nil, 90, nil ) )
  
      HeliGroup:PushTask( ControlledOrbitTask, 1 )
    end
  end


end

function Transport_Reloaded( HeliGroup, CountryPrefix )

  if CountryPrefix == 'RU' then
    HeliGroup:MessageToRed( 'Troops loaded, flying to the deployment zone. Will contact coalition when initiating deployment.', 15 )
  else
    HeliGroup:MessageToBlue( 'Troops loaded, flying to the deployment zone. Will contact coalition when initiating deployment.', 15 )
  end
end

--- @param Group#GROUP HeliGroup
function Transport_Land( HeliGroup, CountryPrefix, LandingZoneName )

  if CountryPrefix == 'RU' then
    HeliGroup:MessageToRed( "Flying to " .. LandingZoneName .. " for troops deployment.", 15 )
  else
    HeliGroup:MessageToBlue( "Flying to " .. LandingZoneName .. " for troops deployment.", 15 )
  end

  local LandingZone = ZONE:New( CountryPrefix .. " " .. LandingZoneName )
  local DCSTaskLand = HeliGroup:TaskLandAtZone( LandingZone, 30, true )
  HeliGroup:PushTask( DCSTaskLand )

end

function Transport_Deploy( HeliGroup, CountryPrefix, SpawnInfantry )

  local HeliUnit = HeliGroup:GetUnit(1)
  local GroupInfantry = SpawnInfantry:SpawnFromUnit( HeliUnit, 50, 10 )
  if GroupInfantry then
    if CountryPrefix == 'RU' then
      GroupInfantry:MessageToRed( 'Reporting... We are on our way!', 15 )
      HeliGroup:MessageToRed( 'The infantry is deployed.', 15 )
    else
      GroupInfantry:MessageToBlue( 'Reporting... We are on our way!', 15 )
      HeliGroup:MessageToBlue( 'The infantry is deployed.', 15 )
    end
  end
end

--- @param Group#GROUP HeliGroup
function Transport_Switch( HeliGroup, CountryPrefix, FromWayPoint, ToWayPoint, CargoShip )
  HeliGroup:F( { CountryPrefix, FromWayPoint, ToWayPoint, CargoShip } )


  if CountryPrefix == 'US' then
    local CargoShipGroup = GROUP:NewFromName( CargoShip )
    if CargoShipGroup:IsAlive() then
      local SwitchTask  = HeliGroup:CommandSwitchWayPoint( FromWayPoint, ToWayPoint, 1 )
      HeliGroup:SetCommand( SwitchTask )
      HeliGroup:MessageToBlue( "Flying back to cargo ship to reload infantry.", 15 )
    else
      HeliGroup:MessageToBlue( "Our cargo ship has been destroyed, flying to Vinson.", 15 )
    end
  else
    local SwitchTask  = HeliGroup:CommandSwitchWayPoint( FromWayPoint, ToWayPoint, 1 )
    HeliGroup:SetCommand( SwitchTask )
  end

end

US_Troops_Deployment_Left = SPAWN
  :New( "US Troops Deployment Left@AIR/CH-53E" )
  :Limit( 3, 3 )
  :RandomizeRoute( 6, 1, 3000 )
  :CleanUp( 180 )
  :SpawnFunction(
    function( SpawnGroup )
      SpawnGroup
        :WayPointInitialize()
        :WayPointFunction( 1, 1, "Transport_TakeOff", "'US'" )
        :WayPointFunction( 4, 1, "Transport_Reload", "'US'", "'GE Cargo Ship Left'" )
        :WayPointFunction( 5, 1, "Transport_Reloaded", "'US'" )
        :WayPointFunction( 6, 1, "Transport_Land", "'US'", "'Deployment Left ' .. math.random( 1, 3 )" )
        :WayPointFunction( 6, 2, "Transport_Deploy", "'US'", "US_Northern_Infantry_Left_Path" )
        :WayPointFunction( 7, 1, "Transport_Switch", "'US'", 7, 2, "'GE Cargo Ship Left'" )
        :WayPointExecute( 1, 2 )
    end
  )
  :SpawnScheduled( 60, 0.6 )

US_Northern_Infantry_Left_Path  = SPAWN
  :New( 'US_Northern_Infantry_Left_Path' )
  :RandomizeTemplate( { 'US IFV M2A2 Bradley', 'US APC M1126 Stryker ICV', 'US MBT M1A2 Abrams', 'US APC LVTP-7', 'US IFV LAV-25' } )
  :RandomizeRoute( 1, 3, 2000 )

US_Troops_Deployment_Middle = SPAWN
  :New( "US Troops Deployment Middle@AIR/CH-53E" )
  :Limit( 3, 3 )
  :RandomizeRoute( 6, 1, 3000 )
  :CleanUp( 180 )
  :SpawnFunction(
    function( SpawnGroup )
      SpawnGroup
        :WayPointInitialize()
        :WayPointFunction( 1, 1, "Transport_TakeOff", "'US'" )
        :WayPointFunction( 4, 1, "Transport_Reload", "'US'", "'GE Cargo Ship Middle'" )
        :WayPointFunction( 5, 1, "Transport_Reloaded", "'US'" )
        :WayPointFunction( 6, 1, "Transport_Land", "'US'", "'Deployment Right ' .. math.random( 1, 3 )" )
        :WayPointFunction( 6, 2, "Transport_Deploy", "'US'", "US_Northern_Infantry_Right_Path" )
        :WayPointFunction( 7, 1, "Transport_Switch", "'US'", 7, 2, "'GE Cargo Ship Right'" )
        :WayPointExecute( 1, 2 )
    end
  )
  :SpawnScheduled( 60, 0.6 )

US_Troops_Deployment_Right = SPAWN
  :New( "US Troops Deployment Right@AIR/CH-53E" )
  :Limit( 3, 3 )
  :RandomizeRoute( 6, 1, 3000 )
  :CleanUp( 180 )
  :SpawnFunction(
    function( SpawnGroup )
      SpawnGroup
        :WayPointInitialize()
        :WayPointFunction( 1, 1, "Transport_TakeOff", "'US'" )
        :WayPointFunction( 4, 1, "Transport_Reload", "'US'", "'GE Cargo Ship Right'" )
        :WayPointFunction( 5, 1, "Transport_Reloaded", "'US'" )
        :WayPointFunction( 6, 1, "Transport_Land", "'US'", "'Deployment Right ' .. math.random( 1, 3 )" )
        :WayPointFunction( 6, 2, "Transport_Deploy", "'US'", "US_Northern_Infantry_Right_Path" )
        :WayPointFunction( 7, 1, "Transport_Switch", "'US'", 7, 2, "'GE Cargo Ship Right'" )
        :WayPointExecute( 1, 2 )
    end
  )
  :SpawnScheduled( 60, 0.6 )


US_Northern_Infantry_Right_Path = SPAWN
  :New( 'US_Northern_Infantry_Right_Path' )
  :RandomizeTemplate( { 'US IFV M2A2 Bradley', 'US APC M1126 Stryker ICV', 'US MBT M1A2 Abrams', 'US APC LVTP-7', 'US IFV LAV-25' } )
  :RandomizeRoute( 2, 1, 3000 )

US_Troops_Deployment_West = SPAWN
  :New( "US Troops Deployment West@AIR/CH-53E" )
  :Limit( 3, 3 )
  :RandomizeRoute( 6, 1, 3000 )
  :CleanUp( 180 )
  :SpawnFunction(
    function( SpawnGroup )
      SpawnGroup
        :WayPointInitialize()
        :WayPointFunction( 1, 1, "Transport_TakeOff", "'US'" )
        :WayPointFunction( 4, 1, "Transport_Reload", "'US'", "'GE Cargo Ship West'" )
        :WayPointFunction( 5, 1, "Transport_Reloaded", "'US'" )
        :WayPointFunction( 6, 1, "Transport_Land", "'US'", "'Deployment West ' .. math.random( 1, 3 )" )
        :WayPointFunction( 6, 2, "Transport_Deploy", "'US'", "US_Western_Infantry" )
        :WayPointFunction( 7, 1, "Transport_Switch", "'US'", 7, 2, "'GE Cargo Ship West'" )
        :WayPointExecute( 1, 2 )
    end
  )
  :SpawnScheduled( 60, 0.6 )


US_Western_Infantry = SPAWN
  :New( 'US_Western_Infantry' )
  :RandomizeTemplate( { 'US IFV M2A2 Bradley', 'US APC M1126 Stryker ICV', 'US MBT M1A2 Abrams', 'US APC LVTP-7', 'US IFV LAV-25' } )
  :RandomizeRoute( 1, 3, 2000 )

--- SU34 logic to control ships attacks

--- @type SU34Info
-- @field Group#GROUP Group
-- @field #number Status

SU34Info = {}

function Su34AttackCarlVinson( SU34Group )
  env.info("Su34AttackCarlVinson")
  local SU34GroupName = SU34Group:GetName()

  SU34Group:OptionROEOpenFire()
  SU34Group:OptionROTEvadeFire()

  local GroupCarlVinson = GROUP:NewFromName("US Carl Vinson #001")

  if GroupCarlVinson:IsAlive() then
    SU34Group:PushTask( SU34Group:TaskAttackGroup( GroupCarlVinson ), 1 )
  end
  SU34Group:MessageToRed( string.format('%s: ', SU34GroupName ) .. 'Attacking carrier Carl Vinson. ', 10 )
  SU34Info[SU34GroupName].Status = 1
end

function Su34AttackWest( SU34Group )
  env.info("Su34AttackWest")
  local SU34GroupName = SU34Group:GetName()

  SU34Group:OptionROEOpenFire()
  SU34Group:OptionROTEvadeFire()

  local GroupShipWest1 = GROUP:NewFromName("US Ship West #001")
  local GroupShipWest2 = GROUP:NewFromName("US Ship West #002")

  if GroupShipWest1:IsAlive() then
    SU34Group:PushTask( SU34Group:TaskAttackGroup( GroupShipWest1 ), 1 )
    --controllerSu34.pushTask(controllerSu34,{id = 'AttackGroup', params = { groupId = GroupShipWest1:getID(), expend = AI.Task.WeaponExpend.ALL, attackQtyLimit = true}})
  end
  if GroupShipWest2:IsAlive() then
    SU34Group:PushTask( SU34Group:TaskAttackGroup( GroupShipWest2 ), 1 )
    --controllerSu34.pushTask(controllerSu34,{id = 'AttackGroup', params = { groupId = GroupShipWest2:getID(), expend = AI.Task.WeaponExpend.ALL, attackQtyLimit = true}})
  end
  SU34Group:MessageToRed( string.format('%s: ', SU34GroupName ) .. 'Attacking invading ships in the west. ', 10 )
  SU34Info[SU34GroupName].Status = 2
end

function Su34AttackNorth( SU34Group )
  env.info("Su34AttackNorth")
  local SU34GroupName = SU34Group:GetName()

  SU34Group:OptionROEOpenFire()
  SU34Group:OptionROTEvadeFire()

  local GroupShipNorth1 = GROUP:NewFromName("US Ship North #001")
  local GroupShipNorth2 = GROUP:NewFromName("US Ship North #002")
  local GroupShipNorth3 = GROUP:NewFromName("US Ship North #003")
  if GroupShipNorth1:IsAlive()  then
    SU34Group:PushTask( SU34Group:TaskAttackGroup( GroupShipNorth1 ), 1 )
  end
  if GroupShipNorth2:IsAlive() then
    SU34Group:PushTask( SU34Group:TaskAttackGroup( GroupShipNorth2 ), 1 )
    --controllerSu34.pushTask(controllerSu34,{id = 'AttackGroup', params = { groupId = GroupShipNorth2:getID(), expend = AI.Task.WeaponExpend.ALL, attackQtyLimit = false}})
  end
  if GroupShipNorth3:IsAlive() then
    SU34Group:PushTask( SU34Group:TaskAttackGroup( GroupShipNorth3 ), 1 )
    --controllerSu34.pushTask(controllerSu34,{id = 'AttackGroup', params = { groupId = GroupShipNorth3:getID(), expend = AI.Task.WeaponExpend.ALL, attackQtyLimit = false}})
  end

  SU34Group:MessageToRed( string.format('%s: ', SU34GroupName ) .. 'Attacking invading ships in the north. ', 10 )
  SU34Info[SU34GroupName].Status = 3
end

function Su34Orbit( SU34Group )
  env.info("Su34Orbit")
  local SU34GroupName = SU34Group:GetName()
  SU34Group:OptionROEHoldFire()
  SU34Group:OptionROTVertical()
  SU34Group:PushTask( SU34Group:TaskControlled( SU34Group:TaskOrbitCircle( 120, 600 ), SU34Group:TaskCondition( nil, nil, nil, nil, 600, nil) ), 1 )
  SU34Group:MessageToRed( string.format('%s: ',SU34GroupName) .. 'In orbit and awaiting further instructions. ', 10 )
  SU34Info[SU34GroupName].Status = 4
end

function Su34TakeOff( SU34Group )
  env.info("Su34TakeOff")
  local SU34GroupName = SU34Group:GetName()
  
  SU34Group:OptionROEHoldFire()
  SU34Group:OptionROTVertical()
  SU34Group:MessageToRed( string.format('%s: ',SU34GroupName) .. 'Take-Off. ', 10 )
  SU34Info[SU34GroupName].Status = 8
end

function Su34Hold( SU34Group )
  env.info("Su34Hold")
  local SU34GroupName = SU34Group:GetName()
  SU34Group:OptionROEHoldFire()
  SU34Group:OptionROTVertical()
  SU34Group:MessageToRed( string.format('%s: ',SU34GroupName) .. 'Holding Weapons. ', 10 )
  SU34Info[SU34GroupName].Status = 5
end

function Su34RTB( SU34Group )
  env.info("Su34RTB")
  local SU34GroupName = SU34Group:GetName()
  SU34Info[SU34GroupName].Status = 6
  SU34Group:MessageToRed( string.format('%s: ',SU34GroupName) .. 'Return to Krasnodar. ', 10 )
end

function Su34Destroyed( SU34Group )
  env.info("Su34Destroyed")
  local SU34GroupName = SU34Group:GetName()
  SU34Info[SU34GroupName].Status = 7
  SU34Group:MessageToRed( string.format('%s: ',SU34GroupName) .. 'Destroyed. ', 30 )
end


function Su34OverviewStatus()
  local msg = ""

  for SU34GroupName, SU34Data in pairs( SU34Info ) do

    BASE:E( 'Su34 Overview Status: GroupName = ' .. SU34GroupName )

    if SU34Data.Group:IsAlive() then
      if SU34Data.Status == 1 then
        msg = msg .. string.format( "%s: ", SU34GroupName )
        msg = msg .. "Attacking carrier Carl Vinson. "
      elseif SU34Data.Status == 2 then
        msg = msg .. string.format( "%s: ", SU34GroupName )
        msg = msg .. "Attacking supporting ships in the west. "
      elseif SU34Data.Status == 3 then
        msg = msg .. string.format( "%s: ", SU34GroupName )
        msg = msg .. "Attacking invading ships in the north. "
      elseif SU34Data.Status == 4 then
        msg = msg .. string.format( "%s: ", SU34GroupName )
        msg = msg .. "In orbit and awaiting further instructions. "
      elseif SU34Data.Status == 5 then
        msg = msg .. string.format( "%s: ", SU34GroupName )
        msg = msg .. "Holding Weapons. "
      elseif SU34Data.Status == 6 then
        msg = msg .. string.format( "%s: ", SU34GroupName )
        msg = msg .. "Return to Krasnodar. "
      elseif SU34Data.Status == 7 then
        msg = msg .. string.format( "%s: ", SU34GroupName )
        msg = msg .. "Destroyed. "
      elseif SU34Data.Status == 8 then
        msg = msg .. string.format( "%s: ", SU34GroupName )
        msg = msg .. "Take-Off. "
      end
    else
      if SU34Data.Status == 7 then
        msg = msg .. string.format( "%s: ", SU34GroupName )
        msg = msg .. "Destroyed. "
      else
        Su34Destroyed( SU34GroupName )
      end
    end
  end
  
  MESSAGE:New( msg, "Status", 15, "Status" ):ToRed()
  
  return true
end

function SU34Menu()

  for SU34GroupName, SU34Data in pairs( SU34Info ) do
    BASE:E( { SU34GroupName, SU34Data } )
    
    if SU34Data.Group:IsAlive() and SU34Data.Status >= 1 and SU34Data.Status <= 5 then
      if SU34MainMenu == nil then
        SU34MainMenu = MENU_COALITION:New( coalition.side.RED, "SU-34 anti-ship flights", nil )
      end
      if not SU34Data.Menu then
        SU34Data.Menu = MENU_COALITION:New( coalition.side.RED, "Flight " .. SU34GroupName, SU34MainMenu )
        MENU_COALITION_COMMAND:New( coalition.side.RED , "Attack carrier Carl Vinson",           SU34Data.Menu, Su34AttackCarlVinson, SU34Data.Group )
        MENU_COALITION_COMMAND:New( coalition.side.RED , "Attack ships in the west",             SU34Data.Menu, Su34AttackWest,       SU34Data.Group )
        MENU_COALITION_COMMAND:New( coalition.side.RED , "Attack ships in the north",            SU34Data.Menu, Su34AttackNorth,      SU34Data.Group )
        MENU_COALITION_COMMAND:New( coalition.side.RED , "Hold position and await instructions", SU34Data.Menu, Su34Orbit,            SU34Data.Group )
        MENU_COALITION_COMMAND:New( coalition.side.RED , "Report status",                        SU34Data.Menu, Su34OverviewStatus )
      end
    else
      if SU34Data.Menu then
        SU34Data.Menu:Remove()
      end
    end
  end
  
  return true
end



SU34MenuScan = SCHEDULER:New( nil, SU34Menu, {}, 5, 10, 0 )
SU34Status = SCHEDULER:New( nil, Su34OverviewStatus, {}, 5, 300, 0 )

--- @param Group#GROUP SU34Group
function Su34Alive( SU34Group )

  local SU34GroupName = SU34Group:GetName()
  BASE:E({SU34GroupName})

  if not SU34Info[SU34GroupName] then
    SU34Info[SU34GroupName] = {}
    SU34Info[SU34GroupName].Status = 9
    SU34Info[SU34GroupName].Group = GROUP:NewFromName(SU34GroupName)
  end
end


Spawn_RU_Attack_Ships = SPAWN
  :New( 'RU_TF1_Attack_Ships@HOT/SU-34' )
  :Limit( 5, 5 )
  --:SpawnUncontrolled()
  :RandomizeRoute( 1, 1, 3000 )
  :InitRepeatOnEngineShutDown()
  :SpawnFunction(
    function( SpawnGroup )
      SpawnGroup
        :WayPointInitialize()
        :WayPointFunction( 1, 1, "Su34Alive" )
        :WayPointFunction( 2, 1, "Su34TakeOff" )
        :WayPointFunction( 3, 1, "Su34Orbit" )
        :WayPointFunction( 5, 1, "Su34RTB" )
        :WayPointExecute( 1, 2 )
    end
  )
  :SpawnScheduled( 1800, 0.4 )
  



SpawnRU_SU30 = SPAWN
  :New( 'RU SU-30@AI Patrol SAM Area' )
  :Limit( 3, 30 )
  :RandomizeRoute( 1, 1, 6000 )
  :SpawnScheduled( 900, 0.4 )

SpawnFR_MIRAGE = SPAWN
  :New( 'TF3 FR MIRAGE 2000-5@AI CAP' )
  :Limit( 2, 30 )
  :RandomizeRoute( 3, 1, 3000 )
  :SpawnScheduled( 900, 0.4 )

SpawnRU_KA50 = SPAWN
  :New( 'TF3 RU KA-50@AI Ground Defense' )
  :Limit( 1, 10 )
  :RandomizeRoute( 1, 1, 3000 )
  :SpawnScheduled( 600, 0.4 )

SpawnRU_MI28N = SPAWN
  :New( 'TF3 RU MI-28N@AI Ground Defense' )
  :Limit( 1, 20 )
  :RandomizeRoute( 1, 1, 3000 )
  :SpawnScheduled( 900, 0.4 )

SpawnRU_SU25T = SPAWN
  :New( 'TF3 RU SU-25T@AI Ground Defense' )
  :Limit( 1, 5 )
  :RandomizeRoute( 1, 1, 3000 )
  :InitRepeatOnEngineShutDown()
  :SpawnScheduled( 450, 0.4 )

SpawnUS_F117A = SPAWN
  :New( 'TF2 US F-117A@AI PINPOINT' )
  :Limit( 1, 5 )
  :RandomizeRoute( 1, 1, 4000 )
  :SpawnScheduled( 1200, 0.7 )

SpawnUS_FA18C_SEAD = SPAWN
  :New( 'TF1 US FA-18C@AI Destroy SA-10' )
  :Limit( 1, 6 )
  :RandomizeRoute( 2, 1, 3000 )
  :SpawnScheduled( 900, 0.2 )

SpawnUS_FA18C_CAP = SPAWN
  :New( 'TF1 US FA-18C@AI Helicopter Escort' )
  :Limit( 3, 16 )
  :RandomizeRoute( 2, 1, 3000 )
  :SpawnScheduled( 350, 0.2 )

SpawnUS_A10A = SPAWN
  :New( 'TF3 US A-10A@AI Destroy SA-6/11' )
  :Limit( 2, 20 )
  :RandomizeRoute( 3, 1, 3000 )
  :SpawnScheduled( 600, 0.5 )

SpawnGE_SU25T = SPAWN
  :New( 'TF3 GE SU-25T@AI Destroy SA-6/11' )
  :Limit( 1, 8 )
  :RandomizeRoute( 1, 1, 10000 )
  :SpawnScheduled( 30, 0.5 )

SpawnUS_AH1W = SPAWN
  :New( 'TF1 US AH-1W Farp AI - Attack Anapa' )
  :Limit( 2, 20 )
  :RandomizeRoute( 2, 1, 6000 )
  :SpawnScheduled( 750, 0.3 )

SpawnBE_KA50 = SPAWN
  :New( 'TF1 BE KA-50@AI Attack AA' )
  :Limit( 2, 20 )
  :RandomizeRoute( 3, 1, 3000 )
  :SpawnScheduled( 900, 0.6 )


RU_Infantry_Deployment = SPAWN
  :New( "RU Infantry Deployment@AIR/MIL-26" )
  :Limit( 4, 3 )
  :RandomizeRoute( 3, 2, 3000 )
  :CleanUp( 180 )
  :SpawnFunction(
    function( SpawnGroup )
      SpawnGroup
        :WayPointInitialize()
        :WayPointFunction( 1, 1, "Transport_TakeOff", "'RU'" )
        :WayPointFunction( 2, 1, "Transport_Reload", "'RU'", "''" )
        :WayPointFunction( 3, 1, "Transport_Reloaded", "'RU'" )
        :WayPointFunction( 4, 1, "Transport_Land", "'RU'", "'Deployment Defenses ' .. math.random( 1, 4 )" )
        :WayPointFunction( 4, 2, "Transport_Deploy", "'RU'", "RU_Infantry_Defenses" )
        :WayPointFunction( 6, 1, "Transport_Switch", "'RU'", 6, 2, "''" )
        :WayPointExecute( 1, 2 )
    end
  )
  :SpawnScheduled( 60, 0.6 )


RU_Infantry_Defenses = SPAWN
  :New( 'RU Infantry Defenses' )
  :Limit( 20, 120 )
  :RandomizeTemplate( { 'RU Infantry Defenses A', 'RU Infantry Defenses B',  'RU Infantry Defenses C', 'RU Infantry Defenses D' } )
  :Array( 90, 10, 30, 30 )
  :RandomizeRoute( 2, 1, 4000 )


SEAD_SA10_Defenses = SEAD
  :New( { 'Russia SA-10 Battery Array #001' } )

SEAD_SA11_Defenses_Anapa = SEAD
  :New( { 'RU SA-11 BUK Air Defense #001' } )

SEAD_SA8_Defenses = SEAD
  :New( { 'RU SA-8 Airbase Defense' } )

SEAD_SAM_Defenses_South = SEAD
  :New( { 'RU SA-6 - Middle Defenses', 'RU SA-11 - South Defenses' } )


--- NATO SEAD Defenses
SEAD_Hawk_Defenses = SEAD
  :New( { 'US Hawk Battery' } )

SEAD_Roland_Defenses = SEAD
  :New( { 'DE SAM Roland ADS' } )

SEAD_Ship_Defenses = SEAD
  :New( { 'US Ship North', 'US Ship West' } )


MOVEMENT_CH53E = MOVEMENT
  :New( { 'US CH-53E Infantry Left', 'US CH-53E Infantry Right', 'US CH-53E Infantry West' }, 20 )

MOVEMENT_MI26 = MOVEMENT
  :New( { 'RU MI-26 Infantry' }, 10 )


--- NATO

do -- USA destroy air defenses

  local Mission = MISSION:New( 'Destroy SA-10', 'Primary', 'Destroy the enemy SA-10 batteries at Anapa airport. Once the SA-10 batteries are out, USA infantry forces can progress to Anapa from the north, and the airbase can be finally captured', 'NATO'  )

  Mission:AddClient( CLIENT:New( 'TF1 US A-10C@AIR Destroy SA-10 1' ) )
  Mission:AddClient( CLIENT:New( 'TF1 US A-10C@AIR Destroy SA-10 2' ) )
  Mission:AddClient( CLIENT:New( 'TF1 US A-10C@HOT Destroy SA-10 3' ) )
  Mission:AddClient( CLIENT:New( 'TF1 US A-10C@HOT Destroy SA-10 4' ) )
  Mission:AddClient( CLIENT:New( 'TF1 US A-10C@RAMP Destroy SA-10 5' ) )
  Mission:AddClient( CLIENT:New( 'TF1 US A-10C@RAMP Destroy SA-10 6' ) )
  Mission:AddClient( CLIENT:New( 'TF1 BE KA-50@HOT Destroy SA-10 1' ) )
  Mission:AddClient( CLIENT:New( 'TF1 BE KA-50@HOT Destroy SA-10 2' ) )
  Mission:AddClient( CLIENT:New( 'TF1 BE KA-50@RAMP Destroy SA-10 3' ) )
  Mission:AddClient( CLIENT:New( 'TF1 BE KA-50@RAMP Destroy SA-10 4' ) )

  local DestroyGroupsTask = DESTROYRADARSTASK:New( { 'Russia SA-10 Battery Array' } )
  DestroyGroupsTask:SetGoalTotal( 2 )
  Mission:AddTask( DestroyGroupsTask, 1 )

  MISSIONSCHEDULER.AddMission( Mission )

end



do -- USA destroy Su-34 ship attack forces

  local Mission = MISSION:New( 'Destroy Su-34 Ship Attack', 'Secondary', 'Su-34 planes are approaching from the east. They pose an enormous threat to our fleet. Destroy them before they engage anti-radar weapons to destroy our carrier and ships!', 'NATO'  )

  Mission:AddClient( CLIENT:New( 'TF2 US F-15C@HOT Destroy SU-34 1' ) )
  Mission:AddClient( CLIENT:New( 'TF2 US F-15C@HOT Destroy SU-34 2' ) )
  Mission:AddClient( CLIENT:New( 'TF2 US F-15C@HOT Destroy SU-34 3' ) )
  Mission:AddClient( CLIENT:New( 'TF2 US F-15C@HOT Destroy SU-34 4' ) )
  Mission:AddClient( CLIENT:New( 'TF2 US F-15C@AIR Destroy SU-34 5' ) )
  Mission:AddClient( CLIENT:New( 'TF2 US F-15C@AIR Destroy SU-34 6' ) )

  local DestroyGroupsTask = DESTROYGROUPSTASK:New( 'anti ship air defenses', 'Su-34 squadrons', {
    'TF1 RU Su-34 Krymsk@AI - Attack Ships' }
  )

  DestroyGroupsTask:SetGoalTotal( 5 )
  Mission:AddTask( DestroyGroupsTask, 1 )

  MISSIONSCHEDULER.AddMission( Mission )

end

do -- NATO destroy SA-6 / SA-11 DEFENSES TO ANAPA
  local Mission = MISSION:New( 'Destroy SAMs', 'Operational', 'Destroy the Russian mobile SAM sites between Gudauata and Anapa. Their elimination will ease our F-15C, A-10A and A-10C airstrikes and air attack from Gudauata.', 'NATO'  )

  Mission:AddClient( CLIENT:New( 'TF3 US A-10A@HOT Destroy SA-6/11 1' ) )
  Mission:AddClient( CLIENT:New( 'TF3 US A-10A@HOT Destroy SA-6/11 2' ) )
  Mission:AddClient( CLIENT:New( 'TF3 US A-10A@RAMP Destroy SA-6/11 3' ) )
  Mission:AddClient( CLIENT:New( 'TF3 US A-10A@RAMP Destroy SA-6/11 4' ) )
  Mission:AddClient( CLIENT:New( 'TF3 US A-10C@HOT Destroy SA-6/11 1' ) )
  Mission:AddClient( CLIENT:New( 'TF3 US A-10C@HOT Destroy SA-6/11 2' ) )
  Mission:AddClient( CLIENT:New( 'TF3 US A-10C@RAMP Destroy SA-6/11 3' ) )
  Mission:AddClient( CLIENT:New( 'TF3 US A-10C@RAMP Destroy SA-6/11 4' ) )
  Mission:AddClient( CLIENT:New( 'TF3 GE SU-25T@HOT Destroy SA-6/11 1' ) )
  Mission:AddClient( CLIENT:New( 'TF3 GE SU-25T@HOT Destroy SA-6/11 2' ) )
  Mission:AddClient( CLIENT:New( 'TF3 GE SU-25T@RAMP Destroy SA-6/11 3' ) )
  Mission:AddClient( CLIENT:New( 'TF3 GE SU-25T@RAMP Destroy SA-6/11 4' ) )
  Mission:AddClient( CLIENT:New( 'TF3 GE SU-25T@AIR Destroy SA-6/11 5' ) )
  Mission:AddClient( CLIENT:New( 'TF3 GE SU-25T@AIR Destroy SA-6/11 6' ) )

  local DestroyGroupRadarsTask = DESTROYUNITTYPESTASK:New( 'SAM sites', 'Kub 1S91 and Buk SR 9S18M1 search radars', { 'RU SA-6 - Middle Defenses', 'RU SA-11 - South Defenses' }, { 'Kub 1S91 str', 'SA-11 Buk SR 9S18M1' } )

  DestroyGroupRadarsTask:SetGoalTotal( 18 )
  Mission:AddTask( DestroyGroupRadarsTask, 1 )

  MISSIONSCHEDULER.AddMission( Mission )

end

do -- USA Deploy troops to battle zone

  DefenseActivation = {
    { "Georgian SA-3 Defense System", false },
    { "Georgian Early Warning Radar (EWR) Callsign Warrior", false },
    { "Georgian SA-11 Defense System", false }
  }

function ActivateDefenses( Mission, Client )

  -- Check if the cargo is all deployed for mission success.
  for CargoID, CargoData in pairs( Mission._Cargos ) do
    if Group.getByName( CargoData.CargoGroupName ) then
      local CargoGroup = Group.getByName( CargoData.CargoGroupName )
      if CargoGroup then
        -- Check if the cargo is ready to activate the nearby units.
        CurrentLandingZoneID = _TransportValidateUnitInZone( CargoGroup:getUnits()[1], Mission:GetTask( 2 ).LandingZones ) -- The second task is the Deploytask to measure mission success upon
        if CurrentLandingZoneID then
          env.info( "CurrentLandingZoneID = " .. CurrentLandingZoneID )
          if DefenseActivation[CurrentLandingZoneID][2] == false then
            trigger.action.setGroupAIOn( Group.getByName( DefenseActivation[CurrentLandingZoneID][1] ) )
            DefenseActivation[CurrentLandingZoneID][2] = true
            MessageToBlue( "Mission Command: Message to all airborne units! The " .. DefenseActivation[CurrentLandingZoneID][1] .. " is armed. Our air defenses are now stronger.", 60, "BLUE/Defense" )
            MessageToRed( "Mission Command: Our satellite systems are detecting additional NATO air defenses. To all airborne units: Take care!!!", 60, "RED/Defense" )
          end
        end
      end
    end
  end
end

local Mission = MISSION:New( 'Activate Air Defenses', 'Operational', 'Transport troops from the "Gamma" control center to the battle zone.', 'NATO' )
Mission:AddGoalFunction( ActivateDefenses )

local Client

Client = CLIENT:New( 'TF4 BE UH-1H@HOT Deploy Infantry 1' )
Client:Transport()
Mission:AddClient( Client )

Client = CLIENT:New( 'TF4 BE UH-1H@HOT Deploy Infantry 2' )
Client:Transport()
Mission:AddClient( Client )

Client = CLIENT:New( 'TF4 BE UH-1H@RAMP Deploy Infantry 3' )
Client:Transport()
Mission:AddClient( Client )

Client = CLIENT:New( 'TF4 BE UH-1H@RAMP Deploy Infantry 4' )
Client:Transport()
Mission:AddClient( Client )

local EngineerNames = { "Charlie", "Fred", "Sven", "Prosper", "Godfried", "Adam", "Freddy", "Saskia", "Karolina", "Levente", "Urbanus", "Helena", "Teodora", "Timea", "John", "Ibrahim", "Christine", "Carl", "Monika" }

local CargoTable = {}
for CargoItem = 1, 8 do
  Mission:AddCargo( "Team " .. CargoItem .. ": " .. EngineerNames[math.random(1, #EngineerNames)] .. ' and ' .. EngineerNames[math.random(1, #EngineerNames)], CARGO_TYPE.ENGINEERS, math.random( 70, 120 ) * 2, 'US Troop Barracks Gamma', 'US Invasion Infantry', 'US Troops Gamma' )
end

-- Assign the Pickup Task
local PickupTask = PICKUPTASK:New( 'USA Troops Gamma pickup zone', CARGO_TYPE.ENGINEERS, CLIENT.ONBOARDSIDE.RIGHT )
PickupTask:AddSmokeRed( 'US Troop Barracks Gamma' )
Mission:AddTask( PickupTask, 1 )

local DeployZones = { "US Deployment Zone Alpha", "US Deployment Zone Beta", "US Deployment Zone Gamma" }
local DeployZonesSmokeUnits = { "US Deployment Zone Alpha Transport", "US Deployment Zone Beta Transport", "US Deployment Zone Gamma Transport" }
-- Assign the Deploy Task
local DeployTask = DEPLOYTASK:New( DeployZones, CARGO_TYPE.ENGINEERS )
DeployTask:AddSmokeRed( DeployZonesSmokeUnits )
DeployTask:SetGoalTotal( 3 )
Mission:AddTask( DeployTask, 2 )

MISSIONSCHEDULER.AddMission( Mission )

end


--- CCCP

do


end

do -- Russia destroy northern USA ship
  local Mission = MISSION:New( 'Destroy Ships', 'Primary', 'A large infantry invasion is progressing to Anapa from the North. USA infantry is being deployed by USA Navy helicopters unloading the ships. Destroy the ships further to the North. Beware of mobile SAMs and the ship defenses. Fly low and slow!', 'Russia'  )

  Mission:AddClient( CLIENT:New( 'TF1 RU SU-25T@HOT Northern Ships 1' ) )
  Mission:AddClient( CLIENT:New( 'TF1 RU SU-25T@HOT Northern Ships 2' ) )
  Mission:AddClient( CLIENT:New( 'TF1 RU SU-25T@RAMP Northern Ships 3' ) )
  Mission:AddClient( CLIENT:New( 'TF1 RU SU-25T@RAMP Northern Ships 4' ) )

  local DestroyGroupsTask = DESTROYGROUPSTASK:New( 'infantry deploying ships', 'destroyers', { 'US Ship North' } )
  DestroyGroupsTask:SetGoalTotal( 3 )
  Mission:AddTask( DestroyGroupsTask, 1 )

  MISSIONSCHEDULER.AddMission( Mission )

end

do -- Russia destroy USA helicopter infantry landing forces
  local Mission = MISSION:New( 'Destroy CH-53E helicopters', 'Tactical', 'The USA is deploying infantry forces with CH-53E helicopters. Destroy the helicoptes to prevent further unloading of USA infantry forces from the ships.', 'Russia'  )

  Mission:AddClient( CLIENT:New( 'TF2 RU MIG-29S@HOT Helicopters 1' ) )
  Mission:AddClient( CLIENT:New( 'TF2 RU MIG-29S@HOT Helicopters 2' ) )
  Mission:AddClient( CLIENT:New( 'TF2 RU MIG-29S@RAMP Helicopters 3' ) )
  Mission:AddClient( CLIENT:New( 'TF2 RU MUG-29S@RAMP Helicopters 4' ) )
  Mission:AddClient( CLIENT:New( 'TF2 RU SU-27@HOT Helicopters 1' ) )
  Mission:AddClient( CLIENT:New( 'TF2 RU SU-27@HOT Helicopters 2' ) )
  Mission:AddClient( CLIENT:New( 'TF2 RU SU-27@RAMP Helicopters 3' ) )
  Mission:AddClient( CLIENT:New( 'TF2 RU SU-27@RAMP Helicopters 4' ) )
  Mission:AddClient( CLIENT:New( 'TF2 RU SU-33@HOT Helicopters 1' ) )
  Mission:AddClient( CLIENT:New( 'TF2 RU SU-33@HOT Helicopters 2' ) )
  Mission:AddClient( CLIENT:New( 'TF2 RU SU-33@RAMP Helicopters 3' ) )
  Mission:AddClient( CLIENT:New( 'TF2 RU SU-33@RAMP Helicopters 4' ) )

  local DestroyGroupsTask = DESTROYGROUPSTASK:New( 'USA transport helicopters', 'helicopters', { 'US CH-53E Air AI - Infantry Transport' } )
  DestroyGroupsTask:SetGoalTotal( 9 )
  Mission:AddTask( DestroyGroupsTask, 1 )

  MISSIONSCHEDULER.AddMission( Mission )
end

do -- Stop the upcoming infantry
  local Mission = MISSION:New( 'Destroy Infantry', 'Operational', 'The USA is deploying infantry forces with CH-53E helicopters, which are progressing to Anapa. Defend our airbase from the upcoming USA infantry!', 'Russia'  )

  Mission:AddClient( CLIENT:New( 'TF3 RU KA-50@HOT Infantry 1' ) )
  Mission:AddClient( CLIENT:New( 'TF3 RU KA-50@HOT Infantry 2' ) )
  Mission:AddClient( CLIENT:New( 'TF3 RU KA-50@RAMP Infantry 3' ) )
  Mission:AddClient( CLIENT:New( 'TF3 RU KA-50@RAMP Infantry 4' ) )
  Mission:AddClient( CLIENT:New( 'TF3 RU SU-25T@HOT Infantry 1' ) )
  Mission:AddClient( CLIENT:New( 'TF3 RU SU-25T@HOT Infantry 2' ) )
  Mission:AddClient( CLIENT:New( 'TF3 RU SU-25T@RAMP Infantry 3' ) )
  Mission:AddClient( CLIENT:New( 'TF3 RU SU-25T@RAMP Infantry 4' ) )
  Mission:AddClient( CLIENT:New( 'TF3 RU SU-27@HOT Infantry 1' ) )
  Mission:AddClient( CLIENT:New( 'TF3 RU SU-27@HOT Infantry 2' ) )
  Mission:AddClient( CLIENT:New( 'TF3 RU SU-27@RAMP Infantry 3' ) )
  Mission:AddClient( CLIENT:New( 'TF3 RU SU-27@RAMP Infantry 4' ) )

  local DestroyGroupsTask = DESTROYGROUPSTASK:New( 'USA Infantry', 'infantry vehicles', { 'US CH-53E Infantry Left', 'US CH-53E Infantry Right' } )
  DestroyGroupsTask:SetGoalTotal( 30 )
  Mission:AddTask( DestroyGroupsTask, 1 )

  MISSIONSCHEDULER.AddMission( Mission )

end

do -- Russia Rescue workers from oil platforms
  local Mission = MISSION:New( 'Rescue oil rig workers', 'Operational', 'Russian workers are still on the Oil Rigs in the sea. Fly to the west and rescue them. They will use a red smoke signal when you approach the oil rigs. Note that we are not sure in which oil rig exactly the workers are. Search for the red smoke, fly to the oil rig, and rescue the workers by landing on the oil rig. Fly back to Gelend and land in the zone indicated by a red smoke signal. Good luck!', 'Russia' )
  --	Mission:AddGoal( MissionGoal )

  local Client

  Client = CLIENT:New( 'TF4 RU MI-8@HOT Rescue Oil Workers 1' )
  Client:Transport()
  Mission:AddClient( Client )

  Client = CLIENT:New( 'TF4 RU MI-8@HOT Rescue Oil Workers 2' )
  Client:Transport()
  Mission:AddClient( Client )

  Client = CLIENT:New( 'TF4 RU MI-8@RAMP Rescue Oil Workers 3' )
  Client:Transport()
  Mission:AddClient( Client )

  Client = CLIENT:New( 'TF4 RU MI-8@RAMP Rescue Oil Workers 4' )
  Client:Transport()
  Mission:AddClient( Client )

  local CargoTable = {}
  for CargoItem = 1, 2 do
    Mission:AddCargo( 'Oil workers ' .. CargoItem, CARGO_TYPE.ENGINEERS, math.random( 70, 120 ) * 2, nil, 'RU Oil Rig Workers', 'Oil Rig Workers Deployment #011' )
  end

  -- Assign the Pickup Task
  local PickupTask = PICKUPTASK:New( 'Oil Rig #011', CARGO_TYPE.ENGINEERS, CLIENT.ONBOARDSIDE.FRONT )
  PickupTask:AddSmokeRed( 'RU Oil Rig #011', 50 )
  Mission:AddTask( PickupTask, 1 )

  -- Assign the Deploy Task
  local DeployTask = DEPLOYTASK:New( 'RU Anapa Rescue Workers', CARGO_TYPE.ENGINEERS )
  DeployTask:AddSmokeRed( 'RU Workers Rescue Vehicle' )
  DeployTask:SetGoalTotal( 1 )
  Mission:AddTask( DeployTask, 2 )

  MISSIONSCHEDULER.AddMission( Mission )

end


--MusicRegister( 'REC1', 'Ashes to Ashes.ogg', 4 * 60 + 24 )
--MusicRegister( 'REC1', 'Black Dog.ogg', 4 * 60 + 57 )
--MusicRegister( 'REC1', 'Everybodys Got To Learn Sometime.ogg', 4 * 60 + 15 )
--MusicRegister( 'REC1', 'Long Cool Woman.ogg', 3 * 60 + 14 )
--MusicRegister( 'REC1', 'Take It As It Comes.ogg', 2 * 60 + 14 )
--MusicRegister( 'REC1', 'The Wall Street Shuffle.ogg', 3 * 60 + 51 )
--MusicRegister( 'REC1', 'Heroes.ogg', 3 * 60 + 37 )


-- MISSION SCHEDULER STARTUP
MISSIONSCHEDULER.Start()
MISSIONSCHEDULER.ReportMenu()
MISSIONSCHEDULER.ReportMissionsFlash( 120 )

env.info( "Anapa Airbase.lua loaded." )
