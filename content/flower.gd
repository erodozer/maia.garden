extends Resource

export var id: String
export(Texture) var icon
export(Texture) var young_sprite
export(Texture) var mature_sprite
var type = "flower"
export var name: String
export(int, 1, 999) var price = 5
export(int, 1, 30) var mature = 2
export var description: String
export var stack = 1
