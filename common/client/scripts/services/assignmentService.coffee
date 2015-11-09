app = angular.module 'codesubmit'

app.service 'assignmentService', (urlService) ->
	self = {}

	self.list = (done) ->
		urlService.get urlService.assignment.list(), done

	self.listPublishedWithMyStats = (done) ->
		urlService.get urlService.assignment.listPublishedWithMyStats(), done

	self.findByAsgId = (asgId, done) ->
		urlService.get urlService.assignment.findByAsgId(asgId), done

	self.create = (assignment, done) ->
		payload =
			assignment: assignment

		urlService.post urlService.assignment.create(), payload, done

	self.update = (assignment, done) ->
		payload =
			assignment: assignment

		urlService.post urlService.assignment.update(), payload, done

	return self
