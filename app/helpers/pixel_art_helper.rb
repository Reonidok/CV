# Renders pixel-art sprites as a single box-shadow-painted element — a
# server-side port of the design's React sprite() routine. Each sprite is a
# character map + a legend mapping characters to colours.
module PixelArtHelper
  ACCENT = "#C2143B".freeze
  GREEN  = "#1f6b43".freeze

  # ---- Sprite maps -------------------------------------------------------

  CHARACTER = [
    "........................",
    "........KKKKKKKK........",
    ".......KKKKKKKKKK.......",
    "......KKKKKKKKKKKK......",
    "......KKFFFFFFFFKK......",
    "......KFFFFFFFFFFK......",
    "......KFFFFFFFFFFK......",
    ".......GGGGGGGGGG.......",
    ".......GLLGFFGLLG.......",
    ".......GLLGFFGLLG.......",
    ".......GGGGFFGGGG.......",
    ".......FFFFFFFFFF.......",
    ".......FFFFFFFFFF.......",
    "........FFFFFFFF........",
    ".....NNNNNFFFFNNNNN.....",
    "....NNNNDDDDDDDDNNNN....",
    "...NNNNNNNNRNRNNNNNNN...",
    "...NNNNNNNNRNRNNNNNNN...",
    "...NNNNNDDDDDDDDNNNNN...",
    "...NNNNNDDDDDDDDNNNNN...",
    "...NNNNNNNNNNNNNNNNNN...",
    "...DDDDDDDDDDDDDDDDDD...",
    "....NNNNNNNNNNNNNNNN....",
    "....DDDDDDDDDDDDDDDD...."
  ].freeze
  CHARACTER_LEGEND = { "K" => "#6b5331", "F" => "#ecb98d", "G" => GREEN, "L" => "#d2efe0",
                       "N" => "#474d59", "D" => "#2f343e", "R" => ACCENT }.freeze

  MAC = [
    "..KKKKKKKKKKKKKK..",
    "..KEEEEEEEEEEEEK..",
    "..KccccEEEEEEEEK..",
    "..KEEEEEEEEEEEEK..",
    "..KEEEEcccccEEEK..",
    "..KEEEEEEEEEEEEK..",
    "..KKKKKKKKKKKKKK..",
    "PPPPPPPPPPPPPPPPPP",
    "KPPPPPPPPPPPPPPPPK",
    ".KKKKKKKKKKKKKKKK."
  ].freeze
  MAC_LEGEND = { "K" => "#3b4048", "E" => "#82dccb", "c" => "#2f343e", "P" => "#c9ced4" }.freeze

  CUP = [
    "..W...W..",
    "...W.W...",
    "..W...W..",
    ".........",
    ".xxxxxxx.",
    ".xOOOOOx.",
    ".xJJJJJx.",
    ".xCCCCCx.",
    ".xCCCCCx.",
    ".xCCCCCx.",
    ".xxxxxxx."
  ].freeze
  CUP_LEGEND = { "W" => "#cccccc", "x" => "#2f343e", "O" => ACCENT, "J" => "#6f4626", "C" => "#f5f6f8" }.freeze

  FUJI = [
    "............SS............",
    "...........SSSS...........",
    "..........SSSSSS..........",
    ".........SSSSSSSS.........",
    "........SSSSSSSSSS........",
    ".......FFSSFFFFSSFF.......",
    "......FFFSSFFFFSSFFF......",
    ".....FFFFSSFFFFSSFFFF.....",
    "....FFFFFFFFFFFFFFFFFF....",
    "...FFFFFFFFFFFFFFFFFFFF...",
    "..FFFFFFFFFFFFFFFFFFFFFF..",
    ".FFFFFFFFFFFFFFFFFFFFFFFF.",
    "FFFFFFFFFFFFFFFFFFFFFFFFFF"
  ].freeze
  FUJI_LEGEND = { "S" => "#ffffff", "F" => "#6c7da0" }.freeze

  PAGODA = [
    "........p........",
    "........p........",
    "......rrrrr......",
    ".....rrrrrrr.....",
    "....rrrrrrrrr....",
    ".......www.......",
    ".......wdw.......",
    ".....rrrrrrr.....",
    "....rrrrrrrrr....",
    "...rrrrrrrrrrr...",
    "......wwwww......",
    "......wdddw......",
    "....rrrrrrrrr....",
    "...rrrrrrrrrrr...",
    "..rrrrrrrrrrrrr..",
    ".rrrrrrrrrrrrrrr.",
    ".....wwwwwww.....",
    ".....wwwwwww.....",
    ".....wdddddw.....",
    ".....wdddddw.....",
    "....wwwwwwwww....",
    "...wwwwwwwwwww..."
  ].freeze
  PAGODA_LEGEND = { "r" => ACCENT, "w" => "#c9a26f", "d" => "#3b2a1a", "p" => "#3b2a1a" }.freeze

  FLOWER = [
    ".ppp.",
    "ppppp",
    "ppcpp",
    "ppppp",
    ".ppp."
  ].freeze
  FLOWER_LEGEND = { "p" => "#f4a9c4", "c" => "#e07ba6" }.freeze

  # ---- Renderers ---------------------------------------------------------

  # Paints a sprite map into one element using a multi-part box-shadow.
  def pixel_sprite(map, legend, px:, anim: nil, style: nil)
    cols = map.map(&:length).max
    rows = map.length
    shadows = []
    map.each_with_index do |row, y|
      row.chars.each_with_index do |char, x|
        color = legend[char]
        shadows << "#{x * px}px #{y * px}px 0 0 #{color}" if color
      end
    end

    outer = "position:relative;width:#{cols * px}px;height:#{rows * px}px;"
    outer << "animation:#{anim};" if anim
    outer << style if style

    tag.div(style: outer) do
      tag.div(style: "position:absolute;top:0;left:0;width:#{px}px;height:#{px}px;box-shadow:#{shadows.join(',')};")
    end
  end

  def character_sprite
    pixel_sprite(CHARACTER, CHARACTER_LEGEND, px: 9, anim: "floatA 4s ease-in-out infinite")
  end

  def mac_sprite
    pixel_sprite(MAC, MAC_LEGEND, px: 7, anim: "floatB 4.6s ease-in-out infinite")
  end

  def cup_sprite
    pixel_sprite(CUP, CUP_LEGEND, px: 7, anim: "floatB 3.4s ease-in-out infinite")
  end

  def fuji_sprite
    pixel_sprite(FUJI, FUJI_LEGEND, px: 9, anim: "floatB 6s ease-in-out infinite")
  end

  def pagoda_sprite
    pixel_sprite(PAGODA, PAGODA_LEGEND, px: 5)
  end

  def flower_sprite(px)
    pixel_sprite(FLOWER, FLOWER_LEGEND, px: px)
  end

  # A blossoming branch: two twigs plus five sakura flowers.
  def sakura_branch
    tag.div(class: "rk-sakura", style: "position:relative;width:160px;height:86px;") do
      safe_join([
        tag.div(style: "position:absolute;left:2px;top:44px;width:150px;height:6px;background:#5a3a2a;transform:rotate(-17deg);transform-origin:left center;"),
        tag.div(style: "position:absolute;left:118px;top:22px;width:46px;height:5px;background:#5a3a2a;transform:rotate(-48deg);transform-origin:left center;"),
        tag.div(flower_sprite(4), style: "position:absolute;left:-2px;top:36px;"),
        tag.div(flower_sprite(5), style: "position:absolute;left:44px;top:20px;"),
        tag.div(flower_sprite(4), style: "position:absolute;left:88px;top:6px;"),
        tag.div(flower_sprite(5), style: "position:absolute;left:134px;top:0px;"),
        tag.div(flower_sprite(4), style: "position:absolute;left:68px;top:42px;")
      ])
    end
  end
end
