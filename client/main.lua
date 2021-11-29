-- PONY JOB MANAGER

-- ADMIN STUFF

local user_group = ""

RegisterNetEvent('pony_job_manager:get_group')
AddEventHandler('pony_job_manager:get_group', function(cb)
    user_group = group
end)

RegisterCommand("hireboss", function(source, args)
    TriggerServerEvent("pony_job_manager:check_admin")
    Wait(500)
    if has_value(Config.JobManager, user_group) then
        -- Set Player as boss for a job : playerId - job
        if args[1] ~= nil and args[2] ~= nil then 
            TriggerServerEvent('pony_job_manager:hire_boss', args[1], args[2])
            TriggerClientEvent("vorp:TipRight", source, _U('boss_hired_msg', args[2]), 20 * 1000)
        end
    else
        Citizen.Trace('Jobmanager check failed')
    end
end)

RegisterCommand("fireboss", function(source, args)
    TriggerServerEvent("pony_job_manager:check_admin")
    Wait(500)
    if has_value(Config.JobManager, user_group) then
        -- Revoke boss license for a job : playerId
        if args[1] ~= nil and args[2] ~= nil then 
            TriggerServerEvent('pony_job_manager:fire_boss', args[1])
            TriggerClientEvent("vorp:TipRight", source, _U('boss_fired_msg', args[2]), 20 * 1000)
        end
    else
        Citizen.Trace('Jobmanager check failed')
    end
end)

-- BOSS STUFF

RegisterNetEvent('pony_job_manager:open')
AddEventHandler('pony_job_manager:open', function(...)
    log("open warmenu client")
	WarMenu.OpenMenu('boss')
end)

-- EMPLOYEE STUFF

RegisterNetEvent('pony_job_manager:set_grade')
AddEventHandler('pony_job_manager:set_grade', function(cb)
	local User = cb

	SendNUIMessage({
		isJob = true,
		name = User.job,
		grade = User.grade
	})
end)

-- Start on character select payment and stuff
AddEventHandler("vorp:SelectedCharacter", function()
	Citizen.CreateThread(function(...)
		-- Get payed for your job
		while true do
            -- Get current Job grade name
		    TriggerServerEvent("pony_job_manager:get_grade")

			Citizen.Wait(Config.SalaryPeriod)
				TriggerServerEvent('pony_job_mangaer:pay_salary',"0x089027928098908_");
			end
	end)
end)

