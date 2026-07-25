extends Node2D

var descs : Dictionary = {
	"HEALTHY": "[b]Healthy[/b]\nA patient with no detected illness or abnormal symptoms.\nSymptoms:\n• Normal temperature\n• Normal blood pressure\n• Normal breathing\n• Normal heartbeat\n• Clear saliva\n• Normal eyes\n• Normal arms \n• Cure: Crybaby Treatment",

	"VIRAL_CONJUNCTIVITIS": "[b]Viral Conjunctivitis[/b]\nA viral infection of the eye that causes inflammation of the conjunctiva.\nSymptoms:\n• Pink/red eyes\n• Mild fever\n• Eye irritation\n• Increased tearing\n• Normal arms \nCure: Antivirals",

	"BACTERIAL_PNEUMONIA": "[b]Bacterial Pneumonia[/b]\nA bacterial infection that causes inflammation and fluid buildup in the lungs.\nSymptoms:\n• High fever\n• Green saliva/mucus\n• Crackling lung sounds\n• Rapid heartbeat\n• Weakness\n• Cold arms\n• Cure: Antibiotics",

	"ENDOCARDITIS": "[b]Endocarditis[/b]\nAn infection of the inner lining of the heart that can disrupt normal heart function.\nSymptoms:\n• Fever\n• Irregular heartbeat\n• Abnormal lung sounds\n• Fatigue\n• Low energy\n• Rashy arms\n• Cure: Antibiotics",

	"MYOCARDITIS": "[b]Myocarditis[/b]\nInflammation of the heart muscle that can affect heartbeat and circulation.\nSymptoms:\n• Fever\n• Irregular heartbeat\n• Chest discomfort\n• Fatigue\n• Weakness\n• Normal arms \nCure: Heart Medicine",

	"SEPTIC_SHOCK": "[b]Septic Shock[/b]\nA severe infection response causing dangerous drops in blood pressure.\nSymptoms:\n• High fever\n• Very low blood pressure\n• Rapid heartbeat\n• Weakness\n• Confusion\n• Cold arms\nCure: Emergency Medicine",

	"ANAPHYLAXIS": "[b]Anaphylaxis[/b]\nA severe allergic reaction causing breathing difficulty and circulation problems.\nSymptoms:\n• Wheezing\n• Low blood pressure\n• Rashy arms\nCure: Allergy Medicine",

	"STIMULANT_OVERDOSE": "[b]Stimulant Overdose[/b]\nA toxic reaction caused by excessive stimulant activity in the body.\nSymptoms:\n• Bloodshot eyes\n• High blood pressure\n• Extremely fast heartbeat\n• Increased body temperature\n• Agitation\n• Burning arms\nCure: Emergency Medicine",

	"OPIOID_OVERDOSE": "[b]Opioid Overdose[/b]\nA dangerous reaction caused by excessive opioid effects on the nervous system.\nSymptoms:\n• Abnormal eyes\n• Slow heartbeat\n• Low blood pressure\n• Cold arms\nCure: Emergency Medicine",

	"HYPOTHERMIA": "[b]Hypothermia[/b]\nA condition where the body temperature drops below normal levels.\nSymptoms:\n• Low body temperature\n• Slow heartbeat\n• Weakness\n• Confusion\n• Shivering\n• Cold arms\nCure: Chill Pill",

	"HEAT_STROKE": "[b]Heat Stroke[/b]\nA dangerous condition caused by extreme overheating of the body.\nSymptoms:\n• Very high temperature\n• Fast heartbeat\n• Strong heartbeat\n• Confusion\n• Weakness\n• Burning arms\nCure: Chill Pill",

	"HEART_FAILURE": "[b]Heart Failure[/b]\nA condition where the heart cannot pump blood effectively.\nSymptoms:\n• Crackling lung sounds\n• Irregular heartbeat\n• Shortness of breath\n• Fatigue\n• Weakness\n• Cold arms\nCure: Heart Medicine",

	"ATRIAL_FIBRILLATION": "[b]Atrial Fibrillation[/b]\nAn irregular heart rhythm caused by abnormal electrical activity in the heart.\nSymptoms:\n• Irregular heartbeat\n• High blood pressure\n• Rapid heartbeat\n• Dizziness\n• Fatigue\n• Normal arms\nCure: Heart Medicine",

	"HYPERTENSION": "[b]Hypertension[/b]\nA condition where blood pressure remains higher than normal.\nSymptoms:\n• High blood pressure\n• Strong heartbeat\n• Headache\n• Dizziness\n• Fatigue\n• Hot arms\nCure: Heart Medicine",

	"SEASONAL_ALLERGIES": "[b]Seasonal Allergies[/b]\nAn immune reaction to airborne substances such as pollen.\nSymptoms:\n• Pink eyes\n• Wheezing\n• Sneezing\n• Runny nose\n• Eye irritation\n• Rashy arms\nCure: Allergy Medicine",

	"VIRAL_BRONCHITIS": "[b]Viral Bronchitis[/b]\nA viral infection causing inflammation of the airways.\nSymptoms:\n• Wheezing\n• White saliva/mucus\n• Mild fever\n• Cough\n• Chest discomfort\n• Cold arms\n• Cure: Antivirals",

	"BACTERIAL_BRONCHITIS": "[b]Bacterial Bronchitis[/b]\nA bacterial infection causing inflammation of the bronchial tubes.\nSymptoms:\n• Wheezing\n• Green saliva/mucus\n• Fever\n• Cough\n• Chest discomfort\n• Cold arms\n• Cure: Antibiotics",

	"BRONCHITIS": "[b]Bronchitis[/b]\nInflammation of the airways that affects breathing.\nSymptoms:\n• Wheezing\n• Fever\n• Cough\n• Chest discomfort\n• Fatigue\n• Cold arms\nCure: Antivirals",

	"ASTHMA": "[b]Asthma[/b]\nA condition where the airways narrow and make breathing difficult.\nSymptoms:\n• Wheezing\n• Shortness of breath\n• Chest tightness\n• Difficulty breathing\n• Cold arms\nCure: Resipratory Medicine",

	"TUBERCULOSIS": "[b]Tuberculosis[/b]\nA bacterial infection that primarily affects the lungs.\nSymptoms:\n• Crackling lung sounds\n• Green saliva/mucus\n• Fever\n• Persistent cough\n• Weakness\n• Fungal infections\n• Cure: Antibiotics",

	"ALLERGIC_CONJUNCTIVITIS": "[b]Allergic Conjunctivitis[/b]\nAn allergic reaction causing inflammation of the eyes.\nSymptoms:\n• Pink eyes\n• Eye irritation\n• Tearing\n• Itching\n• Rashy arms\nCure: Allergy Medicine"
}

func regenerate(possible_diseases : Array):
	$RichTextLabel.text = " \n [b]Illnesses[/b]"
	for p in possible_diseases:
		$RichTextLabel.text += "\n ----------------- \n" + descs[p]
