return {
  version = "1.5",
  luaversion = "5.1",
  tiledversion = "1.8.4",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 46,
  height = 12,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 8,
  nextobjectid = 18,
  backgroundcolor = { 2, 2, 29 },
  properties = {},
  tilesets = {
    {
      name = "mansion_interior",
      firstgid = 1,
      filename = "../../tilesets/mansion_interior.tsx"
    },
    {
      name = "mansion",
      firstgid = 287,
      filename = "../../tilesets/mansion.tsx"
    },
    {
      name = "mansion_pillars",
      firstgid = 917,
      filename = "../../tilesets/mansion_pillars.tsx"
    },
    {
      name = "queen_symbol_floor",
      firstgid = 938,
      tilewidth = 640,
      tileheight = 216,
      spacing = 0,
      margin = 0,
      columns = 0,
      objectalignment = "unspecified",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 1,
        height = 1
      },
      properties = {},
      wangsets = {},
      tilecount = 1,
      tiles = {
        {
          id = 1,
          image = "../../../../assets/sprites/queen_symbol.png",
          width = 640,
          height = 216
        }
      }
    },
    {
      name = "mansion_top",
      firstgid = 940,
      filename = "../../tilesets/mansion_top.tsx",
      exportfilename = "../../tilesets/mansion_top.lua"
    },
    {
      name = "big_fountain",
      firstgid = 1030,
      tilewidth = 175,
      tileheight = 45,
      spacing = 0,
      margin = 0,
      columns = 0,
      objectalignment = "unspecified",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 1,
        height = 1
      },
      properties = {},
      wangsets = {},
      tilecount = 4,
      tiles = {
        {
          id = 3,
          image = "../../../../assets/sprites/tilesets/spr_cc_fountainbg_ch1_3.png",
          width = 175,
          height = 45
        },
        {
          id = 0,
          image = "../../../../assets/sprites/tilesets/spr_cc_fountainbg_ch1_0.png",
          width = 175,
          height = 45
        },
        {
          id = 1,
          image = "../../../../assets/sprites/tilesets/spr_cc_fountainbg_ch1_1.png",
          width = 175,
          height = 45
        },
        {
          id = 2,
          image = "../../../../assets/sprites/tilesets/spr_cc_fountainbg_ch1_2.png",
          width = 175,
          height = 45
        }
      }
    }
  },
  layers = {
    {
      type = "imagelayer",
      image = "../../../../assets/sprites/tilesets/spr_mansion_ferris_wheel_bg_0.png",
      id = 4,
      name = "Calque d'Images 1",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = -200,
      parallaxx = 1,
      parallaxy = 1,
      repeatx = true,
      repeaty = false,
      properties = {}
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 46,
      height = 12,
      id = 2,
      name = "dark_pillars",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 926, 927, 928, 0, 0, 0, 0, 926, 927, 928, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 929, 930, 931, 0, 0, 0, 0, 929, 930, 931, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 929, 930, 931, 0, 0, 0, 0, 926, 927, 928, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 926, 927, 928, 0, 0, 0, 0, 929, 930, 931, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 929, 930, 931, 0, 0, 0, 0, 926, 927, 928, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 926, 927, 928, 0, 0, 0, 0, 929, 930, 931, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 929, 930, 931, 0, 0, 0, 0, 926, 927, 928, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 926, 927, 928, 0, 0, 0, 0, 929, 930, 931, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 920, 921, 922, 0, 0, 0, 0, 920, 921, 922, 0, 0, 0, 0, 0, 0, 0, 929, 930, 931, 0, 0, 0, 0, 926, 927, 928, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 923, 924, 925, 0, 0, 0, 0, 923, 924, 925, 0, 0, 0, 0, 0, 0, 0, 926, 927, 928, 0, 0, 0, 0, 929, 930, 931, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 926, 927, 928, 0, 0, 0, 0, 926, 927, 928, 0, 0, 0, 0, 0, 0, 0, 926, 927, 928, 0, 0, 0, 0, 926, 927, 928, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 929, 930, 931, 0, 0, 0, 0, 929, 930, 931, 0, 0, 0, 0, 0, 0, 0, 929, 930, 931, 0, 0, 0, 0, 929, 930, 931, 0
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 46,
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
        927, 928, 0, 929, 930, 931, 0, 0, 0, 929, 930, 931, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 926, 928, 0, 0, 0, 926, 928, 0, 0, 0, 0, 0,
        930, 931, 0, 926, 927, 928, 0, 0, 0, 926, 927, 928, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 929, 931, 0, 0, 0, 929, 931, 0, 0, 0, 0, 0,
        927, 928, 0, 929, 930, 931, 0, 0, 0, 929, 930, 931, 0, 317, 318, 318, 318, 318, 318, 318, 318, 318, 318, 318, 318, 318, 318, 318, 318, 318, 318, 318, 319, 0, 929, 931, 0, 0, 0, 929, 931, 0, 0, 0, 0, 0,
        930, 931, 0, 926, 927, 928, 0, 0, 0, 926, 927, 928, 0, 335, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 337, 0, 926, 928, 0, 0, 0, 926, 928, 0, 0, 0, 0, 0,
        933, 934, 0, 929, 930, 931, 0, 0, 0, 929, 930, 931, 0, 335, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 337, 0, 929, 931, 0, 0, 0, 929, 931, 0, 0, 0, 0, 0,
        936, 937, 0, 932, 933, 934, 0, 0, 0, 932, 933, 934, 0, 335, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 337, 0, 932, 934, 0, 0, 0, 932, 934, 0, 0, 0, 0, 0,
        318, 319, 0, 935, 936, 937, 0, 0, 0, 935, 936, 937, 0, 335, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 337, 0, 935, 937, 0, 0, 0, 935, 937, 0, 0, 0, 0, 0,
        336, 752, 318, 318, 318, 318, 318, 318, 318, 318, 318, 318, 318, 751, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 336, 752, 318, 318, 318, 318, 318, 318, 318, 318, 318, 974, 975, 975, 975,
        354, 354, 354, 354, 354, 354, 354, 354, 354, 354, 354, 354, 354, 354, 354, 354, 354, 354, 354, 354, 354, 354, 354, 354, 354, 354, 354, 354, 354, 354, 354, 354, 354, 354, 354, 354, 354, 354, 354, 354, 354, 354, 984, 985, 985, 985,
        83, 83, 83, 83, 83, 83, 83, 83, 83, 83, 83, 83, 83, 920, 921, 922, 0, 0, 0, 0, 0, 0, 920, 922, 0, 0, 0, 0, 0, 0, 920, 921, 922, 0, 0, 0, 0, 0, 0, 920, 922, 0, 0, 0, 0, 0,
        267, 267, 267, 267, 267, 267, 267, 267, 267, 267, 267, 267, 268, 923, 924, 925, 0, 0, 0, 0, 0, 0, 923, 925, 0, 0, 0, 0, 0, 0, 923, 924, 925, 0, 0, 0, 0, 0, 0, 923, 925, 0, 0, 0, 0, 0,
        278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 279, 926, 927, 928, 0, 0, 0, 0, 0, 0, 926, 928, 0, 0, 0, 0, 0, 0, 926, 927, 928, 0, 0, 0, 0, 0, 0, 926, 928, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 7,
      name = "objects_queen",
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
          x = 597,
          y = 348,
          width = 640,
          height = 216,
          rotation = 0,
          gid = 939,
          visible = true,
          properties = {}
        }
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
          id = 2,
          name = "big_fountain",
          type = "",
          shape = "rectangle",
          x = 900,
          y = 40,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 3,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 1840,
          y = 280,
          width = 20,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "queen_mansion_top",
            ["marker"] = "entry_l"
          }
        },
        {
          id = 14,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = -20,
          y = 240,
          width = 20,
          height = 120,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "queen_mansion_4f_c",
            ["marker"] = "entry_r"
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 5,
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
          id = 5,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1320,
          y = 240,
          width = 520,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 6,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1320,
          y = 80,
          width = 40,
          height = 160,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 7,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 200,
          width = 120,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 8,
          name = "",
          type = "",
          shape = "rectangle",
          x = 80,
          y = 240,
          width = 440,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 9,
          name = "",
          type = "",
          shape = "rectangle",
          x = 480,
          y = 80,
          width = 40,
          height = 160,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 10,
          name = "",
          type = "",
          shape = "rectangle",
          x = 520,
          y = 40,
          width = 800,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 11,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 360,
          width = 1840,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 12,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1680,
          y = 338,
          width = 160,
          height = 22,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 13,
          name = "",
          type = "",
          shape = "polygon",
          x = 1640,
          y = 360,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = 40, y = 0 },
            { x = 39.9922, y = -22.0078 }
          },
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 6,
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
          id = 15,
          name = "entry_l",
          type = "",
          shape = "point",
          x = 24,
          y = 303.25,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 16,
          name = "spawn",
          type = "",
          shape = "point",
          x = 920,
          y = 160,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 17,
          name = "entry_r",
          type = "",
          shape = "point",
          x = 1800,
          y = 320,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
