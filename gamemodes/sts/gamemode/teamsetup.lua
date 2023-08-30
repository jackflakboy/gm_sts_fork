local ply = FindMetaTable("Player")
include("cubes.lua")
teams = {}

teams[1] = {
    name = "Blue",
    color = Vector(0.2, 0.2, 1.0),
    cubes = {
        cube1 = Cube.new{
            entity = "blue_box1",
            level = 1,
            rarity = 1,
            strength = 1,
            multiplier = 1,
            mob = "blue_npc_headcrab"
        },
        cube2 = Cube.new{
            entity = "blue_box2",
            level = 1,
            rarity = 1,
            strength = 1,
            multiplier = 1,
            mob = "blue_npc_headcrab"
        },
        cube3 = Cube.new{
            entity = "blue_box3",
            level = 1,
            rarity = 1,
            strength = 1,
            multiplier = 1,
            mob = "blue_npc_headcrab"
        },
        cube4 = Cube.new{
            entity = "blue_box4",
            level = 1,
            rarity = 1,
            strength = 1,
            multiplier = 1,
            mob = "blue_npc_headcrab"
        }
    },
    points = 999
}

teams[2] = {
    name = "Red",
    color = Vector(1.0, 0, 0),
    cubes = {
        cube1 = Cube.new{
            entity = "red_box1",
            level = 1,
            rarity = 1,
            strength = 1,
            multiplier = 1,
            mob = "red_npc_headcrab"
        },
        cube2 = Cube.new{
            entity = "red_box2",
            level = 1,
            rarity = 1,
            strength = 1,
            multiplier = 1,
            mob = "red_npc_headcrab"
        },
        cube3 = Cube.new{
            entity = "red_box3",
            level = 1,
            rarity = 1,
            strength = 1,
            multiplier = 1,
            mob = "red_npc_headcrab"
        },
        cube4 = Cube.new{
            entity = "red_box4",
            level = 1,
            rarity = 1,
            strength = 1,
            multiplier = 1,
            mob = "red_npc_headcrab"
        }
    },
    points = 0
}

teams[3] = {
    name = "Green",
    color = Vector(0.0, 1.0, 0.0),
    cubes = {
        cube1 = Cube.new{
            entity = "green_box1",
            level = 1,
            rarity = 1,
            strength = 1,
            multiplier = 1,
            mob = "green_npc_headcrab"
        },
        cube2 = Cube.new{
            entity = "green_box2",
            level = 1,
            rarity = 1,
            strength = 1,
            multiplier = 1,
            mob = "green_npc_headcrab"
        },
        cube3 = Cube.new{
            entity = "green_box3",
            level = 1,
            rarity = 1,
            strength = 1,
            multiplier = 1,
            mob = "green_npc_headcrab"
        },
        cube4 = Cube.new{
            entity = "green_box4",
            level = 1,
            rarity = 1,
            strength = 1,
            multiplier = 1,
            mob = "green_npc_headcrab"
        }
    },
    points = 0
}

teams[4] = {
    name = "Yellow",
    color = Vector(1.0, 1.0, 0.0),
    cubes = {
        cube1 = Cube.new{
            entity = "yellow_box1",
            level = 1,
            rarity = 1,
            strength = 1,
            multiplier = 1,
            mob = "yellow_npc_headcrab"
        },
        cube2 = Cube.new{
            entity = "yellow_box2",
            level = 1,
            rarity = 1,
            strength = 1,
            multiplier = 1,
            mob = "yellow_npc_headcrab"
        },
        cube3 = Cube.new{
            entity = "yellow_box3",
            level = 1,
            rarity = 1,
            strength = 1,
            multiplier = 1,
            mob = "yellow_npc_headcrab"
        },
        cube4 = Cube.new{
            entity = "yellow_box4",
            level = 1,
            rarity = 1,
            strength = 1,
            multiplier = 1,
            mob = "yellow_npc_headcrab"
        }
    },
    points = 0
}

teams[0] = {
    name = "Empty",
    color = Vector(1.0, 1.0, 1.0),
    cubes = {}
}

teams[5] = {
    name = "Spectator",
    color = Vector(0.0, 0.0, 0.0),
    cubes = {}
}

function ply:SetupTeam(n)
    if not teams[n] then return end
    self:SetTeam(n)
    self:SetPlayerColor(teams[n].color)
    self:SetModel("models/player/police.mdl")
end