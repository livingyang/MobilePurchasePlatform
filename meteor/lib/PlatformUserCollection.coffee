@PlatformUserCollection = new Meteor.Collection "platformUser"

PlatformUserCollection.loginUser = (userId, platform, sessionId, appId, appKey) ->
	@update {userId: userId, platform: platform},
		{userId: userId, platform: platform, sessionId: sessionId, lastLoginTime: (new Date).getTime(), appId: appId, appKey: appKey},
		{upsert: true}

PlatformUserCollection.getLastLoginUsers = (limitCount = 10) ->
	@find {}, {sort: {lastLoginTime : -1}, limit: limitCount}

if Meteor.isServer
	PlatformUserCollection.vertifyUser = (userDocumentId) ->
		platformUser = PlatformUserCollection.findOne _id: userDocumentId

		params =
			AppId: platformUser.appId
			Act: 4
			Uin: platformUser.userId
			SessionID: platformUser.sessionId
		params.Sign = CryptoJS.MD5("#{params.AppId}#{params.Act}#{params.Uin}#{params.SessionID}#{platformUser.appKey}").toString()
		receive: JSON.parse (HTTP.get "http://service.sj.91.com/usercenter/AP.aspx", params: params).content
		params: params

	Meteor.methods "PlatformUserCollection.vertifyUser" : PlatformUserCollection.vertifyUser

if Meteor.isClient
	PlatformUserCollection.vertifyUser = (userDocumentId, callback) ->
		Meteor.call "PlatformUserCollection.vertifyUser", userDocumentId, (error, result) ->
			callback? result