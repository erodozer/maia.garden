extends Resource

export var id: String
export(Texture) var icon
var type = "flower"
export var name: String
export(int, 1, 999) var price = 5
export(int, 1, 30) var mature = 2
export var description: String
