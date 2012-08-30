function warlock_destruction(self)

	local mana = UnitMana("player")/UnitManaMax("player")
	local hp = UnitHealth("player")/UnitHealthMax("player")
	local targetHp = UnitHealth("target")/UnitHealthMax("target")
	local mousoverHp = UnitHealth("mouseover")/UnitHealthMax("mouseover")

	local embers = UnitPower("player",14)
	local hasEmbers = false

	if embers > 0 then 
		hasEmbers = true
	end
	

	if jps.MultiTarget then
		--AOE
		--Lets burn this shift! 

		--TODO: Count our engaged targets

		--Burn them down!
		if jps.checkTimer("RoF") == nil or jps.checkTimer("RoF") == 0 then
			createTimer("RoF", 6)
			jps.groundClick()
			return "Rain of Fire"
		end

		--We just FaB'ed lets figure out if we should aoe conflag or aoe immolate or aoe incinerate.
		if jps.buff("Fire and Brimstone") then
			if jps.debuffDuration("immolate", "mouseover") == 0 then
				return "Immolate"
			else
				if cd("conflagrate") == 0 then
					return "Conflagrate"
				else
					return "Incinerate"
				end
			end
		end

		--Do we have enough embers for an Fire and Brimstone
		if embers >= 2 then
				--Fire And Brimstone this shizzle
				return "Fire and Brimstone"
			end
		end

		--We blew all our fancy shizzle just dot em the old school way
		--TODO: Research if building embers for an aoe immolate results in more damage.
		if 	jps.debuffDuration("immolate", "mouseover")==0
			and UnitAffectingCombat("mouseover") 
			and mouseoverHp > 20
			and UnitThreatSituation("player","mousover")<2 then
			jps.Target = "mouseover"
			return "Immolate"
		end
	else
		--SINGLE TARGET

		--Lets check if we need to bring the magic vulnerability and if there's a point wasting a gcd on one.
		if (jps.notmyDebuffDuration("curse of elements") == 0 and jps.notmyDebuffDuration("master poisoner") == 0)
			and ( ( targetHp > 20 and UnitHealth("target") > 1000000 ) or ( UnitHealth("target") > 1000000 ) ) then --Arbitrary hp numbers, will fine tune this later.
			return "Curse of Elements"
		end

		if hasEmbers and UnitHealth("target") > 100000 --currently i'm hitting arround 100k minimum with this one, will update to scale with level 90 dps later.
			return "Chaos Bolt"
		end

	end
end