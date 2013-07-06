Sequelize = require 'sequelize'
mysql = require('../infrastructure/db').mysql
config = require '../config'
User = require('./user')

UserInfo = mysql.define 'user_infos',
    user_id:
        type: Sequelize.INTEGER
        primaryKey: true
        unique: true
        allowNull: false
    #this is a copy over of username at registration, may be different in the future though
    nickname:
        type: Sequelize.STRING
        unique: true
        allowNull: false
        validate:
            isAlphanumeric: true
            len:
                [config.system.username.min, config.system.username.max]


User.hasOne UserInfo,
UserInfo.belongsTo User

module.exports = UserInfo