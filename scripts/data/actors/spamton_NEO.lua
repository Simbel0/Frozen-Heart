local actor, super = Class(Actor, "spamton_neo")

function actor:init()
    super:init(self)

    -- Display name (optional)
    self.name = "Spamton NEO"

    -- Width and height for this actor, used to determine its center
    self.width = 82
    self.height = 89

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    --self.hitbox = {0, 25, 19, 14}

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {1, 0, 0}

    -- Whether this actor flips horizontally (optional, values are "right" or "left", indicating the flip direction)
    self.flip = nil

    -- Path to this actor's sprites (defaults to "")
    self.path = "enemies/spamton_neo"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "idle"

    -- Sound to play when this actor speaks (optional)
    self.voice = "sneo"
    -- Path to this actor's portrait for dialogue (optional)
    self.portrait_path = nil
    -- Offset position for this actor's portrait (optional)
    self.portrait_offset = nil

    -- Whether this actor as a follower will blush when close to the player
    self.can_blush = false

    -- Table of talk sprites and their talk speeds (default 0.25)
    self.talk_sprites = {}

    -- Table of sprite animations
    self.animations = {
        -- Looping animation with 0.25 seconds between each frame
        -- (even though there's only 1 idle frame)
        ["idle"] = {"idle", 0.25, true}
    }

    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {
        -- Since the width and height is the idle sprite size, the offset is 0,0
        ["idle"] = {0, 0}
    }

    self.sneo={}
    self.sneo_anim="idle"
    self.frozenstate=1
end

function actor:onSpriteUpdate(sprite)
    print(self.sneo_anim)

    if self.frozenstate==1 then
        self.sneo["arml"].frozen=true
        if self.sneo["arml"].freeze_progress<1 then
            Game.battle.timer:tween(20/30, self.sneo["arml"], {freeze_progress = 1})
        end
        self.sneo["wingl"].frozen=true
        if self.sneo["wingl"].freeze_progress<1 then
            Game.battle.timer:tween(20/30, self.sneo["wingl"], {freeze_progress = 1})
        end
    end

    if self.sneo_anim == "idle" then
        self.sneo["body"].rotation = math.rad(0+math.sin(Kristal.getTime()*4)*17)
        if self.frozenstate<1 then
            self.sneo["arml"].rotation = math.rad(0+math.sin(Kristal.getTime()*2)*17)
            self.sneo["wingl"].rotation = math.rad(0-math.sin(Kristal.getTime()*2)*9)
        end
        self.sneo["armr"].rotation = math.rad(0+math.sin(Kristal.getTime()*4.4)*17)
        self.sneo["legl"].rotation = math.rad(0+math.sin(Kristal.getTime()*2.5)*17)
        self.sneo["legr"].rotation = math.rad(0+math.sin(Kristal.getTime()*2.3)*17)
        self.sneo["wingr"].rotation = math.rad(0+math.sin(Kristal.getTime()*5)*17)
    end

    for i,v in pairs(self.sneo["strings"]) do
        if v.thiccString then
            v.x=v.ori_x+(math.sin(Kristal.getTime()*0.1)*2)
        end
    end
    super:onSpriteUpdate(self, sprite)
end

function actor:onSpriteInit(sprite)
    sprite.alpha=0
    if not self.sneo["head"] then
        self.sneo["head"]=FreezingSprite("head", sprite.width/2, sprite.height/2, nil, nil, "enemies/spamton_neo/normal")
        self.sneo["head"]:setOrigin(0.5,0.5)
        self.sneo["head"]:play(1/4)
        self.sneo["body"]=FreezingSprite("body", sprite.width/2, sprite.height/2, nil, nil, "enemies/spamton_neo/normal")
        self.sneo["body"]:setOrigin(0.5,0.5)
        self.sneo["arml"]=FreezingSprite("arml", sprite.width/2, sprite.height/2, nil, nil, "enemies/spamton_neo/normal")
        self.sneo["arml"]:setOrigin(0.5,0.5)
        self.sneo["armr"]=FreezingSprite("armr", sprite.width/2, sprite.height/2, nil, nil, "enemies/spamton_neo/normal")
        self.sneo["armr"]:setOrigin(0.5,0.5)
        self.sneo["legl"]=FreezingSprite("legl", sprite.width/2, sprite.height/2, nil, nil, "enemies/spamton_neo/normal")
        self.sneo["legl"]:setOrigin(0.5,0.5)
        self.sneo["legr"]=FreezingSprite("legr", sprite.width/2, sprite.height/2, nil, nil, "enemies/spamton_neo/normal")
        self.sneo["legr"]:setOrigin(0.5,0.5)
        self.sneo["wingl"]=FreezingSprite("wingl", sprite.width/2, sprite.height/2, nil, nil, "enemies/spamton_neo/normal")
        self.sneo["wingl"]:setOrigin(0.5,0.5)
        self.sneo["wingr"]=FreezingSprite("wingr", sprite.width/2, sprite.height/2, nil, nil, "enemies/spamton_neo/normal")
        self.sneo["wingr"]:setOrigin(0.5,0.5)
        for i,v in pairs(self.sneo) do
            sprite:addChild(v)
            v.frozen=false
            v.freeze_progress=0
            v:setLayer(sprite.layer)
        end
        self.sneo["head"]:setLayer(self.sneo["body"].layer+10)
        self.sneo["body"]:setLayer(self.sneo["body"].layer)
        self.sneo["body"]:shiftOrigin(0.27, 0.4)
        self.sneo["arml"]:setLayer(self.sneo["body"].layer-3)
        self.sneo["arml"]:shiftOrigin(0.25, 0.44)
        self.sneo["armr"]:setLayer(self.sneo["body"].layer+5)
        self.sneo["armr"]:shiftOrigin(0.44, 0.42)
        self.sneo["legl"]:setLayer(self.sneo["body"].layer-2)
        self.sneo["legl"]:shiftOrigin(0.27, 0.63)
        self.sneo["legr"]:setLayer(self.sneo["body"].layer-1)
        self.sneo["legr"]:shiftOrigin(0.37, 0.63)
        self.sneo["wingl"]:setLayer(self.sneo["body"].layer-5)
        self.sneo["wingl"]:shiftOrigin(0.5, 0.6)
        self.sneo["wingr"]:setLayer(self.sneo["body"].layer+5)
        self.sneo["wingr"]:shiftOrigin(0.43, 0.37)

        if self.frozenstate==1 then
            self.sneo["arml"].freeze_progress=1
            self.sneo["wingl"].freeze_progress=1
        end

        self.sneo["strings"]={}
        for i=1,20 do
            self.sneo["strings"][i]=Rectangle(15+1*i, 30, 0.5, 200)
            self.sneo["strings"][i].ori_x=15+1*i
            self.sneo["strings"][i]:setColor(0, 0.2, 0, 1)
            self.sneo["strings"][i]:setOrigin(0.5, 1)
            self.sneo["strings"][i]:setLayer(self.sneo["body"].layer-10)
            self.sneo["strings"][i].thiccString = false
            sprite:addChild(self.sneo["strings"][i])
        end
        for i=21,26 do
            self.sneo["strings"][i]=Rectangle(15+3*(i-20), 30, 1, 200)
            self.sneo["strings"][i].ori_x=15+3*(i-20)
            self.sneo["strings"][i]:setColor(0, 0.5, 0, 1)
            self.sneo["strings"][i]:setOrigin(0.5, 1)
            self.sneo["strings"][i]:setLayer(self.sneo["body"].layer-9)
            self.sneo["strings"][i].thiccString = true
            sprite:addChild(self.sneo["strings"][i])
        end

        --self.orishow=Ellipse(0, 0, 2)
        --self.orishow:setLayer(BATTLE_LAYERS["top"])
        --self.orishow:setColor(1, 0, 0, 1)
        --self.sneo["legr"].parent:addChild(self.orishow)
        --self.orishow:setPosition(self.sneo["legr"].x, self.sneo["legr"].y)
    end
    super:onSpriteInit(self, sprite)
end

return actor