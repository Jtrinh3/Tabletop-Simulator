--Idk who made this originally but I'm using bits and pieces from it.
function onLoad(saved_data)
	searchTerm = ''
	bannedCards = 
		{
		"cheatyface",
		
		--colorless
		"ashnod's altar",
		"blasting station",
		"chrome mox",
		"gemstone cavern",
		"glacial chasm",
		"grim monolith",
		"lion's eye diamond", 
		"mana vault",
		"mox amber",
		"mox diamond",
		"phyrexian altar",
		"sol ring",
		"staff of domination",
		"the one ring",
		"the tabernacle at pendrell vale",
		"walking ballista",
		"winter orb",
		
		--White
		"drannith magistrate",
		"enlightened tutor
		"humility",
		"smothering tithe",
    		"teferi's protection",
		
		--Blue
		"consecrated sphinx",
		"cyclonic rift",
		"expropriate",
		"fierce guardianship",
		"force of will",
		"gifts ungiven",
		"intuition",
		"jin-gitaxias, core augur",
		"mystical tutor",
		"narset, parter of veils", --for same reason as leovold
		"rhystic study",
		"sway of the stars",
		"thassa's oracle",
		"urza, lord high artificer",
		
		--Black
		"ad nauseam",
		"bolas's citadel",
		"cabal coffers",
		"demonic consultation",
		"equisite blood",
		"gonti's aether heart",
		"k'rrik, son of yawgmoth",
		"maralen of the mornsong",
		"tainted pact",
		"tergrid, god of fright", --I swear it's only ran with wheels
		
		--Red
		"aggravated assault",
		"boom // bust",
		"decree of annihilation",
		"devastation",
		"final fortune",
    		"insurrection",
		"jeska's will",
		"jokulhaups",
		"last chance",
		"kiki-jiki, mirror breaker",
		"mob rule",
		"obliterate",
    		"sneak attack",
		"splinter twin",
		"underworld breach",
		"warrior's oath",
		
		--Green
		"constant mist",
		"gaea's cradle",
		"tooth and nail",
		"scute swarm", --boring
		"spore frog",
		
		--Multicolored
		"chance for glory",
    		"inkshield",
		"heliod, the radiant dawn",
		"notion thief",
		"sen triplet",
		"stitch in time",
		"time sieve",

		--cheap af tutors
		"demonic tutor",
		"enlightened tutor",
		"imperial seal",
		"mystical tutor",
		"personal tutor",
		"sylvan tutor",
		"vampiric tutor",
		"worldly tutor",
		
		
		--Default commander bans
		"ancestral recall",
		"balance",
		"biorhythm",
		"black lotus",
		"braids, cabal minion",
		"channel",
		"chaos orb",
		"coalition victory",
		"dockside extortionist",
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
		"jeweled lotus",
		"karakas",
		"leovold, emissary of trest",
		"library of alexandria",
		"limited resources",
		"lutri, the spellchaser",
		"mana vault",
		"mox emerald",
		"mox jet",
		"mox pearl",
		"mox ruby",
		"mox sapphire",
		"nadu, winged wisdom",
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
	if prevt==nil then prevt=0
    		end
	if nowt-prevt<1 then return end
	prevt=nowt
	deck = co.collision_object
	if deck.type == "Deck" then
    		printToAll("Watch out! This deck contains:", {r=1,g=.3,b=1})
		--nTake= #bannedCards
		nTaken=0	
		for i,card in ipairs(deck.getObjects()) do
			cname=card.name:lower():gsub('%p','')
			for j,cardName in ipairs(bannedCards) do	--For each name in the ban list
				if cname:match(cardName) then
					nTaken=nTaken+1
				        --[[rot=deck.getRotation()
				        pos=deck.getPosition()
				        rig=deck.getTransformRight()
				        rot[3]=0
				        pos=pos+rig:scale(deckDir*2.4+deckDir*(nTaken-1)*1.5)
				        pos[2]=pos[2]+nTaken*0.1
				        deck.takeObject({index=i-nTaken,position=pos,rotation=rot})]]
                			printToAll(cardName, {r=1,g=1,b=1})
          
					--get only 1 card
				        --if nTaken==tonumber(nTake) then
				        --	break
				end
			end
		end
    	Wait.time(function() deck.shuffle() end, 0.1, 5)
	if nTaken==0 then printToAll("This deck is 100% Kosher and Gluten-Free!", {r=.2,g=1,b=.4})
	else printToAll("You dirty filth!", {r=1,g=.2,b=.2})
		end
	--self.destruct()
	end
end
