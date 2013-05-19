Sequelize = require 'sequelize'
mysql = require('../infrastructure/db').mysql

Group = mysql.define 'groups',
    id:
        type: Sequelize.INTEGER
        primaryKey: true
        unique: true
        autoIncrement: true
        allowNull: false
    name:
        type: Sequelize.STRING
        unique: true
        allowNull: false
    privilege:
        type: Sequelize.INTEGER
        unique: false
        allowNull: false

module.exports = Group
