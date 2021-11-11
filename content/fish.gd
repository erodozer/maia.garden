extends Resource

export var id: String
var type = "fish"
export(Texture) var icon
export(String, "pond", "river") var location: String = "pond"
export var name: String
export(int, 1, 999) var price: int
export(int, 1, 100) var strength: int = 1
export(int, 1, 100) var stamina: int = 1
export(float, 0.01, 1000.0) var min_size: float = 0.1
export(float, 0.01, 1000.0) var max_size: float = 0.1
export(float, 0.01, 1.0) var rarity = 0.5
export(int, 10, 999) var health = 100
export var description: String
export var stack = 1
export(int, 0, 99) var starting = 0
var sort_weight = 99
