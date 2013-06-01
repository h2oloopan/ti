Sequelize = require 'sequelize'
mysql = require('../infrastructure/db').mysql
config = require '../config'
User = require './user'

Goal = mysql.define 'goals',
    id:
        type: Sequelize.INTEGER
        primaryKey: true
        unique: true
        autoIncrement: true
        allowNull: false
    title:
        type: Sequelize.STRING
        allowNull: false
    description:
        type: Sequelize.TEXT
        allowNull: true
    start:
        type: Sequelize.DATE
        allowNull: false
    end:
        type: Sequelize.DATE
        allowNull: false
    target:
        type: Sequelize.DECIMAL 32, 10
        allowNull: false
    progress:
        type: Sequelize.DECIMAL 32, 10
        allowNull: false

Goal.belongsTo User
User.hasMany Goal

module.exports = Goal
