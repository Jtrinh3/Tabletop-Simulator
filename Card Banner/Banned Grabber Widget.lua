--Idk who made this originally but im using bits and pieces from it.
function onLoad(saved_data)
	searchTerm = ''
	bannedCards = 
		{
		"cheatyface",
		
		--colorless
		"ashnod's altar",
		"blasting station",
		"chrome mox",
		"jeweled lotus",
		"lion's eye diamond",
		"mana vault", 
		"mana crypt",
		"mox diamond",
		"phyrexian altar",
		"sol ring",
		"staff of domination",
		"the tabernacle at pendrell vale",
		"walking ballista",
		
		--White
		--"cathar's crusade", --slow play
		"smothering tithe",
		
		--Blue
		"cyclonic rift",
		"expropriate",
		"intruder alarm",
		"magosi, the waterveil",
		"narset, parter of veils", --for same reason as leovold
		"rhystic study",
		"temporal manipulation",
		"time stretch",
		"urza, lord high artificer",
		
		--Black
		"ad nauseam",
		"bolas's citadel",
		"demonic consultation",
		"equisite blood",
		"gravecrawler",
		"k'rrik, son of yawgmoth",
		"reassembling skeleton",
		"tainted pact",
		"tergrid, god of fright", --I swear it's only ran with wheels
		
		--Red
		"aggravated assault",
		"dockside extortionist",
		"jeska's will",
		"kiki-jiki, mirror breaker",
		"sneak attack",
		"splinter twin",
		"underworld breach",
		
		--Green
		"gaea's cradle",
		--"scute swarm", --slow play
		
		--Multicolored
		"heliod, the radiant dawn",
		"sen triplet",
		"time sieve",

		--cheap af tutors
		--[[
		"demonic tutor",
		"enlightened tutor",
		"mystical tutor",
		"personal tutor",
		"sylvan tutor",
		"vampiric tutor",
		"worldly tutor",
		]]--
		
		--Default commander bans
		"ancestral recall",
		"balance",
		"biorhythm",
		"black lotus",
		"braids, cabal minion",
		"channel",
		"chaos orb",
		"coalition victory",
		"emrakul, the aeon’s torn",
		"erayo, soratami ascendant",
		"falling star",
		"fastbond",
		"flash",
		"gifts ungiven",
		"golos, tireless pilgrim",
		"griselbrand",
		"hullbreacher",
		"iona, shield of emeria",
		"karakas",
		"leovold, emissary of trest",
		"library of alexandria",
		"limited resources",
		"lutri, the spellchaser",
		"mox emerald",
		"mox jet",
		"mox pearl",
		"mox ruby",
		"mox sapphire",
		"panoptic mirror",
		"paradox engine",
		"primeval titan",
		"prophet of kruphix",
		"recurring nightmare",
		"rofellos, llanowar emissary",
		"shahrazad",
		"sundering titan",
		"sway of the stars",
		"sylvan primordial",
		"time vault",
		"time walk",
		"tinker",
		"tolarian academy",
		"trade secrets",
		"upheaval",
		"yawgmoth’s bargain"
		}
	deckDir=-1
	if saved_data ~= "" then
		local loaded_data = JSON.decode(saved_data)
		searchTerm = loaded_data[1]
		deckDir = loaded_data[2]
	end
	if deckDir==1 then
		lab='→'
		tip='card extraction: [b]right[/b]'
	else
		lab='←'
		tip='card extraction: [b]left[/b]'
	end
	self.createButton({
		label=lab,
		tooltip=tip,
		click_function="changeDeckDir",
		function_owner=self,
		position={-1.6,0.1,-1.3},
		height=200,
		width=400,
		font_size=500,
		font_color={1,1,1,90},
		color={0,0,0,0},
	})
	self.createButton({
		input_function='getSearch',
		function_owner=self,
		label='Banned!',
		value=searchTerm,
		position={0,0.1,0},
		width=1900,
		height=321,
		font_size=300,
		font_color={1,.3,.3,1},
		color=Color.Red
		tooltip='Commence the banningning',
		alignment=3
	})
end
function getSearch(obj,ply,val)
	searchTerm=val
	updateSave()
end
function changeDeckDir()
	deckDir=deckDir*-1
	if deckDir==1 then
		lab='→'
		tip='card extraction: [b]right[/b]'
	else
		lab='←'
		tip='card extraction: [b]left[/b]'
	end
	self.editButton({index=0,label=lab,tooltip=tip})
  updateSave()
end
function updateSave()
  local data_to_save = {searchTerm,deckDir}
  saved_data = JSON.encode(data_to_save)
  self.script_state = saved_data
end

function onCollisionEnter(co)
	nowt=os.time()
	if prevt==nil then prevt=0 end
	if nowt-prevt<1 then return end
	prevt=nowt
	deck = co.collision_object
	if deck.type == "Deck" then
		--nTake= #bannedCards
		nTaken=0	
		for i,card in ipairs(deck.getObjects()) do
			cname=card.name:lower():gsub('%p','')
			for j,cardName in ipairs(bannedCards) do	--For each name in the ban list
				if cname:match(cardName) then
					nTaken=nTaken+1
				        rot=deck.getRotation()
				        pos=deck.getPosition()
				        rig=deck.getTransformRight()
				        rot[3]=0
				        pos=pos+rig:scale(deckDir*2.4+deckDir*(nTaken-1)*1.5)
				        pos[2]=pos[2]+nTaken*0.1
				        deck.takeObject({index=i-nTaken,position=pos,rotation=rot})
					--get only 1 card
				        --if nTaken==tonumber(nTake) then
				        --	break
					end
				 end
			end
    Wait.time(function() deck.shuffle() end, 0.1, 5)

    self.destruct()
	end
end
