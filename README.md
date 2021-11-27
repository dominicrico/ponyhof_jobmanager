
# Ponyhof Job Manager
Job manager for admins and bosses.

## Features
**Admin**
- Manage bosses and jobs
- Multilanguage

**Boss**
- Hire and fire employees
- Salary management
- Promote and degrade employees

**Employees**
- Get on or off duty at any job
- Receive salary

**UI**
- Extends ui with job name and grade


## Requirements
- [ghmattimysql](https://github.com/GHMatti/ghmattimysql/releases)
- [VORP-Core](https://github.com/VORPCORE/VORP-Core/releases)
- [VORP-Inputs](https://github.com/VORPCORE/VORP-Inputs/releases)
- [VORP-Character](https://github.com/VORPCORE/VORP-Character/releases)

## How to install
- Download files or clone repository
- Copy and paste ``ponyhof_jobmanager`` folder to resources/
- Import ``jobmanager.sql`` to your database
- Add `ensure ponyhof_jobmanager` to your ``server.cfg`` file
- Edit ``config.lua`` to your needs
- Restart your server