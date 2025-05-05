import { Op } from 'sequelize'
import {Users} from '../db_models/model_init.js'
import Milestones from '../db_models/milestones.js';

export default async function verifyLogin(username, password) {
    try {
        const data = await Users.findOne({
            attributes: ['password', 'id', 'icon'],
            where: {
                username: {
                    [Op.eq]: username,

                },
            },
        });

        // Check if data exists and if password matches

        if (data.dataValues.password == password) {
            const milestones = await Milestones.findAll({
                where: {
                    user_id: data.dataValues.id, // By user Id
                },

                attributes: ['title', 'is_complete'],
            });
            var milestones_dict = {}
            milestones.forEach(milestone => {
                milestones_dict[milestone.dataValues.title] = milestone.dataValues.is_complete
            })
            console.log(milestones_dict)
            return {'user_id':data.dataValues.id, 'user_icon':data.dataValues.icon, 'milestones':milestones_dict}
        } else {
            return "invalid_password";
        }
    } catch (error) {
        console.error("Error during user lookup: No User Found");
        return "invalid_username";
    }
};