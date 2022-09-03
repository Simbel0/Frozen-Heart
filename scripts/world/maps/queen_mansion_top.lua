return {
  version = "1.5",
  luaversion = "5.1",
  tiledversion = "1.8.4",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 62,
  height = 12,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 6,
  nextobjectid = 11,
  backgroundcolor = { 2, 2, 29 },
  properties = {
    ["music"] = "wind_highplace"
  },
  tilesets = {
    {
      name = "mansion_top",
      firstgid = 1,
      filename = "../tilesets/mansion_top.tsx"
    },
    {
      name = "city_girder",
      firstgid = 91,
      filename = "../tilesets/city_girder.tsx"
    }
  },
  layers = {
    {
      type = "imagelayer",
      image = "../../../assets/sprites/tilesets/spr_mansion_ferris_wheel_bg_0.png",
      id = 2,
      name = "Calque d'Images 1",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = -40,
      parallaxx = 1.3,
      parallaxy = 1,
      repeatx = true,
      repeaty = false,
      properties = {}
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 62,
      height = 12,
      id = 1,
      name = "Calque de Tuiles 1",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12,
        32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32,
        0, 100, 101, 102, 103, 104, 105, 106, 107, 104, 105, 106, 107, 100, 101, 102, 103, 0, 0, 0, 100, 101, 102, 103, 104, 105, 106, 107, 104, 105, 106, 107, 100, 101, 102, 103, 0, 0, 0, 100, 101, 102, 103, 104, 105, 106, 107, 104, 105, 106, 107, 100, 101, 102, 103, 0, 0, 0, 0, 100, 101, 102,
        0, 109, 110, 111, 112, 113, 114, 115, 116, 113, 114, 115, 116, 109, 110, 111, 112, 0, 0, 0, 109, 110, 111, 112, 113, 114, 115, 116, 113, 114, 115, 116, 109, 110, 111, 112, 0, 0, 0, 109, 110, 111, 112, 113, 114, 115, 116, 113, 114, 115, 116, 109, 110, 111, 112, 0, 0, 0, 0, 109, 110, 111,
        0, 118, 119, 120, 121, 122, 123, 124, 125, 122, 123, 124, 125, 118, 119, 120, 121, 0, 0, 0, 118, 119, 120, 121, 122, 123, 124, 125, 122, 123, 124, 125, 118, 119, 120, 121, 0, 0, 0, 118, 119, 120, 121, 122, 123, 124, 125, 122, 123, 124, 125, 118, 119, 120, 121, 0, 0, 0, 0, 118, 119, 120
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 3,
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
          id = 1,
          name = "npc",
          type = "",
          shape = "point",
          x = 1979,
          y = 333,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["actor"] = "ralsei",
            ["cutscene"] = "overworld.ralsei_dialogue",
            ["facing"] = "up"
          }
        },
        {
          id = 2,
          name = "npc",
          type = "",
          shape = "point",
          x = 1980,
          y = 300,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["actor"] = "queen",
            ["cutscene"] = "overworld.queen_dialogue"
          }
        },
        {
          id = 7,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 2480,
          y = 282,
          width = 20,
          height = 56,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "mansion_queen_prefountain",
            ["marker"] = "entry_l"
          }
        },
        {
          id = 8,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = -20,
          y = 282,
          width = 20,
          height = 56,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "queen_mansion_4f_d",
            ["marker"] = "entry_r"
          }
        },
        {
          id = 10,
          name = "script",
          type = "",
          shape = "rectangle",
          x = 1700,
          y = 280,
          width = 41,
          height = 70,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "overworld.together"
          }
        }
      }
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
          id = 3,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 338,
          width = 2480,
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
          x = 0,
          y = 240,
          width = 2480,
          height = 41.8182,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 5,
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
          id = 5,
          name = "entry_l",
          type = "",
          shape = "point",
          x = 40.1818,
          y = 314.182,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 6,
          name = "spawn",
          type = "",
          shape = "point",
          x = 354,
          y = 307.333,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 9,
          name = "entry_r",
          type = "",
          shape = "point",
          x = 2440,
          y = 320,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["music"] = "wind_highplace"
          }
        }
      }
    }
  }
}
