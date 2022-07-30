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

	cutscene:wait(1)
	local nextCut="intro.goner"
	if skip then
		cutscene:text("* Would you like to see the goner intro again?")
		local c=cutscene:choicer({"Yes", "No"})
		print(c)
		if c==2 then
			nextCut="intro.intro"
			cutscene:wait(0.5)
			cutscene:text("* Would you like to load a save file from DELTARUNE?")
			local c2=cutscene:choicer({"Yes", "No"})
			if c2==1 then
				local current_os = love.system.getOS()
			    oriSaves={{}, {}, {}}
			    local fileFound = false
			    if current_os == "Windows" then
			        for i=0,2 do
			            file = string.gsub(os.getenv('UserProfile'), "\\", "/").."/AppData/Local/DELTARUNE/filech2_".. i
			            if file_exists(file) then
			                print("Save file "..i.." found!")
			                oriSaves[i+1]=getFileLines(file)
			                fileFound=true
			            end
			        end
			    end
			    cutscene:wait(0.5)
			    if fileFound then
			    	cutscene:text("* Please select the save file you want to load.")
			    	local t={}
	                for i=1,3 do
	                    if #oriSaves[i]>0 then
	                        if tonumber(oriSaves[i][1468])>=1 then
	                            table.insert(t, "F"..i.." - "..oriSaves[i][1].." [S]")
	                        else
	                            table.insert(t, "F"..i.." - "..oriSaves[i][1])
	                        end
	                    end
	                end
	                local c=cutscene:choicer(t)
	                Game.save_name=oriSaves[c][1]
	                Game:setFlag("deltarune_data", {
	                    gonername=oriSaves[c][2],
	                    krisStats={
	                        hp=oriSaves[c][79],
	                        maxhp=oriSaves[c][80],
	                        atk=oriSaves[c][81],
	                        def=oriSaves[c][82],
	                        mag=oriSaves[c][83],
	                        weapon=oriSaves[c][85],
	                        armor1=oriSaves[c][86],
	                        armor2=oriSaves[c][87]
	                    },
	                    susieStats={
	                        hp=oriSaves[c][141],
	                        maxhp=oriSaves[c][142],
	                        atk=oriSaves[c][143],
	                        def=oriSaves[c][144],
	                        mag=oriSaves[c][145],
	                        weapon=oriSaves[c][147],
	                        armor1=oriSaves[c][148],
	                        armor2=oriSaves[c][149]
	                    },
	                    ralseiStats={
	                        hp=oriSaves[c][203],
	                        maxhp=oriSaves[c][204],
	                        atk=oriSaves[c][205],
	                        def=oriSaves[c][206],
	                        mag=oriSaves[c][207],
	                        weapon=oriSaves[c][209],
	                        armor1=oriSaves[c][210],
	                        armor2=oriSaves[c][211],
	                    },
	                    noelleStats={
	                        armor1=oriSaves[c][272],
	                        armor2=oriSaves[c][273]
	                    },
	                    jevil=oriSaves[c][832],
	                    vessel={
	                        head=oriSaves[c][1453],
	                        body=oriSaves[c][1454],
	                        legs=oriSaves[c][1455]
	                    }
	                })
	                Game.money=oriSaves[c][11]
	                Game.playtimer=oriSaves[c][3055]
	                cutscene:text("* It is done.")
	            else
	            	cutscene:text("* You have no save file for DELTARUNE.\nImpossible to load data.")
	            end
	        end
	    end
	end
	cutscene:wait(1)
	cutscene:gotoCutscene(nextCut)
end