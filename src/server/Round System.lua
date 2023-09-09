local Players = game:GetService("Players")

local Settings = {
    startThreshold = 1; -- Minimum players to begin round
	Timer = 30; -- In Seconds
	Buffer = true;
}

local roundSystem = {
	
	-- Players
	currentPlayers = 0;
	Players = {};
	
	-- Connections
	joinConn = nil;
	leaveConn = nil;
	
	-- Misc.
	queueActive = false;
	roundActive = false;
}

-- General
function roundSystem:startQueue()
	self.queueActive = true
	task.spawn(function()
		
		-- Starting queue, allowing buffer for players to join before true queue starts (if active)
		if Settings.Buffer then
			for seconds = Settings.Timer, -1 do
				print(seconds)
				task.wait(1)
			end
		end

	end)
end

-- Detection
function roundSystem:start()
	
end

-- Players
function roundSystem:addPlayer(plr : Player)
	table.insert(self.Players,plr.UserId)
	roundSystem:adjustPlayerCount()
end

function roundSystem:kickPlayer(plr : Player)
	self.Players[plr.UserId] = nil
	roundSystem:adjustPlayerCount()
end

function roundSystem:adjustPlayerCount()
	self.currentPlayers = #Players
end

function roundSystem:establishConnections()
	
	for _ , plr in Players:GetPlayers() do
		if not table.find(self.Players,plr.UserId) then
			roundSystem:addPlayer(plr)
		end
	end
	
	self.joinConn = Players.PlayerAdded:Connect(function(plr)
		roundSystem:addPlayer(plr)
	end)
	
	self.leaveConn = Players.PlayerRemoving:Connect(function(plr)
		roundSystem:kickPlayer(plr)
	end)

end

function roundSystem:removeConnections()
	self.joinConn:Disconnect()
	self.leaveConn:Disconnect()
	self.joinConn = nil;
	self.leaveConn = nil;
end

function roundSystem.init()
	
	roundSystem:establishConnections()
	
end

return roundSystem
