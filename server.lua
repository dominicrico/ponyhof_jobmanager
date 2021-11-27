local VorpCore = {}
local salaryTable = []

TriggerEvent("getCore",function(core)
    VorpCore = core
end)

exports.ghmattimysql:execute('SELECT * FROM jobsalary', {}, function(result)
	salaryTable = result
end)

-- ADMIN MANAGER --

RegisterServerEvent('pony_job_manager:check_admin')
AddEventHandler('pony_job_manager:check_admin', function()
    local User = VorpCore.getUser(source)
    local _source = source
    local Character = User.getUsedCharacter
    local targetidentifier = Character.identifier
    local targetcharidentifier = Character.charIdentifier
    local group = Character.group

    TriggerClientEvent('pony_job_manager:get_group', _source, group)
end)

-- Hire Boss for a Job
RegisterServerEvent('pony_job_manager:hire_boss')
AddEventHandler('pony_job_manager:hire_boss', function(target, job)
  local Character2 = VorpCore.getUser(target).getUsedCharacter
  local targetidentifier = Character2.identifier
  local targetcharidentifier = Character2.charIdentifier
  local _source = source

  exports.ghmattimysql:execute('SELECT * FROM jobmanager WHERE identifier=@identifier AND charidentifier=@charidentifier', {['identifier'] = targetidentifier, ['charidentifier'] = targetcharidentifier}, function(result)
    if result[1] ~= nil then
      print("player" .. targetidentifier .. "is already a boss")
    else
      exports.ghmattimysql:execute('INSERT INTO jobmanager (identifier, charidentifier, jobname) VALUES (@identifier, @charidentifier, @job)', {['identifier'] = targetidentifier, ['charidentifier'] = targetcharidentifier, ['job'] = job},function (result)
        if result.affectedRows < 1 then
          log("error", "failed to hire as boss for player " .. targetidentifier)
        end
      end)
    end

  end)
end) 

-- Fire Boss for a Job
RegisterServerEvent('pony_job_manager:fire_boss')
AddEventHandler('pony_job_manager:fire_boss', function (target)
    local Character2 = VorpCore.getUser(target).getUsedCharacter
    local targetidentifier = Character2.identifier
    local targetcharidentifier = Character2.charIdentifier
    local _source = source

  exports.ghmattimysql:execute('DELETE FROM jobmanager WHERE identifier=@identifier AND charidentifier=@charidentifier', { ['identifier'] = targetidentifier, ['charidentifier'] = targetcharidentifier},function (result)
    if result.affectedRows < 1 then
      log("error", "failed to fire boss for player " .. targetidentifier)
    end

  end)
end)

-- BOSS MANAGER --

RegisterServerEvent('pony_job_manager:check_boss')
AddEventHandler('pony_job_manager:check_boss', function()
    local User = VorpCore.getUser(source)
    local _source = source
    local Character = User.getUsedCharacter
    local u_identifier = Character.identifier
    local u_charid = Character.charIdentifier

    exports.ghmattimysql:execute('SELECT * FROM jobmanager WHERE identifier=@identifier AND charidentifier=@charidentifier', {['identifier'] = u_identifier, ['charidentifier'] = u_charid}, function(result)
        if result[1] ~= nil then
          jobname = result[1].jobname
          TriggerClientEvent('pony_job_manager:open', _source, jobname)
        else
          print("Not a boss")
        end
    
    end)
end)

-- Set/Update Job grade
RegisterServerEvent('pony_job_manager:set_grade_name')
AddEventHandler('pony_job_manager:set_grade_name', function(job, grade, name)
  local Character2 = VorpCore.getUser(target).getUsedCharacter
  local targetidentifier = Character2.identifier
  local targetcharidentifier = Character2.charIdentifier
  local _source = source

  exports.ghmattimysql:execute('SELECT * FROM jobgrades WHERE identifier=@identifier AND grade=@grade', {['identifier'] = job, ['grade'] = grade}, function(result)
    if result[1] ~= nil then
      exports.ghmattimysql:execute('UPDATE jobgrades SET gradename=@gradename WHERE identifier=@identifier AND grade=@grade', {['identifier'] = job, ['grade'] = grade, ['gradename'] = name},function (result)
        if result.affectedRows < 1 then
          log("error", "failed to update grade name")
        end
      end)
    else
      exports.ghmattimysql:execute('INSERT INTO jobgrades (identifier, grade, gradename) VALUES (@identifier, @grade, @gradename)', {['identifier'] = job, ['grade'] = grade, ['gradename'] = name},function (result)
        if result.affectedRows < 1 then
          log("error", "failed to add new grade name")
        end
      end)
    end

  end)
end) 

-- Delete Job grade
RegisterServerEvent('pony_job_manager:delete_grade_name')
AddEventHandler('pony_job_manager:delete_grade_name', function(job, grade)
  local Character2 = VorpCore.getUser(target).getUsedCharacter
  local targetidentifier = Character2.identifier
  local targetcharidentifier = Character2.charIdentifier
  local _source = source

  exports.ghmattimysql:execute('SELECT * FROM jobgrades WHERE identifier=@identifier AND grade=@grade', {['identifier'] = job, ['grade'] = grade}, function(result)
    if result[1] ~= nil then
      print("job grade" .. grade .. "not found")
    else
      exports.ghmattimysql:execute('DELETE FROM jobgrades WHERE identifier=@identifier AND grade=@grade', {['identifier'] = job, ['grade'] = grade},function (result)
        if result.affectedRows < 1 then
          log("error", "failed to delete grade")
        end
      end)
    end

  end)
end) 

-- Hire Employee for Job

-- Fire Employee for Job

-- Promote Employee for Job

-- Degrate Employee for Job

-- EMPLOYEE STUFF --

-- Get Job grade name for ui

RegisterServerEvent('pony_job_manager:get_grade')
AddEventHandler('pony_job_manager:get_grade', function()
    local User = VorpCore.getUser(source)
    local _source = source
    local Character = User.getUsedCharacter
    local u_job = Character.job
    local u_grade = Character.jobgrade

    exports.ghmattimysql:execute('SELECT * FROM jobgrades WHERE identifier=@identifier AND grade=@grade', {['identifier'] = u_job, ['grade'] = u_grade}, function(result)
        if result[1] ~= nil then
					local U = {}
					U.job = Character.job
					U.grade result[1].gradename
          TriggerClientEvent('pony_job_manager:set_grade', _source, U)
        else
          print("grade not found with id" .. u_grade)
        end
    
    end)
end)

-- Get on or off duty for all jobs

RegisterServerEvent('pony_job_manager:switch_duty')
AddEventHandler('pony_job_manager:switch_duty', function()
  local _source = source
  local Character = VorpCore.getUser(_source).getUsedCharacter

	if string.sub(Character.job, 0, 3) == 'off' then
		TriggerServerEvent("pony_job_manager:givejob", Character.charIdentifier, string.sub(Character.job, 4, -1), Character.jobgrade)
		TriggerClientEvent("vorp:TipRight", _source, Config.Notify_On_Duty, 20 * 1000)
	elseif string.sub(Character.job, 0, 3) ~= 'off' then
		TriggerServerEvent("pony_job_manager:givejob", Character.charIdentifier, 'off'..Character.job, Character.jobgrade)
		TriggerClientEvent("vorp:TipRight", _source, Config.Notify_Off_Duty, 20 * 1000)
	end
end)

-- Get payed for doing your job

RegisterServerEvent("pony_job_mangaer:pay_salary")
AddEventHandler("pony_job_mangaer:pay_salary", function(_verifyAntiAbuse)
	if _verifyAntiAbuse == "0x089027928098908" then
		local source = source

		for _k, _v in pairs(salaryTable) do
			local Character = VorpCore.getUser(source).getUsedCharacter
			
			if Character.job == _v.identifier then
				if _v.type == 'money' then
					Character.addCurrency(0, _v.salary)
					TriggerClientEvent("vorp:TipRight", _source, _U('received_money_salary', _v.salary), 20 * 1000)
				end

				if _v.type == 'gold' >= 1 then
					Character.addCurrency(1, _v.salary)
					TriggerClientEvent("vorp:TipRight", _source, _U('received_gold_salary', _v.salary), 20 * 1000)
				end

				if Config.XpPerJob >= 1 then
					Character.addXp(Config.XpPerJob)
					TriggerClientEvent("vorp:TipRight", _source, _U('received_xp_salary', Config.XpPerJob), 20 * 1000)
				end
			end
		end
end)