return function(cutscene)
	Game.world.fader.alpha = 1
	Game.world.fader.color = {0, 0, 0}
	for _,music in ipairs(Music.getPlaying()) do
        music:stop()
    end

	local DELTARUNE = DELTARUNE_LOGO()
	DELTARUNE:setLayer(0)
	Game.stage:addChild(DELTARUNE)
	DELTARUNE:setPosition(DELTARUNE:localToScreenPos())
	local FH_logo = Sprite("kristal/title_logo", 120, 170)
	FH_logo:setScale(2.5)
	FH_logo.alpha = 0
	Game.stage:addChild(FH_logo)

	cutscene:wait(function()
		return DELTARUNE.animation_phase == 1
	end)

	cutscene:wait(2)
	local function createParticle(x, y)
        local sprite = Sprite("effects/icespell/snowflake", x, y)
        sprite:setOrigin(0.5, 0.5)
        sprite:setScale(1.5*2)
        sprite.layer = 2
        Game.stage:addChild(sprite)
        return sprite
    end

    local x, y = SCREEN_WIDTH/2, SCREEN_HEIGHT/2

    local particles = {}
    cutscene:wait(1/30)
    Assets.playSound("icespell")
    particles[1] = createParticle(x-25*2, y-20*2)
    cutscene:wait(3/30)
    particles[2] = createParticle(x+25*2, y-20*2)
    cutscene:wait(3/30)
    particles[3] = createParticle(x, y+20*2)
    cutscene:wait(3/30)
    Game.stage:addChild(IceSpellBurst(x, y))
    for _,particle in ipairs(particles) do
        for i = 0, 5 do
            local effect = IceSpellEffect(particle.x, particle.y)
            effect:setScale(0.75*2)
            effect.physics.direction = math.rad(60 * i)
            effect.physics.speed = 8
            effect.physics.friction = 0.2
            effect.layer = 1
            Game.stage:addChild(effect)
        end
    end
    cutscene:fadeOut(0, {global=true, color={1, 1, 1}})
    DELTARUNE:remove()
    FH_logo.alpha = 1
    cutscene:wait(1/30)
    for _,particle in ipairs(particles) do
        particle:remove()
    end
    cutscene:wait(cutscene:fadeIn(1, {global=true}))
    cutscene:wait(2)
    local credits = FullCreditsText()
    credits.layer = 2
    Game.stage:addChild(credits)
end