highScore = 0
function _init()
	pal()
	ASTEROID_POINTS = 100
	nextColor = 2
	stars = {}
	for i = 0, 500 do
		stars[i] = {}
		stars[i].x  = flr(rnd(128))
		stars[i].y  = flr(rnd(128))
		stars[i].s  = flr(rnd(2))
	end
	alarm0    = MakeAlarm(120,NextLevel)
	TITLE     = 1
	PLAYING   = 2
	enemySpeed=.2
	score     = 0
	lives     = 3
	gameState = TITLE
	player    = NewObject(63,102,7,4)
	player.w  = 16
	player.h  = 16
	gameOver  = false
	enemies   = {}
		for i = 1,15 do
			local e = NewObject(flr(rnd(128)),flr(rnd(128))-128,flr(rnd(5))+11,enemySpeed,270)
			add(enemies, e)
		end
	    shots = {}
	playerDeathSound = 0
	playerDeath = 0
	palcolor = 0
	
	
	greenAstroid = 11
	blueAstroid = 12
	redAstroid = 8
	purpleAstroid = 2
	yellowAstroid = 10
end

function _update60()
	if (gameState == TITLE) then
		UpdateTitle()
	elseif (gameState == PLAYING) then
		UpdateGame()
	end
end

function UpdateTitle()
	if (btnp(4) or btnp(5)) then
		gameState = PLAYING
	end
end

function UpdateGame()
	
	
	
	if (lives == 0) then
		Restart()
	end
	
	--if (score%500) then
	--	NextLevel()
	--end
	
	--AddToScore(score)

	DrawGame()
	
	if (playerDeath == 0) then
		if btnp(LEFT) then
			player.x -=4
		elseif btnp(RIGHT) then
			player.x +=4
		end
	end
	
	if (player.x > 124) then
		player.x = 124
	elseif (player.x < -2) then
		player.x = -2
	end
	
	if (playerDeath == 0) then
		if (btnp(BUTTON1) or btnp(UP)) then
			sfx(0)
			--makes a new shot
			
			--local sh = {x=player.x-1, y=player.y-8}
			local sh =NewObject(player.x-1,player.y-8,10,3,0)
			add( shots, sh ) 
		end
	end
	
	--update shots
	for s in all (shots) do 
		s.y -= 2
	end
	CleanupShots()
	
		for e in all (enemies) do
			MoveObject(e)			
			if (e.x > 128) then
				e.x = flr(rnd(128))
				e.y = flr(rnd(25 ))-25
			end		
			if (e.y > 112) then
				e.y = flr(rnd(10 ))-10
				e.x = flr(rnd(128))
			end
			if (RectHit(e,player)) then
				lives -= 1
				e.y = flr(rnd(10 ))-10
				e.x = flr(rnd(128))
				sfx(2)
			end
		end
	
	for s in all (shots) do
		for e in all (enemies) do
			if (RectHit(s, e)) then
				AddToScore(1)
				e.y = flr(rnd(10 ))-10
				e.x = flr(rnd(128))
				del(shots,s)
				sfx(1)
			end
		end
	end
	
end

function CleanupShots()
	for s in all (shots) do
		if (s.y < -10) then
			--delete s from list of shots
			del(shots,s)
		end
	end
end


function _draw()
	if (gameState == TITLE) then
		printh"gamestate: title"
		DrawTitle()
	elseif (gameState == PLAYING) then
		printh"gamestate: game"
		DrawGame()
	end
end

function DrawTitle()
	cls()
	for i = 0, 500 do
		spr(stars[i].s, stars[i].x, stars[i].y)
	end
	
	rectfill(40,56,92,63,black)
	rectfill(36,121,91,127,black)
	spr(32,39,55,7,1) 
	--print("astrosmash",47,55,blue)
	print("high score: "..highScore, 40,122, blue)
end

function DrawGame()
	cls()
	DrawObject(player)
	for i = 0, 500 do
		spr(stars[i].s, stars[i].x, stars[i].y)
	end
	rectfill(0,115,128,128,blue)
	print("score: "..score, 2,116,light_blue)
	print("lives: "..lives, 2,122,light_blue)
	if (lives == 3) then
		spr(4,118,117)
		spr(4,109,117)
		spr(4,100,117)
	elseif (lives > 3) then
		spr(9,91,117)
		spr(4,118,117)
		spr(4,109,117)
		spr(4,100,117)
	elseif (lives == 2) then
		spr(4,118,117)
		spr(4,109,117)
	elseif (lives == 1) then
		spr(4,118,117)
	elseif (lives == 0) then
		print("  ")
	else
		print("error counting lives",47,119)
	end
		
	print("   high score: ", 40,116, light_blue)
	print("      "..highScore, 40,122, light_blue)
	if (highScore < score) then
		highScore = score
	end
	--draw each shot
	for s in all (shots) do
		spr(10,s.x,s.y)
	end
	
	
	
	for e in all (enemies) do
		e.Draw(e)
	end

	for e in all (enemies) do
		if (e.y > 128) then
			e.y = -8
			e.x = flr(rnd(128))
		end
	end
	
	
	if(lives == 0)then
		print("game over!",45,63)
		print("press any button to continue", 9,70)
	end
	
	
	
end




function  Restart()
	playerDeath = 1
	if (playerDeathSound == 0) then
		sfx(4)
		playerDeathSound = 1
	end
	
	print("game over!",45,63)
	print("press any button to continue", 9,70)
	for e in all (enemies) do
		e.speed = 0
	end
	if (btnp(BUTTON1) or btnp(BUTTON2)) then 
		_init()
		--gameState = TITLE
	end
end

	

--function NextLevel()
--	sfx(9)
--	enemySpeed += .1
--	palcolor+=1
--	pal(palcolor)
	
--end

	
function AddToScore(amount)
	local oldRemainder = score % 500 -- 0-999
	score = score + amount
	local newRemainder = score % 500 -- 0-999
	palStart = 2
	if (newRemainder == 0 or (newRemainder < oldRemainder)) then
		local tempColor = nextColor 
		for i=1,15 do 
			pal(i, tempColor)
			tempColor += 1
			if (tempColor == 16) then 
				tempColor = 1
			end
		end
		
		--add 1 to the next starting in the palette
		nextColor += 1
		if (nextColor == 16) then 
			nextColor = 1
		end


		sfx(9)
		enemySpeed += .1
	end
end
	