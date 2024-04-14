const { calculateEquity } = require('poker-odds');

function roundUpToNearest10(n) {
    return Math.ceil(n / 10) * 10;
}

function getRandomInt(min, max) {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min + 1)) + min;
}

function advice(equity, last_raise, expected_pot) {
    const bluff_freq = 20; // bluffs 20% of the time, when appropriate.
    let implied_odds = 100 * (last_raise / expected_pot);
    let equity_diff = equity - implied_odds // + if good equity, - if bad.
    let answer = "";
    if (equity_diff > 0) {
        // check if raise is viable
        if ((equity_diff / 100) * expected_pot > (last_raise * 2)) {
            let raise = roundUpToNearest10((equity_diff / 100) * expected_pot);
            answer = `raise to ${raise} (${100-bluff_freq}): call (${bluff_freq})`;
        }
        else {
            if (last_raise > 0) {
                answer = `call ${last_raise} (${roundUpToNearest10(equity)}), raise (${100-roundUpToNearest10(equity/2)})`;
            }
            else {
                answer = "check";
            }
            
        }
    } 
    else if (equity_diff > -40) {
        let random_num = getRandomInt(1, 100);
        if (random_num <= bluff_freq) {
            let raise = (2* last_raise) + random_num;
            answer = `let's try a bluff: raise to ${raise}`;
        }
        else {
            answer = "fold";
        }
    }
    else {
        if (last_raise > 0) {
            answer = "fold";
        }
        else {
            answer = "check";
        }
    }
    return answer;
}

function main() {
    let playing = true;
    while (playing) {
        
        let players = 3;
        let sb = 25;
        let bb = 50;
        let pot_size = sb+bb;
        let last_raise = 0;
        const board = [] // starts empty
        const iterations = 10000 // optional
        const exhaustive = false // optional
        let player_hand = ['2h', '7s'];
        let hands = [player_hand];

        for (let i = 1; i < players; i++) {
            hands.push(['..','..']);
        }
        
        let data = calculateEquity(hands, board, iterations, exhaustive)[0];
        let wins = data['wins'];
        let ties = data['ties'];
        let count = data['count'];
        let equity = (100 * wins/count);
        let expected_pot = pot_size + (last_raise * players);
        let get_advice = advice(equity, last_raise, expected_pot);
        console.log(get_advice);
        playing = false;

      }

    }
main();
