import { Op } from 'sequelize'
import Users from '../db_models/users.js'

export default async function verifyLogin(username, password) {
    try {
        const data = await Users.findOne({
            attributes: ['password', 'id'],
            where: {
                username: {
                    [Op.eq]: username,
                },
            },
        });

        // Check if data exists and if password matches
        
        if (data.dataValues.password == password) {
            return data.dataValues.id;
        } else {
            return "Invalid Password";
        }
    } catch (error) {
        console.error("Error during user lookup:", error);
        return "An error occurred";
    }
};