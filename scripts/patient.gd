extends Node

var eyecondition : int = 0 #normal, pink, gooner eye
var bloodpressure : int = 50 #50 = normal, range from 0 - 100
var temprature : int = 50 # 50 is normal, like 90 degree temp. 100 is very hot
var whatstethohears : int = 0 #breathing, something else, something else
var saliavacolor : int = 0 #clear, green, white

#Yo logan this is for the screen thingy
var heartcondition : int = 0 #normal (double beat), irregular (single beat)



func newpatient():
	eyecondition = randi_range(0,2)
	bloodpressure = randi_range(20,100)
	temprature = randi_range(30,100)
	whatstethohears = randi_range(0,3)
	saliavacolor = randi_range(0,3)
	heartcondition = randi_range(0,1)
	
	
