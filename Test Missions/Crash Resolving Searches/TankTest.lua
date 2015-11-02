Tank1 =
{
	["route"] = 
	{
		["spans"] = 
		{
			[1] = 
			{
				[1] = 
				{
					["y"] = 617527.7142857,
					["x"] = -355915.42857143,
				}, -- end of [1]
				[2] = 
				{
					["y"] = 618230.57142856,
					["x"] = -356416.85714286,
				}, -- end of [2]
			}, -- end of [1]
			[2] = 
			{
				[1] = 
				{
					["y"] = 617786.28571427,
					["x"] = -356102.57142858,
				}, -- end of [1]
				[2] = 
				{
					["y"] = 617786.28571427,
					["x"] = -356102.57142858,
				}, -- end of [2]
			}, -- end of [2]
		}, -- end of ["spans"]
		["points"] = 
		{
			[1] = 
			{
				["alt"] = 10,
				["type"] = "Turning Point",
				["ETA"] = 0,
				["alt_type"] = "BARO",
				["formation_template"] = "",
				["y"] = 617527.7142857,
				["x"] = -355915.42857143,
				["ETA_locked"] = true,
				["speed"] = 5.5555555555556,
				["action"] = "Off Road",
				["task"] = 
				{
					["id"] = "ComboTask",
					["params"] = 
					{
						["tasks"] = 
						{
							[1] = 
							{
								["enabled"] = true,
								["auto"] = true,
								["id"] = "WrappedAction",
								["number"] = 1,
								["params"] = 
								{
									["action"] = 
									{
										["id"] = "EPLRS",
										["params"] = 
										{
											["value"] = true,
											["groupId"] = 2,
										}, -- end of ["params"]
									}, -- end of ["action"]
								}, -- end of ["params"]
							}, -- end of [1]
							[2] = 
							{
								["number"] = 2,
								["auto"] = false,
								["id"] = "WrappedAction",
								["enabled"] = true,
								["params"] = 
								{
									["action"] = 
									{
										["id"] = "Option",
										["params"] = 
										{
											["value"] = 4,
											["name"] = 0,
										}, -- end of ["params"]
									}, -- end of ["action"]
								}, -- end of ["params"]
							}, -- end of [2]
						}, -- end of ["tasks"]
					}, -- end of ["params"]
				}, -- end of ["task"]
				["speed_locked"] = true,
			}, -- end of [1]
			[2] = 
			{
				["alt"] = 10,
				["type"] = "Turning Point",
				["ETA"] = 155.40983343003,
				["alt_type"] = "BARO",
				["formation_template"] = "",
				["y"] = 618230.57142856,
				["x"] = -356416.85714286,
				["ETA_locked"] = false,
				["speed"] = 5.5555555555556,
				["action"] = "Off Road",
				["task"] = 
				{
					["id"] = "ComboTask",
					["params"] = 
					{
						["tasks"] = 
						{
						}, -- end of ["tasks"]
					}, -- end of ["params"]
				}, -- end of ["task"]
				["speed_locked"] = true,
			}, -- end of [2]
		}, -- end of ["points"]
		["routeRelativeTOT"] = true,
	}, -- end of ["route"]
	["groupId"] = 1000,
	["tasks"] = 
	{
	}, -- end of ["tasks"]
	["hidden"] = false,
	["units"] = 
	{
		[1] = 
		{
			["y"] = 617527.7142857,
			["type"] = "M-1 Abrams",
			["name"] = "US MBT M1A2 Abrams #001",
			["unitId"] = 9,
			["heading"] = 2.1904687787976,
			["playerCanDrive"] = true,
			["skill"] = "Excellent",
			["x"] = -355915.42857143,
		}, -- end of [1]
	}, -- end of ["units"]
	["y"] = 617527.7142857,
	["x"] = -355915.42857143,
	["name"] = "US MBT M1A2 Abrams #001",
	["start_time"] = 0,
	["task"] = "Ground Nothing",
	["visible"] = false,
	--["taskSelected"] = true,
	["lateActivation"] = false,
}

coalition.addGroup( country.id.USA, Group.Category.GROUND, Tank1)



