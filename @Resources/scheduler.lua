divider = '|'
COLUMN_INDEX_TASK_NAME = 1
COLUMN_INDEX_TASK_TIME = 2

StartTime = os.time()
counter = 0
finish = true

function Initialize()
	-- Rainmeter vars
	ScaleFactor = SKIN:GetVariable('ScaleFactor')
	sTaskListFile = SELF:GetOption('TaskListFile')
	mode = SKIN:GetVariable('Mode')
	smoothness = SKIN:GetVariable('Smoothness')
	FontColor = SKIN:GetVariable('FONTCOLOR')
	end

function SplitText(inputstr, sep)
	local sep=sep or '|'
	local arr={}
	for taskstr, timestr in string.gmatch(inputstr,'([^.]*)'..sep..'(.*)') do
		table.insert(arr, taskstr)
		table.insert(arr, timestr)
	end
	return arr
end

function GetTasks()
	local taskList={}
	for line in io.lines(sTaskListFile) do
		taskList[#taskList + 1] = SplitText(line)
	end
	return taskList
end

function setVars()
	--Scale MatrixTransformation
	HiddenTaskScaleX = 1 - 8/13
	HiddenTaskScaleY = 1 - 8/13
	NextTaskScaleX = 8/13
	NextTaskScaleY = 8/13
	CurrentTaskScaleX = 1
	CurrentTaskScaleY = 1
	PreviousTaskScaleX = 8/13
	PreviousTaskScaleY = 8/13
	
	--Font Size
	HiddenTaskSize = 10*ScaleFactor
	NextTaskSize= 10*ScaleFactor
	CurrentTaskSize = 10*ScaleFactor
	PreviousTaskSize = 10*ScaleFactor
	
	--Font Opacity
	HiddenTaskOpacity = 0
	PreviousTaskOpacity = 255
	
	--Y position
	LineSpacing = 4*ScaleFactor
	HiddenTaskY = 0
	NextTaskY = HiddenTaskSize*HiddenTaskScaleY + LineSpacing*HiddenTaskScaleY
	CurrentTaskY = NextTaskY + NextTaskSize*NextTaskScaleY + LineSpacing*NextTaskScaleY
	PreviousTaskY = CurrentTaskY + CurrentTaskSize*CurrentTaskScaleY + LineSpacing*CurrentTaskScaleY
	
	--Y position MatrixTransformation
	HiddenTaskMoveY = HiddenTaskY - HiddenTaskY*PreviousTaskScaleY
	NextTaskMoveY = NextTaskY - NextTaskY*NextTaskScaleY
	CurrentTaskMoveY = CurrentTaskY - CurrentTaskY*CurrentTaskScaleY
	PreviousTaskMoveY = PreviousTaskY - PreviousTaskY*PreviousTaskScaleY
	
	--X position
	X1 = 0*ScaleFactor
	X2 = 50*ScaleFactor
	
	--X position MatrixTransformation
	HiddenTaskMoveX = X1 - X1*HiddenTaskScaleX
	NextTaskMoveX = X1 - X1*NextTaskScaleX
	CurrentTaskMoveX = X1 - X1*CurrentTaskScaleX
	PreviousTaskMoveX = X1 - X1*PreviousTaskScaleX
	
	--Task content
	SKIN:Bang('!SetVariable', 'HiddenTaskTime', tasks[hiddenindex][COLUMN_INDEX_TASK_TIME])
	SKIN:Bang('!SetVariable', 'HiddenTaskName', tasks[hiddenindex][COLUMN_INDEX_TASK_NAME])
	SKIN:Bang('!SetVariable', 'NextTaskTime', tasks[nextindex][COLUMN_INDEX_TASK_TIME])
	SKIN:Bang('!SetVariable', 'NextTaskName', tasks[nextindex][COLUMN_INDEX_TASK_NAME])
	SKIN:Bang('!SetVariable', 'CurrentTaskTime', tasks[index][COLUMN_INDEX_TASK_TIME])
	SKIN:Bang('!SetVariable', 'CurrentTaskName', tasks[index][COLUMN_INDEX_TASK_NAME])
	SKIN:Bang('!SetVariable', 'PreviousTaskTime', tasks[preindex][COLUMN_INDEX_TASK_TIME])
	SKIN:Bang('!SetVariable', 'PreviousTaskName', tasks[preindex][COLUMN_INDEX_TASK_NAME])
	--Size
	SKIN:Bang('!SetVariable', 'HiddenTaskSize', HiddenTaskSize)
	SKIN:Bang('!SetVariable', 'NextTaskSize', NextTaskSize)
	SKIN:Bang('!SetVariable', 'PreviousTaskSize', PreviousTaskSize)
	SKIN:Bang('!SetVariable', 'CurrentTaskSize', CurrentTaskSize)
	--Opacity & Color
	SKIN:Bang('!SetVariable', 'PreviousTaskOpacity', ''..FontColor..','..PreviousTaskOpacity..'')
	SKIN:Bang('!SetVariable', 'HiddenTaskOpacity', ''..FontColor..','..HiddenTaskOpacity..'')
	--Y pos
	SKIN:Bang('!SetVariable', 'HiddenTaskY', HiddenTaskY)
	SKIN:Bang('!SetVariable', 'NextTaskY', NextTaskY)
	SKIN:Bang('!SetVariable', 'PreviousTaskY', PreviousTaskY)
	SKIN:Bang('!SetVariable', 'CurrentTaskY', CurrentTaskY)
	--X pos
	SKIN:Bang('!SetVariable', 'X1', X1)
	SKIN:Bang('!SetVariable', 'X2', X2)
	
	--Scale MatrixTransformation
	SKIN:Bang('!SetVariable', 'HiddenTaskScaleX', HiddenTaskScaleX)
	SKIN:Bang('!SetVariable', 'HiddenTaskScaleY', HiddenTaskScaleY)
	SKIN:Bang('!SetVariable', 'NextTaskScaleX', NextTaskScaleX)
	SKIN:Bang('!SetVariable', 'NextTaskScaleY', NextTaskScaleY)
	SKIN:Bang('!SetVariable', 'CurrentTaskScaleX', CurrentTaskScaleX)
	SKIN:Bang('!SetVariable', 'CurrentTaskScaleY', CurrentTaskScaleY)
	SKIN:Bang('!SetVariable', 'PreviousTaskScaleX', PreviousTaskScaleX)
	SKIN:Bang('!SetVariable', 'PreviousTaskScaleY', PreviousTaskScaleY)
	--Move MatrixTransformation
	SKIN:Bang('!SetVariable', 'HiddenTaskMoveX', HiddenTaskMoveX)
	SKIN:Bang('!SetVariable', 'HiddenTaskMoveY', HiddenTaskMoveY)
	SKIN:Bang('!SetVariable', 'NextTaskMoveX', NextTaskMoveX)
	SKIN:Bang('!SetVariable', 'NextTaskMoveY', NextTaskMoveY)
	SKIN:Bang('!SetVariable', 'CurrentTaskMoveX', CurrentTaskMoveX)
	SKIN:Bang('!SetVariable', 'CurrentTaskMoveY', CurrentTaskMoveY)
	SKIN:Bang('!SetVariable', 'PreviousTaskMoveX', PreviousTaskMoveX)
	SKIN:Bang('!SetVariable', 'PreviousTaskMoveY', PreviousTaskMoveY)	
	
	--TEMP
	tempHiddenTaskOpacity = HiddenTaskOpacity
	tempPreviousTaskOpacity = PreviousTaskOpacity
	
	tempNextTaskSize = NextTaskSize
	tempCurrentTaskSize = CurrentTaskSize*CurrentTaskScaleY
	
	tempHiddenTaskY = HiddenTaskY
	tempNextTaskY = NextTaskY
	tempCurrentTaskY = CurrentTaskY
	tempPreviousTaskY = PreviousTaskY
	
	tempHiddenTaskScaleY = HiddenTaskScaleY
	tempHiddenTaskScaleX = HiddenTaskScaleX
	tempNextTaskScaleY = NextTaskScaleY
	tempNextTaskScaleX = NextTaskScaleX
	tempCurrentTaskScaleY = CurrentTaskScaleY
	tempCurrentTaskScaleX = CurrentTaskScaleX
	tempPreviousTaskScaleY = PreviousTaskScaleY
	tempPreviousTaskScaleX = PreviousTaskScaleX
	
end

function moveVars()
	--Opacity
	deltaHiddenTaskOpacity = (PreviousTaskOpacity - HiddenTaskOpacity)/FPS
	deltaPreviousTaskOpacity = (HiddenTaskOpacity - PreviousTaskOpacity)/FPS
	
	tempHiddenTaskOpacity = tempHiddenTaskOpacity + deltaHiddenTaskOpacity
	tempPreviousTaskOpacity = tempPreviousTaskOpacity + deltaPreviousTaskOpacity
	
	--Y position
	deltaHiddenTaskY = (NextTaskY - HiddenTaskY)/FPS
	deltaNextTaskY = (CurrentTaskY - NextTaskY)/FPS
	deltaCurrentTaskY = (PreviousTaskY - CurrentTaskY)/FPS
	deltaPreviousTaskY =  ((PreviousTaskY + HiddenTaskSize + LineSpacing) - PreviousTaskY)/FPS
	
	tempHiddenTaskY = tempHiddenTaskY + deltaHiddenTaskY
	tempNextTaskY = tempNextTaskY + deltaNextTaskY
	tempCurrentTaskY = tempCurrentTaskY + deltaCurrentTaskY
	tempPreviousTaskY = tempPreviousTaskY + deltaHiddenTaskY
	
	--Scale MatrixTransformation
	deltaHiddenTaskScaleY = (NextTaskScaleY - HiddenTaskScaleY)/FPS
	deltaHiddenTaskScaleX  = (NextTaskScaleX - HiddenTaskScaleX)/FPS
	deltaNextTaskScaleY = (CurrentTaskScaleY - NextTaskScaleY)/FPS
	deltaNextTaskScaleX = (CurrentTaskScaleX - NextTaskScaleX)/FPS
	deltaCurrentTaskScaleY = (CurrentTaskScaleY - PreviousTaskScaleY)/FPS
	deltaCurrentTaskScaleX = (CurrentTaskScaleX - PreviousTaskScaleX)/FPS
	deltaPreviousTaskScaleY = (PreviousTaskScaleY - HiddenTaskScaleY)/FPS
	deltaPreviousTaskScaleX = (PreviousTaskScaleX - HiddenTaskScaleX)/FPS
	
	tempHiddenTaskScaleY = tempHiddenTaskScaleY + deltaHiddenTaskScaleY
	tempHiddenTaskScaleX = tempHiddenTaskScaleX + deltaHiddenTaskScaleX
	tempNextTaskScaleY = tempNextTaskScaleY + deltaNextTaskScaleY
	tempNextTaskScaleX = tempNextTaskScaleX + deltaNextTaskScaleX
	tempCurrentTaskScaleY = tempCurrentTaskScaleY - deltaCurrentTaskScaleY
	tempCurrentTaskScaleX = tempCurrentTaskScaleX - deltaCurrentTaskScaleX
	tempPreviousTaskScaleY = tempPreviousTaskScaleY - deltaPreviousTaskScaleY
	tempPreviousTaskScaleX = tempPreviousTaskScaleX - deltaPreviousTaskScaleX

	--Move MatrixTransformation
	tempHiddenTaskMoveY = tempHiddenTaskY - tempHiddenTaskY*tempHiddenTaskScaleY
	tempHiddenTaskMoveX = X1 - X1*tempHiddenTaskScaleX
	tempNextTaskMoveY = tempNextTaskY - tempNextTaskY*tempNextTaskScaleY
	tempNextTaskMoveX = X1 - X1*tempNextTaskScaleX
	tempCurrentTaskMoveY = tempCurrentTaskY - tempCurrentTaskY*tempCurrentTaskScaleY
	tempCurrentTaskMoveX = X1 - X1*tempCurrentTaskScaleX
	tempPreviousTaskMoveY = tempPreviousTaskY - tempPreviousTaskY*tempPreviousTaskScaleY
	tempPreviousTaskMoveX = X1 - X1*tempPreviousTaskScaleX

	--Opacity
	SKIN:Bang('!SetVariable', 'HiddenTaskOpacity', ''..FontColor..','..tempHiddenTaskOpacity..'')
	SKIN:Bang('!SetVariable', 'PreviousTaskOpacity', ''..FontColor..','..tempPreviousTaskOpacity..'')
	--Y position
	SKIN:Bang('!SetVariable', 'HiddenTaskY', ''..tempHiddenTaskY..'')
	SKIN:Bang('!SetVariable', 'NextTaskY', ''..tempNextTaskY..'')
	SKIN:Bang('!SetVariable', 'CurrentTaskY', ''..tempCurrentTaskY..'')
	SKIN:Bang('!SetVariable', 'PreviousTaskY', ''..tempPreviousTaskY..'')
	--Scale
	SKIN:Bang('!SetVariable', 'HiddenTaskScaleX', tempHiddenTaskScaleX)
	SKIN:Bang('!SetVariable', 'HiddenTaskScaleY', tempHiddenTaskScaleY)
	SKIN:Bang('!SetVariable', 'NextTaskScaleX', tempNextTaskScaleX)
	SKIN:Bang('!SetVariable', 'NextTaskScaleY', tempNextTaskScaleY)
	SKIN:Bang('!SetVariable', 'CurrentTaskScaleX', tempCurrentTaskScaleX)
	SKIN:Bang('!SetVariable', 'CurrentTaskScaleY', tempCurrentTaskScaleY)
	SKIN:Bang('!SetVariable', 'PreviousTaskScaleX', tempPreviousTaskScaleX)
	SKIN:Bang('!SetVariable', 'PreviousTaskScaleY', tempPreviousTaskScaleY)
	
	--Move
	SKIN:Bang('!SetVariable', 'HiddenTaskMoveX', tempHiddenTaskMoveX)
	SKIN:Bang('!SetVariable', 'HiddenTaskMoveY', tempHiddenTaskMoveY)	
	SKIN:Bang('!SetVariable', 'NextTaskMoveX', tempNextTaskMoveX)
	SKIN:Bang('!SetVariable', 'NextTaskMoveY', tempNextTaskMoveY)	
	SKIN:Bang('!SetVariable', 'CurrentTaskMoveX', tempCurrentTaskMoveX)
	SKIN:Bang('!SetVariable', 'CurrentTaskMoveY', tempCurrentTaskMoveY)	
	SKIN:Bang('!SetVariable', 'PreviousTaskMoveX', tempPreviousTaskMoveX)
	SKIN:Bang('!SetVariable', 'PreviousTaskMoveY', tempPreviousTaskMoveY)	

	
	if tempCurrentTaskScaleY <= PreviousTaskScaleY then
		done = true
	else
		done = false
	end
end

function GetIndex(list)
	local CurrentTime = os.date("%H:%M", os.time())
	for i=1,#list,1 do
		if CurrentTime < list[i][COLUMN_INDEX_TASK_TIME] then
			return i - 1
		end
	end
end

function GetFPS()
	local CurrentTime = os.time()
	counter = counter + 1
	if (CurrentTime - StartTime) >= 1 then
		FPS = counter / (CurrentTime - StartTime) or 5
		counter = 0
		StartTime = CurrentTime
	end
end

function activate()
	--function starts reshuffling tasks
	Refresh = SKIN:GetVariable('Refresh')
	if tonumber(Refresh) == 1 then done = false else done = true end
	if tempCurrentTaskScaleY <= PreviousTaskScaleY then
		done = true
	end
end

function Update()
	tasks = GetTasks()
	
	--Mode
	if tonumber(mode) == 1 then
		GetFPS()		
	else
		FPS = smoothness
	end
	
	--Index
	index = GetIndex(tasks) or #tasks
	if index < 1 then index = #tasks end --або 1
	preindex = index - 1
	if preindex < 1 then preindex = #tasks end
	nextindex = index + 1
	if nextindex > #tasks then nextindex = 1 end
	hiddenindex = nextindex + 1
	if hiddenindex > #tasks then hiddenindex = 1 end
	
	--Vars
	if index ~= temp or done == false then
		temp = index
		moveVars()
	else
		temp = index
		setVars()
	end
	
	-- activate() --debug
	
	return true
end