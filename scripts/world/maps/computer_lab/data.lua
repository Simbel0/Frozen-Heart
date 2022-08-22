return {
  version = "1.5",
  luaversion = "5.1",
  tiledversion = "1.8.4",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 16,
  height = 12,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 7,
  nextobjectid = 11,
  properties = {
    ["light"] = true
  },
  tilesets = {
    {
      name = "computer_lab_stuff",
      firstgid = 1,
      tilewidth = 222,
      tileheight = 148,
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
      tilecount = 5,
      tiles = {
        {
          id = 5,
          image = "../../../../assets/sprites/light/Berdly_fucking_dead.png",
          width = 50,
          height = 44
        },
        {
          id = 6,
          image = "../../../../assets/sprites/light/bin.png",
          width = 60,
          height = 36
        },
        {
          id = 7,
          image = "../../../../assets/sprites/light/books_Berdly.png",
          width = 82,
          height = 36
        },
        {
          id = 8,
          image = "../../../../assets/sprites/light/books_Noelle.png",
          width = 82,
          height = 36
        },
        {
          id = 9,
          image = "../../../../assets/sprites/light/desk.png",
          width = 222,
          height = 148
        }
      }
    }
  },
  layers = {
    {
      type = "imagelayer",
      image = "../../../../assets/sprites/light/computer_lab.png",
      id = 2,
      name = "lab",
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
          name = "",
          type = "",
          shape = "rectangle",
          x = 490,
          y = 406,
          width = 60,
          height = 36,
          rotation = 0,
          gid = 7,
          visible = true,
          properties = {}
        },
        {
          id = 3,
          name = "",
          type = "",
          shape = "rectangle",
          x = 304,
          y = 340,
          width = 222,
          height = 148,
          rotation = 0,
          gid = 10,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 4,
      name = "objects-nerd",
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
          x = 333,
          y = 208,
          width = 50,
          height = 44,
          rotation = 0,
          gid = 2147483654,
          visible = true,
          properties = {}
        },
        {
          id = 6,
          name = "",
          type = "",
          shape = "rectangle",
          x = 355.25,
          y = 236,
          width = 82,
          height = 36,
          rotation = 0,
          gid = 8,
          visible = true,
          properties = {}
        },
        {
          id = 7,
          name = "",
          type = "",
          shape = "rectangle",
          x = 355,
          y = 236.25,
          width = 82,
          height = 36,
          rotation = 0,
          gid = 9,
          visible = true,
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
          id = 8,
          name = "susie",
          type = "",
          shape = "point",
          x = 340,
          y = 315.913,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 9,
          name = "kris",
          type = "",
          shape = "point",
          x = 394.133,
          y = 315.978,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 10,
          name = "noelle",
          type = "",
          shape = "point",
          x = 428.313,
          y = 205.938,
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
