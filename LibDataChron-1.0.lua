local MAJOR,MINOR = "Lib:DataChron-1.0", 1
-- Get a reference to the package information if any
local APkg = Apollo.GetPackage(MAJOR)
-- If there was an older version loaded we need to see if this is newer
if APkg and (APkg.nVersion or 0) >= MINOR then
	return -- no upgrade needed
end
-- Set a reference to the actual package or create an empty table
local Lib = APkg and APkg.tPackage or {}

Lib.AttributeStorage, Lib.NameStorage, Lib.ProxyStorage = Lib.AttributeStorage or {}, Lib.NameStorage or {}, Lib.ProxyStorage or {}
local AttributeStorage, NameStorage = Lib.AttributeStorage, Lib.NameStorage

Lib.domt = {
	__metatable = "access denied",
	__index = function(self, key) return AttributeStorage[self] and AttributeStorage[self][key] end,
}

Lib.domt.__newindex = function(self, key, value)
	if not AttributeStorage[self] then AttributeStorage[self] = {} end
	if AttributeStorage[self][key] == value then return end
	AttributeStorage[self][key] = value
	local name = NameStorage[self]
	if not name then return end
	Event_FireGenericEvent("LibDataChron_AttributeChanged", name, key, value, self)
	Event_FireGenericEvent("LibDataChron_AttributeChanged_"..name, name, key, value, self)
	Event_FireGenericEvent("LibDataChron_AttributeChanged_"..name.."_"..key, name, key, value, self)
	Event_FireGenericEvent("LibDataChron_AttributeChanged__"..key, name, key, value, self)
end

function Lib:NewDataObject(name, dataobj)
	if self.ProxyStorage[name] then return end

	if dataobj then
		assert(type(dataobj) == "table", "Invalid dataobj, must be nil or a table")
		self.AttributeStorage[dataobj] = {}
		for i,v in pairs(dataobj) do
			self.AttributeStorage[dataobj][i] = v
			dataobj[i] = nil
		end
	end
	dataobj = setmetatable(dataobj or {}, self.domt)
	self.ProxyStorage[name], self.NameStorage[dataobj] = dataobj, name
	Event_FireGenericEvent("LibDataChron_DataObjectCreated", name, dataobj)
	return dataobj
end

function Lib:DataObjectIterator()
	return pairs(self.ProxyStorage)
end

function Lib:GetDataObjectByName(dataobjectname)
	return self.ProxyStorage[dataobjectname]
end

function Lib:GetNameByDataObject(dataobject)
	return self.NameStorage[dataobject]
end

local next = pairs(AttributeStorage)
function Lib:pairs(dataobject_or_name)
	local t = type(dataobject_or_name)
	assert(t == "string" or t == "table", "Usage: ldc:pairs('dataobjectname') or ldc:pairs(dataobject)")

	local dataobj = self.ProxyStorage[dataobject_or_name] or dataobject_or_name
	assert(AttributeStorage[dataobj], "Data object not found")

	return next, AttributeStorage[dataobj], nil
end

local ipairs_iter = ipairs(AttributeStorage)
function Lib:ipairs(dataobject_or_name)
	local t = type(dataobject_or_name)
	assert(t == "string" or t == "table", "Usage: ldc:ipairs('dataobjectname') or ldc:ipairs(dataobject)")

	local dataobj = self.ProxyStorage[dataobject_or_name] or dataobject_or_name
	assert(AttributeStorage[dataobj], "Data object not found")

	return ipairs_iter, AttributeStorage[dataobj], 0
end

function Lib:OnDependencyError(strDep, strError)
	return false
end

function Lib:OnLoad() end

Apollo.RegisterPackage(Lib, MAJOR, MINOR, {})
