const app = new Vue({
    el: '#app',

    data: {
        nomeRisorsa : GetParentResourceName(),

        locales : {},

        textSettings : {
            text : "abcdefgh",
            color : "#ffffff",
        },

        notifySettings : {
            text : "",
            enable : false,
        },
        maxSize : 8
    },

    methods: {
        postNUI(name, table) {
            $.post(`https://${this.nomeRisorsa}/${name}`, JSON.stringify(table));
        },

        notification(text) {
            if(this.notifySettings.enable) {
                return
            }

            this.notifySettings.text = text
            this.notifySettings.enable = true
            setTimeout(() => {
                this.notifySettings.enable = false
            }, 3000);
        },

        viewColorInput() {
            $("#inputColor").click()
        },

        saveText() {
            this.postNUI("saveText", this.textSettings)
            this.notification(this.locales.text_edited)
        },

        checkText(event) {
            const key = event.key || ""
            const input = event.target
            const selectionLength = Math.max(0, (input.selectionEnd || 0) - (input.selectionStart || 0))
            const currentLength = this.textSettings.text.length - selectionLength

            if (!/^[A-Za-z ]$/.test(key) || currentLength >= app.maxSize) {
                event.preventDefault()
                return false
            }
        }
    }

});

window.addEventListener('message', function(event) {
    var data = event.data;
    if (data.type === "OPEN") {

        if(!data.color || data.color.length == 0 || !data.color.startsWith("#")) {
            data.color = "#ffffff"
        }

        app.textSettings.color = data.color
        app.textSettings.text = data.text
        $("#app").fadeIn(500)
    } else if(data.type === "UPDATE") {

        if(!data.color || data.color.length == 0 || !data.color.startsWith("#")) {
            data.color = "#ffffff"
        }

        app.textSettings.color = data.color
        app.textSettings.text = data.text
    } else if(data.type === "SET_LOCALES") {
        app.locales = data.locales
    } else if(data.type === "CONFIG") {
        app.maxSize = data.maxSize
    } else if(data.type === "CLOSE") {
        $("#app").fadeOut(250)
    }
})

document.onkeyup = function (data) {
    if (data.key == 'Escape') {
        $("#app").fadeOut(500)
        app.postNUI("close")
    } else if(data.key == 'Enter') {
        app.saveText()
    }
};
