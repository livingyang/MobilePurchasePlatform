Template.hello.greeting = ->
	"Welcome to meteor."

Template.hello.events "click #addDocument": ->
	console.log CryptoJS.MD5('91SDK').toString()
	# PlatformUserCollection.loginUser "user111", "91", Random.id()
	# console.log DisplayParamsCollection.getLastDocument().count()
	# DisplayParamsCollection.addDocument data: Random.id()
	
Template.hello.events "click #cleanDocuments": ->
	# DisplayParamsCollection.remove({})
	# DisplayParamsCollection.clean()

# Template.hello.documents = ->
# 	DisplayParamsCollection.getLastDocument()

Template.hello.platformUsers = ->
	PlatformUserCollection.getLastLoginUsers()

Template.hello.events "click .btnVertify": ->
	PlatformUserCollection.vertifyUser @_id, (result) ->
		alert result