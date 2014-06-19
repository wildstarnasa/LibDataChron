LibDataChron
============

LibDataChron is a Wildstar implementation of LibDataBroker
This relies on Carbine Events

For the moment rough docs can be found at the original github site: [LibDataBroker](https://github.com/tekkub/libdatabroker-1-1)

Event names and arguments are:

`
LibDataChron_DataObjectCreated
* name
* dataobj

LibDataChron_AttributeChanged
* name
* attr
* value
* dataobj

LibDataChron_AttributeChanged_<name>
* name
* attr
* value
* dataobj

LibDataChron_AttributeChanged_<name>_<key>
* name
* attr
* value
* dataobj

LibDataChron_AttributeChanged__<key>
* name
* attr
* value
* dataobj
`

```lua
local ldc = Apollo.GetPackage("Lib:DataChron-1.0").tPackage

-- do stuff with ldc
```
