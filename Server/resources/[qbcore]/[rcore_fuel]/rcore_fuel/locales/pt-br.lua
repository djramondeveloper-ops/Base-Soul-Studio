--[[
========================================================================================
 ██████╗ ██╗     ███████╗ █████╗ ███╗   ██╗███████╗██████╗ 
██╔════╝ ██║     ██╔════╝██╔══██╗████╗  ██║██╔════╝██╔══██╗
██║      ██║     █████╗  ███████║██╔██╗ ██║█████╗  ██║  ██║
██║      ██║     ██╔══╝  ██╔══██║██║╚██╗██║██╔══╝  ██║  ██║
╚██████╗ ███████╗███████╗██║  ██║██║ ╚████║███████╗██████╔╝
 ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═════╝ 

                 ██████╗ ██╗   ██╗
                 ██╔══██╗╚██╗ ██╔╝
                 ██████╔╝ ╚████╔╝ 
                 ██╔══██╗  ╚██╔╝  
                 ██████╔╝   ██║   
                 ╚═════╝    ╚═╝   

██╗  ██╗ █████╗ ███████╗██╗███╗   ███╗
██║  ██║██╔══██╗╚══███╔╝██║████╗ ████║
███████║███████║  ███╔╝ ██║██╔████╔██║
██╔══██║██╔══██║ ███╔╝  ██║██║╚██╔╝██║
██║  ██║██║  ██║███████╗██║██║ ╚═╝ ██║
╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝╚═╝     ╚═╝

██╗  ██╗███████╗██████╗ ██████╗ ███████╗██████╗  █████╗ 
██║  ██║██╔════╝██╔══██╗██╔══██╗██╔════╝██╔══██╗██╔══██╗
███████║█████╗  ██████╔╝██████╔╝█████╗  ██████╔╝███████║
██╔══██║██╔══╝  ██╔══██╗██╔══██╗██╔══╝  ██╔══██╗██╔══██║
██║  ██║███████╗██║  ██║██║  ██║███████╗██║  ██║██║  ██║
╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝
========================================================================================
--]]

Locales["pt-br"] = {
    -- price note: this isnt the only place for this currency there are more in the locales that contians "$"
    ["currency"] = "$%s",

    ["not_enough_money_for_fuel"] = "Não adianta usar... Eu não tenho dinheiro suficiente mesmo.",

    -- shop
    ["shop_primary_title"] = "Loja de equipamentos para veículos",
    ["buy_item"] = "Comprar item com",
    ["decline_buy"] = "Não tenho interesse",
    ["cant_carry_item"] = "Você não consegue carregar este item!",
    ["item_bought"] = "Item comprado",

    -- taxi
    ["taxi_primary"] = "Táxi",
    ["taxi_second"] = "Você precisa de um motorista?",

    ["accept_taxi"] = "Sim, preciso de um táxi!",
    ["decline_taxi"] = "Vou a pé.",

    -- target
    ["target_pump_label"] = "Interagir com o bico de combustível",
    ["target_pump_icon"] = "fas fa-gas-pump",
    ["target_pump_targeticon"] = "fas fa-gas-pump",

    ["target_pickup_barrel_label"] = "Interagir com o barril",
    ["target_pickup_barrel_icon"] = "fas fa-tint",
    ["target_pickup_barrel_targeticon"] = "fas fa-tint",

    ["target_process_label"] = "Interagir com o cano",
    ["target_process_icon"] = "fas fa-wrench",
    ["target_process_targeticon"] = "fas fa-wrench",

    ["target_store_label"] = "Guardar o barril",
    ["target_store_icon"] = "fas fa-tint",
    ["target_store_targeticon"] = "fas fa-tint",

    -- player job
    ["did_not_pick_wrong_fuel"] = "Este veículo está com o combustível correto. Nenhuma ação é necessária!",
    ["select_vehicle"] = "Olhe para o veículo até ele ficar destacado e selecione pressionando ~INPUT_ATTACK~, ou saia do seletor pressionando ~INPUT_FRONTEND_RRIGHT~",
    ["wrong_fuel_failure"] = "Hmm? Que cheiro é esse? Ah não... Coloquei o tipo errado de combustível no meu veículo... Preciso de uma bomba de extração ou chamar um mecânico para retirar o combustível...",
    ["pumping_out"] = "Retirando o combustível [💧]",
    ["there_is_generator"] = "Já existe um gerador instalado!",

    -- company
    ["maximum_fuel_price"] = "O preço máximo para este tipo de combustível é: $%s!",

    ["company_price"] = "$%s",

    ["bought_property_title"] = "Propriedade comprada!",
    ["bought_property_desc"] = "Posto de combustível em %s",

    ["bought_property_title_no_money"] = "Você não tem dinheiro suficiente",

    ["your_company_blip"] = "Sua empresa",
    ["for_sale_company_blip"] = "Posto de combustível à venda",

    -- fuel pump notif
    ["vehicle_is_full"] = "O tanque deste veículo já está cheio!",

    ["take_gun"] = "Pressione ~INPUT_PICKUP~ para pegar o bico de combustível",
    ["put_away_gun"] = "Pressione ~INPUT_PICKUP~ para guardar o bico de combustível",
    ["select_car"] = "Ótimo! Agora olhe para o veículo que deseja abastecer até ele ficar destacado e pressione ~INPUT_ATTACK~\nUse ~INPUT_COVER~ para trocar o tipo de combustível!",
    ["wrong_fuel_type_car"] = "O veículo que você está tentando abastecer usa %s, mas esta bomba fornece %s. Usar o combustível errado pode danificar o veículo.",
    ["wrong_fuel_type_engine"] = "Este veículo não aceita esse combustível; ele requer %s, não %s",


    ["how_to_stop"] = "Você pode parar o abastecimento pressionando ~INPUT_ATTACK~",
    ["pump_doesnt_have_any_fuel"] = "Esta bomba está sem combustível!",

    ["closed"] = "O posto de combustível está fechado",
    ["empty"] = "Sem", -- the result will be "out of gasoline" / "out of diesel" etc.
    ["cannot_refuel_from_jerrycan"] = "Você não pode abastecer este veículo com um galão!",
    ["jerry_can_empty"] = "Seu galão está vazio!",
    ["jerrycan_guide"] = "Aproxime-se de um veículo até ele ficar destacado em branco e pressione ~INPUT_PICKUP~ para começar a abastecer",

    -- just for now if player is too far away it will show subtitle
    ["fueling_noscaleform"] = "Combustível: %0.f%% <br>Custo: %0.f$",

    -- buy company menu
    ["buy_company_main_title_menu"] = "À venda!",
    ["buy_company_title_menu"] = "Esta empresa custa $%s",

    ["buy_company"] = "Quero comprar!",
    ["decline_buying_company"] = "Preciso de um tempo para pensar.",

    ["money_management"] = "Gerenciar dinheiro",

    ["cant_buy_his_own"] = "Você já é dono deste posto. Não pode comprá-lo!",

    -- money management menu
    ["money_management_title"] = "Dinheiro da empresa",
    ["money_management_second_title"] = "Saldo: $%s",

    ["withdraw"] = "Sacar dinheiro",
    ["deposit"] = "Depositar dinheiro",

    -- company menu
    ["not_enough_money_in_company"] = "Sua empresa não tem saldo suficiente para esta ação!",
    ["player_lack_funds_deposit"] = "Você não tem dinheiro suficiente para depositar esse valor!",

    ["final_payment"] = "Comprar para o estoque",
    ["final_payment_second_title"] = "Vai custar: $%s | %s",

    ["select_payment_method"] = "Escolha a forma de pagamento",

    ["fuel_prices"] = "Preço por tipo de combustível",
    ["mission_task"] = "Tarefas de missão de combustível",

    ["company_menu_primaty_title"] = "Menu da empresa",
    ["company_menu_title"] = "Menu da sua empresa",

    ["sell_company"] = "Colocar esta empresa à venda",
    ["open/close_shop"] = "Estamos abertos?",

    ["price_fuel"] = "Definir novo preço do combustível",
    ["refuel_tankers"] = "Solicitar reabastecimento dos tanques",
    ["cancel_mission"] = "Cancelar missão",

    ["mission"] = "Missão",
    ["cancel_mission_text"] = "Deseja cancelar a missão?",
    ["mission_canceled_by_owner"] = "A missão foi cancelada pelo proprietário.",

    ["company_player_list"] = "Selecione o funcionário para este trabalho",

    ["current_gas_price_input"] = "Novo preço do combustível: %s",

    ["previous_price_of_station"] = "O preço atual deste posto é: %s$",

    ["company_fuel_type_title"] = "Combustível da empresa",
    ["company_fuel_type_subtitle"] = "Selecione o combustível que deseja comprar",

    ["gas_station_open"] = "O posto está aberto",
    ["gas_station_close"] = "Você fechou o posto",

    ["gas_station_selling"] = "Você colocou sua empresa à venda.",
    ["gas_station_selling_canceled"] = "Você retirou sua empresa da venda.",

    ["choose_how_much_fuel"] = "Selecione a quantidade que deseja comprar",
    ["capacity_fuel_full"] = "Você não pode comprar mais combustível; os tanques da empresa estão cheios!",

    ["employee_item"] = "Permitir abastecimento apenas por funcionários?",

    ["employee_item_open"] = "Agora somente funcionários deste posto podem abastecer veículos",
    ["employee_item_close"] = "Agora qualquer pessoa pode abastecer o próprio veículo",

    ["must_find_employee"] = "A política deste posto exige que um funcionário abasteça seu veículo. Procure um funcionário.",

    ["boss_action"] = "Ações do chefe",
    ["boss_menu"] = "Abrir menu do chefe",

    ["wrong_price"] = "O preço da empresa deve ficar entre ~g~$%s ~w~e ~g~$%s!",
    -- fuel mission

    -- keep it mind there is a hard limit on how many chars the default GTA notification can display. I already had to shorten this to fit.
    ["tiptruck_area_not_clear"] = "Há algo bloqueando a área do veículo da missão. Libere o local primeiro! (marcado no mapa)",

    ["take_card"] = "Pressione ~INPUT_PICKUP~ para pegar o cartão de ponto",
    ["return_card"] = "Pressione ~INPUT_PICKUP~ para devolver o cartão de ponto",

    ["equip_clothes"] = "Pressione ~INPUT_PICKUP~ para vestir o uniforme de trabalho",
    ["back_to_civil_clothes"] = "Pressione ~INPUT_PICKUP~ para voltar à roupa civil.",

    ["wrong_barrel"] = "Este barril já está cheio. Leve-o até o caminhão e guarde-o!",

    ["money_refunded"] = "O jogador que aceitou sua missão cancelou o contrato. Reembolsamos %s$.",

    ["mission_canceled"] = "A missão foi cancelada!",
    ["not_in_mission"] = "Você não está em nenhuma missão!",
    ["mission_successfull"] = "Missão concluída! Você reabasteceu o posto com sucesso!",

    ["call_taxi"] = "Pressione ~INPUT_PICKUP~ para chamar um táxi!",

    ["place_barrel"] = "Pressione ~INPUT_PICKUP~ para encher este barril!",
    ["store_barrel"] = "Pressione ~INPUT_PICKUP~ para guardar este barril!",
    ["missing_barrel"] = "Está faltando um barril! Vá buscar um!",

    ["barrel_not_processed"] = "Você não pode carregar este barril no caminhão! Ele ainda não foi processado.",
    ["barrel_wait"] = "Ainda não está pronto, aguarde!",
    ["barrel_done"] = "O barril está pronto. Pressione ~INPUT_PICKUP~ para pegá-lo",
    ["barrel_done_interaction"] = "O barril está pronto. Use o menu de interação para pegá-lo!",

    ["put_barrel_into_truck"] = "Pressione ~INPUT_PICKUP~ para colocar o barril no caminhão",
    ["take_barrel_from_truck"] = "Pressione ~INPUT_PICKUP~ para retirar o barril do caminhão",

    ["lacking_funds"] = "Você ou sua empresa não têm dinheiro suficiente para abastecer! São necessários ~g~$%s~w~!",

    ["processing_oil"] = "Preparando barril de petróleo [🛢️]",
    ["final_pumping"] = "Transferindo combustível [🔋]️",

    ["3d_text_completed"] = "CONCLUÍDO",

    ["fuel_mission_primary_title_menu"] = "Trabalho de missão!",
    ["fuel_mission_title_menu"] = "O empresário '%s' está pedindo uma entrega de combustível. Deseja aceitar?",
    ["select_item"] = "Selecionar item",

    ["entrance_oil_fac"] = "Esta é a entrada da instalação onde você processará o petróleo",
    ["equip_clothes_tut"] = "Aqui você veste o uniforme de trabalho para trabalhar com segurança!",
    ["pick_up_oil_barrel"] = "Aqui você pega um barril vazio e o enche",
    ["fill_barrel_here"] = "Encha o barril com petróleo aqui",
    ["then_take_the_barrel"] = "Depois de encher o barril, leve-o de volta ao caminhão e repita quando necessário",

    ["pick_barrel"] = "Pressione ~INPUT_PICKUP~ para pegar",

    ["talk_to_npc"] = "Fale com esta pessoa para obter um caminhão Phantom",

    ["all_barrel_pickup"] = "Você coletou todos os barris. Vá para o próximo ponto marcado no mapa!",
    ["all_barrel_stored"] = "Você guardou todos os barris. Vá para o próximo ponto marcado no mapa!",

    ["what_to_do_in_drop_out_barrels"] = "Retire os barris do caminhão e guarde-os junto aos outros barris deste local",
    ["phantom_nozzle_info"] = "Pressione ~INPUT_PICKUP~ para conectar/desconectar o bico",

    ["drop_barrel_info"] = "Ótimo, agora leve este barril até a bomba! Você também pode soltá-lo com ~INPUT_VEH_DUCK~, mas perderá o barril para sempre!",

    ["press_to_speak_with_npc"] = "Pressione ~INPUT_PICKUP~ para falar com o NPC",
    ["go_store_phantom"] = "Ótimo! Agora guarde o caminhão para concluir!",

    ["fuel_bought_company"] = "Você comprou o combustível.",
    ["maximum_owned_companies"] = "Você pode possuir no máximo ~r~[%s]~w~ empresas de combustível ao mesmo tempo!",
    -- other
    ["interact_key"] = "Pressione ~INPUT_PICKUP~ para interagir",

    ["accept_task"] = "Aceitar tarefa",
    ["decline_task"] = "Recusar tarefa",

    ["cash"] = "Dinheiro",
    ["bank"] = "Banco",
    ["society"] = "Empresa",

    ["y"] = "Sim",
    ["n"] = "Não",

    -- type fuel for check
    ["manual_guide"] = "Olhe para o veículo cujo tipo de combustível deseja verificar e pressione ~INPUT_ATTACK~",
    ["manual_reading"] = "Lendo o manual...",


    -- UI translation ( The editor is not planned to added in locales )

    ["close_button"] = "Fechar",
    ["truck_hose_title"] = "Como conectar a mangueira do caminhão ao tanque",

    ["truck_hose_part_1"] = "1. Vá até a traseira do caminhão, no lado direito, e pressione \"E\" para pegar a mangueira.",
    ["truck_hose_part_2"] = "2. Conecte-a à entrada ligada ao tanque de combustível.",
    ["truck_hose_part_3"] = "Aguarde o progresso chegar a 100%% e depois faça os passos na ordem inversa.",

    -- fuel label names
    [FuelType.NATURAL] = "Gasoline",
    [FuelType.DIESEL] = "Diesel",
    [FuelType.EV] = "EV",
    [FuelType.LPG] = "LPG",
    [FuelType.CNG] = "CNG",
    [FuelType.MILK] = "Milk",
    [FuelType.AVIATION] = "Aviation fuel",

    [FuelType.NATURAL .. "_check"] = "This vehicle runs only on gasoline",
    [FuelType.DIESEL .. "_check"] = "This vehicle runs only on diesel",
    [FuelType.EV .. "_check"] = "This vehicle is electric",
    [FuelType.LPG .. "_check"] = "This vehicle runs only on LPG",
    [FuelType.CNG .. "_check"] = "This vehicle runs only on CNG",
    [FuelType.AVIATION .. "_check"] = "This vehicle runs only on aviation fuel",
    [FuelType.MILK .. "_check"] = "What... this vehicle runs on milk???",

    ["liter_unit"] = "L",
    [FuelType.NATURAL .. "_unit"] = "L",
    [FuelType.DIESEL .. "_unit"] = "L",
    [FuelType.EV .. "_unit"] = "kWh",
    [FuelType.LPG .. "_unit"] = "L",
    [FuelType.CNG .. "_unit"] = "kg",
    [FuelType.MILK .. "_unit"] = "L",
    [FuelType.AVIATION .. "_unit"] = "L",
}

