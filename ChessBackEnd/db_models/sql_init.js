// Written by: Jackson Butler

import {Sequelize, DataTypes, Model, Op} from 'sequelize';
import dotenv from 'dotenv';
dotenv.config()
const sequelize = new Sequelize(`postgres://${process.env.DB_USER}:${process.env.DB_PASS}@${process.env.DB_HOST}/${process.env.DB_NAME}`,{
    define: {
        freezeTableName: true,
    },
});

export {sequelize, Sequelize, DataTypes, Model, Op}
