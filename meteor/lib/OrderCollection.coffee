@OrderCollection = new Meteor.Collection "order"

OrderCollection.createOrder = ->
	@findOne _id: @insert price: 1, description: "test", isNoticed: false, createTime: (new Date).getTime()

OrderCollection.noticeOrder = (orderId) ->
	@update {_id: orderId}, {$set: isNoticed: true}

OrderCollection.getLastOrder = (limitCount = 10) ->
	@find {}, {sort: {createTime : -1}, limit: limitCount}
