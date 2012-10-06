local addon, ns = ...

ns.config = {
	guildRanks = {
		['Council'] = true,
		['"Special"'] = true,
		['Hardcore Raider'] = true,
		['Raider'] = true,
		['Trial'] = true,

	},
	ranks = { 
		mainspec = 1,
		offspec = 2.25,
		unranked = 2.25,
	},
	minbid = 3,
	boundaries = {
		[1] = { points = 50,  factor = 1 	   },
		[2] = { points = 100, factor = (2 / 3) },
		[3] = { points = 150, factor = (1 / 3) },
	}
}
