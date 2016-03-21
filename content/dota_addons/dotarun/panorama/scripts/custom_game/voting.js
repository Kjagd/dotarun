var selectedLength = "";
var difficultyModes = ["Short","Med","Long"];
var difficultyCounts = [15, 15, 15];
var difficultyOffsets = [15, 15, 15];
var countOffset = 10;



function HoverDifficulty(name) {
    var panel = $("#"+name)

    if (name != selectedLength || selectedLength != "")
        panel.AddClass('Hover')
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
    $.Msg(selectedLength);
    //$("#MiranaTest").style.position = "50px 0 0 0";


    var idName = GetLengthID(selectedLength);
    var countHolder = $("#"+difficultyModes[idName]+"Count");
    difficultyCounts[idName] += difficultyOffsets[idName];
    difficultyOffsets[idName] *= 0.9;

    var miranaFace = $.CreatePanel("Panel", countHolder, "countPanel");
    miranaFace.BLoadLayout("file://{resources}/layout/custom_game/mirana_face.xml", false, false);
           
    miranaFace.style.position = difficultyCounts[idName]+"px 0 0 0";
}

function GetLengthID(name) {
    if (selectedLength == difficultyModes[0]) {
        return 0;
    } else if (selectedLength == difficultyModes[1]) {
        return 1;
    } else {
        return 2;
    }
}

//function PerfectMiranaRa