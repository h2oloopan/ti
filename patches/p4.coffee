Forum = require '../models/forum'
Section = require '../models/section'
mysql = require('../infrastructure/db').mysql

exports.apply = (cb) ->
    query = 'ALTER TABLE forums ADD CONSTRAINT fk_forums_sections FOREIGN KEY (section_id) REFERENCES sections (id);'
    Forum.sync
        force: true
    .success ->
        Section.sync
            force: true
        .success ->
            mysql.query(query)
            .success ->
                cb null
            .error (err) ->
                cb err
        .error (err) ->
            cb err
    .error (err) ->
        cb err
