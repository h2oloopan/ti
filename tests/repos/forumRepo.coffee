should = require 'should'
mysql = require('../../infrastructure/db').mysql
forumRepo = require '../../repos/forumRepo'

describe 'forumRepo', ->

    beforeEach (done) ->
        query = 'DELETE FROM sections;'
        mysql.query(query)
        .success ->
            query = 'INSERT INTO sections (name) VALUES ("test section");'
            mysql.query(query)
            .success ->
                query = 'INSERT INTO sections (name) VALUES ("another test section");'
                mysql.query(query)
                .success ->
                    done()
                .error (err) ->
                    done err
            .error (err) ->
                done err
        .error (err) ->
            done err


    describe 'getSection', ->
        it 'should return with error when causing trouble in the database (e.g. bad column name)', (done) ->
            forumRepo.getSection
                xx: 'yy'
            , (err, section) ->
                should.exist err
                should.not.exist section
                done()

        it 'should return null when no rows in the db match query', (done) ->
            forumRepo.getSection
                name: 'bad name'
            , (err, section) ->
                should.not.exist err
                should.not.exist section
                done()

        it 'should return section when the query matches', (done) ->
            forumRepo.getSection
                name: 'test section'
            , (err, section) ->
                should.not.exist err
                section.should.have.property 'name', 'test section'
                done()

    describe 'getSections', ->
        it 'should return with error when causing trouble in the database (e.g. bad column name)', (done) ->
            forumRepo.getSections
                xx: 'yy'
            , (err, sections) ->
                should.exist err
                should.not.exist sections
                done()

        it 'should return empty array when no rows in the db match query', (done) ->
            forumRepo.getSections
                name: 'bad name'
            , (err, sections) ->
                should.not.exist err
                sections.should.be.an.instanceOf Array
                sections.length.should.equal 0
                done()

        it 'should return all objects in the database if no constraints passed in', (done) ->
            forumRepo.getSections null, (err, sections) ->
                should.not.exist err
                sections.should.be.an.instanceOf Array
                sections.length.should.equal 2
                sections[0].should.have.property 'name', 'test section'
                sections[1].should.have.property 'name', 'another test section'
                done()

        it 'should return all matching rows in the database', (done) ->
            #may need to add more rows to make this one even better
            forumRepo.getSections
                name: 'another test section'
            , (err, sections) ->
                should.not.exist err
                sections.should.be.an.instanceOf Array
                sections.length.should.equal 1
                sections[0].should.have.property 'name', 'another test section'
                done()

    describe 'deleteSectionById', ->
        it 'should return with err when causing trouble in the database (e.g. invalid id)', (done) ->
            forumRepo.deleteSectionById 'wtf', (err) ->
                should.exist err
                done()

        it 'should return with err when there is no row in the db matches passed in id', (done) ->
            forumRepo.deleteSectionById -1, (err) ->
                should.exist err
                done()

        it 'should delete the matching section when passing in a correct id', (done) ->
            query = 'SELECT id FROM sections WHERE name = "test section";'
            mysql.query(query)
            .success (rows) ->
                id = rows[0].id
                forumRepo.deleteSectionById id, (err) ->
                    should.not.exist err
                    query = 'SELECT id FROM sections WHERE id = ' + id + ';'
                    mysql.query(query)
                    .success (rows) ->
                        rows.length.should.equal 0
                        done()
                    .error (err) ->
                        done err
            .error (err) ->
                done err



    describe 'updateSection', ->
        it 'should return with err if section passed in has no id', (done) ->
            forumRepo.updateSection
                name: 'section without id'
            , (err, section) ->
                should.exist err
                should.not.exist section
                done()

        it 'should update the item in database accordingly', (done) ->
            query = 'SELECT id FROM sections WHERE name = "test section";'
            mysql.query(query)
            .success (rows) ->
                id = rows[0].id
                forumRepo.updateSection
                    id: id
                    name: 'new section name'
                , (err, section) ->
                    should.not.exist err
                    should.exist section
                    section.should.have.property 'id', id
                    section.should.have.property 'name', 'new section name'
                    #check the db directly, just play safe
                    query = 'SELECT id, name FROM sections WHERE id = ' + id + ';'
                    mysql.query(query)
                    .success (rows) ->
                        rows.length.should.equal 1
                        rows[0].name.should.equal 'new section name'
                        done()
                    .error (err) ->
                        done err
            .error (err) ->
                done err
        #need to add more tests to this one


