(defglobal ?*modifiedCarSpeed* = 0)
(defglobal ?*modifiedFanSpeed* = 5)
(defglobal ?*hazardLight* = "Off")
(defglobal ?*modifiedRpm* = 0)

(deftemplate engine
    (slot engineLight (allowed-values On Off))
    (slot make)
	(slot model)
	(slot year)
	(slot engineTemp (type INTEGER))
	(slot engineRpm (type INTEGER))
	(slot oilTemp (type INTEGER))
	(slot oilLevel (type INTEGER))
	(slot fanSpeed (type INTEGER))
    (slot crankshaftStatus (allowed-values NeedChanging good))
	(slot fuelLevel (allowed-values Low Medium High)) 
	(slot carSpeed (type INTEGER))
	
)


;( assert (engine (make VW)(model polo)(year 2008)(engineLight On)(engineTemp 230)(engineRpm 4000)(oilTemp 230)(fanSpeed 7)(fuelLevel High)(carSpeed 80)))
;( assert (engine (make VW)(model polo)(year 2008)(engineLight On)(engineTemp 180)(engineRpm 4000)(oilTemp 230)(fanSpeed 6)(fuelLevel High)(carSpeed 80)))
;( assert (engine (make VW)(model polo)(year 2008)(engineLight On)(engineTemp 130)(engineRpm 4000)(oilTemp 230)(fanSpeed 6)(fuelLevel High)(carSpeed 67)))
;( assert (engine (make VW)(model polo)(year 2008)(engineLight On)(engineTemp 180)(engineRpm 4000)(oilTemp 230)(fanSpeed 8)(fuelLevel High)(carSpeed 67)))
;( assert (engine (make VW)(model polo)(year 2008)(engineLight On)(engineTemp 100)(engineRpm 4000)(oilTemp -40)(fanSpeed 6)(fuelLevel High)(carSpeed 67)))
( assert (engine (make VW)(model polo)(year 2008)(engineLight On)(engineTemp 100)(engineRpm 4000)(oilTemp 120)(fanSpeed 6)(fuelLevel High)(carSpeed 67)))
;( assert (engine (make VW)(model polo)(year 2008)(engineLight On)(engineTemp 100)(engineRpm 4000)(oilTemp 170)(fanSpeed 6)(fuelLevel High)(carSpeed 67)))
;( assert (engine (make VW)(model polo)(year 2008)(engineLight On)(engineTemp 100)(engineRpm 4000)(oilTemp 432)(fanSpeed 6)(fuelLevel High)(carSpeed 67)))
;( assert (engine (make VW)(model polo)(year 2008)(engineLight On)(engineTemp 100)(engineRpm 4000)(oilTemp 100)(fanSpeed 6)(fuelLevel Low)(carSpeed 67)))
;( assert (engine (make VW)(model polo)(year 2008)(engineLight On)(engineTemp 100)(engineRpm 4000)(oilTemp 100)(fanSpeed 6)(fuelLevel Medium)(carSpeed 67)))
;( assert (engine (make VW)(model polo)(year 2008)(engineLight On)(engineTemp 100)(engineRpm 4000)(oilTemp 100)(fanSpeed 6)(fuelLevel High)(carSpeed 67)))
;( assert (engine (make VW)(model polo)(year 2008)(engineLight On)(engineTemp 100)(crankshaftStatus good)(engineRpm 4000)(oilTemp 100)(fanSpeed 6)(fuelLevel High)(carSpeed 67)))

;defining a function 
(deffunction modifyFanSpeed(?e)
	(if (> ?*modifiedFanSpeed* 9 ) then
        (return 10) 
      
        else (if (< ?*modifiedFanSpeed* 5 ) then
        (return 5) 
      
      
                        else
                        return (+ ?*modifiedFanSpeed* 2)
                )))
(deffunction reducecarSpeed(?e ?reduce)
	(if (< ?e.carSpeed 20) then
        (return 20) 
      else (if (>  ?e.carSpeed 80) then
            (return 45) 
   
                        else
                        return (- ?e.carSpeed ?reduce)
                )))
;Defining rules



(defrule fuellevellow
    ?e <- (engine{fuelLevel == Low})
    => (bind ?*modifiedCarSpeed* (reducecarSpeed ?e 20))  
    (printout t "| fuel Very low please find the gas station soon speed has been reduced to " ?*modifiedCarSpeed* crlf)
    )

(defrule fuellevelMedium
    ?e <- (engine{fuelLevel == Medium})
    => 
    (printout t "| Next time you are at the gas station fill up the tank. " crlf)
    )

(defrule fuellevelHigh
    ?e <- (engine{fuelLevel == High})
    => 
    (printout t "| you are good with fuel. " crlf)
)

(defrule crankshaftrule
    ?e <- (engine{crankshaftStatus == "NeedChanging"})
    => (bind ?*modifiedRpm* 2000)
    (printout t ".due to faulty Crankshaft Engine RPM has been limited to " ?*modifiedRpm*)
)

(defrule oilTempRule-3
    "this will configure your engine" 
?e <- (engine{oilTemp > 200})
    => (bind ?*modifiedFanSpeed* 10)
    (printout t " | Fan Speed changed to " ?*modifiedFanSpeed*)
    (bind ?*modifiedCarSpeed* 0)    
    (printout t "  Dangerously hot, engine oil Temperature is " ?e.oilTemp " Stop your vehicle and wait for the engine to cool down: updated speed " ?*modifiedCarSpeed* crlf)
    (bind ?*hazardLight* "On")
    (printout t "  hazard light " ?*hazardLight* crlf)
)
(defrule oilTempRule-2
    "this will configure your engine" 
?e <- (engine{(oilTemp > 150)&&(oilTemp < 200)})
    => (bind ?*modifiedFanSpeed* 10)
    (printout t " | Fan Speed changed to " ?*modifiedFanSpeed*)
    
)
(defrule OilTempRule-1
    "this will configure your engine" 
?e <- (engine{(oilTemp > 120)&&(oilTemp < 150)})
    => (bind ?*modifiedFanSpeed* (modifyFanSpeed ?e))
    (printout t " | Fan Speed changed to " ?*modifiedFanSpeed*)
    )

(defrule OilTempRule-0

?e <- (engine{oilTemp < 120})
    => 
    (printout t "| Engine oil temperature Looks good ")
)

(defrule EngineTempRule-3
   " this will configure your engine" 
?e <- (engine{(engineTemp > 120)&&(engineTemp < 150)})
    =>
  ;  (if(and(> ?e.engineTemp 120)(< ?e.engineTemp 150)) then
    (bind ?*modifiedCarSpeed* (reducecarSpeed ?e 15))
    (printout t " | hot engine " ?e.engineTemp "  reduced speed is " ?*modifiedCarSpeed* crlf)
    (bind ?*modifiedFanSpeed* (modifyFanSpeed ?e))
    (printout t "  Fan Speed " ?*modifiedFanSpeed*)
;)
  )    
(defrule EngineTempRule-2
   "this will configure your engine" 
?e <- (engine{(engineTemp > 150)&&(engineTemp < 200)})
    =>
    ;(if(and(> ?e.engineTemp 150)(< ?e.engineTemp 200)) then
    (bind ?*modifiedCarSpeed* (reducecarSpeed ?e 20))    
    (printout t " | Very hot engine " ?e.engineTemp " and reduced speed " ?*modifiedCarSpeed* crlf)
    (bind ?*modifiedFanSpeed* (modifyFanSpeed ?e))
    (printout t "Fan Speed " ?*modifiedFanSpeed*) 
;)
  )    
(defrule EngineTempRule-1
   "this will configure your engine" 
?e <- (engine{engineTemp > 200})
    =>
   ; (if(and(> ?e.engineTemp 20)(< ?e.engineTemp 2003)) then
    (bind ?*modifiedCarSpeed* 0)    ;)
    (printout t "|Dangerously hot, engine Temperature is " ?e.engineTemp " Stop your vehicle and wait for the engine to cool down: updated speed " ?*modifiedCarSpeed* crlf)
    (bind ?*hazardLight* "On")
    (printout t ".hazard light " ?*hazardLight* crlf)
    )
(defrule EngineTempRule-0

?e <- (engine{engineTemp < 120})
    => 
    (printout t " | Engine temperature Looks good. ")
)


(defrule LowOilTempRule
   "will be trigged when engine oil temperature is very low"
    (declare (salience 1)) 
?e <- (engine{oilTemp < -30})
    =>
    (printout t "| Dangerously cold, Oil Temperature is very low please consider not driving today or leave the engine on for 15 minutes "  crlf)
	(bind ?*hazardLight* "On")
    (printout t "hazard light " ?*hazardLight* crlf)
    )
(defrule light-on  
   "this will either control or SUGGEST engine configuration" 
(declare (salience 10))
    ?e <- (engine {engineLight == On})
    =>
    (printout t "	  !! Welcome !!
        ")
    (printout t "!!Engine Light is ON!!
please note following considitions will apply on your " ?e.make " " ?e.model " " ?e.year " Engine" crlf)
         
)
(defrule light-Off  
   "this will either control or SUGGEST engine configuration" 
(declare (salience 20))
    ?e <- (engine {engineLight == Off})
    =>
    (printout t "!! Welcome !!")
    (printout t "Even though engine light is off. following things are suggested for safer Driving " ?e.make " " ?e.model " " ?e.year " " crlf)
        
)

(run)	
(clear)
(exit)
