import delay from "./delay.js";

class GameQueue {

    constructor() {
        this.queue = [];
    };

    add (user_id) {
        if (!this.queue.includes(user_id)) {
            this.queue.push(user_id);
        }
    };

    leave(user_id) {
        const index = this.queue.indexOf(user_id);
        if (index !== -1) {
            this.queue.splice(index, 1);
        }
    };

    find_match() {
        if (this.queue.length >= 2) {
            const player1 = this.queue.shift();
            const player2 = this.queue.shift();
            return {player1, player2};
        } else {
            return null
        }
    };

    async listen() {
        while (true) {
            const users = this.find_match()
            if (users !== null) {
                this.leave(users[0]);
                this.leave(users[1]);
                return users
            }
            await delay(5000)

        }

    };

}

export default GameQueue