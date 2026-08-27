Config = {}

Config.AdminPermission = 'Admin'
Config.Debug = false
Config.TargetDistance = 2.2
Config.WorkerInteractDistance = 3.0
Config.SessionExpireSeconds = 180
Config.ServiceDurationMs = 12000
Config.BusinessShare = 0.75
Config.MoneyAccount = 'bank' -- 'bank' = PaymentBank | 'full' = PaymentFull
Config.MaxBrothels = 50
Config.MaxRoomsPerBrothel = 20
Config.MaxWorkersPerBrothel = 20
Config.MaxManagersPerBrothel = 10
Config.MaxTransactionAmount = 10000000

Config.WorkerModels = {
    's_f_y_hooker_01',
    's_f_y_hooker_02',
    's_f_y_hooker_03',
    'a_f_y_business_04',
    'a_f_y_bevhills_04'
}

Config.Services = {
    private = {
        label = 'Atendimento privado',
        defaultPrice = 500,
        minPrice = 1,
        maxPrice = 100000
    },
    premium = {
        label = 'Atendimento premium',
        defaultPrice = 1000,
        minPrice = 1,
        maxPrice = 100000
    }
}


Config.Street = {
    Enabled = true,
    MaxDistance = 7.5,
    MaxVehicleSpeed = 0.2,
    MaxServices = 3,
    SearchIntervalMs = 750,
    SecludedRadius = 35.0,
    SecludedTimeoutMs = 120000,
    Prices = {
        private = 250,
        premium = 500
    },
    HookerModelNames = {
        's_f_y_hooker_01',
        's_f_y_hooker_02',
        's_f_y_hooker_03'
    },
    BlacklistedVehicleClasses = {
        [8]=true,[13]=true,[14]=true,[15]=true,[16]=true,[18]=true,[19]=true,[21]=true,[22]=true
    }
}
