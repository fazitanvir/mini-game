local nbrDisplaying = 1

-- RegisterCommand('me', function(source, args, raw)
--     local text = string.sub(raw, 4)
--     TriggerServerEvent('3dme:shareDisplay', text)
-- end)


RegisterNetEvent('3dme:triggerDisplay', function(text, source)
    local offset = 1 + (nbrDisplaying*0.15)
    Display(GetPlayerFromServerId(source), text, offset)
end)


function Display(mePlayer, text, offset)
    local displaying = true

CreateThread(function()
    Wait(5000)
    displaying = false
end)
	
CreateThread(function()
    nbrDisplaying = nbrDisplaying + 1
    while displaying do
        Wait(0)
        local coordsMe = GetEntityCoords(GetPlayerPed(mePlayer), false)
        local coords = GetEntityCoords(PlayerPedId(), false)
        local dist = Vdist2(coordsMe, coords)
        if dist < 500 then
             DrawText3D(coordsMe['x'], coordsMe['y'], coordsMe['z']+offset-1.250, text)
        end
    end
    nbrDisplaying = nbrDisplaying - 1
    end)
end

function DrawText3D(x,y,z, text)
  local onScreen, _x, _y = World3dToScreen2d(x, y, z)
  local p = GetGameplayCamCoords()
  local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
  local scale = (1 / distance) * 2
  local fov = (1 / GetGameplayCamFov()) * 100
  local scale = scale * fov
  if onScreen then
		SetTextScale(0.35, 0.35)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x,_y)
		local factor = (string.len(text)) / 370
		DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 150)
    end
end

--//Mini Games

-- Animations
animDict1 = "mp_player_int_upperwank"
animDict2 = "anim@mp_player_intcelebrationmale@wank"
anim1 = "mp_player_int_wank_01_enter"
anim2 = "mp_player_int_wank_01_exit"
anim3 = "wank"

-- Display 3D Text with 3dme
function DisplayText(text)
	TriggerServerEvent("3dme:shareDisplay", text) -- Edit if using a 3dme alternative
end

-- Get Animations
function loadAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end

-- Rock, Paper, Scissors
RegisterCommand("rps", function(source, args, command)
	local text = rpsPrefix
	local options = {"Rock!", "Paper!", "Scissors!"}
	local choice = ""
	if args[1] == "r" then
		choice = options[1]
	elseif args[1] == "p" then
		choice = options[2]
	elseif args[1] == "s" then
		choice = options[3]
	else
		return
	end
	text = text ..choice
	loadAnimDict(animDict1)
	TaskPlayAnim(PlayerPedId(-1), animDict1, anim1, 8.0, -8, -1, 8, 0, 0, 0, 0)
	Wait(700)
	DisplayText(text)
end)
TriggerEvent("chat:addSuggestion", "/rps", "Rock, Paper, Scissors", {
    { name="r/p/s", help="r=Rock, p=Paper or s=Scissors" },
})

-- Flip Coin
RegisterCommand("flip", function(source, args, command)
	local text = flipPrefix
	local options = {"Heads", "Tails"}
	text = text ..options[math.random(1, #options)]
	loadAnimDict(animDict1)
	TaskPlayAnim(PlayerPedId(-1), animDict1, anim2, 8.0, -8, -1, 8, 0, 0, 0, 0)
	Wait(700)
	DisplayText(text)
end)
TriggerEvent("chat:addSuggestion", "/flip", "Flip a coin")

-- Roll Dice
RegisterCommand("roll", function(source, args, command)
	local text = rollPrefix
	local dice = {}
	local numOfDice = tonumber(args[1]) and tonumber(args[1]) or 1
	local numOfSides = tonumber(args[2]) and tonumber(args[2]) or 6
	if (numOfDice < 1 or numOfDice > maxDice) then numOfDice = 1 end
	if (numOfSides < 2 or numOfSides > maxDiceSides) then numOfSides = 6 end
	for i = 1, numOfDice do
		dice[i] = math.random(1, numOfSides)
		text = text ..dice[i] .."/" ..numOfSides .."  "
	end
	loadAnimDict(animDict2)
	TaskPlayAnim(PlayerPedId(-1), animDict2, anim3, 8.0, 1.0, -1, 49, 0, 0, 0, 0)
	Wait(1500)
	ClearPedTasks(GetPlayerPed(-1))
	DisplayText(text)
end)

TriggerEvent("chat:addSuggestion", "/roll", "Roll dice", {
    { name="Dice", help="Number of dice (1-" ..maxDice ..")" },
    { name="Sides", help="Number of sides (2-" ..maxDiceSides ..")" },
})
