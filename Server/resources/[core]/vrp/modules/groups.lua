-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Service = {}
local SeoulAdminControlNativeGroups = {}
local SeoulAdminControlManagedGroups = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- FORSERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
for Permission in pairs(Groups) do
	Service[Permission] = {}
	SeoulAdminControlNativeGroups[Permission] = true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL ADMINCONTROL RUNTIME HELPERS
-----------------------------------------------------------------------------------------------------------------------------------------
local function SeoulAdminControlIsManagedData(Data)
	return type(Data) == "table" and (Data.Source == "admincontrol" or Data.SeoulAdminControl == true or Data.SeoulSource == "AdminControl")
end

local function SeoulAdminControlBuildHierarchy(Data)
	local Hierarchy = {}
	local SourceHierarchy = type(Data) == "table" and Data.Hierarchy or nil

	if type(SourceHierarchy) == "table" then
		for Level,Entry in ipairs(SourceHierarchy) do
			if type(Entry) == "table" then
				Hierarchy[#Hierarchy + 1] = tostring(Entry.Title or Entry.Name or Entry.Group or ("Cargo "..tostring(Level)))
			elseif Entry ~= nil then
				Hierarchy[#Hierarchy + 1] = tostring(Entry)
			end
		end
	end

	if #Hierarchy == 0 then
		Hierarchy[1] = "Membro"
	end

	return Hierarchy
end

local function SeoulAdminControlBuildPermission(Permission,Data)
	local RuntimePermission = {}
	RuntimePermission[tostring(Permission)] = true

	local SourcePermission = type(Data) == "table" and Data.Permission or nil
	if type(SourcePermission) == "table" then
		for Key,Value in pairs(SourcePermission) do
			local Candidate
			if type(Key) == "string" and Value == true then
				Candidate = Key
			elseif type(Value) == "string" then
				Candidate = Value
			elseif type(Value) == "table" then
				Candidate = Value.Group or Value.Name or Value.Permission
			end

			Candidate = tostring(Candidate or ""):gsub("^%s+",""):gsub("%s+$","")
			if Candidate ~= "" and not Candidate:find("%.permissao",1,false) then
				RuntimePermission[Candidate] = true
			end
		end
	end

	return RuntimePermission
end

local function SeoulAdminControlBuildRuntimeGroup(Permission,Data)
	Data = type(Data) == "table" and Data or {}

	return {
		Permission = SeoulAdminControlBuildPermission(Permission,Data),
		Hierarchy = SeoulAdminControlBuildHierarchy(Data),
		Name = tostring(Data.Name or Data.Title or Permission),
		Service = Data.Service ~= false,
		Type = tostring(Data.Type or "Work"),
		Markers = Data.Markers or false,
		Chat = Data.Chat == true,
		Chest = Data.Chest == true,
		Domination = Data.Domination == true or Data.Kind == "gang",
		Block = Data.Block == true,
		OrgPanel = Data.OrgPanel == true,
		SecurityCam = Data.SecurityCam == true,
		Banned = Data.Banned == true,
		Salary = type(Data.Salary) == "table" and Data.Salary or nil,
		Backpack = type(Data.Backpack) == "table" and Data.Backpack or nil,
		Max = Data.Max or Data.Members or false,
		SeoulAdminControl = true,
		SeoulKind = Data.Kind or "job"
	}
end

local function SeoulAdminControlEnsureRuntimeGroup(Permission,Data)
	Permission = tostring(Permission or ""):gsub("^%s+",""):gsub("%s+$","")
	if Permission == "" then return false end

	if Groups[Permission] then
		return true
	end

	if SeoulAdminControlNativeGroups[Permission] then
		return true
	end

	if not SeoulAdminControlIsManagedData(Data) then
		local StateGroups = GlobalState and GlobalState["SeoulGroups"] or nil
		Data = type(StateGroups) == "table" and StateGroups[Permission] or nil
	end

	if not SeoulAdminControlIsManagedData(Data) then
		return false
	end

	Groups[Permission] = SeoulAdminControlBuildRuntimeGroup(Permission,Data)
	Service[Permission] = Service[Permission] or {}
	SeoulAdminControlManagedGroups[Permission] = true

	if type(Theme) == "table" then
		Theme.groups = Groups
	end

	return true
end

local function SeoulAdminControlEnsureAllRuntimeGroups()
	local StateGroups = GlobalState and GlobalState["SeoulGroups"] or nil
	if type(StateGroups) ~= "table" then return 0 end

	local Applied = 0
	for Permission,Data in pairs(StateGroups) do
		if SeoulAdminControlIsManagedData(Data) and not SeoulAdminControlNativeGroups[Permission] then
			if SeoulAdminControlEnsureRuntimeGroup(Permission,Data) then
				Applied = Applied + 1
			end
		end
	end

	return Applied
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUPS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Groups()
	SeoulAdminControlEnsureAllRuntimeGroups()
	return Groups
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL ADMINCONTROL SYNC GROUPS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.SeoulAdminControlSyncGroups(RuntimeGroups)
	if type(RuntimeGroups) ~= "table" then
		return { Added = 0, Updated = 0, Removed = 0, Skipped = 0, Error = "RuntimeGroups inválido" }
	end

	local Added,Updated,Removed,Skipped = 0,0,0,0

	for Permission in pairs(SeoulAdminControlManagedGroups) do
		if not RuntimeGroups[Permission] and not SeoulAdminControlNativeGroups[Permission] then
			Groups[Permission] = nil
			Service[Permission] = nil
			SeoulAdminControlManagedGroups[Permission] = nil
			Removed = Removed + 1
		end
	end

	for Permission,Data in pairs(RuntimeGroups) do
		if type(Permission) == "string" and Permission ~= "" and type(Data) == "table" then
			if SeoulAdminControlNativeGroups[Permission] then
				Skipped = Skipped + 1
			else
				local Exists = Groups[Permission] ~= nil
				Data.SeoulAdminControl = true
				Data.Source = Data.Source or "admincontrol"

				if SeoulAdminControlEnsureRuntimeGroup(Permission,Data) then
					if Exists then
						Updated = Updated + 1
					else
						Added = Added + 1
					end

					-- Atualiza os dados do grupo gerenciado em runtime sem sobrescrever grupos nativos.
					Groups[Permission] = SeoulAdminControlBuildRuntimeGroup(Permission,Data)
					Service[Permission] = Service[Permission] or {}
					SeoulAdminControlManagedGroups[Permission] = true
				end
			end
		end
	end

	if type(Theme) == "table" then
		Theme.groups = Groups
	end

	GlobalState["SeoulRuntimeGroupsApplied"] = {
		Added = Added,
		Updated = Updated,
		Removed = Removed,
		Skipped = Skipped,
		Managed = SeoulAdminControlManagedGroups
	}

	return { Added = Added, Updated = Updated, Removed = Removed, Skipped = Skipped }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL ADMINCONTROL GROUP SOURCES
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.SeoulAdminControlGroupSources()
	return {
		Native = SeoulAdminControlNativeGroups,
		Managed = SeoulAdminControlManagedGroups
	}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL ADMINCONTROL ENSURE GROUP
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.SeoulAdminControlEnsureGroup(Permission,Data)
	return SeoulAdminControlEnsureRuntimeGroup(Permission,Data)
end

function vRP.SeoulAdminControlEnsureAllGroups()
	return SeoulAdminControlEnsureAllRuntimeGroups()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USERDOMINATION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UserDomination(Passport)
	local Group = false

	for Index,v in pairs(Groups) do
		if v.Domination then
			if vRP.HasPermission(Passport,Index) then
				Group = Index
				break
			end
		end
	end

	return Group
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USERSALARYS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UserSalarys(Passport)
	local Valuation = 0

	for Permission,v in pairs(Groups) do
		local SalaryLevels = v.Salary
		if SalaryLevels then
			local Level = vRP.HasService(Passport,Permission)
			if Level and SalaryLevels[Level] then
				Valuation = Valuation + SalaryLevels[Level]
			end
		end
	end

	return Valuation
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USERGROUPS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UserGroups(Passport)
	SeoulAdminControlEnsureAllRuntimeGroups()
	local Table = {}
	for Permission in pairs(Groups) do
		local CheckPermission = vRP.HasPermission(Passport,Permission)
		if CheckPermission then
			Table[Permission] = CheckPermission
		end
	end

	return Table
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DATAGROUPS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.DataGroups(Permission)
	local Table = vRP.GetSrvData("Permissions:"..Permission,true)
	return Table,CountTable(Table) or 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- AMOUNTGROUPS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.AmountGroups(Permission)
	local Amount = vRP.GetSrvData("Permissions:"..Permission,true)
	return CountTable(Amount) or 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUPTYPE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GroupType(Permission)
	SeoulAdminControlEnsureRuntimeGroup(Permission)
	return Groups[Permission] and Groups[Permission].Type or "UnWorked"
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOOPPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.LoopPermission(Passport,Permission)
	if Groups[Permission] and Groups[Permission].Permission then
		for Parent in pairs(Groups[Permission].Permission) do
			if vRP.HasPermission(Passport,Parent) then
				return Parent
			end
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAINELBLOCK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.PainelBlock(Permission)
	return Groups[Permission] and Groups[Permission].Block or false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETUSERTYPE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GetUserType(Passport,Type)
	local Passport = tostring(Passport)

	for Permission,Group in pairs(Groups) do
		if Group.Type == Type then
			local Consult = vRP.GetSrvData("Permissions:"..Permission,true)
			if Consult[Passport] then
				return Permission
			end
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HIERARCHY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Hierarchy(Permission)
	SeoulAdminControlEnsureRuntimeGroup(Permission)
	return Groups[Permission] and Groups[Permission].Hierarchy or {}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NAMEHIERARCHY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.NameHierarchy(Permission,Level)
	SeoulAdminControlEnsureRuntimeGroup(Permission)
	return Groups[Permission] and Groups[Permission].Hierarchy and Groups[Permission].Hierarchy[Level] or Permission
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NUMPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.NumPermission(Permission)
	local Table = {}
	if Groups[Permission] and Groups[Permission].Permission then
		for Parent in pairs(Groups[Permission].Permission) do
			if Service[Parent] then
				for Passport,source in pairs(Service[Parent]) do
					if source and Characters[source] and not Table[Passport] then
						Table[Passport] = source
					end
				end
			end
		end
	end

	return Table,CountTable(Table) or 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NUMGROUPS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.NumGroups(Permission)
	local Table = {}

	local GroupPermission = Groups[Permission]
	if not (GroupPermission and GroupPermission.Permission) then
		return Table
	end

	for Parent in pairs(GroupPermission.Permission) do
		local GroupParent = Groups[Parent]
		local Players = vRP.DataGroups(Parent)
		if GroupParent and Players then
			for Passport,Level in pairs(Players) do
				if not Table[Passport] then
					Table[Passport] = { Level = Level, Permission = Parent }
				end
			end
		end
	end

	return Table
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- AMOUNTSERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.AmountService(Permission,Level)
	local PermissionParts = splitString(Permission,"-")
	if PermissionParts[2] then
		Permission,Level = PermissionParts[1],parseInt(PermissionParts[2])
	end

	local Table = {}
	if Groups[Permission] and Groups[Permission].Permission then
		for Parent in pairs(Groups[Permission].Permission) do
			if Service[Parent] then
				for Passport,source in pairs(Service[Parent]) do
					if source and Characters[source] and not Table[Passport] and (not Level or (Level and Level == vRP.HasPermission(Passport,Parent))) then
						Table[Passport] = true
					end
				end
			end
		end
	end

	return CountTable(Table) or 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVICETOGGLE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.ServiceToggle(source,Passport,Permission,Silenced)
	if not Characters[source] then
		return false
	end

	if Groups[Permission] then
		local Passport = tostring(Passport)
		local Permission = SplitOne(Permission)
		if Service[Permission] and Service[Permission][Passport] then
			vRP.ServiceLeave(source,Passport,Permission,Silenced)
		elseif vRP.HasPermission(Passport,Permission) then
			vRP.ServiceEnter(source,Passport,Permission,Silenced)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVICEENTER
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.ServiceEnter(source,Passport,Permission,Silenced)
	if not source or not Passport or not Permission or not Characters[source] or not Groups[Permission] then
		return false
	end

	local CurrentTimer = os.time()
	local Passport = tostring(Passport)
	local Level = vRP.HasPermission(Passport,Permission)

	if not Playing[Permission] then
		Playing[Permission] = {}
	end

	Playing[Permission][Passport] = Playing[Permission][Passport] or CurrentTimer

	Player(source).state[Permission] = Level

	if Groups[Permission].Markers then
		exports.markers:Enter(source,Permission,Level)
	end

	if Service[Permission] then
		Service[Permission][Passport] = source
		TriggerClientEvent("service:Client",source,Permission,true)
	end

	if not Silenced then
		TriggerClientEvent("Notify",source,"Central de Empregos","Você acaba de dar inicio a sua jornada de trabalho, lembrando que a sua vida não se resume só a isso.","default",5000)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVICELEAVE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.ServiceLeave(source,Passport,Permission,Silenced)
	if not Characters[source] or not Groups[Permission] then
		return false
	end

	local CurrentTimer = os.time()
	local Passport = tostring(Passport)

	if not Playing[Permission] then
		Playing[Permission] = {}
	end

	if Playing[Permission][Passport] then
		local Consult = vRP.GetSrvData("Playing:"..Passport,true)
		Consult[Permission] = (Consult[Permission] or 0) + (CurrentTimer - Playing[Permission][Passport])
		vRP.SetSrvData("Playing:"..Passport,Consult,true)

		Playing[Permission][Passport] = nil
	end

	Player(source).state[Permission] = nil

	if Groups[Permission].Markers then
		exports.markers:Exit(source,Passport)
		TriggerClientEvent("radio:RadioClean",source)
	end

	if Service[Permission] and Service[Permission][Passport] then
		TriggerClientEvent("service:Client",source,Permission,false)
		Service[Permission][Passport] = nil
	end

	if not Silenced then
		TriggerClientEvent("Notify",source,"Central de Empregos","Você acaba finalizar sua jornada de trabalho, esperamos que você tenha aprendido bastante hoje.","default",5000)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.SetPermission(Passport,Permission,Level,Mode)
	SeoulAdminControlEnsureRuntimeGroup(Permission)
	if Groups[Permission] then
		local Passport = tostring(Passport)
		local Consult = vRP.GetSrvData("Permissions:"..Permission,true)
		local Hierarchy = Groups[Permission].Hierarchy and CountTable(Groups[Permission].Hierarchy) or 1

		if Mode then
			local Adjustment = (Mode == "Demote") and 1 or -1
			Consult[Passport] = math.min(math.max((Consult[Passport] or 1) + Adjustment,1),Hierarchy)
		else
			Consult[Passport] = Level and math.min(parseInt(Level),Hierarchy) or Hierarchy
		end

		vRP.ServiceEnter(vRP.Source(Passport),Passport,Permission,true)
		vRP.SetSrvData("Permissions:"..Permission,Consult,true)
		TriggerEvent("Seoul:PermissionsChanged",Passport,Permission)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.RemovePermission(Passport,Permission)
	SeoulAdminControlEnsureRuntimeGroup(Permission)
	if Groups[Permission] then
		local Passport = tostring(Passport)
		if Service[Permission] and Service[Permission][Passport] then
			Service[Permission][Passport] = nil
		end

		local Consult = vRP.GetSrvData("Permissions:"..Permission,true)
		if Consult[Passport] then
			local source = vRP.Source(Passport)

			Consult[Passport] = nil
			vRP.ServiceLeave(source,Passport,Permission,true)
			vRP.SetSrvData("Permissions:"..Permission,Consult,true)
			TriggerEvent("Seoul:PermissionsChanged",Passport,Permission)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HASPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.HasPermission(Passport,Permission,Level)
	SeoulAdminControlEnsureRuntimeGroup(Permission)
	local PermissionParts = splitString(Permission,"-")
	if PermissionParts[2] then
		Permission,Level = PermissionParts[1],parseInt(PermissionParts[2])
	end

	if not Groups[Permission] then
		return false
	end

	local Passport = tostring(Passport)
	local Consult = vRP.GetSrvData("Permissions:"..Permission,true)
	local CurrentLevel = Consult[Passport]

	return (CurrentLevel and (not Level or CurrentLevel <= Level)) and CurrentLevel or false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HASTABLE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.HasTable(Passport,Table)
	local Passport = tostring(Passport)

	for _,Permission in ipairs(Table) do
		local Check = splitString(Permission)
		local PermissionName,LevelParented = Check[1],Check[2] and parseInt(Check[2]) or nil
		local Consult = vRP.GetSrvData("Permissions:"..PermissionName,true)
		local CurrentLevel = Consult[Passport]

		if CurrentLevel and (not LevelParented or CurrentLevel <= LevelParented) then
			return Permission
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HASGROUP
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.HasGroup(Passport,Permission,Level)
	if not Passport or not Permission then
		return false
	end

	local PermissionParts = splitString(Permission)
	if PermissionParts[2] then
		Permission,Level = PermissionParts[1],parseInt(PermissionParts[2])
	end

	if Groups[Permission] and Groups[Permission].Permission then
		local Passport = tostring(Passport)
		for Parent in pairs(Groups[Permission].Permission) do
			local ParentParts = splitString(Parent)
			local ParentPermission,ParentLevel = ParentParts[1],ParentParts[2] and parseInt(ParentParts[2]) or nil
			local Consult = vRP.GetSrvData("Permissions:"..ParentPermission,true)
			local CurrentLevel = Consult[Passport]

			if CurrentLevel and ((not Level and not ParentLevel) or (not Level and ParentLevel and CurrentLevel == ParentLevel) or (Level and CurrentLevel <= Level)) then
				return CurrentLevel
			end
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HASSERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.HasService(Passport,Permission,Level)
	local PermissionParts = splitString(Permission)
	if PermissionParts[2] then
		Permission,Level = PermissionParts[1],parseInt(PermissionParts[2])
	end

	if Groups[Permission] and Groups[Permission].Permission then
		local Passport = tostring(Passport)
		for Parent in pairs(Groups[Permission].Permission) do
			local ParentParts = splitString(Parent)
			local ParentPermission,ParentLevel = ParentParts[1],ParentParts[2] and parseInt(ParentParts[2]) or nil
			local Consult = vRP.GetSrvData("Permissions:"..ParentPermission,true)
			local CurrentLevel = Consult[Passport]

			if CurrentLevel and Groups[ParentPermission] and Service[ParentPermission] and Service[ParentPermission][Passport] then
				if (not Level and not ParentLevel) or (not Level and ParentLevel and CurrentLevel == ParentLevel) or (Level and CurrentLevel <= Level) then
					return CurrentLevel
				end
			end
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYING
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Playing(Passport,Permission)
	local CurrentTimer = os.time()
	local Passport = tostring(Passport)
	local Consult = vRP.GetSrvData("Playing:"..Passport)
	local Return = Consult[Permission] or 0

	if Playing[Permission] and Playing[Permission][Passport] then
		Return = Return + (CurrentTimer - Playing[Permission][Passport])
	end

	return Return
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect",function(Passport,source,First)
	local Passport = tostring(Passport)
	for Permission,v in pairs(Groups) do
		if v.Service and vRP.HasPermission(Passport,Permission) and Service[Permission] and (Service[Permission][Passport] == false or (First and Service[Permission][Passport] == nil)) then
			vRP.ServiceEnter(source,Passport,Permission,true)
		end
	end

	Playing.Online[Passport] = Playing.Online[Passport] or os.time()

	local Prison = vRP.Identity(Passport).Prison
	if Prison >= 1 then
		TriggerClientEvent("prison:Prisioner",source,true)

		TriggerClientEvent("Notify",source,"Penitenciária de Bolingbroke","Você ainda precisa realizar <b>"..Dotted(Prison).." Serviços</b>.","policia",10000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport,source)
	local CurrentTimer = os.time()
	local Passport = tostring(Passport)
	local Consult = vRP.GetSrvData("Playing:"..Passport,true)

	for Permission,v in pairs(Groups) do
		if Playing[Permission] and Playing[Permission][Passport] then
			Consult[Permission] = (Consult[Permission] or 0) + (CurrentTimer - Playing[Permission][Passport])
			Playing[Permission][Passport] = nil
		end

		if Service[Permission] and Service[Permission][Passport] then
			Service[Permission][Passport] = false
		end
	end

	if Playing.Online[Passport] then
		Consult.Online = (Consult.Online or 0) + (CurrentTimer - Playing.Online[Passport])
		Playing.Online[Passport] = nil
	end

	vRP.SetSrvData("Playing:"..Passport,Consult,true)
end)
