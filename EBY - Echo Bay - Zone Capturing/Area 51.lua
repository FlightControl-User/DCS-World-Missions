
do -- Setup the Command Centers
  
  RU_CC = COMMANDCENTER:New( GROUP:FindByName( "REDHQ" ), "Russia HQ" )
  US_CC = COMMANDCENTER:New( GROUP:FindByName( "BLUEHQ" ), "USA HQ" )

end

do -- Missions

  Scoring = SCORING:New( "Area 51" )
  
  US_Mission_EchoBay = MISSION:New( US_CC, "Echo Bay", "Primary",
    "Welcome trainee. The airport Groom Lake in Echo Bay needs to be captured.\n" ..
    "There are five random capture zones located at the airbase.\n" ..
    "Move to one of the capture zones, destroy the fuel tanks in the capture zone, " ..
    "and occupy each capture zone with a platoon.\n " .. 
    "Your orders are to hold position until all capture zones are taken.\n" ..
    "Use the map (F10) for a clear indication of the location of each capture zone.\n" ..
    "Note that heavy resistance can be expected at the airbase!\n" ..
    "Mission 'Echo Bay' is complete when all five capture zones are taken, and held for at least 5 minutes!"
    , coalition.side.RED)
    
  US_Mission_EchoBay:AddScoring( Scoring )
  
  US_Mission_EchoBay:Start()

  RU_Mission_Rastov = MISSION:New( RU_CC, "Rastov", "Primary",
    "Welcome trainee. The zones in Rastov needs to be captured.\n" ..
    "There are five random capture zones located at the airbase.\n" ..
    "Move to one of the capture zones, destroy the fuel tanks in the capture zone, " ..
    "and occupy each capture zone with a platoon.\n " .. 
    "Your orders are to hold position until all capture zones are taken.\n" ..
    "Use the map (F10) for a clear indication of the location of each capture zone.\n" ..
    "Note that heavy resistance can be expected at the airbase!\n" ..
    "Mission 'Rastov' is complete when all five capture zones are taken, and held for at least 5 minutes!"
    , coalition.side.BLUE)
    
  RU_Mission_Rastov:AddScoring( Scoring )
  
  RU_Mission_Rastov:Start()

end





RU_A2G_CAS_Templates = { 
  "RU_A2G_CAS #001",
  "RU_A2G_CAS #002",
  "RU_A2G_CAS #003",
  "RU_A2G_CAS #004",
  "RU_A2G_CAS #006",
  "RU_A2G_CAS #007",
  }
  
RU_G2G_ARM_Templates = {
  "RU_G2G_ARM_T #001",
  "RU_G2G_ARM_T #002",
  "RU_G2G_ARM_T #003"
}

RU_Spawn = {
  SPAWN:New( "RU_G2G_ARM_S #001" ):InitLimit( 6, 12 ):InitRandomizeTemplate( RU_G2G_ARM_Templates ):InitArray( 0, 20, 10, 10 ),
  SPAWN:New( "RU_G2G_ARM_S #002" ):InitLimit( 6, 12 ):InitRandomizeTemplate( RU_G2G_ARM_Templates ):InitArray( 0, 20, 10, 10 ),
  SPAWN:New( "RU_G2G_ARM_S #003" ):InitLimit( 6, 12 ):InitRandomizeTemplate( RU_G2G_ARM_Templates ):InitArray( 0, 20, 10, 10 ),
  SPAWN:New( "RU_A2G_CAS_S #001" ):InitLimit( 2, 12 ),
  SPAWN:New( "RU_A2G_CAS_S #002" ):InitLimit( 2, 12 ),
  SPAWN:New( "RU_A2G_CAS_S #003" ):InitLimit( 2, 12 ),
  SPAWN:New( "RU_A2G_CAS_S #004" ):InitLimit( 2, 12 ),
  SPAWN:New( "RU_A2G_CAS_S #005" ):InitLimit( 2, 12 ),
  SPAWN:New( "RU_A2G_CAS_S #006" ):InitLimit( 2, 12 ),
  }

local RU_ZoneCount = 13
local US_ZoneCount = 6

local ZoneRandom = 5

local US_ZoneNames = { "Alpha","Beta","Gamma","Delta","Epsilon","Zeta","Eta","Theta","Iota","Kappa","Lambda","Mu","Nu","Xi","Omicron","Pi","Rho","Sigma","Tua","Upsilon","Phi","Chi","Psi","Omega","Digamma",}
local RU_ZoneNames = { "Alpha","Beta","Gamma","Delta","Epsilon","Zeta","Eta","Theta","Iota","Kappa","Lambda","Mu","Nu","Xi","Omicron","Pi","Rho","Sigma","Tua","Upsilon","Phi","Chi","Psi","Omega","Digamma",}

local RU_ZonesCapture = {}

for RU_ZoneID = 1, RU_ZoneCount do
  RU_ZonesCapture[RU_ZoneID] = ZONE:New( "RU_CAPTURE_" .. RU_ZoneID )
end


local US_ZonesCapture = {}

for US_ZoneID = 1, US_ZoneCount do
  US_ZonesCapture[US_ZoneID] = ZONE:New( "US_CAPTURE_" .. US_ZoneID )
end

--- Model the MISSION for RED

ZonesCaptureCoalition = {}

for RU_ZoneID = 1, ZoneRandom do

  local RandomZoneID = math.random( 1, #RU_ZonesCapture )
  local RandomZoneNameID = math.random( 1, #RU_ZoneNames )
  
  local ZoneCaptureCoalition = ZONE_CAPTURE_COALITION:New( RU_ZonesCapture[RandomZoneID], coalition.side.RED ) 
  ZoneCaptureCoalition:GetZone():SetName( RU_ZoneNames[RandomZoneNameID] )
  table.insert( ZonesCaptureCoalition, ZoneCaptureCoalition )
  
  table.remove( RU_ZonesCapture, RandomZoneID )
  table.remove( RU_ZoneNames, RandomZoneNameID )
end

for US_ZoneID = 1, ZoneRandom do

  local RandomZoneID = math.random( 1, #US_ZonesCapture )
  local RandomZoneNameID = math.random( 1, #US_ZoneNames )
  
  local ZoneCaptureCoalition = ZONE_CAPTURE_COALITION:New( US_ZonesCapture[RandomZoneID], coalition.side.BLUE )
  ZoneCaptureCoalition:GetZone():SetName( US_ZoneNames[RandomZoneNameID] )
  table.insert( ZonesCaptureCoalition, ZoneCaptureCoalition )
  
  table.remove( US_ZonesCapture, RandomZoneID )
  table.remove( US_ZoneNames, RandomZoneNameID )
end

local US_ZoneCaptureGroupSet = SET_GROUP:New():FilterCoalitions("blue"):FilterStart()
local RU_ZoneCaptureGroupSet = SET_GROUP:New():FilterCoalitions("red"):FilterStart()

TasksRed = {}
TasksBlue = {}


for CaptureZoneID = 1, ZoneRandom * 2 do

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
        TasksRed[ZoneCaptureCoalition] = TASK_ZONE_CAPTURE:New( RU_Mission_Rastov, RU_ZoneCaptureGroupSet, ZoneCaptureCoalition:GetZoneName(), ZoneCaptureCoalition )
        RU_CC:SetMenu()
      else
        ZoneCaptureCoalition:Smoke( SMOKECOLOR.Red )
        RU_CC:MessageTypeToCoalition( string.format( "%s is under protection of Russia", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
        US_CC:MessageTypeToCoalition( string.format( "%s is under protection of Russia", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
        TasksBlue[ZoneCaptureCoalition] = TASK_ZONE_CAPTURE:New( US_Mission_EchoBay, US_ZoneCaptureGroupSet, ZoneCaptureCoalition:GetZoneName(), ZoneCaptureCoalition )
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
      TasksBlue[ZoneCaptureCoalition]:Remove()
      TasksBlue[ZoneCaptureCoalition] = nil
    else
      US_CC:MessageTypeToCoalition( string.format( "%s is captured by Russia, we lost it!", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
      RU_CC:MessageTypeToCoalition( string.format( "We captured %s, Excellent job!", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
      TasksRed[ZoneCaptureCoalition]:Remove()
      TasksRed[ZoneCaptureCoalition] = nil
    end
    
    RU_Spawn[math.random(#RU_Spawn)]:Spawn()

    self:AddScore( "Captured", "Zone captured: Extra points granted.", 200 )    

    local AllRedZonesGuarded = true
    local AllBlueZonesGuarded = true
    for ZoneID = 1, ZoneRandom do
      local ZoneCaptureCoalition = ZonesCaptureCoalition[ZoneID] -- Functional.ZoneCaptureCoalition#ZONE_CAPTURE_COALITION
      if not ZoneCaptureCoalition.Goal:IsAchieved() then
        if ZoneCaptureCoalition:GetCoalition() == coalition.side.BLUE then
          AllBlueZonesGuarded = false
        end
        if ZoneCaptureCoalition:GetCoalition() == coalition.side.RED then
          AllRedZonesGuarded = false
        end
      end
    end
    if AllBlueZonesGuarded == true then
      US_Mission_EchoBay:Complete()
    end

    if AllRedZonesGuarded == true then
      RU_Mission_Rastov:Complete()
    end
    
    self:__Guard( 30 )
  end
  
  -- Create the tasks under the mission
  
  
  ZoneCaptureCoalition:__Guard( 1 )
  
end



