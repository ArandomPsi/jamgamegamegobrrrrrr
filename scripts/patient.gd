extends Node
class_name Patient

signal setup_finished()

enum EYES {NORMAL, PINK, GOONER}
var eyecondition : EYES = EYES.NORMAL #normal, pink, gooner eye
var bloodpressure : int = 50 #50 = normal, range from 0 - 100
var temprature : int = 50 # 50 is normal, like 90 degree temp. 100 is very hot
var whatstethohears : int = 0 #breathing, something else, something else
var saliavacolor : int = 0 #clear, green, white

enum HEARTRATES {NORMAL, IRREGULAR, PUMPED}
#Yo logan this is for the screen thingy
var heartcondition : HEARTRATES = HEARTRATES.NORMAL #normal (double beat), irregular (single beat), crazypumped (triple beat)
var heartrate : int 


func newpatient():
	eyecondition = EYES.values().pick_random() as EYES
	bloodpressure = randi_range(20,95)
	temprature = randi_range(30,100)
	whatstethohears = randi_range(0,3)
	saliavacolor = randi_range(0,3)
	heartcondition = HEARTRATES.values().pick_random() as HEARTRATES
	heartrate = randi_range(5, 45) * [1, -1].pick_random()
	setup_finished.emit()
