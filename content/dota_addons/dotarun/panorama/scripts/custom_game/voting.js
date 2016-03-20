var selectedLength = ""
var difficultyModes = ["Short","Med","Long"]


function HoverDifficulty(name) {
    var panel = $("#"+name)

    if (name != selectedLength || selectedLength != "")
        panel.AddClass('Hover')

    Glow(panel)
    UpdateMultipliers(name)
}

function MouseOverDiff(name) {
    var panel = $("#"+name)


    if (name != selectedLength)
        panel.RemoveClass('Hover')

}

function SelectDifficulty(name) {
    var panel = $("#"+name)
    selectedLength = name

    for (var i in difficultyModes)
    {
        var diffPanel = $("#"+difficultyModes[i])
        if (difficultyModes[i] != selectedLength)
        {
            diffPanel.RemoveClass('Hover')
            diffPanel.RemoveClass('Selected')
        }
    }

    panel.AddClass('Hover')
    panel.AddClass('Selected')
    
    Game.EmitSound("ui_generic_button_click");
}

function ConfirmVote() {
    Game.EmitSound("ui_generic_button_click");
    var panel = $("#"+selectedLength)

}