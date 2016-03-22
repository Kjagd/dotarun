var selectedLength = "";
var difficultyModes = ["Short","Med","Long"];
var difficultyCounts = [22, 22, 22];
var difficultyOffsets = [13, 13, 13];
var timer = $("#Countdown");
var voted = false
$("#VoteBtn").enabled = false;


function HoverDifficulty(name) {
    if (voted) return;
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
    if (voted) return;
    var panel = $("#"+name)
    selectedLength = name
    $("#VoteBtn").enabled = true;


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
    $("#VoteBtn").enabled = false;
    voted = true;

    var data = {};
    data['length'] = selectedLength
    GameEvents.SendCustomGameEventToServer( "vote_cast", { "data" : data } );
}

function ReceiveVote( data ) {
    var idName = GetLengthID(data.voted);
    var count = data.vote_count
    var countHolder = $("#"+data.voted+"Count");
    var offsetInc =  difficultyOffsets[idName];
    var offset = difficultyCounts[idName];
    for (var i = 0; i < count; i++) {
        offset += offsetInc;
        offsetInc *= 0.9;
    }

    var miranaFace = $.CreatePanel("Panel", countHolder, "countPanel");
    miranaFace.style.position = offset+"px 0 0 0";
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

function UpdateVoteTimer( data )
{
    timer.text = data.time;
}

function WinnerFound ( data ) 
{
    $("#Short").AddClass("Fade");
    $("#Med").AddClass("Fade");
    $("#Long").AddClass("Fade");
    $("#"+data.winner).RemoveClass("Fade");
    $("#Voting").DeleteAsync(1.5);
}

function RemoveGui( data ) {
    var panel = $("#Voting");
    if  (panel != null) {
        panel.DeleteAsync(0);
    }
}

GameEvents.Subscribe( "update_vote_timer", UpdateVoteTimer);
GameEvents.Subscribe( "voting_done", WinnerFound);
GameEvents.Subscribe( "vote_cast", ReceiveVote);
GameEvents.Subscribe( "remove_voting", RemoveGui);
GameEvents.Subscribe( "EnsureVoteGuiDelete", RemoveGui);


