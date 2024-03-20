--alarm library for Pico-8

alarms = {} -- list of alarms

function MakeAlarm (ticks, func)
	local a = {}
	a.ticks = ticks
	a.Action = func
	add(alarms, a)
	return a
end

function UpdateAlarm(alarm)

	if (alarm.ticks > 0) then
		alarm.ticks -= 1 -- subtacting 1 from the ticks value
	elseif (alarm.ticks == 0) then
		alarm.ticks = -1 -- stop countdown
		alarm.Action()
	end
end

function UpdateAlarms()
	foreach (alarms, UpdateAlarm)
end

--start/restart an alarm
function StartAlarm(alarm , t)
	if (alarm.ticks == -1) then
		alarm.ticks = t
	end
end

function RestartAlarm(alarm, t)
	StartAlarm(alarm, t)
end

function NewAlarm(ticks, func)
	MakeAlarm (ticks, func)
end