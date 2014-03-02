sqlite3 = require('sqlite3').verbose()
options = require('../../config').db[0].options
path = require 'path'
fs = require 'fs'


repos = module.exports =
    #this is the repos collection for sqlite3 db
    type: 'sqlite3'
    initialize: (cb) ->
        #this function initialize the database
        #run the initialization sql
        #TODO: implement the patching system later
        fs.readFile path.join(__dirname, 'initialize.sql'), {encoding: 'utf8'}, (err, sql) ->
            if err
                cb err
            else
                file = path.join __dirname, options.file
                db = new sqlite3.Database file, (err) ->
                    if err
                        cb err
                    else
                        db.serialize ->
                            db.exec sql, (err) ->
                                cb err
                        db.close()

    getRepo: (name) ->
        return repo = require './' + name + 'Repo'
