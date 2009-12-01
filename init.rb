require File.dirname(__FILE__) + '/lib/action_flow'

::ApplicationController.__send__(:include, ActionFlow::Filters)

