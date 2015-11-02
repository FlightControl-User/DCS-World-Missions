env.setErrorMessageBoxEnabled(false)

Su34Status = { status = {} }
boardMsgRed = { statusMsg = "" }
boardMsgAll = { timeMsg = "" }
SpawnSettings = {}
Su34MenuPath = {}
Su34Menus = 0

_MusicTable = {}
_MusicTable.Files = {}
_MusicTable.Queue = {}
_MusicTable.FileCnt = 0

function Su34AttackCarlVinson(groupName)
	local groupSu34 = Group.getByName( groupName )
	local controllerSu34 = groupSu34.getController(groupSu34)
	local groupCarlVinson = Group.getByName("US Carl Vinson #001")
	controllerSu34.setOption( controllerSu34, AI.Option.Air.id.ROE, AI.Option.Air.val.ROE.OPEN_FIRE )
	controllerSu34.setOption( controllerSu34, AI.Option.Air.id.REACTION_ON_THREAT, AI.Option.Air.val.REACTION_ON_THREAT.EVADE_FIRE )
	if groupCarlVinson ~= nil then
		controllerSu34.pushTask(controllerSu34,{id = 'AttackGroup', params = { groupId = groupCarlVinson:getID(), expend = AI.Task.WeaponExpend.ALL, attackQtyLimit = true}})
	end
	Su34Status.status[groupName] = 1
	MessageToRed( string.format('%s: ',groupName) .. 'Attacking carrier Carl Vinson. ', 10, 'RedStatus' .. groupName )
end

function Su34AttackWest(groupName)
	local groupSu34 = Group.getByName( groupName )
	local controllerSu34 = groupSu34.getController(groupSu34)
	local groupShipWest1 = Group.getByName("US Ship West #001")
	local groupShipWest2 = Group.getByName("US Ship West #002")
	controllerSu34.setOption( controllerSu34, AI.Option.Air.id.ROE, AI.Option.Air.val.ROE.OPEN_FIRE )
	controllerSu34.setOption( controllerSu34, AI.Option.Air.id.REACTION_ON_THREAT, AI.Option.Air.val.REACTION_ON_THREAT.EVADE_FIRE )
	if groupShipWest1 ~= nil then
		controllerSu34.pushTask(controllerSu34,{id = 'AttackGroup', params = { groupId = groupShipWest1:getID(), expend = AI.Task.WeaponExpend.ALL, attackQtyLimit = true}})
	end
	if groupShipWest2 ~= nil then
		controllerSu34.pushTask(controllerSu34,{id = 'AttackGroup', params = { groupId = groupShipWest2:getID(), expend = AI.Task.WeaponExpend.ALL, attackQtyLimit = true}})
	end
	Su34Status.status[groupName] = 2
	MessageToRed( string.format('%s: ',groupName) .. 'Attacking invading ships in the west. ', 10, 'RedStatus' .. groupName )
end

function Su34AttackNorth(groupName)
	local groupSu34 = Group.getByName( groupName )
	local controllerSu34 = groupSu34.getController(groupSu34)
	local groupShipNorth1 = Group.getByName("US Ship North #001")
	controllerSu34.setOption( controllerSu34, AI.Option.Air.id.ROE, AI.Option.Air.val.ROE.OPEN_FIRE )
	controllerSu34.setOption( controllerSu34, AI.Option.Air.id.REACTION_ON_THREAT, AI.Option.Air.val.REACTION_ON_THREAT.EVADE_FIRE )
	if groupShipNorth1 ~= nil then
		controllerSu34.pushTask(controllerSu34,{id = 'AttackGroup', params = { groupId = groupShipNorth1:getID(), expend = AI.Task.WeaponExpend.ALL, attackQtyLimit = false}})
	end
	Su34Status.status[groupName] = 3
	MessageToRed( string.format('%s: ',groupName) .. 'Attacking invading ships in the north. ', 10, 'RedStatus' .. groupName )
end

function Su34Orbit(groupName)
	local groupSu34 = Group.getByName( groupName )
	local controllerSu34 = groupSu34:getController()
	controllerSu34.setOption( controllerSu34, AI.Option.Air.id.ROE, AI.Option.Air.val.ROE.WEAPON_HOLD )
	controllerSu34.setOption( controllerSu34, AI.Option.Air.id.REACTION_ON_THREAT, AI.Option.Air.val.REACTION_ON_THREAT.EVADE_FIRE )
	controllerSu34:pushTask( {id = 'ControlledTask', params = { task = { id = 'Orbit', params = { pattern = AI.Task.OrbitPattern.RACE_TRACK } }, stopCondition = { duration = 600 } } } )
	Su34Status.status[groupName] = 4
	MessageToRed( string.format('%s: ',groupName) .. 'In orbit and awaiting further instructions. ', 10, 'RedStatus' .. groupName )
end

function Su34TakeOff(groupName)
	local groupSu34 = Group.getByName( groupName )
	local controllerSu34 = groupSu34:getController()
	controllerSu34.setOption( controllerSu34, AI.Option.Air.id.ROE, AI.Option.Air.val.ROE.WEAPON_HOLD )
	controllerSu34.setOption( controllerSu34, AI.Option.Air.id.REACTION_ON_THREAT, AI.Option.Air.val.REACTION_ON_THREAT.BYPASS_AND_ESCAPE )
	Su34Status.status[groupName] = 8
	MessageToRed( string.format('%s: ',groupName) .. 'Take-Off. ', 10, 'RedStatus' .. groupName )	
end

function Su34Hold(groupName)
	local groupSu34 = Group.getByName( groupName )
	local controllerSu34 = groupSu34:getController()
	controllerSu34.setOption( controllerSu34, AI.Option.Air.id.ROE, AI.Option.Air.val.ROE.WEAPON_HOLD )
	controllerSu34.setOption( controllerSu34, AI.Option.Air.id.REACTION_ON_THREAT, AI.Option.Air.val.REACTION_ON_THREAT.BYPASS_AND_ESCAPE )
	Su34Status.status[groupName] = 5
	MessageToRed( string.format('%s: ',groupName) .. 'Holding Weapons. ', 10, 'RedStatus' .. groupName )
end

function Su34RTB(groupName)
	Su34Status.status[groupName] = 6
	MessageToRed( string.format('%s: ',groupName) .. 'Return to Krasnodar. ', 10, 'RedStatus' .. groupName )
end

function Su34Destroyed(groupName)
	Su34Status.status[groupName] = 7
	MessageToRed( string.format('%s: ',groupName) .. 'Destroyed. ', 30, 'RedStatus' .. groupName )
end

function GroupAlive( groupName )
	mist.debug.info('GroupAlive','groupName', { groupName } )
	local groupTest = Group.getByName( groupName )
	
	local groupExists = false
	
	if groupTest then
		groupExists = groupTest:isExist()
	end
	
	mist.debug.info( 'GroupAlive','groupExists', { groupExists } )
	
	return groupExists
end

function Su34IsDead()

end

function Su34OverviewStatus()
	local msg = ""
	local currentStatus = 0
	local Exists = false
	
	for groupName, currentStatus in pairs(Su34Status.status) do
		
		env.info(('Su34 Overview Status: GroupName = ' .. groupName ))
		Alive = GroupAlive( groupName )
		mist.debug.info( 'Su34OverviewStatus', 'Alive', {Alive} )
		
		if Alive then
			if currentStatus == 1 then
				msg = msg .. string.format("%s: ",groupName)
				msg = msg .. "Attacking carrier Carl Vinson. "
			elseif currentStatus == 2 then
				msg = msg .. string.format("%s: ",groupName)
				msg = msg .. "Attacking supporting ships in the west. "
			elseif currentStatus == 3 then
				msg = msg .. string.format("%s: ",groupName)
				msg = msg .. "Attacking invading ships in the north. "
			elseif currentStatus == 4 then
				msg = msg .. string.format("%s: ",groupName)
				msg = msg .. "In orbit and awaiting further instructions. "
			elseif currentStatus == 5 then
				msg = msg .. string.format("%s: ",groupName)
				msg = msg .. "Holding Weapons. "
			elseif currentStatus == 6 then
				msg = msg .. string.format("%s: ",groupName)
				msg = msg .. "Return to Krasnodar. "
			elseif currentStatus == 7 then
				msg = msg .. string.format("%s: ",groupName)
				msg = msg .. "Destroyed. "
			elseif currentStatus == 8 then
				msg = msg .. string.format("%s: ",groupName)
				msg = msg .. "Take-Off. "
			end
		else
			if currentStatus == 7 then
				msg = msg .. string.format("%s: ",groupName)
				msg = msg .. "Destroyed. "
			else
				Su34Destroyed(groupName)
			end
		end
	end

	boardMsgRed.statusMsg = msg
end

function UpdateTimeMsg()
	boardMsgAll.timeMsg = string.format("%00d",120 - ( timer.getTime() / 60 )) .. ' Minutes left.'
	MessageToAll( boardMsgAll.timeMsg, 5, 'AllTime' )
end

function UpdateBoardMsg()
	Su34OverviewStatus()
	MessageToRed( boardMsgRed.statusMsg, 15, 'RedStatus' )
end



function ShowStatusBoard( flg )
	trigger.action.setUserFlag(96,flg)
end

function MusicReset( flg )
	trigger.action.setUserFlag(95,flg)
end

function PlaneActivate(groupNameFormat, flg)
	local groupName = groupNameFormat .. string.format("%03d", trigger.misc.getUserFlag(flg))
	--trigger.action.outText(groupName,10)
	trigger.action.activateGroup(Group.getByName(groupName))
end

function Su34Menu(groupName)
	
	--env.info(( 'Su34Menu(' .. groupName .. ')' ))
	local groupSu34 = Group.getByName( groupName )

	if Su34Status.status[groupName] == 1 or
	   Su34Status.status[groupName] == 2 or
	   Su34Status.status[groupName] == 3 or
	   Su34Status.status[groupName] == 4 or
	   Su34Status.status[groupName] == 5 then
		if Su34MenuPath[groupName] == nil then
			Su34MenuPath[groupName] = missionCommands.addSubMenuForCoalition(
				coalition.side.RED, 
				"Flight " .. groupName, 
				planeMenuPath
			)

			missionCommands.addCommandForCoalition( 
				coalition.side.RED, 
				groupName .. " attack carrier Carl Vinson",
				Su34MenuPath[groupName],
				Su34AttackCarlVinson, 
				groupName
			)

			missionCommands.addCommandForCoalition( 
				coalition.side.RED, 
				groupName .. " attack ships in the west",
				Su34MenuPath[groupName],
				Su34AttackWest, 
				groupName
			)
			
			missionCommands.addCommandForCoalition( 
				coalition.side.RED, 
				groupName .. " attack ships in the north",
				Su34MenuPath[groupName],
				Su34AttackNorth, 
				groupName
			)

			missionCommands.addCommandForCoalition( 
				coalition.side.RED, 
				groupName .. " hold position and await instructions",
				Su34MenuPath[groupName],
				Su34Orbit,
				groupName
			)

			missionCommands.addCommandForCoalition( 
				coalition.side.RED, 
				groupName .. " report status",
				Su34MenuPath[groupName],
				Su34OverviewStatus
			)
		end
	else
		if Su34MenuPath[groupName] then
			missionCommands.removeItemForCoalition(coalition.side.RED, Su34MenuPath[groupName])
		end
	end
end

function MainMenu()
	local statusMenuPath
	local musicMenuPath
	

	statusMenuPath = missionCommands.addSubMenu(
		"Status board", 
		nil
	)

	musicMenuPath = missionCommands.addSubMenu(
		"Music", 
		nil
	)

	planeMenuPath = missionCommands.addSubMenuForCoalition(
		coalition.side.RED, 
		"SU-34 anti-ship flights", 
		nil
	)
	
	missionCommands.addCommand( 
		"Status board on",
		statusMenuPath,
		ShowStatusBoard,
		2
	)

	missionCommands.addCommand( 
		"Status board off",
		statusMenuPath,
		ShowStatusBoard,
		0
	)
	
	missionCommands.addCommand( 
		"Music On",
		musicMenuPath,
		MusicReset,
		99
	)
	
	missionCommands.addCommand( 
		"Music Off",
		musicMenuPath,
		MusicReset,
		100
	)

end




-- Call this function first to initialize the SpawnSettings table, which is required to have in order to have the spawning working.
function SpawnInit( SpawnPrefix, SpawnGroupOffSet, SpawnLowTimer, SpawnHighTimer, SpawnStartPoint, SpawnEndPoint, SpawnRadius, SpawnMaxUnits, SpawnMaxGroups )
	--env.info(('Spawn Init: ' .. SpawnPrefix .. ' - ' .. SpawnLowTimer .. ' - ' .. SpawnHighTimer .. ' - ' .. SpawnRadius .. ' - ' .. SpawnMaxUnits))

	SpawnSettings[SpawnPrefix] = {}
	SpawnSettings[SpawnPrefix]['SpawnCount'] = 0
	SpawnSettings[SpawnPrefix]['SpawnGroupOffSet'] = SpawnGroupOffSet
	SpawnSettings[SpawnPrefix]['SpawnLowTimer'] = SpawnLowTimer
	SpawnSettings[SpawnPrefix]['SpawnHighTimer'] = SpawnHighTimer
	SpawnSettings[SpawnPrefix]['SpawnCurrentTimer'] = 0
	SpawnSettings[SpawnPrefix]['SpawnSetTimer'] = 0
	SpawnSettings[SpawnPrefix]['SpawnRadius'] = SpawnRadius
	SpawnSettings[SpawnPrefix]['SpawnMaxUnits'] = SpawnMaxUnits
	SpawnSettings[SpawnPrefix]['SpawnMaxGroups'] = SpawnMaxGroups
	SpawnSettings[SpawnPrefix]['SpawnStartPoint'] = SpawnStartPoint
	SpawnSettings[SpawnPrefix]['SpawnEndPoint'] = SpawnEndPoint
	SpawnSettings[SpawnPrefix]['SpawnScheduled'] = false
	SpawnSettings[SpawnPrefix]['AliveFactor'] = 1

	-- Start Spawning when the low and high timer width values are filled out
	if SpawnLowTimer ~= 0 and SpawnHighTimer ~= 0 then
		SpawnStart( SpawnPrefix )
	end
end

function AliveUnits( )

	env.info(( 'AliveUnits:' ))

	local ClientUnit = 0
	local AliveUnitsRed = coalition.getGroups(coalition.side.RED)
	local AliveUnitsBlue = coalition.getGroups(coalition.side.BLUE)
	local unitId
	local unitData
	local AliveUnits = {}
	
	for unitId, unitData in pairs(AliveUnitsRed) do
		if unitData:isExist() then
			env.info(('AliveUnits: Alive RED Unit = ' .. unitData:getName() ))
			ClientUnit = ClientUnit + 1
			AliveUnits[ClientUnit] = unitData
		end
	end

	for unitId, unitData in pairs(AliveUnitsBlue) do
		if unitData:isExist() then
			env.info(('AliveUnits: Alive BLUE Unit = ' .. unitData:getName() ))
			ClientUnit = ClientUnit + 1
			AliveUnits[ClientUnit] = unitData
		end
	end

	env.info(( 'AliveUnits: ' .. ClientUnit ))
	
	return AliveUnits

end

-- Call this function to start the Spawning scheduling.
function SpawnStart(SpawnPrefix)
	env.info(( 'SpawnStart: ' .. SpawnPrefix ))

	local ClientUnit = #AlivePlayerUnits()
	
	SpawnSettings[SpawnPrefix]['AliveFactor'] = ( 10 - ClientUnit  ) / 10
	
	if SpawnSettings[SpawnPrefix]['SpawnScheduled'] == false then
		SpawnSettings[SpawnPrefix]['SpawnScheduled'] = true
		SpawnSettings[SpawnPrefix]['SpawnSetTimer'] = math.random( SpawnSettings[SpawnPrefix]['SpawnLowTimer'] * SpawnSettings[SpawnPrefix]['AliveFactor'] / 10 , SpawnSettings[SpawnPrefix]['SpawnHighTimer'] * SpawnSettings[SpawnPrefix]['AliveFactor']  / 10 )
		
		SpawnSettings[SpawnPrefix]['SpawnFunction'] = mist.scheduleFunction( SpawnScheduled, { SpawnPrefix }, timer.getTime() + 1, 1)
	end
	
	--env.info(( 'SpawnStart: end' ))
end

-- Call this function to stop the Spawning scheduling.
function SpawnStop(SpawnPrefix)
	--env.info(( 'SpawnStop: ' .. SpawnPrefix ))
	SpawnSettings[SpawnPrefix]['SpawnScheduled'] = false
	--env.info(( 'SpawnStop: end' ))
end

-- Use this function to spawn an extra entity when required based on programmed logic
function SpawnExtra(SpawnPrefix)
	--env.info(( 'SpawnExtra: ' .. SpawnPrefix ))

	Spawn( SpawnPrefix )

	--env.info(( 'SpawnExtra: end' ))
end

-- This function is called automatically by the Spawning scheduler. A new function is scheduled when SpawnScheduled is true.
function SpawnScheduled(SpawnPrefix)
	--env.info(( 'SpawnScheduled: ' .. SpawnPrefix ))

	if SpawnSettings[SpawnPrefix]['SpawnCurrentTimer'] == SpawnSettings[SpawnPrefix]['SpawnSetTimer'] then
		Spawn( SpawnPrefix )
		if SpawnSettings[SpawnPrefix]['SpawnScheduled'] == true then
			local ClientUnit = #AlivePlayerUnits()
			SpawnSettings[SpawnPrefix]['AliveFactor'] = ( 10 - ClientUnit  ) / 10
			SpawnSettings[SpawnPrefix]['SpawnCurrentTimer'] = 0
			SpawnSettings[SpawnPrefix]['SpawnSetTimer'] = math.random( SpawnSettings[SpawnPrefix]['SpawnLowTimer'] * SpawnSettings[SpawnPrefix]['AliveFactor'] , SpawnSettings[SpawnPrefix]['SpawnHighTimer'] * SpawnSettings[SpawnPrefix]['AliveFactor'] )
		end
	else
		SpawnSettings[SpawnPrefix]['SpawnCurrentTimer'] = SpawnSettings[SpawnPrefix]['SpawnCurrentTimer'] + 1
	end
	
	--env.info(( 'SpawnScheduled: end' ))
end

function Respawn( ReSpawnGroup )

	local SpawnGroup = {}
	local SpawnUnits
	local RouteCount

	local SpawnPrefix = string.match( ReSpawnGroup:getName(), ".*#" )
	local SpawnCount = string.sub( string.match( ReSpawnGroup:getName(), "#.*" ), 2 )
	
	--Get the Group Data with Mist
	SpawnGroup =  mist.getGroupData(SpawnPrefix .. "000" )
	
	if SpawnGroup ~= nil then

		-- Get the Group Route as the variable points (getGroupData does not do that ...)
		SpawnGroup.route = {}
		SpawnGroup.route.points = mist.getGroupRoute(SpawnPrefix.."000", true)
		

		--Initialize troops deployment (default = no troops deployed)
		--SpawnSettings[SpawnPrefix]['SpawnInfantry']['SpawnCount']['Spawned'] = 0

		SpawnGroup.name = string.format( SpawnPrefix .. '%03d', SpawnCount )
		SpawnGroup.groupName = string.format( SpawnPrefix .. '%03d', SpawnCount )
		
		SpawnUnits = #SpawnGroup.units
		for u = 1, SpawnUnits do
			SpawnGroup.units[u].unitName = string.format( SpawnPrefix .. '%03d-%02d', SpawnCount, u )
			--if type(SpawnGroup.units[u].callsign) == "table" then
			--	env.info(( 'Callsign = ' .. SpawnGroup.units[u].callsign[1]..','..SpawnGroup.units[u].callsign[2]..','..SpawnGroup.units[u].callsign[3]..','..SpawnGroup.units[u].callsign['name'] ))
			--else
			--	if type(SpawnGroup.units[u].callsign) == "number" then
			--		env.info(( 'Callsign = ' .. SpawnGroup.units[u].callsign ))
			--	end
			--end
			--env.info(( 'Spawn: SpawnGroup.units['..u..'].unitName = ' .. SpawnGroup.units[u].unitName ))
		end
		
		SpawnGroup.groupId = ReSpawnGroup.ID

		RouteCount = table.getn(SpawnGroup.route.points)
		--env.info(( 'Spawn: SpawnPrefix = ' .. SpawnPrefix ))
		--env.info(( 'Spawn: RouteCount = ' .. RouteCount ))
		--env.info(( 'Spawn: SpawnSettings[SpawnPrefix][SpawnStartPoint] = ' .. SpawnSettings[SpawnPrefix]['SpawnStartPoint'] ))
		--env.info(( 'Spawn: SpawnSettings[SpawnPrefix][SpawnEndPoint] = ' .. SpawnSettings[SpawnPrefix]['SpawnEndPoint'] ))
		--env.info(( 'Spawn: SpawnSettings[SpawnPrefix][SpawnRadius] = ' .. SpawnSettings[SpawnPrefix]['SpawnRadius'] ))
		
		if SpawnSettings[SpawnPrefix]['SpawnStartPoint'] == 0 and SpawnSettings[SpawnPrefix]['SpawnEndPoint'] == 0 then
		else
			for t = SpawnSettings[SpawnPrefix]['SpawnStartPoint'], RouteCount - SpawnSettings[SpawnPrefix]['SpawnEndPoint'] do
				if t ~= RouteCount then
					SpawnGroup.route.points[t].x = SpawnGroup.route.points[t].x + math.random(SpawnSettings[SpawnPrefix]['SpawnRadius'] * -1, SpawnSettings[SpawnPrefix]['SpawnRadius'])
					SpawnGroup.route.points[t].y = SpawnGroup.route.points[t].y + math.random(SpawnSettings[SpawnPrefix]['SpawnRadius'] * -1, SpawnSettings[SpawnPrefix]['SpawnRadius'])
				else
					-- On the last routepoint, don't use the full randomness to determine the landing point.
					SpawnGroup.route.points[t].x = SpawnGroup.route.points[t].x + math.random(SpawnSettings[SpawnPrefix]['SpawnRadius'] * -1, SpawnSettings[SpawnPrefix]['SpawnRadius']) / 20
					SpawnGroup.route.points[t].y = SpawnGroup.route.points[t].y + math.random(SpawnSettings[SpawnPrefix]['SpawnRadius'] * -1, SpawnSettings[SpawnPrefix]['SpawnRadius']) / 20
				end
				--env.info(('Spawn: SpawnGroup.route.points[' .. t .. '].x = ' .. SpawnGroup.route.points[t].x .. ', SpawnGroup.route.points[' .. t .. '].y = ' .. SpawnGroup.route.points[t].y ))
			end
		end
		
		mist.dynAdd( SpawnGroup )
		
		
		--env.info(( 'Spawn: mist.dynAdd' ))
	else
		--env.info(( 'Spawn: Nothing Spawned. nil value returned ...' ))
	end

end

-- The core Spawning function.
function Spawn( SpawnPrefix )
	--env.info(( 'Spawn: ' .. SpawnPrefix ))
	local SpawnGroup = {}
	local SpawnCount
	local SpawnUnits
	local RouteCount
	
	if ( SpawnSettings[SpawnPrefix]['SpawnMaxGroups'] == 0 ) or ( SpawnSettings[SpawnPrefix]['SpawnCount'] <= SpawnSettings[SpawnPrefix]['SpawnMaxGroups'] ) then
	
		UnitCount = 0
		for unitId, unitData in pairs(mist.DBs.aliveUnits) do
			if string.match( unitData.unitName, ".*#" ) == SpawnPrefix then
				--env.info(('Spawn: Alive Unit = ' .. unitData.unitName ))
				UnitCount = UnitCount + 1
			end
		end
		
		env.info(( 'Spawn: UnitCount = ' .. UnitCount ))

		if UnitCount < SpawnSettings[SpawnPrefix]['SpawnMaxUnits'] then

			--Get the Group Data with Mist
			SpawnGroup =  mist.getGroupData(SpawnPrefix .. "000" )
			
			if SpawnGroup ~= nil then

				-- Get the Group Route as the variable points (getGroupData does not do that ...)
				SpawnGroup.route = {}
				SpawnGroup.route.points = mist.getGroupRoute(SpawnPrefix.."000", true)
				
				-- Increase the spawn counter for the group
				SpawnSettings[SpawnPrefix]['SpawnCount'] = SpawnSettings[SpawnPrefix]['SpawnCount']  + 1
				SpawnCount = SpawnSettings[SpawnPrefix]['SpawnCount']

				--Initialize troops deployment (default = no troops deployed)
				--SpawnSettings[SpawnPrefix]['SpawnInfantry']['SpawnCount']['Spawned'] = 0

				SpawnGroup.name = string.format( SpawnPrefix .. '%03d', SpawnCount )
				SpawnGroup.groupName = string.format( SpawnPrefix .. '%03d', SpawnCount )
				
				SpawnUnits = #SpawnGroup.units
				for u = 1, SpawnUnits do
					SpawnGroup.units[u].unitName = string.format( SpawnPrefix .. '%03d-%02d', SpawnCount, u )
					--if type(SpawnGroup.units[u].callsign) == "table" then
					--	env.info(( 'Callsign = ' .. SpawnGroup.units[u].callsign[1]..','..SpawnGroup.units[u].callsign[2]..','..SpawnGroup.units[u].callsign[3]..','..SpawnGroup.units[u].callsign['name'] ))
					--else
					--	if type(SpawnGroup.units[u].callsign) == "number" then
					--		env.info(( 'Callsign = ' .. SpawnGroup.units[u].callsign ))
					--	end
					--end
					--env.info(( 'Spawn: SpawnGroup.units['..u..'].unitName = ' .. SpawnGroup.units[u].unitName ))
				end
				
				SpawnGroup.groupId = nil

				RouteCount = table.getn(SpawnGroup.route.points)
				--env.info(( 'Spawn: SpawnPrefix = ' .. SpawnPrefix ))
				--env.info(( 'Spawn: RouteCount = ' .. RouteCount ))
				--env.info(( 'Spawn: SpawnSettings[SpawnPrefix][SpawnStartPoint] = ' .. SpawnSettings[SpawnPrefix]['SpawnStartPoint'] ))
				--env.info(( 'Spawn: SpawnSettings[SpawnPrefix][SpawnEndPoint] = ' .. SpawnSettings[SpawnPrefix]['SpawnEndPoint'] ))
				--env.info(( 'Spawn: SpawnSettings[SpawnPrefix][SpawnRadius] = ' .. SpawnSettings[SpawnPrefix]['SpawnRadius'] ))
				
				if SpawnSettings[SpawnPrefix]['SpawnStartPoint'] == 0 and SpawnSettings[SpawnPrefix]['SpawnEndPoint'] == 0 then
				else
					for t = SpawnSettings[SpawnPrefix]['SpawnStartPoint'], RouteCount - SpawnSettings[SpawnPrefix]['SpawnEndPoint'] do
						if t ~= RouteCount then
							SpawnGroup.route.points[t].x = SpawnGroup.route.points[t].x + math.random(SpawnSettings[SpawnPrefix]['SpawnRadius'] * -1, SpawnSettings[SpawnPrefix]['SpawnRadius'])
							SpawnGroup.route.points[t].y = SpawnGroup.route.points[t].y + math.random(SpawnSettings[SpawnPrefix]['SpawnRadius'] * -1, SpawnSettings[SpawnPrefix]['SpawnRadius'])
						else
							-- On the last routepoint, don't use the full randomness to determine the landing point.
							SpawnGroup.route.points[t].x = SpawnGroup.route.points[t].x + math.random(SpawnSettings[SpawnPrefix]['SpawnRadius'] * -1, SpawnSettings[SpawnPrefix]['SpawnRadius']) / 20
							SpawnGroup.route.points[t].y = SpawnGroup.route.points[t].y + math.random(SpawnSettings[SpawnPrefix]['SpawnRadius'] * -1, SpawnSettings[SpawnPrefix]['SpawnRadius']) / 20
						end
						--env.info(('Spawn: SpawnGroup.route.points[' .. t .. '].x = ' .. SpawnGroup.route.points[t].x .. ', SpawnGroup.route.points[' .. t .. '].y = ' .. SpawnGroup.route.points[t].y ))
					end
				end
				
				mist.dynAdd( SpawnGroup )
				
				
				--env.info(( 'Spawn: mist.dynAdd' ))
			else
				--env.info(( 'Spawn: Nothing Spawned. nil value returned ...' ))
			end

		end
	end

	--env.info(( 'Spawn: end' ))
end

function ChooseInfantry ( TeleportPrefixTable, TeleportMax )
	--env.info(( 'ChooseInfantry: ' ))

	TeleportPrefixTableCount = #TeleportPrefixTable
	TeleportPrefixTableIndex = math.random( 1, TeleportPrefixTableCount )
	
	--env.info(( 'ChooseInfantry: TeleportPrefixTableIndex = ' .. TeleportPrefixTableIndex .. ' TeleportPrefixTableCount = ' .. TeleportPrefixTableCount  .. ' TeleportMax = ' .. TeleportMax ))

	local TeleportFound = false
	local TeleportLoop = true
	local Index = TeleportPrefixTableIndex
	local TeleportPrefix = ''
	
	while TeleportLoop do
		TeleportPrefix = TeleportPrefixTable[Index]
		if SpawnSettings[TeleportPrefix] then
			if SpawnSettings[TeleportPrefix]['SpawnCount'] - 1 < TeleportMax then
				SpawnSettings[TeleportPrefix]['SpawnCount'] = SpawnSettings[TeleportPrefix]['SpawnCount'] + 1
				TeleportFound = true
			else
				TeleportFound = false
			end
		else
			SpawnSettings[TeleportPrefix] = {}
			SpawnSettings[TeleportPrefix]['SpawnCount'] = 0
			TeleportFound = true
		end
		if TeleportFound then
			TeleportLoop = false
		else
			if Index < TeleportPrefixTableCount then
				Index = Index + 1
			else
				TeleportLoop = false
			end
		end
		--env.info(( 'ChooseInfantry: Loop 1 - TeleportPrefix = ' .. TeleportPrefix .. ' Index = ' .. Index ))
	end
	
	if TeleportFound == false then
		TeleportLoop = true
		Index = 1
		while TeleportLoop do
			TeleportPrefix = TeleportPrefixTable[Index]
			if SpawnSettings[TeleportPrefix] then
				if SpawnSettings[TeleportPrefix]['SpawnCount'] - 1 < TeleportMax then
					SpawnSettings[TeleportPrefix]['SpawnCount'] = SpawnSettings[TeleportPrefix]['SpawnCount'] + 1
					TeleportFound = true
				else
					TeleportFound = false
				end
			else
				SpawnSettings[TeleportPrefix] = {}
				SpawnSettings[TeleportPrefix]['SpawnCount'] = 0
				TeleportFound = true
			end
			if TeleportFound then
				TeleportLoop = false
			else
				if Index < TeleportPrefixTableIndex then
					Index = Index + 1
				else
					TeleportLoop = false
				end
			end
		--env.info(( 'ChooseInfantry: Loop 2 - TeleportPrefix = ' .. TeleportPrefix .. ' Index = ' .. Index ))
		end
	end

	local TeleportGroupName = ''
	if TeleportFound == true then
		TeleportGroupName = TeleportPrefix .. string.format("%03d", SpawnSettings[TeleportPrefix]['SpawnCount'] )
	else
		TeleportGroupName = ''
	end
	
	--env.info(('ChooseInfantry: TeleportGroupName = ' .. TeleportGroupName ))
	--env.info(('ChooseInfantry: return'))
	
	return TeleportGroupName
end

SpawnedInfantry = 0

function SpawnInfantry ( CarrierGroup, SpawnTableOrStringPrefix, TargetZonePrefix, SpawnStartPoint, SpawnEndPoint )
	env.info(( 'SpawnInfantry: ' ))
	
	local GroupUnits = CarrierGroup:getUnits()
	local GroupUnitCount = table.getn(GroupUnits)
	env.info(( 'SpawnInfantry: GroupUnitCount = ' .. GroupUnitCount ))

	for UnitId, UnitData in pairs(GroupUnits)  do
	
		UnitDeploy = UnitData
		
		local SpawnPrefix = ''

		--Get the Group Data with Mist
		if type(SpawnTableOrStringPrefix) == 'string' then
			SpawnPrefix = SpawnTableOrStringPrefix
		else
			if type(SpawnTableOrStringPrefix) == 'table' then
				SpawnPrefix = SpawnTableOrStringPrefix[math.random(1,#SpawnTableOrStringPrefix)]
			end
		end

		local SpawnGroup =  mist.getGroupData(SpawnPrefix.."000")

		-- Get the Group Route (getGroupData does not do that ...)
		SpawnGroup.route = {}
		SpawnGroup.route.points = mist.getGroupRoute(SpawnPrefix.."000", true)


		SpawnedInfantry = SpawnedInfantry + 1
		SpawnGroupName = SpawnPrefix .. string.format("%03d", SpawnedInfantry )
		
		SpawnGroup.name = SpawnGroupName
		SpawnGroup.groupName =  SpawnGroupName
		env.info(( 'SpawnInfantry: SpawnGroupName = ' .. SpawnGroupName ))
		
		SpawnGroup.start_time = 0
		SpawnGroup.lateActivation = false
		SpawnGroup.groupId = nil
		SpawnGroup.hidden = false

		local UnitDeployPosition = UnitDeploy:getPoint()

		local TargetZone = trigger.misc.getZone( TargetZonePrefix )
		local TargetZonePos = {}
		TargetZonePos.x = TargetZone.point.x + math.random(TargetZone.radius * -1, TargetZone.radius)
		TargetZonePos.z = TargetZone.point.z + math.random(TargetZone.radius * -1, TargetZone.radius)

		local RouteCount = table.getn(SpawnGroup.route.points)
		env.info(( 'SpawnInfantry: RouteCount = ' .. RouteCount ))

		SpawnGroup.route.points[1].x = UnitDeployPosition.x - 50
		SpawnGroup.route.points[1].y = UnitDeployPosition.z
		SpawnGroup.route.points[1].alt = nil
		SpawnGroup.route.points[1].alt_type = nil

		if SpawnStartPoint ~= 0 and SpawnEndPoint ~= 0 then
			for t = SpawnStartPoint, RouteCount + SpawnEndPoint do
				SpawnGroup.route.points[t].x = SpawnGroup.route.points[t].x + math.random(TargetZone.radius * -1, TargetZone.radius)
				SpawnGroup.route.points[t].y = SpawnGroup.route.points[t].y + math.random(TargetZone.radius * -1, TargetZone.radius)
				SpawnGroup.route.points[t].alt = nil
				SpawnGroup.route.points[t].alt_type = nil
			end
		end
		
		SpawnGroup.route.points[RouteCount].x = TargetZonePos.x
		SpawnGroup.route.points[RouteCount].y = TargetZonePos.z
		--env.info(('SpawnInfantry: SpawnGroup.route.points['..RouteCount..'].x = ' .. SpawnGroup.route.points[RouteCount].x .. ', SpawnGroup.route.points['..RouteCount..'].y = ' .. SpawnGroup.route.points[RouteCount].y ))

		local SpawnUnits = table.getn(SpawnGroup.units)
		for v = 1, SpawnUnits do
			SpawnUnitName = SpawnGroupName .. '-' .. string.format("%03d", v )
			SpawnGroup.units[v].unitName = SpawnUnitName
			SpawnGroup.units[v].name = SpawnUnitName
			SpawnGroup.units[v].unitId = nil
			

			local SpawnPos = mist.getRandPointInCircle( UnitDeployPosition, 40, 10 )
			SpawnGroup.units[v].x = SpawnPos.x
			SpawnGroup.units[v].y = SpawnPos.y
			--env.info(('SpawnInfantry: SpawnGroup.units['..v..'].x = ' .. SpawnGroup.units[v].x .. ', SpawnGroup.units['..v..'].y = ' .. SpawnGroup.units[v].y ))
		end
		
		GroupSpawned = mist.dynAdd( SpawnGroup )
		--env.info(( 'SpawnInfantry: mist.dynAdd' ))
	end

	env.info(( 'SpawnInfantry: end' ))
end

function TeleportInfantry ( CarrierGroup, TeleportGroupName, TargetZonePrefix, TeleportMax )
	--env.info(( 'TeleportInfantry: ' ))
	--env.info(( 'TeleportInfantry: CarrierGroup = ' .. CarrierGroup:getName() .. ' TeleportGroupName = ' .. TeleportGroupName ))
	--env.info(( 'TeleportInfantry: TargetZonePrefix = ' .. TargetZonePrefix ))

	if TeleportGroupName ~= '' then
		local GroupUnits = CarrierGroup:getUnits()
		local GroupUnitCount = table.getn(GroupUnits)
		--env.info(( 'TeleportInfantry: GroupUnitCount = ' .. GroupUnitCount ))

		--env.info(('TeleportInfantry: Teleport'))
		if GroupUnitCount > 0 then
			UnitDeploy = GroupUnits[1]

			local UnitDeployPosition = UnitDeploy:getPoint()

			local vars = {}
			vars.gpName = TeleportGroupName
			--env.info(( 'TeleportInfantry: vars.gpName = ' .. vars.gpName ))
			
			vars.action = 'tele'
			vars.point = UnitDeployPosition
			vars.radius = 200
			vars.disperse = true
			vars.maxDisp = 100
			vars.innerRadius = 50
			mist.teleportToPoint(vars)

			-- Get the Group Route (getGroupData does not do that ...)
			local Points = {}
			Points = mist.getGroupRoute( TeleportGroupName, true )

			local TargetZone = trigger.misc.getZone( TargetZonePrefix )
			local TargetZonePos = {}
			TargetZonePos.x = TargetZone.point.x + math.random(TargetZone.radius * -1, TargetZone.radius)
			TargetZonePos.z = TargetZone.point.z + math.random(TargetZone.radius * -1, TargetZone.radius)

			local RouteCount = table.getn(Points)
			--env.info(( 'TeleportInfantry: RouteCount = ' .. RouteCount ))

			Points[1].x = UnitDeployPosition.x - 50
			Points[1].y = UnitDeployPosition.z
			--env.info(('TeleportInfantry: Points[1].x = ' .. Points[1].x .. ', Points[1].y = ' .. Points[1].y ))

			Points[RouteCount].x = TargetZonePos.x
			Points[RouteCount].y = TargetZonePos.z
			--env.info(('TeleportInfantry: Points['..RouteCount..'].x = ' .. Points[RouteCount].x .. ', Points['..RouteCount..'].y = ' .. Points[RouteCount].y ))
			
			GroupSpawned = mist.goRoute( TeleportGroupName, Points )
			--env.info(( 'TeleportInfantry: mist.roRoute' ))
		end
	end

	--env.info(( 'TeleportInfantry: end' ))
end

function LandCarrier ( CarrierGroup, LandingZonePrefix )
	--env.info(( 'LandCarrier: ' ))
	--env.info(( 'LandCarrier: CarrierGroup = ' .. CarrierGroup:getName() ))
	--env.info(( 'LandCarrier: LandingZone = ' .. LandingZonePrefix ))

	local controllerGroup = CarrierGroup:getController()

	local LandingZone = trigger.misc.getZone(LandingZonePrefix)
	local LandingZonePos = {}
	LandingZonePos.x = LandingZone.point.x + math.random(LandingZone.radius * -1, LandingZone.radius)
	LandingZonePos.y = LandingZone.point.z + math.random(LandingZone.radius * -1, LandingZone.radius)

	controllerGroup:pushTask( { id = 'Land', params = { point = LandingZonePos, durationFlag = true, duration = 30 } } )

	--env.info(( 'LandCarrier: end' ))
end

function RouteCarrier( CarrierGroup, LandingZonePrefix, RoutePoint )
	--env.info(( 'RouteCarrier: ' ))
	--env.info(( 'RouteCarrier: CarrierGroup = ' .. CarrierGroup:getName() ))
	--env.info(( 'RouteCarrier: LandingZonePrefix = ' .. LandingZonePrefix ))
	--env.info(( 'RouteCarrier: RoutePoint = ' .. RoutePoint ))

	local points = {}
	points = mist.getGroupRoute(CarrierGroup:getName(), false)

	local LandingZone = trigger.misc.getZone(LandingZonePrefix)
	local LandingZonePos = {}
	LandingZonePos.x = LandingZone.point.x + math.random(LandingZone.radius * -1, LandingZone.radius)
	LandingZonePos.z = LandingZone.point.z + math.random(LandingZone.radius * -1, LandingZone.radius)
	
	--points[#points+1] = mist.heli.buildWP ( { ['x'] = LandingZonePos.x, ['y'] = LandingZonePos.z } )
	--mist.goRoute( CarrierGroup, points )
	
	local routeMessage = mist.getBRStringZone( { zone = LandingZonePrefix, ref = CarrierGroup:getUnit(1):getPoint(), true, true } )
	--env.info(('RouteCarrier: routeMessage = ' .. routeMessage ))

	SendMessageToCarrier( CarrierGroup, 'Mission: Deploy troops at ' .. LandingZonePrefix .. ' at ' .. routeMessage .. '. Fly to the landing zone and deploy the troops using the F10 option.' )
	
	--env.info(( 'RouteCarrier: end' ))
	
end

function SendMessageToCarrier( CarrierGroup, CarrierMessage )

	if CarrierGroup ~= nil then
		local msg = {}
		msg.text = CarrierMessage
		msg.displayTime = 60
		msg.msgFor = { units = { CarrierGroup:getUnits()[1]:getName() } }
		mist.message.add( msg )
		--env.info(('SendMessageToCarrier: Message sent to Carrier ' .. CarrierGroup:getUnits()[1]:getName() .. ' -> ' .. CarrierMessage ))
	end

end

function MessageToGroup( MsgGroup, MsgText, MsgTime, MsgName )

	if MsgGroup ~= nil then
		local MsgTable = {}
		MsgTable.text = MsgText
		MsgTable.displayTime = MsgTime
		MsgTable.msgFor = { units = { MsgGroup:getUnits()[1]:getName() } }
		MsgTable.name = MsgName
		mist.message.add( MsgTable )
		--env.info(('MessageToGroup: Message sent to ' .. MsgGroup:getUnits()[1]:getName() .. ' -> ' .. MsgText ))
	end

end


function MessageToAll( MsgText, MsgTime, MsgName )

	local MsgTable = {}
	MsgTable.text = MsgText
	MsgTable.displayTime = MsgTime
	MsgTable.msgFor = { coa = { 'red', 'blue' } }
	MsgTable.name = MsgName
	mist.message.add( MsgTable )
	--env.info(('MessageToGroup: Message sent to All -> ' .. MsgText ))

end

function MessageToRed( MsgText, MsgTime, MsgName )

	local MsgTable = {}
	MsgTable.text = MsgText
	MsgTable.displayTime = MsgTime
	MsgTable.msgFor = { coa = { 'red' } }
	MsgTable.name = MsgName
	mist.message.add( MsgTable )
	--env.info(('MessageToGroup: Message sent to Red -> ' .. MsgText ))

end

function MessageToBlue( MsgText, MsgTime, MsgName )

	local MsgTable = {}
	MsgTable.text = MsgText
	MsgTable.displayTime = MsgTime
	MsgTable.msgFor = { coa = { 'blue' } }
	MsgTable.name = MsgName
	mist.message.add( MsgTable )
	--env.info(('MessageToGroup: Message sent to Blue -> ' .. MsgText ))

end

function getCarrierHeight( CarrierGroup )

	if CarrierGroup ~= nil then
		if table.getn(CarrierGroup:getUnits()) == 1 then
			local CarrierUnit = CarrierGroup:getUnits()[1]

			local CurrentPoint = CarrierUnit:getPoint()

			local CurrentPosition = { x = CurrentPoint.x, y = CurrentPoint.z }
			local CarrierHeight = CurrentPoint.y
			
			local LandHeight = land.getHeight( CurrentPosition )

			--env.info(( 'CarrierHeight: LandHeight = ' .. LandHeight .. ' CarrierHeight = ' .. CarrierHeight ))
			
			return CarrierHeight - LandHeight
		else
			return 999999
		end
	else
		return 999999
	end
		
end

function AlivePlayerUnits( )

	env.info(( 'AlivePlayerUnits:' ))

	local ClientUnit = 0
	local AlivePlayersRed = coalition.getPlayers(coalition.side.RED)
	local AlivePlayersBlue = coalition.getPlayers(coalition.side.BLUE)
	local unitId
	local unitData
	local AlivePlayerUnits = {}
	
	for unitId, unitData in pairs(AlivePlayersRed) do
		if unitData:isExist() then
			env.info(('AlivePlayerUnits: Alive RED Client = ' .. unitData:getName() ))
			ClientUnit = ClientUnit + 1
			AlivePlayerUnits[ClientUnit] = unitData
		end
	end

	for unitId, unitData in pairs(AlivePlayersBlue) do
		if unitData:isExist() then
			env.info(('AlivePlayerUnits: Alive BLUE Client = ' .. unitData:getName() ))
			ClientUnit = ClientUnit + 1
			AlivePlayerUnits[ClientUnit] = unitData
		end
	end
	
	env.info(( 'AlivePlayerUnits: ' .. ClientUnit ))
	
	return AlivePlayerUnits

end


function MusicRegister( SndRef, SndFile, SndTime )

	env.info(( 'MusicRegister: SndRef = ' .. SndRef ))
	env.info(( 'MusicRegister: SndFile = ' .. SndFile ))
	env.info(( 'MusicRegister: SndTime = ' .. SndTime ))
	

	_MusicTable.FileCnt = _MusicTable.FileCnt + 1

	_MusicTable.Files[_MusicTable.FileCnt] = {}
	_MusicTable.Files[_MusicTable.FileCnt].Ref = SndRef
	_MusicTable.Files[_MusicTable.FileCnt].File = SndFile
	_MusicTable.Files[_MusicTable.FileCnt].Time = SndTime
	
	if not _MusicTable.Function then
		_MusicTable.Function = mist.scheduleFunction( MusicScheduler, { }, timer.getTime() + 10, 10)
	end

end

function MusicToPlayer( SndRef, PlayerName, SndContinue )

	env.info(( 'MusicToPlayer: SndRef = ' .. SndRef  ))

	local PlayerUnits = AlivePlayerUnits()
	for PlayerUnitIdx, PlayerUnit in pairs(PlayerUnits) do
		local PlayerUnitName = PlayerUnit:getPlayerName()
		env.info(( 'MusicToPlayer: PlayerUnitName = ' .. PlayerUnitName  ))
		if PlayerName == PlayerUnitName then
			PlayerGroup = PlayerUnit:getGroup()
			if PlayerGroup then
				env.info(( 'MusicToPlayer: PlayerGroup = ' .. PlayerGroup:getName() ))
				MusicToGroup( SndRef, PlayerGroup, SndContinue )
			end
			break
		end
	end

	env.info(( 'MusicToPlayer: end'  ))

end

function MusicToGroup( SndRef, SndGroup, SndContinue )

	env.info(( 'MusicToGroup: SndRef = ' .. SndRef  ))

	if SndGroup ~= nil then
		if _MusicTable and _MusicTable.FileCnt > 0 then
			if SndGroup:isExist() then
				if MusicCanStart(SndGroup:getUnit(1):getPlayerName()) then
					env.info(( 'MusicToGroup: OK for Sound.'  ))
					local SndIdx = 0
					if SndRef == '' then
						env.info(( 'MusicToGroup: SndRef as empty. Queueing at random.'  ))
						SndIdx = math.random( 1, _MusicTable.FileCnt )
					else
						for SndIdx = 1, _MusicTable.FileCnt do
							if _MusicTable.Files[SndIdx].Ref == SndRef then
								break
							end
						end
					end
					env.info(( 'MusicToGroup: SndIdx =  ' .. SndIdx ))
					env.info(( 'MusicToGroup: Queueing Music ' .. _MusicTable.Files[SndIdx].File .. ' for Group ' ..  SndGroup:getID() ))
					trigger.action.outSoundForGroup( SndGroup:getID(), _MusicTable.Files[SndIdx].File )
					MessageToGroup( SndGroup, 'Playing ' .. _MusicTable.Files[SndIdx].File, 15, 'Music-' .. SndGroup:getUnit(1):getPlayerName() )
					
					local SndQueueRef = SndGroup:getUnit(1):getPlayerName()
					if _MusicTable.Queue[SndQueueRef] == nil then
						_MusicTable.Queue[SndQueueRef] = {}
					end
					_MusicTable.Queue[SndQueueRef].Start = timer.getTime()
					_MusicTable.Queue[SndQueueRef].PlayerName = SndGroup:getUnit(1):getPlayerName()
					_MusicTable.Queue[SndQueueRef].Group = SndGroup
					_MusicTable.Queue[SndQueueRef].ID = SndGroup:getID()
					_MusicTable.Queue[SndQueueRef].Ref = SndIdx
					_MusicTable.Queue[SndQueueRef].Continue = SndContinue
					_MusicTable.Queue[SndQueueRef].Type = Group
				end
			end
		end
	end
end

function MusicCanStart(PlayerName)

	env.info(( 'MusicCanStart:' ))

	local MusicOut = false
	
	if _MusicTable['Queue'] ~= nil and _MusicTable.FileCnt > 0  then
		env.info(( 'MusicCanStart: PlayerName = ' .. PlayerName ))
		local PlayerFound = false
		local MusicStart = 0
		local MusicTime = 0
		for SndQueueIdx, SndQueue in pairs( _MusicTable.Queue ) do
			if SndQueue.PlayerName == PlayerName then
				PlayerFound = true
				MusicStart = SndQueue.Start
				MusicTime = _MusicTable.Files[SndQueue.Ref].Time
				break
			end
		end
		if PlayerFound then
			env.info(( 'MusicCanStart: MusicStart = ' .. MusicStart ))
			env.info(( 'MusicCanStart: MusicTime = ' .. MusicTime ))
			env.info(( 'MusicCanStart: timer.getTime() = ' .. timer.getTime() ))
			
			if MusicStart + MusicTime <= timer.getTime() then
				MusicOut = true
			end
		else
			MusicOut = true
		end
	end
	
	if MusicOut then
		env.info(( 'MusicCanStart: true' ))
	else
		env.info(( 'MusicCanStart: false' ))
	end
	
	return MusicOut
end

function MusicScheduler()

	env.info(( 'MusicScheduler:' ))
	if _MusicTable['Queue'] ~= nil and _MusicTable.FileCnt > 0  then
		env.info(( 'MusicScheduler: Walking Sound Queue.'))
		for SndQueueIdx, SndQueue in pairs( _MusicTable.Queue ) do
			if SndQueue.Continue then
				if MusicCanStart(SndQueue.PlayerName) then
					env.info(('MusicScheduler: MusicToGroup'))
					MusicToPlayer( '', SndQueue.PlayerName, true )
				end
			end
		end
	end

end

env.info(( 'Init: Scripts Loaded' ))

