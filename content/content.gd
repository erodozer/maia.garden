extends Node

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
		"id": "tazzle_introduction",
		"sendAt": "introduce.tazzle",
		"sender": "Tazzle",
		"message": """
The winds have been whispering about a little fairy who's picked up fishing lately.
If you're up for a different challenge, I've set up camp near a nice river in the forest.  You can catch completely different fish here than you can in your pond.
I'll also gladly buy any fish you don't want.

Hope to see you soon~
""",
		"outro": "Tazzle"
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

const godash = preload("res://addons/godash/godash.gd")
var Items = []

func _ready():
	for item in godash.load_dir("res://content/", "item.tres", true).values():
		Items.append(item)

func get_item_reference(id):
	for i in Items:
		if i.id == id:
			return i
	return null
