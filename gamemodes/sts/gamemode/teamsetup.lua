local ply = FindMetaTable("Player")
teams = {}

teams[1] = {
    name = "Blue",
    color = Vector(0.2, 0.2, 1.0),
    cubes = {cube1 = Cube.new{entity = "blue_cube1"}, cube2 = Cube.new{entity = "blue_cube2"}, cube3 = Cube.new{entity = "blue_cube3"}, cube4 = Cube.new{entity = "blue_cube4"}},
    points = 0
}

teams[2] = {
    name = "Red",
    color = Vector(1.0, 0, 0),
    cubes = {cube1 = Cube.new{entity = "red_cube1"}, cube2 = Cube.new{entity = "red_cube2"}, cube3 = Cube.new{entity = "red_cube3"}, cube4 = Cube.new{entity = "red_cube4"}},
    points = 0
}

teams[3] = {
    name = "Green",
    color = Vector(0.0, 1.0, 0.0),
    cubes = {cube1 = Cube.new{entity = "green_cube1"}, cube2 = Cube.new{entity = "green_cube2"}, cube3 = Cube.new{entity = "green_cube3"}, cube4 = Cube.new{entity = "green_cube4"}},
    points = 0
}

teams[4] = {
    name = "Yellow",
    color = Vector(1.0, 1.0, 0.0),
    cubes = {cube1 = Cube.new{entity = "yellow_cube1"}, cube2 = Cube.new{entity = "yellow_cube2"}, cube3 = Cube.new{entity = "yellow_cube3"}, cube4 = Cube.new{entity = "yellow_cube4"}},
    points = 0
}

teams[0] = {
    name = "Empty",
    color = Vector(1.0, 1.0, 1.0),
}

function ply:SetupTeam(n)
    if not teams[n] then return end
    self:SetTeam(n)
    self:SetPlayerColor(teams[n].color)
    self:SetModel("models/player/police.mdl")
end

if (teams[1].points) then
    print("waaa")
end 