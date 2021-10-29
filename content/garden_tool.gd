extends Resource

export var id: String
export(Texture) var icon
var type = "tool"
export var name: String
export(int, 1, 999) var price = 5
export(int, 0, 99) var starting = 0
export(Resource) var effect
export var description: String
export var unlock: String
export(int, 0, 99) var stack = 1
