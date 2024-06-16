return function(cutscene)
	local function file_exists(name)
       local f = io.open(name, "r")
       return f ~= nil and io.close(f)
    end

    local function getFileLines(fileName)
        local f = io.open(fileName, "r")

        tab={}
        for l in f:lines() do
            table.insert(tab, l)
        end

        f:close()
        return tab
    end
	cutscene:fadeOut(0)
	print(love.filesystem.getInfo("saves/frozen_heart/checkpass0")~=nil)
	skip=love.filesystem.getInfo("saves/frozen_heart/checkpass0")~=nil

	Kristal.hideBorder(0)

	cutscene:wait(1)
	local nextCut="intro.goner"
	if skip then
		cutscene:text("* Would you like to see the goner intro again?")
        local choices = {"Yes", "No"}

        if (Kristal.Config["canAccessSecret"] or Kristal.Config["extras"] or Kristal.Config["allclear_scene"]) and not Kristal.Config["beat_once"] then
            Kristal.Config["beat_once"] = true
            Kristal.saveConfig()
        end

        if Kristal.Config["beat_once"] then
            table.insert(choices, "Skip Intro")
        end
        
		local c=cutscene:choicer(choices)
		print(c)
		if c==2 then
			nextCut="intro.intro"
        elseif c == 3 then
            Game:setFlag("plot", 2)
            nextCut = "intro.quickintro"
	    end
	end

	-- Save File Reading
	local current_os = love.system.getOS()
    oriSaves={}
    local fileFound = false
    if current_os == "Windows" then
        for i=0,2 do
            file = string.gsub(os.getenv('UserProfile'), "\\", "/").."/AppData/Local/DELTARUNE/filech2_".. i
            if file_exists(file) then
            	if tonumber(getFileLines(file)[1468])>=1 then
                	print("Snowgrave Save file "..i.." found!")
                	oriSaves=getFileLines(file)
                	fileFound=true
                	break
                end
            end
        end
    end
    
    if fileFound then
    	print("Loading data from save file...")
    	Game.save_name=oriSaves[1]
    	print("Welcome to Frozen Heart, "..Game.save_name)

        print("---STORAGE---")
        for i=452, 475 do
        	local item = Mod:getKristalID(tonumber(oriSaves[i]), "item")
        	print(oriSaves[i], item)
        	Game.inventory:addItemTo("storage", item)
        end

        Game:setFlag("vessel", {
            name=oriSaves[2],
            head=tonumber(oriSaves[1453])+1,
            body=tonumber(oriSaves[1454])+1,
            legs=tonumber(oriSaves[1455])+1,
        })

        print("---VESSEL---")
        for k,v in pairs(Game:getFlag("vessel")) do
        	print(k,v)
        end

        print("It is done.")
    else
    	print("No save data found")
    end

	cutscene:wait(1)
	cutscene:gotoCutscene(nextCut)
end