path = require 'path'

module.exports = $ = {}

# dirs
$.serverDir = __dirname
$.studentDir = path.join $.serverDir, '../'
$.rootDir = path.join $.studentDir, '../'
$.commonDir = path.join $.rootDir, 'common'

# configs
$.config = require path.join $.rootDir, 'configs', 'studentConfig'

# init common components
$ = require(path.join $.commonDir, 'server', 'globals')($)
# init controllers
$.controllers = $.utils.routerHelper.makeControllers
	include:
		assignmentController: ['list', 'findbyasgid']
		studentController: ['changepassword']
		submissionController: ['listmine', 'findminebysubid', 'submit']
$.controllers.userController = $.utils.routerHelper.makeUserController $.stores.studentStore

# routes
$.app.use $.express.static path.join $.studentDir, 'public'
$.app.use '/api', $.utils.routerHelper.makeApi()
