// Written by: Jackson Butler
import delay from "./delay.js";

class GameQueue {

    constructor() {
        this.queue = {
            "1|0": [],    // Bullet
            "1|1": [],
            "2|1": [],
            "3|0": [],    // Blitz
            "3|2": [],
            "5|0": [],
            "5|3": [],
            "10|0": [],
            "10|5": [],
            "15|10": [],  // Rapid
            "30|0": [],
            "30|20": [],
            "60|0": [],   // Classical
            "60|30": []
          };
        this.timeControls = Object.keys(this.queue)
    };

    add (user_id, timeControl) {
        if (this.timeControls.includes(timeControl)) {
            if (!this.queue[timeControl].includes(user_id)) {
                this.queue[timeControl].push(user_id);
                return true
            }
        }
        return false
    };

    leave(user_id, timeControl) {
        if (this.timeControls.includes(timeControl)) {
            const index = this.queue[timeControl].indexOf(user_id);
            if (index !== -1) {
                this.queue[timeControl].splice(index, 1);
                return true
            }
        }
        return false
    };

    find_match(timeControl) {
        // console.log(timeControl,":",this.queue[timeControl].length)
        if (this.queue[timeControl].length >= 2) {
            const player1 = this.queue[timeControl].shift();
            const player2 = this.queue[timeControl].shift();
            return {player1, player2, timeControl};
        } else {
            return null
        }
    };

    async listen() {
        while (true) {
            for (const timeControl of this.timeControls) {
                const users = this.find_match(timeControl);
                if (users !== null) {
                    return users;
                }
            }
            await delay(5000);
        }
    };

}

export default GameQueue