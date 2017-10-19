
GoalScore = 200

FlagMissionEnd = USERFLAG:New( "66" )

RU_VictorySound = USERSOUND:New( "MotherRussia.ogg" )
US_VictorySound = USERSOUND:New( "outro.ogg" )

-- When a zone is capture, 200 points are shared amoung contributors who captured the zone.

do -- Setup the Command Centers
  
  RU_CC = COMMANDCENTER:New( GROUP:FindByName( "REDHQ" ), "Russia HQ" )
  US_CC = COMMANDCENTER:New( GROUP:FindByName( "BLUEHQ" ), "USA HQ" )

end


do -- Setup the groups that can capture the zones

  US_ZoneCaptureGroupSet = SET_GROUP:New():FilterCoalitions("blue"):FilterStart()
  RU_ZoneCaptureGroupSet = SET_GROUP:New():FilterCoalitions("red"):FilterStart()

end


do -- Missions

  -- Setup the Scoring system.
  Scoring = SCORING:New( "Area 51" )
  
  -- The US mission.
  US_Mission_GroomLake = MISSION:New( US_CC, "Groom Lake", "Primary",
    "Welcome trainee. The airport Groom Lake needs to be captured.\n" ..
    "There are five random capture zones located at the airbase.\n" ..
    "Move to one of the capture zones, destroy the fuel tanks in the capture zone, " ..
    "and occupy each capture zone with a platoon.\n " .. 
    "Your orders are to hold position until all capture zones are taken.\n" ..
    "Use the map (F10) for a clear indication of the location of each capture zone.\n" ..
    "Note that heavy resistance can be expected at the airbase!\n" ..
    "Mission 'Groom Lake' is complete when all five capture zones are taken, and held for at least 5 minutes!"
    , coalition.side.BLUE)
    
  -- Connect the scoring to the US mission.
  US_Mission_GroomLake:AddScoring( Scoring )
  
  US_Mission_GroomLake:Start()

  RU_Mission_Rastov = MISSION:New( RU_CC, "Rastov", "Primary",
    "Welcome trainee. The fuel tanks and industry needs to be destroyed.\n" ..
    "Mission 'Rastov' is complete when all industry installations are destroyed!"
    , coalition.side.RED)
    
  RU_Mission_Rastov:AddScoring( Scoring )
  
  RU_Mission_Rastov:Start()

end


do -- Setup the designation of targets for US

  local US_FAC = SET_GROUP:New():FilterPrefixes( "US_FAC" ):FilterOnce()
  local US_Detection = DETECTION_AREAS:New( US_FAC, 500 )
  US_Designate = DESIGNATE:New( US_CC, US_Detection, US_ZoneCaptureGroupSet, US_Mission_GroomLake )

end




-- These Spawn objects will be used to randomly spawn a new A2G_CAS plane when a zone has been captured from the Russian side.
RU_A2G_CAS_Spawn = {
  SPAWN:New( "RU_A2G_CAS_S #001" ):InitRandomizeTemplatePrefixes( "RU_A2G_CAS_T" ):InitLimit( 2, 12 ),
  SPAWN:New( "RU_A2G_CAS_S #002" ):InitRandomizeTemplatePrefixes( "RU_A2G_CAS_T" ):InitLimit( 2, 12 ),
  SPAWN:New( "RU_A2G_CAS_S #003" ):InitRandomizeTemplatePrefixes( "RU_A2G_CAS_T" ):InitLimit( 2, 12 ),
  SPAWN:New( "RU_A2G_CAS_S #004" ):InitRandomizeTemplatePrefixes( "RU_A2G_CAS_T" ):InitLimit( 2, 12 ),
  SPAWN:New( "RU_A2G_CAS_S #005" ):InitRandomizeTemplatePrefixes( "RU_A2G_CAS_T" ):InitLimit( 2, 12 ),
  SPAWN:New( "RU_A2G_CAS_S #006" ):InitRandomizeTemplatePrefixes( "RU_A2G_CAS_T" ):InitLimit( 2, 12 ),
  }

-- These Spawn objects will be used to automatically ensure that there are enough defenses on the Russian side on the zones.
RU_A2G_ARM_Spawn = {
  SPAWN:New( "RU_G2G_ARM_S #001" ):InitRandomizeTemplatePrefixes( "RU_G2G_ARM_T" ):InitLimit( 8, 12 ):InitRandomizeRoute( 3, 0, 1000 ):SpawnScheduled( 180, 0.5 ),
  SPAWN:New( "RU_G2G_ARM_S #002" ):InitRandomizeTemplatePrefixes( "RU_G2G_ARM_T" ):InitLimit( 8, 12 ):InitRandomizeRoute( 3, 0, 1000 ):SpawnScheduled( 180, 0.5 ),
  SPAWN:New( "RU_G2G_ARM_S #003" ):InitRandomizeTemplatePrefixes( "RU_G2G_ARM_T" ):InitLimit( 8, 12 ):InitRandomizeRoute( 3, 0, 1000 ):SpawnScheduled( 180, 0.5 ),
}

local RU_ZoneCount = 13
local US_ZoneCount = 0

local ZoneRandom = 5

local US_ZoneNames = { "Alpha","Beta","Gamma","Delta","Epsilon","Zeta","Eta","Theta","Iota","Kappa","Lambda","Mu","Nu","Xi","Omicron","Pi","Rho","Sigma","Tua","Upsilon","Phi","Chi","Psi","Omega","Digamma",}
local RU_ZoneNames = { "Alpha","Beta","Gamma","Delta","Epsilon","Zeta","Eta","Theta","Iota","Kappa","Lambda","Mu","Nu","Xi","Omicron","Pi","Rho","Sigma","Tua","Upsilon","Phi","Chi","Psi","Omega","Digamma",}

local RU_ZonesCapture = {}

for RU_ZoneID = 1, RU_ZoneCount do
  RU_ZonesCapture[RU_ZoneID] = ZONE:New( "RU_CAPTURE_" .. RU_ZoneID )
  -- We keep the Zone ID for later reference to respawn the fuel tanks.
  RU_ZonesCapture[RU_ZoneID].ZoneID = RU_ZoneID
end


--local US_ZonesCapture = {}
--
--for US_ZoneID = 1, US_ZoneCount do
--  US_ZonesCapture[US_ZoneID] = ZONE:New( "US_CAPTURE_" .. US_ZoneID )
--  -- We keep the Zone ID for later reference to respawn the fuel tanks.
--  US_ZonesCapture[US_ZoneID].ZoneID = US_ZoneID
--end

--- Model the MISSION for RED

ZonesCaptureCoalition = {}
RU_FuelTanks = {}
US_FuelTanks = {}

for RU_ZoneID = 1, ZoneRandom do

  local RandomZoneID = math.random( 1, #RU_ZonesCapture )
  local RandomZoneNameID = math.random( 1, #RU_ZoneNames )
  local ZoneID = RU_ZonesCapture[RandomZoneID].ZoneID
  
  local ZoneCaptureCoalition = ZONE_CAPTURE_COALITION:New( RU_ZonesCapture[RandomZoneID], coalition.side.RED ) 
  ZoneCaptureCoalition:GetZone():SetName( RU_ZoneNames[RandomZoneNameID] )
  
  RU_FuelTanks[ZoneID] = {}
  RU_FuelTanks[ZoneID][1] = SPAWNSTATIC:NewFromStatic( string.format( "FUEL_TANK #%03d-A", ZoneID ), country.id.RUSSIA )
  RU_FuelTanks[ZoneID][2] = SPAWNSTATIC:NewFromStatic( string.format( "FUEL_TANK #%03d-B", ZoneID ), country.id.RUSSIA )
  RU_FuelTanks[ZoneID][3] = SPAWNSTATIC:NewFromStatic( string.format( "FUEL_TANK #%03d-C", ZoneID ), country.id.RUSSIA )

  US_FuelTanks[ZoneID] = {}
  US_FuelTanks[ZoneID][1] = SPAWNSTATIC:NewFromStatic( string.format( "FUEL_TANK #%03d-A", ZoneID ), country.id.USA )
  US_FuelTanks[ZoneID][2] = SPAWNSTATIC:NewFromStatic( string.format( "FUEL_TANK #%03d-B", ZoneID ), country.id.USA )
  US_FuelTanks[ZoneID][3] = SPAWNSTATIC:NewFromStatic( string.format( "FUEL_TANK #%03d-C", ZoneID ), country.id.USA )
  
  
  table.insert( ZonesCaptureCoalition, ZoneCaptureCoalition )
  
  table.remove( RU_ZonesCapture, RandomZoneID )
  table.remove( RU_ZoneNames, RandomZoneNameID )
end

--for US_ZoneID = 1, ZoneRandom do
--
--  local RandomZoneID = math.random( 1, #US_ZonesCapture )
--  local RandomZoneNameID = math.random( 1, #US_ZoneNames )
--  
--  local ZoneCaptureCoalition = ZONE_CAPTURE_COALITION:New( US_ZonesCapture[RandomZoneID], coalition.side.BLUE )
--  ZoneCaptureCoalition:GetZone():SetName( US_ZoneNames[RandomZoneNameID] )
--  table.insert( ZonesCaptureCoalition, ZoneCaptureCoalition )
--  
--  table.remove( US_ZonesCapture, RandomZoneID )
--  table.remove( US_ZoneNames, RandomZoneNameID )
--end

TasksRed = {}
TasksBlue = {}


for CaptureZoneID = 1, ZoneRandom do

  local ZoneCaptureCoalition = ZonesCaptureCoalition[CaptureZoneID] -- Functional.ZoneCaptureCoalition#ZONE_CAPTURE_COALITION
  
  --- @param Functional.ZoneCaptureCoalition#ZONE_CAPTURE_COALITION self
  function ZoneCaptureCoalition:OnEnterGuarded( From, Event, To )
    if From ~= To then
      local Coalition = self:GetCoalition()
      self:E( { Coalition = Coalition } )
      if Coalition == coalition.side.BLUE then
        ZoneCaptureCoalition:Smoke( SMOKECOLOR.Blue )
        US_CC:MessageTypeToCoalition( string.format( "%s is under protection of the USA", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
        RU_CC:MessageTypeToCoalition( string.format( "%s is under protection of the USA", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
        --TasksRed[ZoneCaptureCoalition] = TASK_ZONE_CAPTURE:New( RU_Mission_Rastov, RU_ZoneCaptureGroupSet, ZoneCaptureCoalition:GetZoneName(), ZoneCaptureCoalition )
        RU_CC:SetMenu()
      else
        ZoneCaptureCoalition:Smoke( SMOKECOLOR.Red )
        RU_CC:MessageTypeToCoalition( string.format( "%s is under protection of Russia", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
        US_CC:MessageTypeToCoalition( string.format( "%s is under protection of Russia", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
        --TasksBlue[ZoneCaptureCoalition] = TASK_ZONE_CAPTURE:New( US_Mission_GroomLake, US_ZoneCaptureGroupSet, ZoneCaptureCoalition:GetZoneName(), ZoneCaptureCoalition )
        US_CC:SetMenu()
      end
    end
  end

  --- @param Functional.Protect#ZONE_CAPTURE_COALITION self
  function ZoneCaptureCoalition:OnEnterEmpty()
    ZoneCaptureCoalition:Smoke( SMOKECOLOR.Green )
    US_CC:MessageTypeToCoalition( string.format( "%s is unprotected, and can be captured!", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
    RU_CC:MessageTypeToCoalition( string.format( "%s is unprotected, and can be captured!", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
  end
  
  
  --- @param Functional.Protect#ZONE_CAPTURE_COALITION self
  function ZoneCaptureCoalition:OnEnterAttacked()
    ZoneCaptureCoalition:Smoke( SMOKECOLOR.White )
    local Coalition = self:GetCoalition()
    self:E({Coalition = Coalition})
    if Coalition == coalition.side.BLUE then
      US_CC:MessageTypeToCoalition( string.format( "%s is under attack by Russia", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
      RU_CC:MessageTypeToCoalition( string.format( "We are attacking %s", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
    else
      RU_CC:MessageTypeToCoalition( string.format( "%s is under attack by the USA", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
      US_CC:MessageTypeToCoalition( string.format( "We are attacking %s", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
    end
  end
  
  --- @param Functional.Protect#ZONE_CAPTURE_COALITION self
  function ZoneCaptureCoalition:OnEnterCaptured()
    local Coalition = self:GetCoalition()
    self:E({Coalition = Coalition})
    if Coalition == coalition.side.BLUE then
      RU_CC:MessageTypeToCoalition( string.format( "%s is captured by the USA, we lost it!", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
      US_CC:MessageTypeToCoalition( string.format( "We captured %s, Excellent job!", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
      --TasksBlue[ZoneCaptureCoalition]:Remove()
      --TasksBlue[ZoneCaptureCoalition] = nil
      local ZoneID = ZoneCaptureCoalition:GetZone().ZoneID
      US_FuelTanks[ZoneID][1]:Spawn( 0 ) 
      US_FuelTanks[ZoneID][2]:Spawn( 0 )
      US_FuelTanks[ZoneID][3]:Spawn( 0 )
    else
      US_CC:MessageTypeToCoalition( string.format( "%s is captured by Russia, we lost it!", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
      RU_CC:MessageTypeToCoalition( string.format( "We captured %s, Excellent job!", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
      --TasksRed[ZoneCaptureCoalition]:Remove()
      --TasksRed[ZoneCaptureCoalition] = nil
      local ZoneID = ZoneCaptureCoalition:GetZone().ZoneID
      RU_FuelTanks[ZoneID][1]:Spawn( 0 ) 
      RU_FuelTanks[ZoneID][2]:Spawn( 0 )
      RU_FuelTanks[ZoneID][3]:Spawn( 0 )
    end
    
    RU_A2G_CAS_Spawn[math.random(#RU_A2G_CAS_Spawn)]:Spawn()

    --self:AddScore( "Captured", "Zone captured: Extra points granted.", 200 )    

    local TotalContributions = ZoneCaptureCoalition.Goal:GetTotalContributions()
    local PlayerContributions = ZoneCaptureCoalition.Goal:GetPlayerContributions()
    self:E( { TotalContributions = TotalContributions, PlayerContributions = PlayerContributions } )
    for PlayerName, PlayerContribution in pairs( PlayerContributions ) do
      Scoring:AddGoalScorePlayer( PlayerName, "Zone " .. self.ZoneGoal:GetZoneName() .." captured", PlayerContribution * GoalScore / TotalContributions )
    end

    local AllBlueZonesGuarded = true
--    local AllRedZonesGuarded = true
    for ZoneID = 1, ZoneRandom do
      local ZoneCaptureCoalition = ZonesCaptureCoalition[ZoneID] -- Functional.ZoneCaptureCoalition#ZONE_CAPTURE_COALITION
      if not ZoneCaptureCoalition.Goal:IsAchieved() then
        if ZoneCaptureCoalition:GetCoalition() ~= coalition.side.BLUE then
          AllBlueZonesGuarded = false
        end
--        if ZoneCaptureCoalition:GetCoalition() ~= coalition.side.RED then
--          AllRedZonesGuarded = false
--        end
      end
    end

    if AllBlueZonesGuarded == true then
      US_Mission_GroomLake:Complete()
      FlagMissionEnd:Set( 1 )
      US_VictorySound:ToAll()
    end

--    if AllRedZonesGuarded == true then
--      RU_Mission_Rastov:Complete()
--      FlagMissionEnd:Set( 1 )
--      RU_VictorySound:ToAll()
--    end
    
    self:__Guard( 30 )
  end
  
  -- Create the tasks under the mission
  
  
  ZoneCaptureCoalition:__Guard( 1 )
  
end


-- Validate Blue Victory

US_Attack = ZONE:New( "US_Attack" )

BlueVictoryCheck = BASE:ScheduleRepeat( 30, 30, 0, nil,
  function()
    local AllBlueDestroyed = US_Attack:IsNoneInZoneOfCoalition( coalition.side.BLUE )
    if AllBlueDestroyed == true then
      RU_Mission_Rastov:Complete()
      FlagMissionEnd:Set( 1 )
      RU_VictorySound:ToAll()
    end
  end
)


--- Setup A2A defenses for RED.

RU_GciCap = AI_A2A_GCICAP:New( "RU_G2A_EWR", "RU_A2A_GCI_CAP", "RU_ZONE_CAP", 2, 20000, 200000, 250000 )

--RU_GciCap:SetTacticalDisplay( true )
