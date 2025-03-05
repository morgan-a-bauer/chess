import {Sequelize, DataTypes, Model, Op} from 'sequelize';
export {Sequelize, DataTypes, Model, Op}
import dotenv from 'dotenv';
dotenv.config()

console.log(`postgres://${process.env.DB_USER}:${process.env.DB_PASS}@${process.env.DB_HOST}:${process.env.DB_PORT}/${process.env.DB_NAME}`)
export const sequelize = new Sequelize(`postgres://${process.env.DB_USER}:${process.env.DB_PASS}@${process.env.DB_HOST}:/${process.env.DB_NAME}`);
