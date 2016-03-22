var CountdownStrings = ["Ready","3","2", "1", "Go!", ""];
var timer = $("#CountdownText");
var panel = $("#CountdownPanel");

function StartCountdown( data ) {

    $.Msg("Countdown started");

    for (var i = 0; i < CountdownStrings.length; i++) {
        $.Schedule(i, function(i){
            return function() {
                timer.text = CountdownStrings[i];
                timer.RemoveClass("Animator");
                timer.style.position = "0 0 0 0";
                timer.AddClass("Animator");
                timer.style.position = "0 40px 0 0";
                if (i == 4) {
                    $("#lflag").RemoveClass("Hidden")
                    $("#rflag").RemoveClass("Hidden")
                }
                if (i == 5) {
                    $("#lflag").AddClass("Hidden")
                    $("#rflag").AddClass("Hidden")
                }
            }
        }(i));
    }
}

GameEvents.Subscribe( "start_countdown", StartCountdown);
