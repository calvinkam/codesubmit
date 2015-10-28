
module.exports = ($) ->
	self = {}

	self.lsit = () ->
		$.express.Router().get '/list/:asgId', (req, res, done) ->
			asgId = req.params.asgId

			$.services.submissionService.list {asgId: asgId}, (err, submissions) ->
				return $.utils.onError done, err if err

				res.json
					success: true
					submissions: submissions

	self.listmine = () ->
		$.express.Router().get '/listmine/:asgId', (req, res, done) ->
			asgId = req.params.asgId

			$.services.submissionService.list {asgId: asgId, email: req.user.email}, (err, submissions) ->
				return $.utils.onError done, err if err

				res.json
					success: true
					submissions: submissions

	self.findminebysubid = () ->
		$.express.Router().get '/findminebysubid/:subId', (req, res, done) ->
			subId = req.params.subId

			$.services.submissionService.findBySubId {subId: subId, email: req.user.email}, (err, submission) ->
				return $.utils.onError done, err if err

				res.json
					success: true
					submission: submission

	self.submit = () ->
		$.express.Router().post '/submit/:asgId', (req, res, done) ->
			asgId = req.params.asgId
			code = req.body.code

			$.services.submissionService.submit req.user, asgId, code, (err, submission) ->
				return $.utils.onError done, err if err

				res.json
					success: true
					submission: submission

	return self