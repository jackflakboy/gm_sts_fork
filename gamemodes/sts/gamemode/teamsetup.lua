local ply = FindMetaTable("Player")
include("cubes.lua")
teams = {}

teams[1] = {
    name = "Blue",
    color = Vector(0.2, 0.2, 1.0),
    cubes = {
        cube1 = Cube.new{
            entity = "blue_cube1",
            mob = "blue_npc_headcrab"
        },
        cube2 = Cube.new{
            entity = "blue_cube2",
            mob = "blue_npc_headcrab"
        },
        cube3 = Cube.new{
            entity = "blue_cube3",
            mob = "blue_npc_headcrab"
        },
        cube4 = Cube.new{
            entity = "blue_cube4",
            mob = "blue_npc_headcrab"
        }
    },
    points = 0
}

teams[2] = {
    name = "Red",
    color = Vector(1.0, 0, 0),
    cubes = {
        cube1 = Cube.new{
            entity = "red_cube1",
            mob = "red_npc_headcrab"
        },
        cube2 = Cube.new{
            entity = "red_cube2",
            mob = "red_npc_headcrab"
        },
        cube3 = Cube.new{
            entity = "red_cube3",
            mob = "red_npc_headcrab"
        },
        cube4 = Cube.new{
            entity = "red_cube4",
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
            entity = "green_cube1",
            mob = "green_npc_headcrab"
        },
        cube2 = Cube.new{
            entity = "green_cube2",
            mob = "green_npc_headcrab"
        },
        cube3 = Cube.new{
            entity = "green_cube3",
            mob = "green_npc_headcrab"
        },
        cube4 = Cube.new{
            entity = "green_cube4",
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
            entity = "yellow_cube1",
            mob = "yellow_npc_headcrab"
        },
        cube2 = Cube.new{
            entity = "yellow_cube2",
            mob = "yellow_npc_headcrab"
        },
        cube3 = Cube.new{
            entity = "yellow_cube3",
            mob = "yellow_npc_headcrab"
        },
        cube4 = Cube.new{
            entity = "yellow_cube4",
            mob = "yellow_npc_headcrab"
        }
    },
    points = 0
}

teams[0] = {
    name = "Empty",
    color = Vector(1.0, 1.0, 1.0),
}

teams[5] = {
    name = "Spectator",
    color = Vector(0.0, 0.0, 0.0)
}

function ply:SetupTeam(n)
    if not teams[n] then return end
    self:SetTeam(n)
    self:SetPlayerColor(teams[n].color)
    self:SetModel("models/player/police.mdl")
end