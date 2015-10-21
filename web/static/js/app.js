// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "deps/phoenix_html/web/static/js/phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"
import {Socket} from "deps/phoenix/web/static/js/phoenix"
let socket = new Socket("/socket", {
  logger: (kind, msg, data) => {
    console.log(`${kind}: ${msg}`, data);
  },
  params: {token: window.userToken}
});

socket.connect();
socket.onOpen( () => console.log("connected!") );

let Scoreboard = {
  init() {
    let gameId = $("#game").data("id");
    if (!gameId) { return }

    let gameChannel = socket.channel("games:" + gameId);

    let $scores = $(".score");

    let Game = {
      id: gameId,
      scores() {
        return $scores.map( (i, score) => {
          let $score = $(score);

          return {
            id: $score.data("id"),
            points: parseInt($score.text())
          }
        }).get()
      },

      players: $(".player").map( (i, player) => {
        let $player = $(player);

        return {
          id: $player.data("id"),
          display: $player.text()
        }
      }).get(),

      complete() {
        let scores = this.scores().map( (score) => score.points );
        let max_score = Math.max(...scores);
        let min_score = Math.min(...scores);

        return max_score >= 11 && min_score <= max_score - 2
      },

      increment(score) {
        if (this.complete()) { return }

        let $score = $(score);
        $score.text(parseInt($score.text()) + 1);
      },

      serialize() {
        return {
          id: this.id,
          scores: this.scores(),
          players: this.players,
        }
      }
    }

    gameChannel.on("point", ({id, points}) => {
      $("#score-" + id).text(points);
    });

    gameChannel.on("game_over", ({score_id, points}) => {
      $("#score-" + score_id).text(points);
      $scores.off("click").addClass("game-over")
    });

    gameChannel.join()
      .receive("ok", () => console.log("Joined game channel"))
      .receive("error", reason => console.log("error!", reason));


    if (Game.complete()) {
      $scores.addClass("game-over");
    }
    else {
      $scores.click( ({currentTarget}) => {
        Game.increment(currentTarget);
        let message = Game.complete()? "game_over" : "point";
        gameChannel.push(message, Game.serialize());
      })
    }

  }
}

Scoreboard.init();
