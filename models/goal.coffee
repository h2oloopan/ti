Sequelize = require 'sequelize'
mysql = require('../infrastructure/db').mysql
config = require '../config'
User = require './user'

types =
    progressable: 0
    onestop: 1

statuses =
    succeed: 0
    fail: 1
    progress: 2

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
    type:
        type: Sequelize.INTEGER
        allowNull: false
        defaultValue: types.onestop
    start:
        type: Sequelize.DATE
        allowNull: false
    end:
        type: Sequelize.DATE
        allowNull: false
        #all you need to make sure is end time is later than start time
    target:
        type: Sequelize.DECIMAL 32, 10
        allowNull: true
    progress:
        type: Sequelize.DECIMAL 32, 10
        allowNull: true
    status:
        type: Sequelize.INTEGER
        allowNull: false
        defaultValue: statuses.progress

Goal.types = types
Goal.statuses = statuses
Goal.belongsTo User
User.hasMany Goal

module.exports = Goal
