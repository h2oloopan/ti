define ['models/section'], (Section) ->
    SectionCollection = Backbone.Collection.extend
        model: Section
        url: '/api/sections'
