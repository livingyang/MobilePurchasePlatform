RESTstop.configure()

RESTstop.add "get_num/:num?", ->
	@params.num

RESTstop.add "get_url", ->
	# HTTP.call "GET", "http://www.baidu.com"
	console.log @params

RESTstop.add "display_params", ->
	console.log @params
	console.log "call!!"

