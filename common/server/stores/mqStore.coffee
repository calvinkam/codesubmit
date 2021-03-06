_ = require 'lodash'

module.exports = ($) ->
	self = {}

	sendToQueue = (queue, data, options) ->
		$.amqp.sendToQueue queue, new Buffer(JSON.stringify data), options

	self.pushTask = (data) ->
		sendToQueue $.config.rabbitmq.queues.submission, data, {persisten: true}

	self.rpc = (data, done) ->
		$.amqp.assertQueue '', {exclusive: true, autoDelete: true}, (err, replyQueue) ->
			corr = $.utils.rng.generateUuid()
			consumerTag = $.utils.rng.generateUuid()

			$.amqp.consume replyQueue.queue, ( (msg) ->
				if msg.properties.correlationId == corr
					$.amqp.cancel consumerTag, (err) ->
						done null, JSON.parse msg.content.toString()
			), {noAck: true, consumerTag: consumerTag}

			sendToQueue $.config.rabbitmq.queues.submission, data, {correlationId: corr, replyTo: replyQueue.queue}

	self.work = (worker) ->
		$.amqp.consume $.config.rabbitmq.queues.submission, ( (msg) ->
			worker (JSON.parse msg.content.toString()), (err, result) ->
				$.utils.onError _.noop, err if err

				if msg.properties.replyTo
					sendToQueue msg.properties.replyTo, result, {correlationId: msg.properties.correlationId}

				$.amqp.ack msg
		), {noAck: false}

	self.publish = (key, data) ->
		$.amqp.publish $.config.rabbitmq.queues.runResult, key, new Buffer(JSON.stringify data)

	self.subscribe = (key, listener) ->
		$.amqp.assertQueue '', {exclusive: true}, (err, subscribeQueue) ->
			consumerTag = $.utils.rng.generateUuid()
			$.amqp.bindQueue subscribeQueue.queue, $.config.rabbitmq.queues.runResult, key

			$.amqp.consume subscribeQueue.queue, ( (msg) ->
				listener JSON.parse msg.content.toString(), consumerTag
			), {noAck: true, consumerTag: consumerTag}

	self.cancelConsume = (consumerTag, done) ->
		$.amqp.cancel consumerTag, done

	return self
