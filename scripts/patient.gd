extends Node
class_name Patient

signal setup_finished()
signal died()

var time_left : float = 120.0
"""
scaling (daylength is always 5 minutes):
	day 1: 90-120 seconds per patient, patients required 3, 3 disease options per patient
	day 2: 90 - 120 seconds per patient, patients required 5, 4 disease options per patient
	day 3: 75 - 100 seconds per patient, patients required 6, 5 disease options per patient
	day 4: 75 - 100 seconds per patient, patients required 7, 7 disease options per patient
	day 5: 65 - 90 seconds per patient, patients required 9, 10 disease options per patient
	day 6: 50 - 75 seconds per patient, patients required 10, 14 disease options per patient
	day 7: 45 - 60 seconds per patient, patients required 12, all disease options per patient
"""

enum EYES {NORMAL, PINK, GOONER}
var eyecondition : EYES = EYES.NORMAL #normal, pink, gooner eye
var eye_color : Color = Color.BROWN
var bloodpressure : int = 50 #50 = normal, range from 0 - 100
var temprature : int = 50 # 50 is normal, like 90 degree temp. 100 is very hot
var whatstethohears : int = 0 #breathing,wheezing, crackling
var saliavacolor : int = 0 #clear, green, white
enum ARMS {NORMAL, RASH, COLD, HOT, FUNGAL}
var armcondition : ARMS = ARMS.NORMAL 

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
	ALLERGIC_CONJUNCTIVITIS#,
	#GOONED_TOO_MUCH_LOL
}

var disease : DISEASE

var diseasename : String

var curename : String = ""

var cures := {
	"CRYBABY_TREATMENT":
		[DISEASE.HEALTHY],
	"ANTIBIOTICS": [
		DISEASE.BACTERIAL_PNEUMONIA,
		DISEASE.BACTERIAL_BRONCHITIS,
		DISEASE.ENDOCARDITIS,
		DISEASE.TUBERCULOSIS
	],

	"ANTIVIRALS": [
		DISEASE.VIRAL_CONJUNCTIVITIS,
		DISEASE.VIRAL_BRONCHITIS,
		DISEASE.BRONCHITIS
	],

	"ALLERGY_MEDICINE": [
		DISEASE.SEASONAL_ALLERGIES,
		DISEASE.ALLERGIC_CONJUNCTIVITIS,
		DISEASE.ANAPHYLAXIS
	],

	"HEART_MEDICINE": [
		DISEASE.MYOCARDITIS,
		DISEASE.HEART_FAILURE,
		DISEASE.ATRIAL_FIBRILLATION,
		DISEASE.HYPERTENSION
	],

	"CHILL_PILL": [
		DISEASE.HYPOTHERMIA,
		DISEASE.HEAT_STROKE
	],

	"RESPIRATORY_MEDICINE": [
		DISEASE.ASTHMA
	],

	"EMERGENCY_MEDICINE": [
		DISEASE.SEPTIC_SHOCK,
		DISEASE.STIMULANT_OVERDOSE,
		DISEASE.OPIOID_OVERDOSE
	]#,

	#"THERAPY": [
	#	DISEASE.GOONED_TOO_MUCH_LOL
	#]
}

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
	armcondition = ARMS.NORMAL
	
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
			armcondition = ARMS.COLD
			
		DISEASE.ENDOCARDITIS:
			temprature = randi_range(75,95)
			whatstethohears = 2
			heartcondition = HEARTRATES.IRREGULAR
			armcondition = ARMS.RASH
			
		DISEASE.MYOCARDITIS:
			temprature = randi_range(75,90)
			heartcondition = HEARTRATES.IRREGULAR
			
		DISEASE.SEPTIC_SHOCK:
			bloodpressure = randi_range(15,30)
			temprature = randi_range(75,95)
			heartrate = randi_range(35,45)
			armcondition = ARMS.COLD
			
		DISEASE.ANAPHYLAXIS:
			bloodpressure = randi_range(15,30)
			whatstethohears = 1
			armcondition = ARMS.RASH
			
		DISEASE.STIMULANT_OVERDOSE:
			eyecondition = EYES.GOONER
			bloodpressure = randi_range(75,95)
			heartcondition = HEARTRATES.PUMPED
			heartrate = randi_range(38,45)
			armcondition = ARMS.HOT
			
		DISEASE.OPIOID_OVERDOSE:
			eyecondition = EYES.GOONER
			bloodpressure = randi_range(15,30)
			heartrate = randi_range(5,12)
			armcondition = ARMS.COLD
			
		DISEASE.HYPOTHERMIA:
			temprature = randi_range(5,25)
			heartrate = randi_range(5,12)
			armcondition = ARMS.COLD
			
		DISEASE.HEAT_STROKE:
			temprature = randi_range(90,100)
			heartcondition = HEARTRATES.PUMPED
			heartrate = randi_range(35,45)
			armcondition = ARMS.HOT
			
		DISEASE.HEART_FAILURE:
			whatstethohears = 2
			heartcondition = HEARTRATES.IRREGULAR
			armcondition = ARMS.COLD
			
		DISEASE.ATRIAL_FIBRILLATION:
			bloodpressure = randi_range(70,90)
			heartcondition = HEARTRATES.IRREGULAR
			
		DISEASE.HYPERTENSION:
			bloodpressure = randi_range(80,95)
			heartcondition = HEARTRATES.PUMPED
			armcondition = ARMS.HOT
			
		DISEASE.SEASONAL_ALLERGIES:
			eyecondition = EYES.PINK
			whatstethohears = 1
			armcondition = ARMS.RASH
			
		DISEASE.VIRAL_BRONCHITIS:
			whatstethohears = 1
			saliavacolor = 2
			temprature = randi_range(65,80)
			armcondition = ARMS.COLD
			
		DISEASE.BACTERIAL_BRONCHITIS:
			whatstethohears = 1
			saliavacolor = 1
			temprature = randi_range(75,90)
			armcondition = ARMS.COLD
			
		DISEASE.BRONCHITIS:
			whatstethohears = 1
			temprature = randi_range(70,85)
			armcondition = ARMS.COLD
			
		DISEASE.ASTHMA:
			whatstethohears = 1
			armcondition = ARMS.COLD
			
		DISEASE.TUBERCULOSIS:
			whatstethohears = 2
			saliavacolor = 1
			temprature = randi_range(70,90)
			armcondition = ARMS.FUNGAL
			
		DISEASE.ALLERGIC_CONJUNCTIVITIS:
			eyecondition = EYES.PINK
			armcondition = ARMS.RASH
			"""
		DISEASE.GOONED_TOO_MUCH_LOL:
			eyecondition = EYES.GOONER
			bloodpressure = randi_range(80,100)
			temprature = randi_range(95,100)
			whatstethohears = 1
			saliavacolor = 2
			armcondition = ARMS.HOT
			"""
	
	#clamp some stuff; more randomness
	bloodpressure = clampi(bloodpressure + randi_range(-3, 3), 0, 100)
	temprature = clampi(temprature + randi_range(-3, 3), 0, 100)
	heartrate += randi_range(-5,5)
	
	diseasename = DISEASE.keys()[disease].replace("_", " ").capitalize() #blah blah blah
	
	for c in cures:
		if disease in cures[c]:
			curename = c
			break
	
	setup_finished.emit()
	
	
