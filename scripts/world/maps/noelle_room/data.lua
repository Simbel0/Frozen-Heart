return {
  version = "1.5",
  luaversion = "5.1",
  tiledversion = "1.8.4",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 40,
  height = 12,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 11,
  nextobjectid = 28,
  backgroundcolor = { 27, 27, 42 },
  properties = {},
  tilesets = {
    {
      name = "noelle_room",
      firstgid = 1,
      filename = "../../tilesets/noelle_room.tsx",
      exportfilename = "../../tilesets/noelle_room.lua"
    }
  },
  layers = {
    {
      type = "imagelayer",
      image = "../../../../assets/sprites/tilesets/noelle_room_moon.png",
      id = 9,
      name = "moon",
      visible = true,
      opacity = 1,
      offsetx = -100,
      offsety = 0,
      parallaxx = 0.7,
      parallaxy = 1,
      repeatx = false,
      repeaty = false,
      properties = {}
    },
    {
      type = "imagelayer",
      image = "../../../../assets/sprites/tilesets/noelle_room.png",
      id = 8,
      name = "room",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      repeatx = false,
      repeaty = false,
      properties = {}
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 4,
      name = "collisions",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 1,
          name = "",
          type = "",
          shape = "rectangle",
          x = 142,
          y = 195,
          width = 1140,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 2,
          name = "",
          type = "",
          shape = "polygon",
          x = 1258,
          y = 367,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = 23, y = -132 },
            { x = 31, y = 112 },
            { x = 1, y = 112 }
          },
          properties = {}
        },
        {
          id = 3,
          name = "",
          type = "",
          shape = "rectangle",
          x = 304,
          y = 366,
          width = 954,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 4,
          name = "",
          type = "",
          shape = "rectangle",
          x = 142,
          y = 367,
          width = 92,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 5,
          name = "",
          type = "",
          shape = "rectangle",
          x = 102,
          y = 195,
          width = 40,
          height = 212,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 21,
          name = "",
          type = "",
          shape = "rectangle",
          x = 194,
          y = 407,
          width = 40,
          height = 73,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 22,
          name = "",
          type = "",
          shape = "rectangle",
          x = 304,
          y = 406,
          width = 40,
          height = 74,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 6,
      name = "objects",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 10,
          name = "susie_statue",
          type = "",
          shape = "point",
          x = 165.461,
          y = 257.685,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 11,
          name = "ice-e cushion",
          type = "",
          shape = "point",
          x = 405.063,
          y = 249.548,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 15,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 232,
          y = 200,
          width = 58,
          height = 35,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "interactable_noelle_room",
            ["id"] = 1
          }
        },
        {
          id = 16,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 295.725,
          y = 205.871,
          width = 74.219,
          height = 29.4848,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "interactable_noelle_room",
            ["id"] = 2
          }
        },
        {
          id = 17,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 448,
          y = 176,
          width = 54,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "interactable_noelle_room",
            ["id"] = 3
          }
        },
        {
          id = 18,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 580,
          y = 195,
          width = 122,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "interactable_noelle_room",
            ["id"] = 4
          }
        },
        {
          id = 19,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 826.143,
          y = 195.174,
          width = 54,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "interactable_noelle_room",
            ["id"] = 5
          }
        },
        {
          id = 20,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 229.975,
          y = 477.641,
          width = 76.6585,
          height = 17.6904,
          rotation = 0,
          visible = true,
          properties = {
            ["cond"] = "Game:getFlag(\"plot\", 0)>=2",
            ["map"] = "queen_mansion_4f_b",
            ["marker"] = "out_noelle_room"
          }
        },
        {
          id = 26,
          name = "enemy",
          type = "",
          shape = "point",
          x = 723.366,
          y = 313.364,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["actor"] = "noelle",
            ["aura"] = false,
            ["chase"] = false,
            ["encounter"] = "noelle_battle"
          }
        },
        {
          id = 27,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 1240,
          y = 200,
          width = 80,
          height = 200,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "interactable_noelle_room",
            ["id"] = 6
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 5,
      name = "collisions_objects",
      visible = false,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 6,
          name = "",
          type = "",
          shape = "rectangle",
          x = 232,
          y = 195,
          width = 58,
          height = 69,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 7,
          name = "",
          type = "",
          shape = "rectangle",
          x = 296,
          y = 206,
          width = 74,
          height = 56,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 8,
          name = "",
          type = "",
          shape = "rectangle",
          x = 520,
          y = 200,
          width = 240,
          height = 62,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 9,
          name = "",
          type = "",
          shape = "rectangle",
          x = 824,
          y = 178,
          width = 58,
          height = 78,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 7,
      name = "markers",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 12,
          name = "spawn",
          type = "",
          shape = "point",
          x = 260,
          y = 320,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 25,
          name = "enter",
          type = "",
          shape = "point",
          x = 269.071,
          y = 460.472,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "imagelayer",
      image = "../../../../assets/sprites/tilesets/noelle_ferris_wheel.png",
      id = 10,
      name = "ferris_wheel",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      repeatx = false,
      repeaty = false,
      properties = {}
    }
  }
}
