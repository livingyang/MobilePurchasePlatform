Template.hello.platformUsers = ->
	PlatformUserCollection.getLastLoginUsers()

Template.hello.events "click .btnVertify": ->
	PlatformUserCollection.vertifyUser @_id, (result) ->
		alert JSON.stringify result