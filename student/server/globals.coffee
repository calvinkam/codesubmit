path = require 'path'

module.exports = $ = {}

# dirs
$.serverDir = __dirname
$.studentDir = path.join $.serverDir, '../'
$.rootDir = path.join $.studentDir, '../'
$.commonDir = path.join $.rootDir, 'common'
$.publicDir = path.join $.studentDir, 'public'
$.commonPublicDir = path.join $.studentDir, 'public'

# configs
$.config = require path.join $.rootDir, 'configs', 'studentConfig'

# env
$.env =
	student: true

# init common components
$ = require(path.join $.commonDir, 'server', 'globals')($)
# init controllers
$.controllers = $.utils.routerHelper.makeControllers
	include:
		assignmentController: ['list', 'listpublishedwithmystats', 'findbyasgid']
		studentController: ['changepassword']
		submissionController: ['listmine', 'findminebysubid', 'submit', 'run']
$.controllers.userController = $.utils.routerHelper.makeUserController $.stores.studentStore

# routes
$.app.use $.express.static $.publicDir
$.app.use '/common', $.express.static $.commonPublicDir
$.app.use '/api', $.utils.routerHelper.makeApi()
