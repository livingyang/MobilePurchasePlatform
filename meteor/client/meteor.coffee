Template.hello.platformUsers = ->
	PlatformUserCollection.getLastLoginUsers(20)

Template.hello.orders = ->
	OrderCollection.getLastOrder(20)

Template.hello.events "click .btnVertify": ->
	PlatformUserCollection.vertifyUser @_id, (result) ->
		alert JSON.stringify result