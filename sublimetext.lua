--credentials missing
scriptDetailsUrl = "https://market.myo.com/app/55bbd712e4b0a4d28fe2a279"
--gello2
lastpose = "rest"
SidebarActions  = {}

function SidebarActions:new(a)
	a = a or {}
    setmetatable(a, self)
    self.__index = self
    return a
end

function SidebarActions:showSidebar()
	-- body
	if platform == "Windows" then
		myo.keyboard("k","press","control")
		myo.keyboard("b","press","control")
	elseif platform == "MacOS" then
        myo.keyboard("k","press","command")
        myo.keyboard("b","press","command")
    end
	--Soon on Mac OS
end

function SidebarActions:hideSidebar()
	-- body
	if platform == "Windows"  then
        myo.keyboard("k","press","control")
	    myo.keyboard("b","press","control")
    elseif platform == "MacOS" then
        myo.keyboard("k","press","command")
        myo.keyboard("b","press","command")
	 end
	 --Soon on Mac OS
end

------------------------------------------------------------------------
    --for left handed
function conditionallySwapWave(pose)   
    if myo.getArm() == "left" then
        if pose == "waveIn" then
            pose = "waveOut"
        elseif pose == "waveOut" then
            pose = "waveIn"
        end
    end
    return pose
end 

function onActiveChange(isActive)
    if not isActive then
        diff_value = 0 
        divider = PACE_PARAMETER_FOR_SCROLLING
        lastpose="rest"
    end
end

function getMyoRollDegrees()
    local degrees_value = math.deg(myo.getRoll())
    return degrees_value
end

function differencebetween2( standard_angle, current_angle )
  local diff = standard_angle - current_angle
    if diff > 180 then
        diff = diff - 360
    elseif diff < -180 then
        diff = diff + 360
    end
    return diff
end

------------------------------------------------------------------------

function onPoseEdge(pose, edge)

	myo.setLockingPolicy("standard")
 	milisec = myo.getTimeMilliseconds()
    divider = PACE_PARAMETER_FOR_SCROLLING
	
     --check for left handed
	pose=conditionallySwapWave(pose)

	if edge == "on" then
    
    	if pose == "doubleTap" and myo.isUnlocked()==true and lastpose~="waveOut" then
    		myo.lock()        
    		return true           
      	end

    	if lastpose == "waveOut" then
    		if pose=="waveIn"  then
    			Action:hideSidebar()
    			lastpose=pose
    			myo.unlock("timed")
      			return true
      		else 
    			myo.unlock("hold")
    			return false
    		end
    	end 

    	if pose == "fingersSpread" then
    	    goto_Searchbar()   
    	    myo.lock()         
    	elseif pose=="waveOut" then
    		myo.unlock("hold")
    		Action:showSidebar()
    	end

    end

        if pose == "fist"  then -- remember to hold your fist!
        
            scrollActive= edge == "on";
            cur_angle=getMyoRollDegrees()
            if edge == "off" then
                myo.unlock("timed")
            else
                myo.unlock("hold")
            end
        end
	   
   
    if pose~= "fist" and lastpose~="waveOut" then
	   lastpose=pose --trying to get the last pose waveIn to compine with the waveOut (open and close the side bar)
	end

end

------------------------------------------------------------------------

PACE_PARAMETER_FOR_SCROLLING= 200

function onPeriodic( )
   
    local time = myo.getTimeMilliseconds()
	
    if scrollActive == true then
    	
        diff_value=differencebetween2(cur_angle,getMyoRollDegrees())
        
        if (time-milisec)/divider > 1 then
            
            divider = divider + PACE_PARAMETER_FOR_SCROLLING
            --myo.debug("diff_value ".. diff_value)
        
            --for the scroll Up
            if platform == "Windows" then
                if diff_value > 0.5 then
                    if diff_value < 3 then 
            	       --myo.debug("Slow Up")
                       myo.mouseScrollBy(1)
        	        elseif diff_value < 8  then
                       --myo.debug("Little bit Faster Up")
                       myo.mouseScrollBy(2)
                    elseif diff_value < 15  then
                       --myo.debug("Faster Up")
                       myo.mouseScrollBy(3)
                    elseif diff_value < 25  then
                        --myo.debug("More faster Up")
                        myo.mouseScrollBy(5)
                    elseif diff_value < 34  then
                        --myo.debug("Really fast Up")
                        myo.mouseScrollBy(7)
                    else
                        myo.mouseScrollBy(9)
                    end

                --for the scroll Down
                elseif diff_value < -0.5 then
                    if diff_value > -3 then
                        --myo.debug("Slow Down")
                        myo.mouseScrollBy(-1)
                    elseif diff_value >-8 then
                        --myo.debug("Little bit Faster Down")
                        myo.mouseScrollBy(-2)
                    elseif diff_value >- 15  then
                        --myo.debug("Faster Down")
                        myo.mouseScrollBy(-3)
                    elseif diff_value >- 25  then
                        --myo.debug("More faster Down")
                        myo.mouseScrollBy(-5)    
                    elseif diff_value >- 34  then
                        --myo.debug("Really fast Down")
                        myo.mouseScrollBy(-7)
                    else
                        myo.mouseScrollBy(-9)
                    end
                end
            elseif platform == "MacOS" then
                if diff_value > 0.5 then
                    if diff_value < 3 then 
                       --myo.debug("Slow Up")
                       myo.mouseScrollBy(10)
                    elseif diff_value < 8  then
                       --myo.debug("Little bit Faster Up")
                       myo.mouseScrollBy(20)
                    elseif diff_value < 15  then
                       --myo.debug("Faster Up")
                       myo.mouseScrollBy(30)
                    elseif diff_value < 25  then
                        --myo.debug("More faster Up")
                        myo.mouseScrollBy(50)
                    elseif diff_value < 34  then
                        --myo.debug("Really fast Up")
                        myo.mouseScrollBy(70)
                    else
                        myo.mouseScrollBy(90)
                    end

                --for the scroll Down
                elseif diff_value < -0.5 then
                    if diff_value > -3 then
                        --myo.debug("Slow Down")
                        myo.mouseScrollBy(-10)
                    elseif diff_value >-8 then
                        --myo.debug("Little bit Faster Down")
                        myo.mouseScrollBy(-20)
                    elseif diff_value >- 15  then
                        --myo.debug("Faster Down")
                        myo.mouseScrollBy(-30)
                    elseif diff_value >- 25  then
                        --myo.debug("More faster Down")
                        myo.mouseScrollBy(-50)    
                    elseif diff_value >- 34  then
                        --myo.debug("Really fast Down")
                        myo.mouseScrollBy(-70)
                    else
                        myo.mouseScrollBy(-90)
                    end
                end
            end     
        end

  	end	
end

------------------------------------------------------------------------


Action=SidebarActions:new()

function goto_Searchbar()  
    if platform == "Windows" then
        myo.keyboard("p","press","control","shift")
    elseif platform == "MacOS" then
        myo.keyboard("p","press","command","shift")
    end
end

function onForegroundWindowChange( app, title )
--myo.debug("onForegroundWindowChange: " .. app .. ", " .. title)
	
    if (app == "sublime_text.exe" and platform == "Windows") or (app == "com.sublimetext.2" and platform == "MacOS") then
		myo.vibrate("short") -- coming soon
		return true
	else return false
	end
	-- body
end

function activeAppName()
	return "Sublime Text"
end

