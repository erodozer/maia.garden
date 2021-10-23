extends Node

const FISHING = [
	{
		"id": "goldfish",
		"type": "pond",
		"name": "Goldfish",
		"sell": 3,
		"size": [4.7, 16.1],
		"rarity": 0.7,
		"health": 70,
	},
	{
		"id": "guppy",
		"type": "pond",
		"name": "Guppy",
		"sell": 3,
		"size": [0.6, 2.4],
		"rarity": .7,
		"health": 90
	},
	{
		"id": "koi",
		"type": "pond",
		"name": "Koi",
		"sell": 40,
		"size": [20, 24],
		"rarity": .2,
		"health": 200
	}
]

const CAFE = {
	"tea": {
		"type": "cafe",
		"name": "Tea",
		"cost": 5,
		"stamina": 5,
	},
	"coffee": {
		"type": "cafe",
		"name": "Coffee",
		"cost": 10,
		"stamina": 10
	},
	"latte": {
		"type": "cafe",
		"name": "Coffee",
		"cost": 20,
		"stamina": 15,
	},
	"matcha": {
		"type": "cafe",
		"name": "Matcha",
		"cost": 15,
		"stamina": 10,
	},
}

const FLOWERS = {
	"clover": {
		"type": "flower",
		"id": "clover",
		"name": "Clover",
		"cost": 5,
		"sell": 10,
		"mature": 2,
		"starting": 5,
	},
	"daisy": {
		"type": "flower",
		"id": "daisy",
		"name": "Daisy",
		"cost": 10,
		"sell": 30,
		"mature": 3,
		"starting": 5,
	},
	"tulip": {
		"type": "flower",
		"id": "tulip",
		"name": "Tulip",
		"cost": 15,
		"sell": 60,
		"mature": 6,
		"starting": 3,
	},
}
