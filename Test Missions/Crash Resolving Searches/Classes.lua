-- Task Class Declaration
Task = {
	ClassName = 'Task'
}

function Task:new(o)
	
	o = o or {}
	setmetatable( o, self )
	self.__index = self
	return o

end

function Task:Name()
	print( self.ClassName )
end

DeployTask = Task:new{ClassName = 'DeployTask'}

function DeployTask:Name()
	print( self.ClassName )
end

TaskTest = Task:new()
TaskTest:Name()

TaskTest2 = DeployTask:new()
TaskTest2:Name()

