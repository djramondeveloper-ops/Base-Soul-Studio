// This script was leaked inside at TCHub Website so check that out https://tchub.st/dashboard

var App = new Vue({
	el: '#body',
	data:
	{
	   visible: true,
	   fuelAmount: 0,
	   newFuelAmount: 0,

	   fuelList: [],

	   tankingFuel: false,

	   labelForUnit: "liters",

       pricePerLiter: 0,
	   newFuelCost: 0,
	   CurrentMoneyCounted: 0,

	   litersTanked: 0,
	   newLitersTanked: 0,

	   open: true,
	   inStock: true,

	   notOpenMessage: "",
	   outOfStockMessage: "",
 	},

    methods: {
        animateCounter(field, value) {
            // Retarget from the current number; never queue old server updates.
            gsap.killTweensOf(this.$data, field);
            if (value === 0) {
                this.$data[field] = 0;
                return;
            }
            gsap.to(this.$data, {duration: 0.2, ease: 'none', [field]: value});
        },
        CountPercentageBoxes: (amount)=>{
            return Math.floor(amount / 10)
        },
    },

    computed: {
        animatedMoney: function() {
            return this.newFuelCost.toFixed(1);
        },

        animatedLiters: function(){
            return this.newLitersTanked.toFixed(1);
        },

        animatedFuel: function() {
            return this.newFuelAmount.toFixed(0);
        },
    },
    watch: {
		litersTanked: function(newValue) {
			this.animateCounter('newLitersTanked', newValue);
		},

		CurrentMoneyCounted: function(newValue) {
			this.animateCounter('newFuelCost', newValue);
		},
		fuelAmount: function(newValue) {
			this.animateCounter('newFuelAmount', newValue);
		},
    },
});

$(function(){
	window.addEventListener('message', function(event) {
        var item = event.data;

        if(item.type === "hideAll"){
            $("#body").hide();
        }

        if(item.type === "translation"){
            if(item.fuel){
                App.notOpenMessage = item.notOpenMessage;
                App.outOfStockMessage = item.outOfStockMessage;
            }
        }

        if(item.type === "showFueling"){
            $(".info").stop(true, true).hide();
            $(".tanking").stop(true, true).show();
        }

        if(item.type === "hideFueling"){
            gsap.killTweensOf(App.$data);
            $(".info").stop(true, true).show();
            $(".tanking").stop(true, true).hide();

            App.fuelAmount = 0;
            App.newFuelCost = 0;
            App.CurrentMoneyCounted = 0;
            App.newFuelAmount = 0;
            App.litersTanked = 0;
            App.newLitersTanked = 0;
        }

        if(item.type === "openstatus"){
            App.open = item.open;
            App.inStock = item.inStock;
        }

        if(item.type === "flipScreen"){
            if(item.status){
                $("body").css({ transform: "scaleX(-1)" });
            }
            else
            {
                $("body").css({ transform: "scaleX(1)" });
            }
        }

        if(item.type === "stock"){
            if (App.fuelList[item.index]) {
                App.fuelList[item.index].inStock = item.inStock;
            }
        }

        if(item.type === "activeFuel"){
            for(var i = 0; i < App.fuelList.length; i ++){
                App.fuelList[i].active = false;
            }
            if (App.fuelList[item.index]) {
                App.fuelList[item.index].active = true;
                App.pricePerLiter = App.fuelList[item.index].price;
                App.labelForUnit = App.fuelList[item.index].labelUnitFuel;
            }
        }

        if(item.type === "fuelData"){
            App.visible = false;
            App.fuelList = Array.isArray(item.fuelData) ? item.fuelData : [];

            if (App.fuelList.length > 0) {
                App.pricePerLiter = Number(App.fuelList[0].price) || 0;
                App.labelForUnit = App.fuelList[0].labelUnitFuel || App.labelForUnit;
            } else {
                App.pricePerLiter = 0;
            }

            App.visible = true;
        }

        if(item.type === "show"){
            $("#body").stop(true, true).show();
        }

        if(item.type === "hide"){
            $("#body").stop(true, true).hide();
        }

		if(item.type === "update_cost"){
			if(item.fuel != null && Number.isFinite(Number(item.fuel))){
                App.fuelAmount = Math.max(0, Math.min(100, Number(item.fuel)));
			}
			if(App.fuelAmount >= 99.5){
				App.fuelAmount = 100;
			}

            if (item.cost != null && Number.isFinite(Number(item.cost))) {
                App.CurrentMoneyCounted = Math.max(0, Number(item.cost));
            }
            if (item.litersTanked != null && Number.isFinite(Number(item.litersTanked))) {
                App.litersTanked = Math.max(0, Number(item.litersTanked));
            }
		}
	})
});

$(function(){
    function getQueryParams() {
        var qs = window.location.search;
        qs = qs.split('+').join(' ');

        var params = {},
            tokens,
            re = /[?&]?([^=]+)=([^&]*)/g;

        while (tokens = re.exec(qs)) {
            params[decodeURIComponent(tokens[1])] = decodeURIComponent(tokens[2]);
        }
        return params;
    }

    var result = getQueryParams();

    $.post('https://rcore_fuel/realDuiLoaded', JSON.stringify({
        identifier: result.identifier,
    }));
});

function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}
