extends Node

const FISHING = [
	# pond fish
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
	},
	# river fish
	{
		"id": "bass",
		"type": "river",
		"name": "Bass",
		"sell": 40,
		"size": [20, 24],
		"rarity": .2,
		"health": 200
	},
	{
		"id": "sturgeon",
		"type": "river",
		"name": "Bass",
		"sell": 40,
		"size": [20, 24],
		"rarity": .2,
		"health": 200
	},
	{
		"id": "carp",
		"type": "river",
		"name": "Carp",
		"sell": 40,
		"size": [20, 24],
		"rarity": .2,
		"health": 200
	},
]

const CAFE = [
	{
		"id": "tea",
		"type": "cafe",
		"name": "Tea",
		"cost": 5,
		"stamina": 5,
		"description": "A smooth tea offers a small pick me up",
	},
	{
		"id": "coffee",
		"type": "cafe",
		"name": "Coffee",
		"cost": 10,
		"stamina": 10,
		"description": "Strong and bitter",
	},
	{
		"id": "latte",
		"type": "cafe",
		"name": "Latte",
		"cost": 20,
		"stamina": 15,
		"description": "Perfectly sweet and light"
	},
	{
		"id": "matcha",
		"type": "cafe",
		"name": "Matcha",
		"cost": 15,
		"stamina": 10,
		"description": "A relaxing tea seeped in tradition"
	},
]

const FLOWERS = {
	"clover": {
		"type": "flower",
		"id": "clover",
		"name": "Clover",
		"cost": 5,
		"sell": 10,
		"mature": 2,
		"starting": 5,
		"description": "Grows a patch of clovers (2 days)",
	},
	"daisy": {
		"type": "flower",
		"id": "daisy",
		"name": "Daisy",
		"cost": 10,
		"sell": 30,
		"mature": 3,
		"starting": 5,
		"description": "Grow cute white Daisy's (3 days)",
	},
	"tulip": {
		"type": "flower",
		"id": "tulip",
		"name": "Tulip",
		"cost": 15,
		"sell": 60,
		"mature": 6,
		"starting": 3,
		"description": "Grows Pink Tulips (6 days)",
	},
	"catgrass": {
		"type": "flower",
		"id": "catgrass",
		"name": "Catgrass",
		"cost": 5,
		"sell": 12,
		"mature": 2,
		"starting": 0,
		"description": "Grows catgrass (2 days)",
		"unlock": "request.yuuki_1.completed"
	},
}

const MAIL = [
	{
		"id": "fulavu_bday",
		"sendAt": 1637038800,
		"sender": "FuLavu",
		"message": """Dear maia,

Happy birthday to you!
Please keep being amazing.
I wish you the best in everything you'll do. 
""",
		"outro": "FuLavu",
	},
	{
		"id": "rakknir_bday",
		"sendAt": 1637038800,
		"sender": "Rakknir",
		"message": """It's already that time again.
This is the second of your birthdays we get to celebrate together, I'm really happy that we got to and I hope we get to celebrate many many more together.
Happy birthday Maia hope you have an amazing day.
""",
		"outro": "Rakknir\nPs. Could you refill the mods water bowl? it's been empty for the past few months"
	},
	{
		"id": "artermia_bday",
		"sendAt": 1637038800,
		"sender": "Artermia",
		"message": """Happy Birthday Maia! Only 186 candles to blow out~ I hope you got some cake and you're having an amazing birthday!""",
		"outro": "Love, Artermia"
	},
	{
		"id": "oliver_bday",
		"sendAt": 1637038800,
		"sender": "Oliver",
		"message": """Happy birthday Maia! 
You've survived another revolution around our sun and that's pretty neato if you ask me. I hope you have an incredible day and an even better one next year""",
		"outro": "Oliver"
	},
	{
		"id": "vogon_bday",
		"sendAt": 1637038800,
		"sender": "Vogon",
		"message": """A sweet Happy Birfday to the sweetest little fairy!
Thanks for a whole year of streams and then a whole year of birthdays!
The Garden wishes you the absolute best on your special day!
""",
		"outro": "Vogon out",
	},
	{
		"id": "yuuki_introduction",
		"sendAt": "introduce.yuuki",
		"sender": "Yuuki",
		"message": """Hi Maia!
I hear you've been working hard around your garden lately.  Well lucky for you I've opened up a new Cafe in the forest.

If you ever need a boost of energy or a place to relax you should come visit!
""",
		"outro": "Yuuki"
	},
	{
		"id": "chie_introduction",
		"sendAt": "introduce.chie",
		"sender": "Chie",
		"message": """Daily Fortune Telling
---
Good Luck!

The spirits are in your favor today, your radiant flowers are sure to yield lots of konpeto.

If you'd like to receive another fortune for tomorrow, come over to the shrine!
""",
		"outro": "Chie",
	},
	{
		"id": "test_message",
		"sendAt": 0,
		"sender": "Ero",
		"message": """This is a test message
If you see this in the final version I forgot to remove it
""",
		"outro": "Ero",
	},
]
