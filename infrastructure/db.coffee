Sequelize = require 'sequelize'
config = require '../config'

options =
    host: config.db.host
    port: config.db.port
    #logging: false
    define:
        underscored: true
        freezeTableName: true
        timestamps: false

mysql = exports.mysql = new Sequelize config.db.database
    , config.db.username
    , config.db.password
    , options
