Sequelize = require 'sequelize'
mysql = require('../infrastructure/db').mysql

Post = mysql.define 'posts',
    id:
        type: Sequelize.INTEGER
        primaryKey: true
        unique: true
        autoIncrement: true
        allowNull: false


module.exports = Post
