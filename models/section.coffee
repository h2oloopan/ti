Sequelize = require 'sequelize'
mysql = require('../infrastructure/db').mysql

Section = mysql.define 'sections',
    id:
        type: Sequelize.INTEGER
        primaryKey: true
        unique: true
        autoIncrement: true
        allowNull: false
    name:
        type: Sequelize.STRING
        unique: false
        allowNull: false
    order:
        type: Sequelize.INTEGER
        unique: false
        allowNull: false
        defaultValue: 0

module.exports = Section
