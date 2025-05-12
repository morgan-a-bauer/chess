// Written by: Jackson Butler
import { Op } from "sequelize";
import {Users} from "../db_models/model_init.js";

export default async function select_username_by_id(user_id) {
    const data = await Users.findOne({
        attributes: ['username'],
        where: {
            id: {
                [Op.eq]: user_id,
            },
        },
    });
    console.log(data)
    return data.dataValues.username
}