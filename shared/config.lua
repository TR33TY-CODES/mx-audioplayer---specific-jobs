Config = {}

Config.Debug = true
Config.Locale = 'de' -- 'en', 'fr', 'de', 'bg', 'es', 'it', 'ltu', 'cn'

Config.Radio = {}
Config.Radio.Enable = true
Config.Radio.DisableDefaultRadio = true -- Set to false if you want to use the default radio stations
Config.Radio.RadioKey = 'N'             -- Default key to open the radio (You can set false if you don't want a key)

Config.Boombox = {}
Config.Boombox.Enable = true
Config.Boombox.Item = 'boombox' -- Set false if you don't want item.
Config.Boombox.Target = true    -- Uses qtarget. But if you are using ox_target it'll provide this.

-- Close commands you do not want to use by setting false. Ex: Config.Boombox.CreateBoomboxCommand = false
Config.Boombox.CreateBoomboxCommand = 'bx-create'
Config.Boombox.PickupBoomboxCommand = 'bx-pickup'
Config.Boombox.DropBoomboxCommand = 'bx-drop'
Config.Boombox.DestroyBoomboxCommand = 'bx-destroy'
Config.Boombox.AccessBoomboxCommand = 'bx'

Config.DJ = {}
Config.DJ.Enable = true
Config.DJ.Target = true -- Uses qb-target. Can be modified for ox_target
Config.DJ.Locations = {
    {
        id = 'Pitstop', 
        coords = vector3(950.01, -1556.05, 30.79),
        allowedJobs = { 'udgc' }, -- Nur Polizei kann diese DJ-Station benutzen
        panner = {
            panningModel = 'HRTF',
            refDistance = 15.0,
            rolloffFactor = 1.8,
            distanceModel = 'exponential',
        }
    },
    {
        id = 'BeachClub',
        coords = vector3(944.84, -1565.45, 30.79),
        allowedJobs = { 'ambulance', 'police' }, -- Diese DJ-Station ist nur für Rettungsdienste und UDGC zugänglich
        panner = {
            panningModel = 'HRTF',
            refDistance = 20.0,
            rolloffFactor = 2.0,
            distanceModel = 'linear',
        }
    }
}


local function getFramework()
    local esxHas = GetResourceState('es_extended') == 'started'
    local qbHas = GetResourceState('qb-core') == 'started'
    if esxHas then
        return 'esx'
    elseif qbHas then
        return 'qb'
    end
    return 'standalone'
end

Config.Framework = getFramework()

if Config.Framework == 'standalone' then
    Config.DJ.Jobs = false
    print('DJ is enabled but no framework found. DJ is now available for everyone.')
end

local function checkHasTarget()
    local hasTarget = GetResourceState('qtarget') == 'started' or GetResourceState('ox_target') == 'started'
    if not hasTarget then
        Config.Boombox.Target = false
        Config.DJ.Target = false
        print('No target resource found. Boombox and DJ will not use target.')
    end
end

if Config.Boombox.Target or Config.DJ.Target then
    checkHasTarget()
end
