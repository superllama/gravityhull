table.Merge(TOOL,{
	Name = "Gravity Hull Designator",
	Category = "Construction",
	ClientConVar = {
		floordist = 0,
		gravnormal = 0,
		gravity = 100,
	}
})
if CLIENT then
	language.Add("Tool.localphysics.name", "Gravity Hull Designator")
	language.Add("Tool.localphysics.desc", "Create a local physics system for a ship or building so that you can walk around inside regardless of its movement or angles.")
	language.Add("Tool.localphysics.0", "Fire at an upright hull to create a local physics system. Alt-fire at a designated hull to remove the system.")
	language.Add("Hint_ghd", "Check your chatbox for instructions.")
else
	concommand.Add("ghd_help",function(p)
		p:SendHint("ghd",0)
		p:ChatPrint("==Gravity Hull Designator Help==")
		p:ChatPrint("Use the tool on a contraption to create a hull.")
		p:ChatPrint("If you want to walk on top of it (i.e. flat plate), increase the vertical protrusion factor in the tool rollout.")
		p:ChatPrint("If you want to align gravity with the surface you shot, check the Hit Surface Defines Floor box in the tool rollout.")
		p:ChatPrint("Change the Player Gravity Percentage slider to define how much gravity pulls on players. Doesn't work on props (YET).")
	end)
end
function TOOL.BuildCPanel(cp)
	cp:AddControl("Header",{Text = "#Tool.localphysics.name", Description = "#Tool.localphysics.desc"})
	cp:AddControl("Slider",{Label = "Vertical Protrusion Factor", Description = "The minimum distance from the floor that walls or a ceiling is required to keep entities inside.",
	                        Type = "Integer", Min = 0, Max = 300, Command = "localphysics_floordist"})
	cp:AddControl("Checkbox",{Label = "Hit Surface Defines Floor", Description = "If checked, the surface shot by the tool will determine the pull of gravity for the system.",
							  Command = "localphysics_gravnormal"})
	cp:AddControl("Slider",{Label = "Player Gravity Percentage", Description = "The percentage of normal gravity to apply to players inside. *DOES NOT WORK WITH PROPS YET*",
							Type = "Integer", Min = 0, Max = 500, Command = "localphysics_gravity"})
	cp:AddControl("Button",{Label = "Help", Description = "Help, obviously", Command = "ghd_help"})
	cp:AddControl("Button",{Label = "Fix Camera", Description = "If you're teleporting to the sky when you enter a ship, click this until it works.", Command = "ghd_fixcamera"})
end
--Designate Hull
function TOOL:LeftClick(tr)
	local ent = tr.Entity
	if CLIENT then return IsValid(ent) and !GravHull.GHOSTHULLS[ent] end
	if !(IsValid(ent) and ent:GetMoveType() == MOVETYPE_VPHYSICS and !GravHull.HULLS[ent]) then return false end
	GravHull.RegisterHull(ent,self:GetClientNumber("floordist"),self:GetClientNumber("gravity"))
	if self:GetClientNumber("gravnormal") > 0 then
		GravHull.UpdateHull(ent,tr.HitNormal)
	else
		GravHull.UpdateHull(ent)
	end
	self:GetOwner():ChatPrint("Created a local physics system.")
	return true
end
--Remove Hull
function TOOL:RightClick(tr)
	local ent = tr.Entity
	if CLIENT then return IsValid(ent) end
	if IsValid(ent) and ent:GetMoveType() == MOVETYPE_VPHYSICS then
		if !GravHull.SHIPS[ent] then
			ent = ent.MyShip or (ent.Ghost and ent.Ghost.MyShip)
		end
	else
		return false
	end
	if !IsValid(ent) then return false end
	self:GetOwner():ChatPrint("Removed a local physics system.")
	GravHull.UnHull(ent)
	return true
end
function TOOL:Reload(tr)
	//idk this is for later
end
function TOOL:Think(tr)
	//idk this is for later
end