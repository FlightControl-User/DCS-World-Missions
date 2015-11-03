Include.File( "Mission" )
Include.File( "Client" )
Include.File( "DeployTask" )
Include.File( "PickupTask" )
Include.File( "SlingLoadHookTask" )
Include.File( "SlingLoadUnHookTask" )
Include.File( "DestroyGroupsTask" )
Include.File( "DestroyRadarsTask" )
Include.File( "DestroyUnitTypesTask" )
Include.File( "GoHomeTask" )
Include.File( "Spawn" )
Include.File( "Movement" )
Include.File( "Sead" )
Include.File( "CleanUp" )


-- Workaround due to CARGO bug introduced since DCS World 1.2.12...
-- Now we declare a structure gobally that is used in the state functions to check the cargo status...
GE_CARGO = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }

-- CCCP MISSIONS

do -- CCCP Transport Mission to activate the SA-6 radar installations.

	SA6Activation = { 
		{ "RU SA-6 Kub Moskva", false },
		{ "RU SA-6 Kub Niznij", false },
		{ "RU SA-6 Kub Yaroslavl", false }
	}

	function DeploySA6TroopsGoal( Mission, Client )
	trace.l( "", "DeploySA6TroopsGoal" )


		-- Check if the cargo is all deployed for mission success.
		for CargoID, CargoData in pairs( Mission._Cargos ) do
			trace.l( "", "DeploySA6TroopsGoal", CargoData.CargoGroupName )
			if Group.getByName( CargoData.CargoGroupName ) then
				CargoGroup = Group.getByName( CargoData.CargoGroupName )
				if CargoGroup then
					-- Check if the group is ready to activate an SA-6.
					local CurrentLandingZoneID = routines.IsPartOfGroupInZones( CargoGroup, Mission:GetTask( 2 ).LandingZones ) -- The second task is the Deploytask to measure mission success upon
					trace.l( "", "DeploySA6TroopsGoal", CurrentLandingZoneID )
					if CurrentLandingZoneID then
						if SA6Activation[CurrentLandingZoneID][2] == false then
							trigger.action.setGroupAIOn( Group.getByName( SA6Activation[CurrentLandingZoneID][1] ) )
							SA6Activation[CurrentLandingZoneID][2] = true
							MessageToRed( "Mission Command: Message to all airborne units: we have another of our SA-6 air defense systems armed.", 60, "RED/SA6Defense" )
							MessageToBlue( "Mission Command: Our satellite systems are detecting additional CCCP SA-6 air defense activities near Tskinvali. To all airborne units: Take care!!!", 60, "BLUE/SA6Defense" )
							Mission:GetTask( 2 ):AddGoalCompletion( "SA6 activated", SA6Activation[CurrentLandingZoneID][1], 1 ) -- Register SA6 activation as part of mission goal.
						end
					end
				end
			end
		end
	end

	local Mission = MISSION:New( 'Russia Transport Troops SA-6', 'Operational', 'Transport troops from the control center to one of the SA-6 SAM sites to activate their operation.', 'Russia' )
	Mission:AddGoalFunction( DeploySA6TroopsGoal )

	Mission:AddClient( CLIENT:New( 'RU MI-8MTV2*HOT-Deploy Troops 1' ):Transport() )
	Mission:AddClient( CLIENT:New( 'RU MI-8MTV2*RAMP-Deploy Troops 3' ):Transport() )
	Mission:AddClient( CLIENT:New( 'RU MI-8MTV2*HOT-Deploy Troops 2' ):Transport() )
	Mission:AddClient( CLIENT:New( 'RU MI-8MTV2*RAMP-Deploy Troops 4' ):Transport() )
	
	local EngineerNames = { "Абрам", "Адам", "Адриан", "Афанасий", "Афанасий", "Агафья", "Агата", "Аглая", "Агнесса", "Аграфена", "Акилина", "Аким", "Аксинья", "Акулина", "Альберт", "Альбина", "Александр", "Александра", "Александрина", "Алексей", "Александра", "Алексей", "Алиса", "Алла", "Аллочка", "Алёна", "Алёша", "Анастас", "Анастасия", "Анастасий", "Анастасия", "Анатолий", "Андрей", "Андрей", "Анфиса", "Ангела", "Ангелина", "Анисим", "Анна", "Аннушка", "Антон", "Антонина", "Анушка", "Аня", "Анжела", "Анжелина", "Аполлинария", "Арина", "Ариша", "Аристарх", "Аркадий", "Аркадий", "Аркадий", "Архип", "Арсений", "Арсений", "Артём", "Артемий", "Артур", "Артём", "Ася", "Авдотья", "Август", "Авксентий", "Бенедикт", "Богдан", "Богдана", "Болеслав", "Болеслава", "Борислав", "Борислава", "Бронислав", "Бронислава", "Давид", "Демьян", "Денис", "Диана", "Димитрий", "Дмитрий", "Дмитрий", "Дмитрий", "Дмитрий", "Доминика", "Дорофей", "Дорофей", "Дуня", "Дуняша", "Эдуард", "Екатерина", "Елизавета", "Ермолай", "Есфирь", "Ева", "Евдокия", "Евгений", "Евгений", "Евгения", "Евгений", "Евпраксия", "Фаддей", "Фаддей", "Фаина", "Федор", "Федора", "Федот", "Федя", "Феликс", "Феодор", "Феодора", "Феодосий", "Феофан", "Феофил", "Феофилакт", "Ферапонт", "Филат", "Филипп", "Филиппа", "Фима", "Фока", "Фома", "Фёдор", "Гала", "Галина", "Галя", "Гавриил", "Гавриила", "Геннадий", "Геннадий", "Геннадия", "Геннадий", "Геня", "Георгий", "Георгий", "Герасим", "Гермоген", "Григорий", "Григорий", "Григорий", "Гриша", "Груша", "Игнатий", "Игорь", "Иларий", "Илья", "Илларион", "Инга", "Инна", "Иннокентий", "Иннокентий", "Иосиф", "Ипатий", "Ипатий", "Ипполит", "Ираклий", "Ирина", "Ириней", "Ириней", "Иринушка", "Исаак", "Исай", "Исидор", "Исидора", "Иван", "Иванна", "Екатерина", "Карина", "Карп", "Катенька", "Катерина", "Катя", "Катя", "Казимир", "Харитон", "Кирилл", "Клара", "Клава", "Клавдия", "Клим", "Климент", "Коля", "Константин", "Кристина", "Ксения", "Кузьма", "Лана", "Лариса", "Лаврентий", "Лаврентий", "Лаврентий", "Лена", "Леонид", "Леонтий", "Леонтий", "Леонтий", "Лидия", "Лидочка", "Лилия", "Лилия", "Лилия", "Люба", "Лиза", "Лизавета", "Людмила", "Людмила", "Лука", "Лёша", "Лёв", "Люба", "Любочка", "Любовь", "Людмила", "Макар", "Макарий", "Макарий", "Макс", "Максим", "Максимильян", "Марфа", "Маргарита", "Марина", "Мария", "Марк", "Мартин", "Марья", "Марьяна", "Маша", "Матвей", "Матрона", "Матрёна", "Матвей", "Матвей", "Максим", "Мечислав", "Мефодий", "Мэлор", "Михаил", "Михаил", "Милан", "Милена", "Мирослав", "Мирослава", "Митрофан", "Митя", "Модест", "Моисей", "Мотя", "Мстислав", "Надежда", "Надежда", "Настасья", "Настасья", "Настя", "Ната", "Натали", "Наталия", "Наталья", "Наташа", "Наум", "Назар", "Назарий", "Нестор", "Никифор", "Никодим", "Николай", "Николай", "Никон", "Нинель", "Нонна", "Оксана", "Олег", "Ольга", "Оля", "Онисим", "Осип", "Оксана", "Панкратий", "Панкратий", "Патя", "Павел", "Пелагея", "Пелагия", "Петя", "Петя", "Платон", "Полина", "Прасковья", "Прасковья", "Прохор", "Прокопий", "Прокопий", "Пётр", "Рада", "Радимир", "Радомир", "Радослав", "Радослава", "Ренат", "Роберт", "Родион", "Родя", "Роксана", "Ролан", "Роман", "Ростислав", "Роза", "Розалия", "Рудольф", "Руфина", "Рюрик", "Руслан", "Сабина", "Самуил", "Саша", "Савелий", "Савелий", "Савелий", "Савва", "Селена", "Семён", "Семён", "Серафим", "Серафима", "Сергей", "Сергей", "Сергей", "Севастьян", "Севастьян", "Слава", "Снежана", "София", "Софья", "Соня", "Спартак", "Станимир", "Станислав", "Станислава", "Стася", "Степан", "Сусанна", "Света", "Светлана", "Святополк", "Святослав", "Сюзанна", "Таисия", "Тамара", "Таня", "Тарас", "Таша", "Татьяна", "Татьяна", "Терентий", "Терентий", "Тихон", "Тимофей", "Тимофей", "Тимур", "Тит", "Цецилия", "Ульяна", "Устинья", "Вадик", "Вадим", "Вадимир", "Валентин", "Валентина", "Валерий", "Валериан", "Валерий", "Валерия", "Валерий", "Ваня", "Варфоломей", "Варфоломей", "Варлаам", "Варлам", "Варнава", "Варвара", "Варя", "Василий", "Василиса", "Василий", "Василий", "Васька", "Василий", "Вася", "Венера", "Вениамин", "Вениамин", "Верочка", "Вероника", "Веруша", "Викентий", "Викентий", "Виктор", "Виктория", "Вилен", "Виолетта", "Виссарион", "Виталий", "Виталий", "Виталия", "Виталий", "Витя", "Влад", "Владилен", "Владимир", "Владислав", "Владислава", "Владлен", "Власий", "Власий", "Володя", "Воля", "Вова", "Всеволод", "Вячеслав", "Яким", "Яков", "Яна", "Ярослав", "Ярослава", "Яша", "Ефим", "Ефрем", "Егор", "Екатерина", "Елена", "Елизавета", "Емельян", "Ермолай", "Есфирь", "Ева", "Евдокия", "Евгений", "Евгений", "Евгения", "Евгений", "Евпраксия", "Юлия", "Юлиан", "Юлиана", "Юлианна", "Юлий", "Юлия", "Юра", "Юрий", "Юстина", "Захар", "Жанна", "Жанночка", "Женя", "Зина", "Зинаида", "Зиновий", "Зиновия", "Зоя" }

	local CargoTable = {}
	for CargoItem = 1, 5 do
		Mission:AddCargo( "Team " .. CargoItem .. ": " .. EngineerNames[math.random(1, #EngineerNames)] .. ' and ' .. EngineerNames[math.random(1, #EngineerNames)], CARGO_TYPE.ENGINEERS, math.random( 70, 120 ) * 6, 'Russia Alpha Control Center', 'RU Infantry Alpha', 'Russia Alpha Pickup Zone' )
	end

	for CargoItem = 1, 5 do
		Mission:AddCargo( "Team " .. CargoItem .. ": " .. EngineerNames[math.random(1, #EngineerNames)] .. ' and ' .. EngineerNames[math.random(1, #EngineerNames)], CARGO_TYPE.ENGINEERS, math.random( 70, 120 ) * 6, 'Russia Beta Control Center', 'RU Infantry Beta', 'Russia Beta Pickup Zone' )
	end

	-- Assign the Pickup Task
	PickupZones = { "Russia Alpha Pickup Zone", "Russia Beta Pickup Zone" }
	PickupSignalUnits = { "Russia Alpha Control Center", "Russia Beta Control Center" }
	
	local PickupTask = PICKUPTASK:New( PickupZones, CARGO_TYPE.ENGINEERS, CLIENT.ONBOARDSIDE.LEFT )
	PickupTask:AddSmokeRed( PickupSignalUnits  )
	Mission:AddTask( PickupTask, 1 )

	-- Assign the Deploy Task
	local SA6ActivationZones = { "RU Activation SA-6 Moskva", "RU Activation SA-6 Niznij", "RU Activation SA-6 Yaroslavl" }
	local SA6ActivationZonesSmokeUnits = { "RU SA-6 Transport Moskva", "RU SA-6 Transport Niznij", "RU SA-6 Transport Yaroslavl" }
	
	local DeployTask = DEPLOYTASK:New( SA6ActivationZones, CARGO_TYPE.ENGINEERS )
	DeployTask:AddSmokeRed( SA6ActivationZonesSmokeUnits )
	DeployTask:SetGoalTotal( 3 )
	DeployTask:SetGoalTotal( 3, "SA6 activated" )
	Mission:AddTask( DeployTask, 2 )
	
	MISSIONSCHEDULER.AddMission( Mission )
	
end

do -- CCCP - Destroy Patriots
	local Mission = MISSION:New( 'Patriots', 'Primary', 'Our intelligence reports that 3 Patriot SAM defense batteries are located near Ruisi, Kvarhiti and Gori.', 'Russia'  )

	Mission:AddClient( CLIENT:New( 'RU KA-50*HOT-Patriot Attack 1', "Execute a CAS in Gori Valley, eliminating the Patriot launchers and other ground vehicles. Patriot batteries are at waypoint 2 to 4. Beware approaching NATO air support from the east and the west. Fly low and slow, and scan the area before engaging." ) )
	Mission:AddClient( CLIENT:New( 'RU KA-50*HOT-Patriot Attack 2', "Execute a CAS in Gori Valley, eliminating the Patriot launchers and other ground vehicles. Patriot batteries are at waypoint 2 to 4. Beware approaching NATO air support from the east and the west. Fly low and slow, and scan the area before engaging.") )
	Mission:AddClient( CLIENT:New( 'RU KA-50*RAMP-Patriot Attack 3', "Execute a CAS in Gori Valley, eliminating the Patriot launchers and other ground vehicles. Patriot batteries are at waypoint 2 to 4. Beware approaching NATO air support from the east and the west. Fly low and slow, and scan the area before engaging." ) )
	Mission:AddClient( CLIENT:New( 'RU KA-50*RAMP-Patriot Attack 4', "Execute a CAS in Gori Valley, eliminating the Patriot launchers and other ground vehicles. Patriot batteries are at waypoint 2 to 4. Beware approaching NATO air support from the east and the west. Fly low and slow, and scan the area before engaging.") )

	Mission:AddClient( CLIENT:New( 'RU SU-25T*HOT-Patriot Attack 1', "Fly to the south and execute a CAS in Gori Valley, eliminating the Patriot launchers and other ground vehicles. Patriot batteries are at waypoint 2 to 4. Beware approaching NATO air support from the east and the west. Expect heavy AAA and air defense ground units within Gori Valley." ) )
	Mission:AddClient( CLIENT:New( 'RU SU-25T*HOT-Patriot Attack 2', "Fly to the south and execute a SEAD attack in Gori Valley, eliminating the Patriot radars and other ground air defenses. Patriot batteries are at waypoint 2 to 4. Beware approaching NATO air support from the east and the west. Expect heavy AAA and air defense ground units within Gori Valley." ) )
	Mission:AddClient( CLIENT:New( 'RU SU-25T*RAMP-Patriot Attack 3', "Fly to the south and execute a CAS in Gori Valley, eliminating the Patriot launchers and other ground vehicles. Patriot batteries are at waypoint 2 to 4. Beware approaching NATO air support from the east and the west. Expect heavy AAA and air defense ground units within Gori Valley." ) )
	Mission:AddClient( CLIENT:New( 'RU SU-25T*RAMP-Patriot Attack 4', "Fly to the south and execute a SEAD attack in Gori Valley, eliminating the Patriot radars and other ground air defenses. Patriot batteries are at waypoint 2 to 4. Beware approaching NATO air support from the east and the west. Expect heavy AAA and air defense ground units within Gori Valley." ) )

	Mission:AddClient( CLIENT:New( 'RU MIG-29S*HOT-Air Defense West 1', "Provide CAP support by flying to the south over the mountains and engage with any unidentified aircraft. Protect our Su-25T planes from any unexpected air threats." ..
							  "NATO airbases are in red alert. NATO air defenses are on their way to Gori Valley." ) )
	Mission:AddClient( CLIENT:New( 'RU MIG-29S*HOT-Air Defense West 2', "Provide CAP support by flying to the south over the mountains and engage with any unidentified aircraft. Protect our Su-25T planes from any unexpected air threats." ..
							  "NATO airbases are in red alert. NATO air defenses are on their way to Gori Valley." ) )
	Mission:AddClient( CLIENT:New( 'RU MIG-29S*RAMP-Air Defense West 3', "Provide CAP support by flying to the south over the mountains and engage with any unidentified aircraft. Protect our Su-25T planes from any unexpected air threats." ..
							  "NATO airbases are in red alert. NATO air defenses are on their way to Gori Valley." ) )
	Mission:AddClient( CLIENT:New( 'RU MIG-29S*RAMP-Air Defense West 4', "Provide CAP support by flying to the south over the mountains and engage with any unidentified aircraft. Protect our Su-25T planes from any unexpected air threats." ..
							  "NATO airbases are in red alert. NATO air defenses are on their way to Gori Valley." ) )

	Mission:AddClient( CLIENT:New( 'RU Su-27*HOT-Air Support East 1', "Provide CAP support by flying to the south over the mountains and engage with any unidentified aircraft. Protect our Su-25T planes from any unexpected air threats." ..
							  "NATO airbases are in red alert. NATO air defenses are on their way to Gori Valley." ) )
	Mission:AddClient( CLIENT:New( 'RU Su-27*HOT-Air Support East 2', "Provide CAP support by flying to the south over the mountains and engage with any unidentified aircraft. Protect our Su-25T planes from any unexpected air threats." ..
							  "NATO airbases are in red alert. NATO air defenses are on their way to Gori Valley." ) )
	Mission:AddClient( CLIENT:New( 'RU Su-27*RAMP-Air Support East 3', "Provide CAP support by flying to the south over the mountains and engage with any unidentified aircraft. Protect our Su-25T planes from any unexpected air threats." ..
							  "NATO airbases are in red alert. NATO air defenses are on their way to Gori Valley." ) )
	Mission:AddClient( CLIENT:New( 'RU Su-27*RAMP-Air Support East 4', "Provide CAP support by flying to the south over the mountains and engage with any unidentified aircraft. Protect our Su-25T planes from any unexpected air threats." ..
							  "NATO airbases are in red alert. NATO air defenses are on their way to Gori Valley." ) )

	local DESTROYGROUPSTASK = DESTROYGROUPSTASK:New( 'Patriots', 'Patriot Batteries', { 'US SAM Patriot' }, 75  ) -- 75% of a patriot battery needs to be destroyed to achieve mission success...
	DESTROYGROUPSTASK:SetGoalTotal( 3 )
	Mission:AddTask( DESTROYGROUPSTASK, 1 )
	
	MISSIONSCHEDULER.AddMission( Mission )
end

do -- CCCP - The Rescue of the Russian General
	local Mission = MISSION:New( 'Rescue General', 'Tactical', 'Our intelligence has received a remote signal behind Gori. We believe it is a very important Russian General that was captured by Georgia. Go out there and rescue him! Ensure you stay out of the battle zone, keep south. Waypoint 4 is the location of our Russian General.', 'Russia'  )

	Mission:AddClient( CLIENT:New( 'RU MI-8MTV2*HOT-Rescue General 1' ) )
	Mission:AddClient( CLIENT:New( 'RU MI-8MTV2*HOT-Rescue General 2' ) )
	Mission:AddClient( CLIENT:New( 'RU MI-8MTV2*RAMP-Rescue General 3' ) )
	Mission:AddClient( CLIENT:New( 'RU MI-8MTV2*RAMP-Rescue General 4' ) )

	Mission:AddCargo( 'Russian General', CARGO_TYPE.INFANTRY, math.random( 70, 120 ), nil, 'Russian General', 'General Hiding Zone' )

	-- Assign the Pickup Task
	local PickupTask = PICKUPTASK:New( 'General Hiding Zone', CARGO_TYPE.INFANTRY, CLIENT.ONBOARDSIDE.RIGHT )
	PickupTask:AddFlareWhite( 'Russian General' )
	Mission:AddTask( PickupTask, 1 ) 

		-- Assign the Deploy Tasks
	local DeployTask = DEPLOYTASK:New( 'Tskinvali Headquarters', CARGO_TYPE.INFANTRY )
	DeployTask:AddSmokeWhite( 'Russia Command Center' )
	DeployTask:SetGoalTotal( 1 )
	Mission:AddTask( DeployTask, 2 )

	-- Assign the GoHome Task
	local GoHomeTask = GOHOMETASK:New( 'Russia MI-8MTV2 Troops Transport Home Base' )
	Mission:AddTask( GoHomeTask, 3 )
	
	MISSIONSCHEDULER.AddMission( Mission )

end

do -- CCCP - Deliver packages to secret agent
	local Mission = MISSION:New( 'Package Delivery', 'Operational', 'In order to be in full control of the situation, we need you to deliver a very important package at a secret location. Fly undetected through the NATO defenses and deliver the secret package. The secret agent is located at waypoint 4.', 'Russia'  )

	Mission:AddClient( CLIENT:New( 'RU KA-50*HOT-Package Delivery 1' ):AddCargo( 'Secret Package 1', '', CARGO_TYPE.PACKAGE, math.random( 30, 50 ) ) )
	Mission:AddClient( CLIENT:New( 'RU KA-50*HOT-Package Delivery 2' ):AddCargo( 'Secret Package 2', '', CARGO_TYPE.PACKAGE, math.random( 30, 50 ) ) )
	Mission:AddClient( CLIENT:New( 'RU KA-50*RAMP-Package Delivery 3' ):AddCargo( 'Secret Package 3', '', CARGO_TYPE.PACKAGE, math.random( 30, 50 ) ) )
	Mission:AddClient( CLIENT:New( 'RU KA-50*RAMP-Package Delivery 4' ):AddCargo( 'Secret Package 4', '', CARGO_TYPE.PACKAGE, math.random( 30, 50 ) ) )

	Mission:AddCargo( 'Secret Package 1', CARGO_TYPE.PACKAGE, math.random( 560, 800 ), 'Russia Secret Agent', '', '' )
	Mission:AddCargo( 'Secret Package 2', CARGO_TYPE.PACKAGE, math.random( 100, 300 ), 'Russia Secret Agent', '', '' )
	Mission:AddCargo( 'Secret Package 3', CARGO_TYPE.PACKAGE, math.random( 560, 800 ), 'Russia Secret Agent', '', '' )
	Mission:AddCargo( 'Secret Package 4', CARGO_TYPE.PACKAGE, math.random( 100, 300 ), 'Russia Secret Agent', '', '' )
	
	-- Assign the Deploy Tasks
	local DeployTask = DEPLOYTASK:New( 'Russia Secret Drop Zone', CARGO_TYPE.PACKAGE )
	DeployTask:AddSmokeWhite( 'Russia Secret Agent' )
	DeployTask:SetGoalTotal( 1 )
	Mission:AddTask( DeployTask, 1 )

	-- Assign the GoHome Task
	local GoHomeTask = GOHOMETASK:New( 'Russia Alpha' )
	Mission:AddTask( GoHomeTask, 2 )

	MISSIONSCHEDULER.AddMission( Mission )
end

-- NATO MISSIONS

do -- NATO - Transport Mission to activate the NATO Patriot Defenses

	PatriotActivation = { 
		{ "US SAM Patriot Zerti", false },
		{ "US SAM Patriot Zegduleti", false },
		{ "US SAM Patriot Gvleti", false }
	}

	function DeployPatriotTroopsGoal( Mission, Client )


		-- Check if the cargo is all deployed for mission success.
		for CargoID, CargoData in pairs( Mission._Cargos ) do
			if Group.getByName( CargoData.CargoGroupName ) then
				CargoGroup = Group.getByName( CargoData.CargoGroupName )
				if CargoGroup then
					-- Check if the cargo is ready to activate
					CurrentLandingZoneID = routines.IsPartOfGroupInZones( CargoGroup, Mission:GetTask( 2 ).LandingZones ) -- The second task is the Deploytask to measure mission success upon
					if CurrentLandingZoneID then
						if PatriotActivation[CurrentLandingZoneID][2] == false then
							-- Now check if this is a new Mission Task to be completed...
							trigger.action.setGroupAIOn( Group.getByName( PatriotActivation[CurrentLandingZoneID][1] ) )
							PatriotActivation[CurrentLandingZoneID][2] = true
							MessageToBlue( "Mission Command: Message to all airborne units! The " .. PatriotActivation[CurrentLandingZoneID][1] .. " is armed. Our air defenses are now stronger.", 60, "BLUE/PatriotDefense" )
							MessageToRed( "Mission Command: Our satellite systems are detecting additional NATO air defenses. To all airborne units: Take care!!!", 60, "RED/PatriotDefense" )
							Mission:GetTask( 2 ):AddGoalCompletion( "Patriots activated", PatriotActivation[CurrentLandingZoneID][1], 1 ) -- Register Patriot activation as part of mission goal.
						end
					end
				end
			end
		end
	end

	local Mission = MISSION:New( 'NATO Transport Troops', 'Operational', 'Transport 3 groups of air defense engineers from our barracks "Gold" and "Titan" to each patriot battery control center to activate our air defenses.', 'NATO' )
	Mission:AddGoalFunction( DeployPatriotTroopsGoal )
	
	Mission:AddClient( CLIENT:New( 'US UH-1H*HOT-Deploy Troops 1', 'Transport 3 groups of air defense engineers from our barracks "Gold" and "Titan" to each patriot battery control center to activate our air defenses.' ):Transport() )
	Mission:AddClient( CLIENT:New( 'US UH-1H*RAMP-Deploy Troops 3', 'Transport 3 groups of air defense engineers from our barracks "Gold" and "Titan" to each patriot battery control center to activate our air defenses.' ):Transport() )
	Mission:AddClient( CLIENT:New( 'US UH-1H*HOT-Deploy Troops 2', 'Transport 3 groups of air defense engineers from our barracks "Gold" and "Titan" to each patriot battery control center to activate our air defenses.' ):Transport() )
	Mission:AddClient( CLIENT:New( 'US UH-1H*RAMP-Deploy Troops 4', 'Transport 3 groups of air defense engineers from our barracks "Gold" and "Titan" to each patriot battery control center to activate our air defenses.' ):Transport() )

	local CargoTable = {}

	local EngineerNames = { "Charlie", "Fred", "Sven", "Prosper", "Godfried", "Adam", "Freddy", "Saskia", "Karolina", "Levente", "Urbanus", "Helena", "Teodora", "Timea", "John", "Ibrahim", "Christine", "Carl", "Monika" }
	
	for CargoItem = 1, 5 do
		Mission:AddCargo( "Team " .. CargoItem .. ": " .. EngineerNames[math.random(1, #EngineerNames)] .. ' and ' .. EngineerNames[math.random(1, #EngineerNames)], CARGO_TYPE.ENGINEERS, math.random( 70, 120 ) * 6, 'NATO Gold Coordination Center', 'US Infantry Gold', 'NATO Gold Pickup Zone' )
	end

	for CargoItem = 1, 5 do
		Mission:AddCargo( "Team " .. CargoItem .. ": " .. EngineerNames[math.random(1, #EngineerNames)] .. ' and ' .. EngineerNames[math.random(1, #EngineerNames)], CARGO_TYPE.ENGINEERS, math.random( 70, 120 ) * 6, 'NATO Titan Coordination Center', 'US Infantry Titan', 'NATO Titan Pickup Zone' )
	end

	PickupZones = { "NATO Gold Pickup Zone", "NATO Titan Pickup Zone" }
	PickupSignalUnits = { "NATO Gold Coordination Center", "NATO Titan Coordination Center" }

	-- Assign the Pickup Task
	local PickupTask = PICKUPTASK:New( PickupZones, CARGO_TYPE.ENGINEERS, CLIENT.ONBOARDSIDE.LEFT )
	PickupTask:AddSmokeBlue( PickupSignalUnits  )
	PickupTask:SetGoalTotal( 3 )
	Mission:AddTask( PickupTask, 1 )

	-- Assign the Deploy Task
	-- Assign the Deploy Task
	local PatriotActivationZones = { "US Patriot Battery 1 Activation", "US Patriot Battery 2 Activation", "US Patriot Battery 3 Activation" }
	local PatriotActivationZonesSmokeUnits = { "US SAM Patriot - Battery 1 Control", "US SAM Patriot - Battery 2 Control", "US SAM Patriot - Battery 3 Control" }

	local DeployTask = DEPLOYTASK:New( PatriotActivationZones, CARGO_TYPE.ENGINEERS )
	--DeployTask:SetCargoTargetZoneName( 'US Troops Attack ' .. math.random(2) )
	DeployTask:AddSmokeBlue( PatriotActivationZonesSmokeUnits )
	DeployTask:SetGoalTotal( 3 )
	DeployTask:SetGoalTotal( 3, "Patriots activated" )
	Mission:AddTask( DeployTask, 2 )
	
	MISSIONSCHEDULER.AddMission( Mission )
end

do -- NATO Destroy Mission SA-6 Batteries
	local Mission = MISSION:New( 'SA-6 SAMs', 'Primary', 'Our intelligence reports that 3 SA-6 SAM defense batteries are located near Didmukha, Khetagurov and Berula. Eliminate the Russian SAMs.', 'NATO'  )

	Mission:AddClient( CLIENT:New( 'BE KA-50*HOT-Ground Defense 1', "Execute a CAS in Gori Valley, eliminating the SA-6 launchers and other ground vehicles. Waypoint 2 to 4 are your primary targets. Beware approaching CCCP air support from the north and the west. Fly low and slow, and scan the area before engaging. Good luck!" ) )
	Mission:AddClient( CLIENT:New( 'BE KA-50*HOT-Ground Defense 2', "Execute a CAS in Gori Valley, eliminating the SA-6 launchers and other ground vehicles. Waypoint 2 to 4 are your primary targets. Beware approaching CCCP air support from the north and the west. Fly low and slow, and scan the area before engaging. Good luck!" ) )
	Mission:AddClient( CLIENT:New( 'BE KA-50*RAMP-Ground Defense 3', "Execute a CAS in Gori Valley, eliminating the SA-6 launchers and other ground vehicles. Waypoint 2 to 4 are your primary targets. Beware approaching CCCP air support from the north and the west. Fly low and slow, and scan the area before engaging. Good luck!" ) )
	Mission:AddClient( CLIENT:New( 'BE KA-50*RAMP-Ground Defense 4', "Execute a CAS in Gori Valley, eliminating the SA-6 launchers and other ground vehicles. Waypoint 2 to 4 are your primary targets. Beware approaching CCCP air support from the north and the west. Fly low and slow, and scan the area before engaging. Good luck!" ) )

	Mission:AddClient( CLIENT:New( 'US A-10A*HOT-Ground Defense 1', "Fly to the west and execute a CAS in Gori Valley, eliminating the SA-6 launchers and other ground vehicles. Waypoint 2 to 4 are your primary targets. Beware approaching CCCP air support from the north and the west. Expect heavy AAA and air defense ground units within Gori Valley." ) )
	Mission:AddClient( CLIENT:New( 'US A-10A*HOT-Ground Defense 2', "Fly to the west and execute a CAS in Gori Valley, eliminating the SA-6 launchers and other ground vehicles. Waypoint 2 to 4 are your primary targets. Beware approaching CCCP air support from the north and the west. Expect heavy AAA and air defense ground units within Gori Valley." ) )
	Mission:AddClient( CLIENT:New( 'US A-10A*RAMP-Ground Defense 3', "Fly to the west and execute a CAS in Gori Valley, eliminating the SA-6 launchers and other ground vehicles. Waypoint 2 to 4 are your primary targets. Beware approaching CCCP air support from the north and the west. Expect heavy AAA and air defense ground units within Gori Valley." ) )
	Mission:AddClient( CLIENT:New( 'US A-10A*RAMP-Ground Defense 4', "Fly to the west and execute a CAS in Gori Valley, eliminating the SA-6 launchers and other ground vehicles. Waypoint 2 to 4 are your primary targets. Beware approaching CCCP air support from the north and the west. Expect heavy AAA and air defense ground units within Gori Valley." ) )

	Mission:AddClient( CLIENT:New( 'GE SU-25T*HOT-SA-6 Attack 1', "Fly to the west and execute a SEAD attack in Gori Valley, eliminating the SA-6 radars. Waypoint 2 to 4 are your primary targets. Beware approaching CCCP air support from the north and the west. Expect heavy AAA and air defense ground units within Gori Valley." ) )
	Mission:AddClient( CLIENT:New( 'GE SU-25T*HOT-SA-6 Attack 2', "Fly to the west and execute a SEAD attack in Gori Valley, eliminating the SA-6 radars. Waypoint 2 to 4 are your primary targets. Beware approaching CCCP air support from the north and the west. Expect heavy AAA and air defense ground units within Gori Valley." ) )
	Mission:AddClient( CLIENT:New( 'GE SU-25T*RAMP-SA-6 Attack 3', "Fly to the west and execute a SEAD attack in Gori Valley, eliminating the SA-6 radars. Waypoint 2 to 4 are your primary targets. Beware approaching CCCP air support from the north and the west. Expect heavy AAA and air defense ground units within Gori Valley." ) )
	Mission:AddClient( CLIENT:New( 'GE SU-25T*RAMP-SA-6 Attack 4', "Fly to the west and execute a SEAD attack in Gori Valley, eliminating the SA-6 radars. Waypoint 2 to 4 are your primary targets. Beware approaching CCCP air support from the north and the west. Expect heavy AAA and air defense ground units within Gori Valley." ) )

	Mission:AddClient( CLIENT:New( 'US A-10C*HOT-Ground Defense 1', "Fly to the east and execute a CAS in Gori Valley, eliminating the SA-6 launchers and other ground vehicles. Waypoint 2 to 4 are your primary targets. Beware approaching CCCP air support from the north and the west. Expect heavy AAA and air defense ground units within Gori Valley." ) )
	Mission:AddClient( CLIENT:New( 'US A-10C*HOT-Ground Defense 2', "Fly to the east and execute a CAS in Gori Valley, eliminating the SA-6 launchers and other ground vehicles. Waypoint 2 to 4 are your primary targets. Beware approaching CCCP air support from the north and the west. Expect heavy AAA and air defense ground units within Gori Valley." ) )
	Mission:AddClient( CLIENT:New( 'US A-10C*RAMP-Ground Defense 3', "Fly to the east and execute a CAS in Gori Valley, eliminating the SA-6 launchers and other ground vehicles. Waypoint 2 to 4 are your primary targets. Beware approaching CCCP air support from the north and the west. Expect heavy AAA and air defense ground units within Gori Valley." ) )
	Mission:AddClient( CLIENT:New( 'US A-10C*RAMP*Ground Defense 4', "Fly to the east and execute a CAS in Gori Valley, eliminating the SA-6 launchers and other ground vehicles. Waypoint 2 to 4 are your primary targets. Beware approaching CCCP air support from the north and the west. Expect heavy AAA and air defense ground units within Gori Valley." ) )

	Mission:AddClient( CLIENT:New( 'US F-15C*HOT-Air Defense 1', "Fly to the east and provide CAP of supporting A-10A and A-10C planes. Waypoint 1 follows direction Gori Valley. Waypoint 2 to 4 is your CAP area in the mountains in the North. Beware of approaching CCCP air support from the north and the west. Expect heavy AAA and air defenses within Gori Valley. Land at Kutaisi." ) )
	Mission:AddClient( CLIENT:New( 'US F-15C*HOT-Air Defense 2', "Fly to the east and provide CAP of supporting A-10A and A-10C planes. Waypoint 1 follows direction Gori Valley. Waypoint 2 to 4 is your CAP area in the mountains in the North. Beware of approaching CCCP air support from the north and the west. Expect heavy AAA and air defenses within Gori Valley. Land at Kutaisi." ) )
	Mission:AddClient( CLIENT:New( 'US F-15C*RAMP-Air Defense 3', "Fly to the east and provide CAP of supporting A-10A and A-10C planes. Waypoint 1 follows direction Gori Valley. Waypoint 2 to 4 is your CAP area in the mountains in the North. Beware of approaching CCCP air support from the north and the west. Expect heavy AAA and air defenses within Gori Valley. Land at Kutaisi." ) )
	Mission:AddClient( CLIENT:New( 'US F-15C*RAMP-Air Defense 4', "Fly to the east and provide CAP of supporting A-10A and A-10C planes. Waypoint 1 follows direction Gori Valley. Waypoint 2 to 4 is your CAP area in the mountains in the North. Beware of approaching CCCP air support from the north and the west. Expect heavy AAA and air defenses within Gori Valley. Land at Kutaisi." ) )

	local DESTROYGROUPSTASK = DESTROYGROUPSTASK:New( 'SA-6 SAMs', 'SA-6 SAM Batteries', { 'RU SA-6 Kub' } )
	DESTROYGROUPSTASK:SetGoalTotal( 3 )
	Mission:AddTask( DESTROYGROUPSTASK, 1 )
	
	MISSIONSCHEDULER.AddMission( Mission )
end

do -- NATO "Fury" Sling Load Mission

	function DeployCargoGoal( Mission, Client )
		if routines.IsUnitInZones( Client:ClientGroup():getUnit(1), 'Cargo 1 - Arrival' ) ~= nil then
			Mission:GetTask( 2 ):AddGoalCompletion( "Cargo sling load", "Cargo", 1 ) 
		end
	end

	local Mission = MISSION:New( 'NATO Sling Load', 'Operational', 'Fly to the cargo pickup zone at Dzegvi or Kaspi, and sling the cargo to Soganlug airbase.', 'NATO' )
	Mission:AddGoalFunction( DeployCargoGoal )
	
	Mission:AddClient( CLIENT:New( 'BE UH-1H*HOT-Sling Load 1', 'Fly to Dzegvi or Kaspi and hook-up cargo, sling the cargo to Soganlug airbase. Smoke signals will be given upon arrival. Important note: Due to a bug in DCS World since version 1.2.12, this sling load mission cannot be correctly governed. The Cargo arrival and position cannot be measured anymore, thus, only your helicopter will be measured for the moment. Mission success will only be dependent on the position of your helicopter until this bug is fixed by Eagle Dynamics.' ) )
	Mission:AddClient( CLIENT:New( 'BE UH-1H*RAMP-Sling Load 3', 'Fly to Dzegvi or Kaspi and hook-up cargo, sling the cargo to Soganlug airbase. Smoke signals will be given upon arrival. Important note: Due to a bug in DCS World since version 1.2.12, this sling load mission cannot be correctly governed. The Cargo arrival and position cannot be measured anymore, thus, only your helicopter will be measured for the moment. Mission success will only be dependent on the position of your helicopter until this bug is fixed by Eagle Dynamics.' ) )
	Mission:AddClient( CLIENT:New( 'DE KA-50*HOT-Air Support 1', 'Provide air support.' ) )
	Mission:AddClient( CLIENT:New( 'DE KA-50*RAMP-Air Support 3', 'Provide air support.' ) )
	
	
	
	-- Route to the pickup zones and Hook the Slingload Cargo
	local SLINGLOADHOOKTASK = SLINGLOADHOOKTASK:New( { 'Cargo 1 - Pick-Up', 'Cargo 2 - Pick-Up' }, { 'GE Cargo #001', 'GE Cargo #002', 'GE Cargo #003', 'GE Cargo #004', 'GE Cargo #005',
                                                                                                       'GE Cargo #006', 'GE Cargo #007', 'GE Cargo #008', 'GE Cargo #009', 'GE Cargo #010'	} )
	SLINGLOADHOOKTASK:AddSmokeBlue( { 'GE Cargo - Guard #001', 'GE Cargo - Guard #002' } )
	Mission:AddTask( SLINGLOADHOOKTASK, 1 )

		-- Route to the pickup zone
	local SlingLoadUnhookTask = SLINGLOADUNHOOKTASK:New( { 'Cargo 1 - Arrival', 'Cargo 2 - Arrival' }, { 'GE Cargo #001', 'GE Cargo #002', 'GE Cargo #003', 'GE Cargo #004', 'GE Cargo #005',
                                                                                                           'GE Cargo #006', 'GE Cargo #007', 'GE Cargo #008', 'GE Cargo #009', 'GE Cargo #010'	} )
	SlingLoadUnhookTask:AddSmokeGreen( { 'GE Cargo - Arrival #001', 'GE Cargo - Arrival #002' } )
	SlingLoadUnhookTask:SetGoalTotal( 1, "Cargo sling load" )
	Mission:AddTask( SlingLoadUnhookTask, 2 )

	MISSIONSCHEDULER.AddMission( Mission )
end

do -- NATO - Rescue secret agent from the woods
	local Mission = MISSION:New( 'Rescue secret agent', 'Tactical', 'In order to be in full control of the situation, we need you to rescue a secret agent from the woods behind enemy lines. Avoid the Russian defenses and rescue the agent. Keep south until Khasuri, and keep your eyes open for any SAM presence. The agent is located at waypoint 4 on your kneeboard.', 'NATO'  )

	Mission:AddClient( CLIENT:New( 'DE MI-8MTV2*HOT-Rescue Agent 1' ) )
	Mission:AddClient( CLIENT:New( 'DE MI-8MTV2*HOT-Rescue Agent 2' ) )
	Mission:AddClient( CLIENT:New( 'DE MI-8MTV2*RAMP-Rescue Agent 3' ) )
	Mission:AddClient( CLIENT:New( 'DE MI-8MTV2*RAMP-Rescue Agent 4' ) )

	Mission:AddClient( CLIENT:New( 'DE KA-50*HOT-Air Support 1' ) )
	Mission:AddClient( CLIENT:New( 'DE KA-50*HOT-Air Support 2' ) )
	Mission:AddClient( CLIENT:New( 'DE KA-50*RAMP-Air Support 3' ) )
	Mission:AddClient( CLIENT:New( 'DE KA-50*RAMP-Air Support 4' ) )

	Mission:AddCargo( 'Secret Agent', CARGO_TYPE.INFANTRY, math.random( 70, 120 ), nil, 'GE Secret Agent', 'NATO secret agent hiding zone' )

	-- Assign the Pickup Task
	local PickupTask = PICKUPTASK:New( 'NATO secret agent hiding zone', CARGO_TYPE.INFANTRY, CLIENT.ONBOARDSIDE.FRONT )
	PickupTask:AddFlareWhite( 'GE Secret Agent' )
	Mission:AddTask( PickupTask, 1 ) 

		-- Assign the Deploy Tasks
	local DeployTask = DEPLOYTASK:New( 'Gori Headquarters Drop Zone', CARGO_TYPE.INFANTRY )
	DeployTask:AddSmokeWhite( 'Gori Headquarters' )
	DeployTask:SetGoalTotal( 1 ) -- Once this is achieved, the goal is reached.
	Mission:AddTask( DeployTask, 2 )

	-- Assign the GoHome Task
	local GoHomeTask = GOHOMETASK:New( 'NATO Gori Home Bases' )
	Mission:AddTask( GoHomeTask, 3 )
	
	MISSIONSCHEDULER.AddMission( Mission )
end



-- CCCP COALITION UNITS

-- Russian helicopters engaging the battle field in Gori Valley
Spawn_RU_KA50 = SPAWN:New( 'RU KA-50@HOT-Patriot Attack' ):Limit( 4, 24 ):Schedule( 600, 0.2 ):RandomizeRoute( 1, 1, 4000 )
Spawn_RU_MI28N = SPAWN:New( 'RU MI-28N@HOT-Ground Attack' ):Limit( 4, 24 ):Schedule( 600, 0.2 ):RandomizeRoute( 1, 1, 2000 )
Spawn_RU_MI24V = SPAWN:New( 'RU MI-24V@HOT-Ground Attack' ):Limit( 4, 24 ):Schedule( 600, 0.2 ):RandomizeRoute( 1, 1, 2000 )

-- Russian helicopters deploying troops in the battle field in Gori Valley
Spawn_RU_MI26_Infantry = SPAWN:New( 'RU MI-26@HOT-Transport Infantry' ):Limit( 2, 8 ):Schedule( 900, 0.2 ):RandomizeRoute( 2, 2, 200 )
Spawn_RU_MI26_Troops = SPAWN:New( 'RU MI-26 Troops' ):Limit( 6, 20 ):RandomizeTemplate( { "RU MI-26 Infantry Alpha", "RU MI-26 Infantry Beta", "RU MI-26 Infantry Gamma" } ):RandomizeRoute( 1, 0, 5000 )

Spawn_RU_MI26_East = SPAWN:New( 'RU MI-26@HOT-SAM Transport East' ):Limit( 2, 8 ):Schedule( 900, 0.2 ):RandomizeRoute( 2, 2, 200 )
Spawn_RU_MI26_SAM_East = SPAWN:New( 'RU MI-26 SAM East' ):Limit( 8, 20 ):RandomizeTemplate( { "RU MI-26 SAM East 1", "RU MI-26 SAM East 2", "RU MI-26 SAM East 3" } ):RandomizeRoute( 1, 0, 2000 )

Spawn_RU_MI26_West = SPAWN:New( 'RU MI-26@HOT-SAM Transport West' ):Limit( 2, 8 ):Schedule( 900, 0.2 ):RandomizeRoute( 2, 2, 200 )
Spawn_RU_MI26_SAM_West = SPAWN:New( 'RU MI-26 SAM West' ):Limit( 8, 20 ):RandomizeTemplate( { "RU MI-26 SAM West 1", "RU MI-26 SAM West 2", "RU MI-26 SAM West 3" } ):RandomizeRoute( 1, 0, 2000 )

-- Russian planes attacking ground units in Gori Valley and defending air space over the mountains.
Spawn_RU_SU25T = SPAWN:New( 'RU SU-25T@RAMP-Patriot Attack' ):Limit( 4, 24 ):Schedule( 600, 0.25 ):RandomizeRoute( 1, 1, 200 )
Spawn_RU_SU27 = SPAWN:New( 'RU SU-27@RAMP-Air Support East' ):Limit( 4, 24 ):Schedule( 600, 0.3 ):RandomizeRoute( 1, 1, 8000 )
Spawn_RU_MIG29S = SPAWN:New( 'RU MIG-29S@RAMP-Air Defense West' ):Limit( 4, 24 ):Schedule( 600, 0.4 ):RandomizeRoute( 1, 1, 8000 )
Spawn_RU_MIG31_Intercept = SPAWN:New( 'RU MIG-31@RAMP-Intercept' ):Limit( 4, 24 ):Schedule( 600, 0.4 ):RandomizeRoute( 1, 1, 8000 )
Spawn_RU_SU24M_Bomb_Gori = SPAWN:New( 'RU SU-24M@RAMP-Bomb Gori' ):Limit( 3, 24 ):Schedule( 600, 0.4 ):RandomizeRoute( 1, 1, 8000 )

-- Russian planes escorting the SU25T attack forces
Spawn_RU_Escort1 = SPAWN:New( 'RU SU-30@RAMP-Patriot Attack Escort 1' ):RandomizeRoute( 1, 1, 2000 ):Limit( 2, 12 )
Spawn_RU_Escort2 = SPAWN:New( 'RU SU-30@RAMP-Patriot Attack Escort 2' ):RandomizeRoute( 1, 1, 2000 ):Limit( 2, 12 )

-- Russian ground troops attacking Gori Valley
Spawn_RU_Troops = { 'RU Attack Gori 1', 'RU Attack Gori 2', 'RU Attack Gori 3', 'RU Attack Gori 4', 'RU Attack Gori 5', 'RU Attack Gori 6', 'RU Attack Gori 7' }
Spawn_RU_Troops_Left = SPAWN:New( 'RU Attack Gori Left' ):Limit( 16, 150 ):Schedule( 180, 0.4 ):RandomizeTemplate( Spawn_RU_Troops ):RandomizeRoute( 3, 2, 4000 )
Spawn_RU_Troops_Middle = SPAWN:New( 'RU Attack Gori Middle' ):Limit( 16, 150 ):Schedule( 180, 0.4 ):RandomizeTemplate( Spawn_RU_Troops ):RandomizeRoute( 3, 3, 4000 )
Spawn_RU_Troops_Right = SPAWN:New( 'RU Attack Gori Right' ):Limit( 16, 150 ):Schedule( 180, 0.4 ):RandomizeTemplate( Spawn_RU_Troops ):RandomizeRoute( 3, 3, 4000 )

-- Limit the amount of simultaneous moving units on the ground to prevent lag.
Movement_RU_Troops = MOVEMENT:New( { 'RU Attack Gori Left', 'RU Attack Gori Middle', 'RU Attack Gori Right', 'RU MI-26 Troops' }, 30 )

-- BLUE COALITION UNITS



-- NATO helicopters deploying troops within the battle field.
Spawn_US_CH47D1 = SPAWN:New( 'US CH-47D@RAMP Troop Deployment 1' ):Limit( 2, 16 ):Schedule( 900, 0.2 ):RandomizeRoute( 1, 0, 200 )
Spawn_US_CH47D2 = SPAWN:New( 'US CH-47D@RAMP-Troop Deployment 2' ):Limit( 2, 16 ):Schedule( 900, 0.2 ):RandomizeRoute( 1, 0, 200 )

Spawn_US_CH47Troops = SPAWN:New( 'US CH-47D Troops' ):Limit( 8, 40 ):RandomizeTemplate( { "US Infantry Defenses A", "US Infantry Defenses B", "US Infantry Defenses C", "DE Infantry Defenses D", "DE Infantry Defenses E" } ):RandomizeRoute( 1, 0, 4000 )


-- NATO helicopters engaging in the battle field.
Spawn_BE_KA50 = SPAWN:New( 'BE KA-50@RAMP-Ground Defense' ):Limit( 4, 24 ):Schedule( 600, 0.5 ):RandomizeRoute( 1, 1, 2000 )


Spawn_US_AH64D = SPAWN:New( 'US AH-64D@RAMP-Ground Recon' ):Limit( 4, 20 ):Schedule( 900, 0.5 ):RandomizeRoute( 1, 1, 2000 )

-- NATO planes attacking Russian ground units and defending airspace
Spawn_BE_F16A = SPAWN:New( 'BE F-16A@RAMP-Air Support Mountains' ):Limit( 4, 20 ):Schedule( 900, 0.5 ):RandomizeRoute( 1, 1, 6000 ):RepeatOnEngineShutDown()
Spawn_US_F16C = SPAWN:New( 'US F-16C@RAMP-Sead Gori' ):Limit( 4, 20 ):Schedule( 600, 0.5 ):RandomizeRoute( 1, 1, 6000 ):RepeatOnEngineShutDown()
Spawn_US_F15C = SPAWN:New( 'US F-15C@RAMP-Air Support Mountains' ):Limit( 4, 24 ):Schedule( 600, 0.5 ):RandomizeRoute( 1, 1, 5000 ):RepeatOnEngineShutDown()
Spawn_US_F14A_Intercept = SPAWN:New( 'US F-14A@RAMP-Intercept' ):Limit( 3, 24 ):Schedule( 600, 0.4 ):RandomizeRoute( 1, 1, 6000 )
Spawn_US_A10C_Ground_Defense = SPAWN:New( 'US A-10C*HOT-Ground Defense' ):Limit( 4, 6 ):Schedule( 600, 0.4 ):RandomizeRoute( 1, 1, 6000 ):RepeatOnEngineShutDown()

-- NATO planes escorting the A-10Cs
Spawn_US_F16C_Escort1 = SPAWN:New( 'BE F-16A@HOT - Ground Attack Escort 1' ):RandomizeRoute( 1, 1, 5000 )
Spawn_US_F16C_Escort2 = SPAWN:New( 'BE F-16A@HOT - Ground Attack Escort 2' ):RandomizeRoute( 1, 1, 5000 )

-- NATO Tank Platoons invading Tskinvali
Spawn_US_Platoon = { 'US Tank Platoon 1', 'US Tank Platoon 2', 'US Tank Platoon 3', 'US Tank Platoon 4', 'US Tank Platoon 5', 'US Tank Platoon 6', 'US Tank Platoon 7', 'US Tank Platoon 8', 'US Tank Platoon 9', 'US Tank Platoon 10', 'US Tank Platoon 11', 'US Tank Platoon 12', 'US Tank Platoon 13' }
Spawn_US_Platoon_Left = SPAWN:New( 'US Tank Platoon Left' ):Limit( 16, 150 ):Schedule( 200, 0.4 ):RandomizeTemplate( Spawn_US_Platoon ):RandomizeRoute( 3, 3, 1500 )
Spawn_US_Platoon_Middle = SPAWN:New( 'US Tank Platoon Middle' ):Limit( 16, 150 ):Schedule( 200, 0.4 ):RandomizeTemplate( Spawn_US_Platoon ):RandomizeRoute( 3, 3, 1500 )
Spawn_US_Platoon_Right = SPAWN:New( 'US Tank Platoon Right' ):Limit( 16, 150 ):Schedule( 200, 0.4 ):RandomizeTemplate( Spawn_US_Platoon ):RandomizeRoute( 3, 3, 1500 )

-- NATO Tank Platoons defending the Patriot Batteries
Spawn_US_Patriot_Defense = { 'US Tank Platoon 1', 'US Tank Platoon 2', 'US Tank Platoon 3', 'US Tank Platoon 4', 'US Tank Platoon 5', 'US Tank Platoon 6', 'US Tank Platoon 7', 'US Tank Platoon 8', 'US Tank Platoon 9', 'US Tank Platoon 10', 'US Tank Platoon 11', 'US Tank Platoon 12', 'US Tank Platoon 13' }
Spawn_US_Platoon_Left = SPAWN:New( 'US Patriot Defenses 1' ):Limit( 4, 30 ):Schedule( 250, 0.4 ):RandomizeTemplate( Spawn_US_Patriot_Defense ):RandomizeRoute( 3, 0, 2000 )
Spawn_US_Platoon_Middle = SPAWN:New( 'US Patriot Defenses 2' ):Limit( 4, 30 ):Schedule( 250, 0.4 ):RandomizeTemplate( Spawn_US_Patriot_Defense ):RandomizeRoute( 3, 0, 2000 )
Spawn_US_Platoon_Right = SPAWN:New( 'US Patriot Defenses 3' ):Limit( 4, 30 ):Schedule( 250, 0.4 ):RandomizeTemplate( Spawn_US_Patriot_Defense ):RandomizeRoute( 2, 0, 2000 )

-- Limit the amount of simultaneous moving units on the ground to prevent lag.
Movement_US_Platoons = MOVEMENT:New( { 'US Tank Platoon Left', 'US Tank Platoon Middle', 'US Tank Platoon Right', 'US CH-47D Troops' }, 30 )



-- SEAD DEFENSES

--- CCCP SEAD Defenses
SEAD_RU_SAM_Defenses = SEAD:New( { 'RU SA-6 Kub', 'RU SA-6 Defenses', 'RU MI-26 Troops', 'RU Attack Gori' } )

--- NATO SEAD Defenses
SEAD_Patriot_Defenses = SEAD:New( { 'US SAM Patriot', 'US Tank Platoon', 'US CH-47D Troops' } )


--- Keep some airports clean
CLEANUP_Airports = CLEANUP:New( { 'CLEAN Tbilisi', 'CLEAN Vaziani', 'CLEAN Kutaisi', 'CLEAN Sloganlug', 'CLEAN Beslan', 'CLEAN Mozdok', 'CLEAN Nalchik' }, 1 )


-- MISSION SCHEDULER STARTUP
MISSIONSCHEDULER.Start()
MISSIONSCHEDULER.ReportMenu()
MISSIONSCHEDULER.ReportMissionsFlash( 120 )

env.info( "Gori Valley.lua loaded" )

