async = require 'async'

$ = require './globals'

async.series [
	$.run.setup
	$.run.server
], (err) ->
	return $.logger.log 'error', "error starting up codesubmit student #{err.message}" if err
	$.logger.log 'info', "codeSubmit student listen on port #{$.config.port}"
