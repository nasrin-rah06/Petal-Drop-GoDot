extends Control

var player_name = ""
var score = 0
var attempts = 5
var word_to_guess = ""
var guessed_letters = []

# Category word lists
var fruits = ['apple', 'banana', 'cherry', 'orange', 'grape', 'watermelon', 'kiwi', 'strawberry']
var programming = ["list","string","dictionary","syntax","variable","identifier","function"]
var animals = ["horse","koala","elephant","duck","hippopotamus","crocodile","lion","cheetah"]

# Called by MainMenu when scene is instantiated to set player name
func _ready():
	player_name = Global.player_name
	$PlayerNameLabel.text = "Player: " + player_name
	$ScoreLabel.text = "Score: " + str(score)

	# Connect button signals
	$FruitsButton.pressed.connect(_on_fruits_button_pressed)
	$ProgrammingButton.pressed.connect(_on_programming_button_pressed)
	$AnimalsButton.pressed.connect(_on_animals_button_pressed)
	$GuessButton.pressed.connect(_on_guess_button_pressed)

	reset_game()

	# Connect button signals for category buttons
	$FruitsButton.pressed.connect(_on_fruits_button_pressed)
	$ProgrammingButton.pressed.connect(_on_programming_button_pressed)
	$AnimalsButton.pressed.connect(_on_animals_button_pressed)
	$GuessButton.pressed.connect(_on_guess_button_pressed)

	reset_game()

func reset_game():
	guessed_letters.clear()
	attempts = 5
	update_petal_image()
	update_word_label()

func _on_fruits_button_pressed():
	word_to_guess = fruits[randi() % fruits.size()]
	reset_game()

func _on_programming_button_pressed():
	word_to_guess = programming[randi() % programming.size()]
	reset_game()

func _on_animals_button_pressed():
	word_to_guess = animals[randi() % animals.size()]
	reset_game()

func update_word_label():
	var display_word = ""
	for letter in word_to_guess:
		if letter in guessed_letters:
			display_word += letter + " "
		else:
			display_word += "_ "
	$WordLabel.text = display_word.strip_edges()

func update_petal_image():
	var petal_texture_path = "res://petals/petal_" + str(attempts) + ".png"
	$PetalImage.texture = load(petal_texture_path)

func _on_guess_button_pressed():
	var guess = $GuessInput.text.strip_edges().to_lower()
	$GuessInput.text = ""

	if guess.length() != 1 or !guess.is_valid_identifier() and !guess.is_subsequence_of("abcdefghijklmnopqrstuvwxyz"):
		$Popup.dialog_text = "ONE.LETTER.BRUH"
		$Popup.popup_centered()
		return

	if guess in guessed_letters:
		$Popup.dialog_text = "PEABRAIN YOU GUESSED THAT LETTER ALR"
		$Popup.popup_centered()
		return

	guessed_letters.append(guess)

	if guess not in word_to_guess:
		attempts -= 1
		update_petal_image()

		if attempts <= 0:
			$Popup.dialog_text = "DUMBASS The word was:" + word_to_guess
			$Popup.popup_centered()
			$GuessButton.disabled = true
			return

	update_word_label()

	# Check if word guessed fully
	var clean_word = word_to_guess.replace(" ", "")
	var guessed_word = ""
	for c in word_to_guess:
		guessed_word += (c if c in guessed_letters else "")
	if guessed_word == clean_word:
		score += 10
		$ScoreLabel.text = "Score: " + str(score)
		$Popup.dialog_text = "HELL YEAH"
		$Popup.popup_centered()
