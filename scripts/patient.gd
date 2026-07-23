extends Node
class_name Patient

signal setup_finished()

enum EYES {NORMAL, PINK, GOONER}
var eyecondition : EYES = EYES.NORMAL #normal, pink, gooner eye
var eye_color : Color = Color.BROWN
var bloodpressure : int = 50 #50 = normal, range from 0 - 100
var temprature : int = 50 # 50 is normal, like 90 degree temp. 100 is very hot
var whatstethohears : int = 0 #breathing,wheezing, crackling
var saliavacolor : int = 0 #clear, green, white

enum HEARTRATES {NORMAL, IRREGULAR, PUMPED}
#Yo logan this is for the screen thingy
var heartcondition : HEARTRATES = HEARTRATES.NORMAL #normal (double beat), irregular (single beat), crazypumped (triple beat)
var heartrate : int 

enum DISEASE {
	HEALTHY,
	VIRAL_CONJUNCTIVITIS,
	BACTERIAL_PNEUMONIA,
	ENDOCARDITIS,
	MYOCARDITIS,
	SEPTIC_SHOCK,
	ANAPHYLAXIS,
	STIMULANT_OVERDOSE,
	OPIOID_OVERDOSE,
	HYPOTHERMIA,
	HEAT_STROKE,
	HEART_FAILURE,
	ATRIAL_FIBRILLATION,
	HYPERTENSION,
	SEASONAL_ALLERGIES,
	VIRAL_BRONCHITIS,
	BACTERIAL_BRONCHITIS,
	BRONCHITIS,
	ASTHMA,
	TUBERCULOSIS,
	ALLERGIC_CONJUNCTIVITIS,
	GOONED_TOO_MUCH_LOL
}

var disease : DISEASE

var diseasename : String


#thanks chatgpt for organising this bc it was lowkey messy
func newpatient():
	disease = DISEASE.values().pick_random()
	
	# Healthy defaults
	eyecondition = EYES.NORMAL
	eye_color = Color(randf(), randf(), randf())
	bloodpressure = randi_range(45,55)
	temprature = randi_range(45,55)
	whatstethohears = 0
	saliavacolor = 0
	heartcondition = HEARTRATES.NORMAL
	heartrate = randi_range(18,28)
	
	match disease:
			
		DISEASE.HEALTHY:
			pass
			
		DISEASE.VIRAL_CONJUNCTIVITIS:
			eyecondition = EYES.PINK
			temprature = randi_range(70,85)
			
		DISEASE.BACTERIAL_PNEUMONIA:
			temprature = randi_range(75,95)
			whatstethohears = 2
			saliavacolor = 1
			heartrate = randi_range(30,40)
			
		DISEASE.ENDOCARDITIS:
			temprature = randi_range(75,95)
			whatstethohears = 2
			heartcondition = HEARTRATES.IRREGULAR
			
		DISEASE.MYOCARDITIS:
			temprature = randi_range(75,90)
			heartcondition = HEARTRATES.IRREGULAR
			
		DISEASE.SEPTIC_SHOCK:
			bloodpressure = randi_range(15,30)
			temprature = randi_range(75,95)
			heartrate = randi_range(35,45)
			
		DISEASE.ANAPHYLAXIS:
			bloodpressure = randi_range(15,30)
			whatstethohears = 1
			
		DISEASE.STIMULANT_OVERDOSE:
			eyecondition = EYES.GOONER
			bloodpressure = randi_range(75,95)
			heartcondition = HEARTRATES.PUMPED
			heartrate = randi_range(38,45)
			
		DISEASE.OPIOID_OVERDOSE:
			eyecondition = EYES.GOONER
			bloodpressure = randi_range(15,30)
			heartrate = randi_range(5,12)
			
		DISEASE.HYPOTHERMIA:
			temprature = randi_range(5,25)
			heartrate = randi_range(5,12)
			
		DISEASE.HEAT_STROKE:
			temprature = randi_range(90,100)
			heartcondition = HEARTRATES.PUMPED
			heartrate = randi_range(35,45)
			
		DISEASE.HEART_FAILURE:
			whatstethohears = 2
			heartcondition = HEARTRATES.IRREGULAR
			
		DISEASE.ATRIAL_FIBRILLATION:
			bloodpressure = randi_range(70,90)
			heartcondition = HEARTRATES.IRREGULAR
			
		DISEASE.HYPERTENSION:
			bloodpressure = randi_range(80,95)
			heartcondition = HEARTRATES.PUMPED
			
		DISEASE.SEASONAL_ALLERGIES:
			eyecondition = EYES.PINK
			whatstethohears = 1
			
		DISEASE.VIRAL_BRONCHITIS:
			whatstethohears = 1
			saliavacolor = 2
			temprature = randi_range(65,80)
			
		DISEASE.BACTERIAL_BRONCHITIS:
			whatstethohears = 1
			saliavacolor = 1
			temprature = randi_range(75,90)
			
		DISEASE.BRONCHITIS:
			whatstethohears = 1
			temprature = randi_range(70,85)
			
		DISEASE.ASTHMA:
			whatstethohears = 1
			
		DISEASE.TUBERCULOSIS:
			whatstethohears = 2
			saliavacolor = 1
			temprature = randi_range(70,90)
			
		DISEASE.ALLERGIC_CONJUNCTIVITIS:
			eyecondition = EYES.PINK
			
		DISEASE.GOONED_TOO_MUCH_LOL:
			eyecondition = EYES.GOONER
			bloodpressure = randi_range(80,100)
			temprature = randi_range(95,100)
			whatstethohears = 1
			saliavacolor = 2
	
	#clamp some stuff; more randomness
	bloodpressure = clampi(bloodpressure + randi_range(-3, 3), 0, 100)
	temprature = clampi(temprature + randi_range(-3, 3), 0, 100)
	heartrate += randi_range(-5,5)
	
	diseasename = DISEASE.keys()[disease].replace("_", " ").capitalize() #blah blah blah
	
	#I never deleted this lol
	setup_finished.emit()
	
	print(diseasename)
