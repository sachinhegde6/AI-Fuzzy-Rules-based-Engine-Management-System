(import nrc.fuzzy.*)
(import nrc.fuzzy.jess.FuzzyMain)
(import nrc.fuzzy.jess.*)
(load-package nrc.fuzzy.jess.FuzzyFunctions)

;Defining defglobals for holding car engine properties
;The engine temperature, Oil Temperature, Fan Speed, and Car Speed are all fuzzy variables
(defglobal ?*enginetemp* = (new FuzzyVariable "enginetemp" 0.0 200.0 "celsius"))
(defglobal ?*oiltemp* = (new FuzzyVariable "oiltemp" 0 200.0 "celsius"))
(defglobal ?*oillevel* = (new FuzzyVariable "oillevel" 0 100.0 "percentage"))
(defglobal ?*fuellevel* = (new FuzzyVariable "fuellevel" 0 100.0 "percentage"))

(defglobal ?*fanspeed* = (new FuzzyVariable "fanspeed" 0.0 10.0 "level"))
(defglobal ?*carspeed* = (new FuzzyVariable "carspeed" 0.0 85.0 "miles/hour"))

; defining non-fuzzy global variables
;car manufacturing details 
(defglobal ?*make* = "Volkswagen")
(defglobal ?*model* = "Beetle")
(defglobal ?*year* = "2016")

;non-fuzzy engine parameters
(defglobal ?*enginelight* = "ON")
(defglobal ?*hazardlight* = "OFF")


;rule 1
;defined to initialize all the global variables. please assert in the end to provide current input
(defrule initialize-fuzzy-variables
    (declare (salience 100))
    =>
/*
adding terms for engine temp
(defglobal ?*enginetemp* = (new FuzzyVariable "enginetemp" 0.0 200.0 "celsius"))
|low||medium||high||
|<120|120-150|150-200|
*/
    (printout t crlf)
    (printout t "==============Data initialization  and assertion================" crlf)
    (printout t "Initializing the engine temperature data" crlf)
 	(?*enginetemp* addTerm "low" (new ZFuzzySet 0 120))
	(?*enginetemp* addTerm "medium" (new TriangleFuzzySet 150 30))
    (?*enginetemp* addTerm "high" (new SFuzzySet 181 200))
    (call ?*enginetemp* addTerm "extremelyhot" "extremely high")

/*
adding terms for oil temp
(defglobal ?*oiltemp* = (new FuzzyVariable "oiltemp" 0 200.0 "celsius"))
|low||medium||high   |
|<120|120-150|150-200|
*/
    
    (printout t "Initializing the oil temperature data" crlf)
 	(?*oiltemp* addTerm "low" (new ZFuzzySet 0 120))
	(?*oiltemp* addTerm "medium" (new TriangleFuzzySet 150 30))
    (?*oiltemp* addTerm "high" (new SFuzzySet 181 200))
    (call ?*oiltemp* addTerm "extremelyhot" "extremely high")

/*
adding terms for Fan Speed    
(defglobal ?*fanspeed* = (new FuzzyVariable "fanspeed" 0.0 10.0 "level"))
|low||medium||high|
|1-5| 5-8    |7-10|     
*/
    (printout t "Initializing the fan speed data" crlf)
 	(?*fanspeed* addTerm "low" (new ZFuzzySet 1 5))
	(?*fanspeed* addTerm "medium" (new TriangleFuzzySet 6 2))
    (?*fanspeed* addTerm "high" (new SFuzzySet 7 10))

/*
adding terms for Car Speed    
(defglobal ?*carspeed* = (new FuzzyVariable "carspeed" 0.0 85.0 "miles/hour"))
|low||medium||high|
|20-35|35-55|50-85|     
*/
    (printout t "Initializing the car speed data" crlf)
 	(?*carspeed* addTerm "low" (new ZFuzzySet 20 35))
	(?*carspeed* addTerm "medium" (new TriangleFuzzySet 45 15))
    (?*carspeed* addTerm "high" (new SFuzzySet 50 85))
	(call ?*carspeed* addTerm "extremelyhigh" "extremely high")        

 /* 
Adding terms for oil level          
(defglobal ?*oillevel* = (new FuzzyVariable "oiltemp" 0 100.0 "percentage"))
 |low||medium||high|
|78-90|85-95|97-100|
*/  
    (printout t "Initializing the engine oil level data" crlf)
 	(?*oillevel* addTerm "low" (new ZFuzzySet 78 85))
	(?*oillevel* addTerm "medium" (new TriangleFuzzySet 90 5))
    (?*oillevel* addTerm "high" (new SFuzzySet 95 100))
	(call ?*oillevel* addTerm "extremelylow" "extremely low") 
/*
(defglobal ?*fuellevel* = (new FuzzyVariable "fuellevel" 0 100.0 "percentage"))
|low||medium||high|
|10-30|40-70|75-100|    
*/    
    (printout t "Initializing the fuel level data" crlf)
 	(?*fuellevel* addTerm "low" (new ZFuzzySet 10 30))
	(?*fuellevel* addTerm "medium" (new TriangleFuzzySet 55 15))
    (?*fuellevel* addTerm "high" (new SFuzzySet 75 100))
	(call ?*fuellevel* addTerm "extremelylow" "extremely low") 

     
 ;asserting  the user data. please change here to change the system input    
    (printout t "Asserting the data given by the user " crlf)
 	(assert (theenginetemp (new FuzzyValue ?*enginetemp* "high")))
  	(assert (theoiltemp (new FuzzyValue ?*oiltemp* "low")))
	(assert (theoillevel (new FuzzyValue ?*oillevel* "high")))
    (assert (thefuellevel (new FuzzyValue ?*fuellevel* "high")))


           
    (printout t crlf)
    (printout t "=======================Rule trigger==========================="crlf)
    (printout t "Following rules are trigged with the given input" crlf)
    (printout t crlf)
)


/* rules based on engine temperature
|low||medium||high   |
|<120|120-150|150-200|  
*/
;rule 2
(defrule Enginetemp-Low
    (declare (salience 3))
    (theenginetemp ?t&:(fuzzy-match ?t "low"))
      =>
    (assert (theFan (new FuzzyValue ?*fanspeed* "slightly medium")))
    (assert (theCar (new FuzzyValue ?*carspeed* "extremely very high")))
    (printout t "Triggering rule 2 for low engine temperature: " (?t momentDefuzzify) crlf)
)
;rule 3
(defrule EngineTemp-Medium
    (declare (salience 2))
    (theenginetemp ?t&:(fuzzy-match ?t "medium"))
      =>
    (assert (theFan (new FuzzyValue ?*fanspeed* "slightly high")))
    (assert (theCar (new FuzzyValue ?*carspeed* "medium")))
    (printout t "Triggering rule 3 for medium engine temperature: " (?t momentDefuzzify) crlf)
    )
;Rule 4 
(defrule EngineTemp-High
        (declare (salience 1))
    (theenginetemp ?t&:(fuzzy-match ?t "high"))
      =>
    (assert (theFan (new FuzzyValue ?*fanspeed* "very high")))
    (assert (theCar (new FuzzyValue ?*carspeed* "extremely low")))
     (bind ?*hazardlight* "ON")
    (printout t "Triggering rule 4 for high engine temperature: " (?t momentDefuzzify) crlf)    
    )

/* rules based on oil temperature
|low||medium||high   |
|<120|120-150|150-200|    
*/
;rule 5
(defrule OilTemp-Low
    (declare (salience 1))
    (theoiltemp ?t&:(fuzzy-match ?t "low"))
      =>
    (assert (theFan (new FuzzyValue ?*fanspeed* "low")))
    (assert (theCar (new FuzzyValue ?*carspeed* "extremely very high")))
    (printout t "Triggering rule 5 for low oil temperature: " (?t momentDefuzzify) crlf)
)


;rule 6
(defrule OilTemp-medium
    (declare (salience 2))
    (theoiltemp ?t&:(fuzzy-match ?t "medium"))
      =>
    (assert (theFan (new FuzzyValue ?*fanspeed* "medium")))
    (assert (theCar (new FuzzyValue ?*carspeed* "very high")))
    (printout t "Triggering rule 6 for medium oil temperature: " (?t momentDefuzzify) crlf)
)

;rule 7
(defrule OilTemp-high
    (declare (salience 1))
    (theoiltemp ?t&:(fuzzy-match ?t "high"))
      =>
    (assert (theFan (new FuzzyValue ?*fanspeed* "very high")))
    (assert (theCar (new FuzzyValue ?*carspeed* "low")))
     (bind ?*hazardlight* "ON")
    (printout t "Triggering rule 7 for high oil temperature: " (?t momentDefuzzify) crlf)
)

/* Rules for oil level
(defglobal ?*fuellevel* = (new FuzzyVariable "fuellevel" 0 100.0 "percentage"))
(assert (theoillevel (new FuzzyValue ?*oillevel* "<input>")))
|low||medium||high|
|10-30|40-70|75-100|    
*/
;rule 8 for low oil level
(defrule OilLevel-low
    (declare (salience 3))
    (theoillevel ?t&:(fuzzy-match ?t "low"))
      =>
    (assert (theCar (new FuzzyValue ?*carspeed* "extremely low")))
     (bind ?*hazardlight* "ON")
    (printout t "Triggering rule 8 for low oil level: " (?t momentDefuzzify) crlf)
)

;rule 9 for medium oil level
(defrule OilLevel-medium
    (declare (salience 2))
    (theoillevel ?t&:(fuzzy-match ?t "medium"))
      =>
    (assert (theCar (new FuzzyValue ?*carspeed* "slightly medium or high")))
    (printout t "Triggering rule 9 for medium oil level: " (?t momentDefuzzify) crlf)
)

;rule 10 for high oil level
(defrule OilLevel-high
    (declare (salience 1))
    (theoillevel ?t&:(fuzzy-match ?t "high"))
      =>
    (assert (theCar (new FuzzyValue ?*carspeed* "extremely high")))
    (printout t "Triggering rule 10 for high oil level: " (?t momentDefuzzify) crlf)
)

/*
(defglobal ?*fuellevel* = (new FuzzyVariable "fuellevel" 0 100.0 "percentage"))
(assert (thefuellevel (new FuzzyValue ?*fuellevel* "<input>")))
|low||medium||high|
|10-30|40-70|75-100|    
*/  
;rule 11 for low fuel level
(defrule fuelLevel-low
    (declare (salience 3))
    (thefuellevel ?t&:(fuzzy-match ?t "low"))
      =>
    (assert (theCar (new FuzzyValue ?*carspeed* "low or medium")))
    (printout t "Triggering rule 11 for low fuel level: " (?t momentDefuzzify) crlf)
)

;rule 12 for medium fuel level
(defrule fuelLevel-medium
    (declare (salience 2))
    (thefuellevel ?t&:(fuzzy-match ?t "medium"))
      =>
    (assert (theCar (new FuzzyValue ?*carspeed* "high")))
    (printout t "Triggering rule 12 for medium fuel level: " (?t momentDefuzzify) crlf)
)

;rule 13 for low fuel level
(defrule fuelLevel-high
    (declare (salience 1))
    (thefuellevel ?t&:(fuzzy-match ?t "high"))
      =>
    (assert (theCar (new FuzzyValue ?*carspeed* "extremely high")))
    (printout t "Triggering rule 13 for high fuel level: " (?t momentDefuzzify) crlf)
)




;rule for printing
(defrule print-results
    (declare (salience -100))
    (theFan ?fs)(theCar ?cs)
    =>
    (printout t crlf)
   (printout t " ======================Analysis and result====================" crlf)
   (printout t "		!!Welcome!!" crlf )
    (printout t "Following things are enforced or recommended for your car: " ?*make*" " ?*model* " of year " ?*year*)         
    (printout t crlf)
    (printout t "Radiator fan speed is set to " (?fs momentDefuzzify) crlf)      
    (printout t "Car speed is limited " (?cs momentDefuzzify) crlf)
    (printout t "Hazard light is:" ?*hazardlight* crlf)      
)

(reset)
(run)

