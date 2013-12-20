RESTstop.configure()

RESTstop.add "get_num/:num?", ->
	@params.num

RESTstop.add "get_url", ->
	# HTTP.call "GET", "http://www.baidu.com"
	console.log @params

RESTstop.add "display_params", ->
	console.log @params
	console.log "call!!"

	DisplayParamsCollection.addDocument @params

RESTstop.add "loginUser", ->
	if @params.userId? and @params.platform? and @params.sessionId? and @params.appId? and @params.appKey?
		PlatformUserCollection.loginUser @params.userId, @params.platform, @params.sessionId, @params.appId, @params.appKey
	else
		console.log "loginUser error, params: #{JSON.stringify @params}"

RESTstop.add "createOrder", ->
	OrderCollection.createOrder()

RESTstop.add "noticeOrder", ->
	console.log @params
	if @params.CooOrderSerial? and 1 is OrderCollection.noticeOrder @params.CooOrderSerial
		{"ErrorCode":"1","ErrorDesc":"vertify order success"}
	else
		{"ErrorCode":"0","ErrorDesc":"vertify order failed"}