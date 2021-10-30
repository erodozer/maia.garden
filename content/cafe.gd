extends Resource

export var id: String
export(Texture) var icon
var type = "cafe"
export var name: String
export(int, 0, 99) var price = 5
export(int, 1, 100) var stamina = 5
export var description: String
export var unlock: String
export(int, 0, 1) var stack = 0
export(int, 0, 99) var starting = 0
