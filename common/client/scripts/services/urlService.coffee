app = angular.module 'codesubmit'

app.service 'urlService', ($http) ->

	apiPrefix = '/api'

	self =
		user:
			login: () -> "#{apiPrefix}/user/login"
			logout: () -> "#{apiPrefix}/user/logout"
		admin:
			list: () -> "#{apiPrefix}/admin/list"
			findByEmail: (email) -> "#{apiPrefix}/admin/findbyemail/#{email}"
			create: () -> "#{apiPrefix}/admin/create"
			deactivate: () -> "#{apiPrefix}/admin/deactivate"
			activate: () -> "#{apiPrefix}/admin/activate"
			resetPassword: () -> "#{apiPrefix}/admin/resetpassword"
			changePassword: () -> "#{apiPrefix}/admin/changepassword"
		student:
			list: () -> "#{apiPrefix}/student/list"
			findByEmail: (email) -> "#{apiPrefix}/student/findbyemail/#{email}"
			create: () -> "#{apiPrefix}/student/create"
			deactivate: () -> "#{apiPrefix}/student/deactivate"
			activate: () -> "#{apiPrefix}/student/activate"
			resetPassword: () -> "#{apiPrefix}/student/resetpassword"
			importByCsv: () -> "#{apiPrefix}/student/importbycsv"
			changePassword: () -> "#{apiPrefix}/student/changepassword"
		assignment:
			list: () -> "#{apiPrefix}/assignment/list"
			findByAsgId: (asgId) -> "#{apiPrefix}/assignment/findbyasgid/#{asgId}"
			create: () -> "#{apiPrefix}/assignment/create"
			update: () -> "#{apiPrefix}/assignment/update"
		submission:
			list: (asgId) -> "#{apiPrefix}/submission/list/#{asgId}"
			listMine: (asgId) -> "#{apiPrefix}/submission/listmine/#{asgId}"
			findBySubId: (subId) -> "#{apiPrefix}/submission/findbysubid/#{subId}"
			findMineBySubId: (subId) -> "#{apiPrefix}/submission/findminebysubid/#{subId}"
			submit: (asgId) -> "#{apiPrefix}/submission/submit/#{asgId}"
		storage:
			get: (key, filename) -> "#{apiPrefix}/storage/#{key}?filename=#{filename || key}"
			post: (key) -> "#{apiPrefix}/storage/#{key}"
			findByKey: (key) -> "#{apiPrefix}/storage/#{key}?infoOnly=true"

	self.post = (url, payload, options, done) ->
		if _.isFunction options
			done = options
			options = null

		$http.post(url, payload, options).then ( (res) ->
			if res.data.success
				done null, res.data
			else
				done new Error(res.data.msg)
		), (res) ->
			done new Error("#{res.data} status: #{res.status}")

	self.get = (url, done) ->
		$http.get(url).then ( (res) ->
			if res.data.success
				done null, res.data
			else
				done new Error(res.data.msg)
		), (res) ->
			done new Error("#{res.data} status: #{res.status}")

	return self