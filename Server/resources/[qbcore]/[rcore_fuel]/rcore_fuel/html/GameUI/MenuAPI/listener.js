// This script was leaked inside at TCHub Website so check that out https://tchub.st/dashboard

var index = 0;

var AppInput = new Vue({
	el: '#input',
	data:
	{
        identifier: null,
	    secondaryTitle: "subtitle",
	    float: "middle",
	    position: "middle",
	    ChooseText: "Accept",
	    CloseText: "Close",
	    message: "",
	    defaultTextInfront: "",
	    defaultText: "",
	    visible: false,
	},
    methods: {
        Choose: function(){
            $.post('https://rcore_fuel/inputmethod', JSON.stringify({
                identifier: this.identifier,
                message: this.message,
            }));
        },
        Close: function(){
            $.post('https://rcore_fuel/close', JSON.stringify({
                identifier: this.identifier,
            }));
        },
    },
});

var AppMenu = new Vue({
	el: '#menu',
	data:
	{
        identifier: null,

	    secondaryTitle: "rcore",
        primaryTitle: "",

	    float: "left",
	    position: "middle",

	    descriptionItem: null,

	    backgroundColor: "orange",
	    primaryTitleColor: "black",
	    secondaryTitleColor: "black",

	    backgroundImage: null,

	    itemsCount: 0,

	    isRounded: false,

	    visible: false,
		menu: [],
	},
});
function setActiveMenuIndex(index, active_){
    for(var i = 0; i < AppMenu.menu.length; i++){ AppMenu.menu[i].active = false }
    if(AppMenu.menu[index] != null) {
        AppMenu.menu[index].active = active_
        if(AppMenu.menu[index].description){
            AppMenu.descriptionItem = AppMenu.menu[index].description;
        }
    }
}

function recalculateInteractableItems(){
    AppMenu.itemsCount = 0;
    for(var i = 0; i < AppMenu.menu.length; i++){
        if(AppMenu.menu[i].isItem == true) {
            AppMenu.itemsCount ++;
        }
    }
}

function findFirstInteractableIndex(){
    for(var i = 0; i < AppMenu.menu.length; i++){
        if(AppMenu.menu[i] && AppMenu.menu[i].isItem === true) return i;
    }
    return -1;
}

function ChangeChoiceInItem(forward){
    var menuData = AppMenu.menu[index];
    if(!menuData || !Array.isArray(menuData.choice) || menuData.choice.length === 0) return;
    var data = menuData.choice;
    var currentIndex = Number.isInteger(menuData.activeSubIndex) ? menuData.activeSubIndex : 0;

    currentIndex = (currentIndex + (forward ? -1 : 1) + data.length) % data.length;

    AppMenu.menu[index].activeSubIndex = currentIndex;

    $.post('https://rcore_fuel/clickItem', JSON.stringify({
        index: menuData.index,
        identifier: AppMenu.identifier,
        data: data[currentIndex],
        isArrowKey: true,
    }));
}

function SelectAnotherItemInMenu(forward) {
    var menuLength = AppMenu.menu.length;
    if(menuLength === 0 || AppMenu.itemsCount === 0) return;

    var lastIndex = index;
    var scrollAmount = forward ? -33 : 33;
    var direction = forward ? -1 : 1;
    var attempts = 0;

    do {
        index = (index + direction + menuLength) % menuLength;
        attempts++;
    } while(attempts <= menuLength && (!AppMenu.menu[index] || !AppMenu.menu[index].isItem));

    if(attempts > menuLength || !AppMenu.menu[index] || !AppMenu.menu[index].isItem) return;

    document.getElementById('scrolldiv').scrollTop += (scrollAmount * attempts);

    if(forward && index === menuLength - 1){
        document.getElementById('scrolldiv').scrollTop = 90000;
        AppMenu.activeIndexNumber = menuLength - 1;
    }
    else if(!forward && index === 0){
        document.getElementById('scrolldiv').scrollTop = 0;
        AppMenu.activeIndexNumber = -1;
    }

    AppMenu.activeIndexNumber += forward ? -1 : 1;
    setActiveMenuIndex(index, true);

    AppMenu.descriptionItem = null;
    if(AppMenu.menu[index].description){
        AppMenu.descriptionItem = AppMenu.menu[index].description;
    }

    $.post('https://rcore_fuel/selectNew', JSON.stringify({
        index: AppMenu.menu[index].index,
        identifier: AppMenu.identifier,
        newIndex: AppMenu.menu[index].index,
        oldIndex: AppMenu.menu[lastIndex] ? AppMenu.menu[lastIndex].index : AppMenu.menu[index].index
    }));
}


// Menu
$(function(){
    function display(bool) {
        AppMenu.visible = bool;
    }
    display(false);
	window.addEventListener('message', function(event) {
        var item = event.data;

        if(item.type_menu === "reset"){
            AppMenu.menu = [];
            AppMenu.descriptionItem = null;
            AppMenu.itemsCount = 0;
            AppMenu.activeIndexNumber = 0;
            index = 0;
        }

        if(item.type_menu === "add"){
            delete item.menuItems.data;
            delete item.menuItems.cb;

            AppMenu.menu.push(item.menuItems);
            recalculateInteractableItems();
        }

        if(item.type_menu === "secondaryTitle"){
            AppMenu.secondaryTitle = item.title
        }

        if(item.type_menu === "primaryTitle"){
            AppMenu.primaryTitle = item.title
        }

        if (item.type_menu === "ui"){
            display(item.status);
            if(item.properties){
                AppMenu.float = item.properties.float;
                AppMenu.position = item.properties.position;
                AppMenu.backgroundColor = item.properties.backgroundColor;
                AppMenu.primaryTitleColor = item.properties.primaryTitleColor;
                AppMenu.secondaryTitleColor = item.properties.secondaryTitleColor;
                AppMenu.isRounded = item.properties.isRounded;
                AppMenu.backgroundImage = item.properties.backgroundImage;
            }
            AppMenu.identifier = item.identifier;
            recalculateInteractableItems();
            index = findFirstInteractableIndex();
            AppMenu.activeIndexNumber = 0;
            AppMenu.descriptionItem = null;
            if(index >= 0){
                setActiveMenuIndex(index, true);
            }
        }

	    if(AppMenu.visible && !AppInput.visible){
            if (item.type_menu === "enter"){
                var menuData = AppMenu.menu[index];
                if(!menuData || menuData.isItem !== true) return;

                var choiceData = null;
                if(menuData.checkBox){
                    menuData.value = !menuData.value;
                }

                if(menuData.isChoice && Array.isArray(menuData.choice) && menuData.choice.length > 0){
                    var currentIndex = Number.isInteger(menuData.activeSubIndex) ? menuData.activeSubIndex : 0;
                    currentIndex = Math.max(0, Math.min(menuData.choice.length - 1, currentIndex));
                    choiceData = menuData.choice[currentIndex];
                }

                $.post('https://rcore_fuel/clickItem', JSON.stringify({
                    index: menuData.index,
                    identifier: AppMenu.identifier,
                    data: choiceData ?? menuData,
                }));
            }

            if (item.type_menu === "left"){
                var leftItem = AppMenu.menu[index];
                if(leftItem && leftItem.isItem === true && leftItem.isChoice){
                    ChangeChoiceInItem(false);
                }
            }

            if (item.type_menu === "right"){
                var rightItem = AppMenu.menu[index];
                if(rightItem && rightItem.isItem === true && rightItem.isChoice){
                    ChangeChoiceInItem(true);
                }
            }

            if (item.type_menu === "up"){
                SelectAnotherItemInMenu(true);
            }

            if (item.type_menu === "down"){
                SelectAnotherItemInMenu(false);
            }
		}
	})
});

// Input
$(function(){
    function display(bool) {
        AppInput.visible = bool;
    }
    display(false);
	window.addEventListener('message', function(event) {
        var item = event.data;

        if(item.type_menu === "title_input"){
            AppInput.secondaryTitle = item.title
        }

        if (item.type_menu === "ui_input"){
            display(item.status);
            if(item.properties){
                AppInput.float = item.properties.float;
                AppInput.position = item.properties.position;
                AppInput.ChooseText = item.properties.ChooseText;
                AppInput.CloseText = item.properties.CloseText;
                AppInput.placeHolderText = item.properties.placeHolderText;
                AppInput.message = item.properties.defaultValue;
            }
            AppInput.identifier = item.identifier;
        }
	})
});