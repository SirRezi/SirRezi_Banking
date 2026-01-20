Config = {}

Config.Debug = false

Config.Banks = {
    {
        name = "Fleeca Bank",
        coords = vec3(149.4713, -1042.1696, 28.368),
        heading = 340.0,
        blip = {
            sprite = 108,
            color = 2,
            scale = 0.8,
            name = "Bank"
        },
        ped = {
            model = 's_m_m_security_01',
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        }
    }
}

Config.ATMModels = {
    'prop_atm_01',
    'prop_atm_02',
    'prop_atm_03',
    'prop_fleeca_atm'
}

Config.UI = {
    primaryColor = '#6366f1',
    fontFamily = 'Inter, sans-serif'
}
