Sequelize = require 'sequelize'
mysql = require('../infrastructure/db').mysql
Section = require './section'

Forum = mysql.define 'forums',
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

Forum.belongsTo Section
Section.hasMany Forum

module.exports = Forum
