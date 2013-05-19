#repo for sections and forums
Section = require '../models/section'
Forum = require '../models/forum'

forumRepo =
    #NOTE: this will only return the first one even query matches multiple rows
    getSection: (query, cb) ->
        Section.find
            where: query
        .success (section) ->
            cb null, section
        .error (err) ->
            cb err
    createSection: (section, cb) ->
        Section.create(section)
        .success (section) ->
            cb null, section
        .error (err) ->
            cb err
    updateSection: (section, cb) ->
        Section.find
            where:
                id: section.id
        .success (match) ->
            if (!match?)
                err = new Error 'There is no match to update'
                return cb err
            match.updateAttributes(section)
            .success ->
                cb null, match
            .error (err) ->
                cb err
        .error (err) ->
            cb err
    deleteSectionById: (id, cb) ->
        Section.find
            where:
                id: id
        .success (section) ->
            if (!section?)
                err = new Error 'There is no match to delete'
                return cb err
            section.destroy()
            .success ->
                cb null
            .error (err) ->
                cb err
        .error (err) ->
            cb err
    getSections: (query, cb) ->
        #NOTE: if want everything, pass in query as null
        Section.findAll
            where: query
        .success (sections) ->
            cb null, sections
        .error (err) ->
            cb err

module.exports = forumRepo
