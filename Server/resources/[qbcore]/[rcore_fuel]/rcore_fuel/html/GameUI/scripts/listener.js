// This script was leaked inside at TCHub Website so check that out https://tchub.st/dashboard

var App = new Vue({
	el: '#app',
	data:
	{
	   translation: [],
       receipt: {visible: false, total: 0, liters: 0, unit: 'L', status: ''},
       payment: {open: false, pending: false, cash: false, bank: false},
 	},
    methods: {
        formatAmount(value) { return (Number(value) || 0).toFixed(2); }
    },
});

function Close(){
    $("#textboard").modal("hide");
    $("#tutorial_gas_tube").modal("hide");
    $("#dispenserSettings").modal("hide");
    $("#shopSettings").modal("hide");
    $.post('https://rcore_fuel/exit');
}

function InsertShopData(){
    $.post('https://rcore_fuel/insertShop', JSON.stringify({
        identifier: $(".shopIdentifier").val(),
        blipSprite: $(".blipSprite").val(),
        blipName: $(".blipLabel").val(),
        enableSociety: $(".societyEnabled").prop("checked"),
        societyName: $(".societyName").val(),
        jobName: $(".jobName").val(),
        employeesOnly: $(".employeesOnly").prop("checked"),
        maxTanker: $(".maxTanker").val(),
        shopCost: $(".shopCost").val(),
        enableBlip: $(".enableBlip").prop("checked"),
    }));
    Close();
}

function InsertDispenserData(){
    $.post('https://rcore_fuel/insertDispenser', JSON.stringify({
        price: $(".priceFuel").val(),
        fuel: $("#fuelType").val(),
        align: $("#scaleformPos").val(),
    }));
    Close();
}

function selectPayment(type){
    if (!App.payment.open || App.payment.pending || !App.payment[type]) return;
    App.payment.pending = true;
    $.post('https://rcore_fuel/payment', JSON.stringify({
        type: type,
    }));
}

$(function(){
    $.post('https://rcore_fuel/init_main');

	window.addEventListener('message', function(event) {
        var item = event.data;

        if (item.type === 'refuelSummary' || item.type === 'showpaytype') {
            ['visible', 'unit', 'status'].forEach(key => {
                if (item[key] !== undefined) App.receipt[key] = item[key];
            });
            ['total', 'liters'].forEach(key => {
                if (item[key] !== undefined && item[key] !== null && Number.isFinite(Number(item[key]))) {
                    App.receipt[key] = Number(item[key]);
                }
            });
        }
        if (item.type === 'paymentPending') App.payment.pending = true;
        if (item.type === 'closePayment') {
            App.payment.open = false;
            App.payment.pending = false;
            $('#paymentType').modal('hide');
        }

        if(item.type === "locales_main"){
			 App.translation = item.locales
        }

        if(item.type === "shopSettings"){
			 $("#shopSettings").modal("show");
        }

        if(item.type === "show_guide_tube"){
			 $("#tutorial_gas_tube").modal("show");
        }

        if(item.type === "show_dispenser_settings"){
			 $("#dispenserSettings").modal("show");
        }

        if(item.type === "insertFuelTypes"){
            $("#fuelType").append("<option value='" + item.key +"'>"+ item.label +"</option>");
        }

        if(item.type === "showpaytype"){
            App.payment = {open: true, pending: false, cash: !!item.cash, bank: !!item.bank};
			$('#paymentType').modal({
                backdrop: 'static',
                keyboard: false
            });
        }
	})
});

// Debug
$(function(){
	window.addEventListener('message', function(event) {
        var item = event.data;

        if(item.type === "display_for_copy"){
			$('#textboard').modal("show");
			$(".textarea").val(item.text);
        }
	})
});
