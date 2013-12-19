@DisplayParamsCollection = new Meteor.Collection "displayParams"

DisplayParamsCollection.addDocument = (doc) ->
	@insert
		document: JSON.stringify doc
		time: new Date().getTime()

DisplayParamsCollection.getLastDocument = ->
	@find {}, {sort: {time : -1}, limit: 10}

if Meteor.isClient
	DisplayParamsCollection.clean = ->
		Meteor.call "cleanDisplayParams"

if Meteor.isServer
	Meteor.methods "cleanDisplayParams": ->
		DisplayParamsCollection.remove({})