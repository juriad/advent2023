;; MODEL

(deftemplate module
	(slot name)
	(multislot connections)
	(slot type
		(allowed-values normal flip-flop conjunction)))

;; STATES

(deftemplate flip-flop-state
	(slot module)
	(slot state
		(allowed-values on off)))
		
(deftemplate conjunction-state
	(slot module)
	(slot from)
	(slot level
		(allowed-values low high)))

;; PROCESSING

(deftemplate signal
	(slot id)
	(slot from)
	(slot to)
	(slot level
		(allowed-values low high)))

(deftemplate send
	(slot from)
	(slot level
		(allowed-values low high)))

(deftemplate consume)

;; QUEUE


(deftemplate queue
	(slot side
		(allowed-values back front))
	(slot id))

(deftemplate counter
	(slot level
		(allowed-values low high))
	(slot count))
	
;; START

(deftemplate file
	(slot filename))
	
(deftemplate buttons
	(slot start)
	(slot count))
	
(deftemplate run
	(slot id)
	(slot low)
	(slot high))

;; SIGNAL HANDLING

(defrule send-signal
	(declare (salience 5))
	?s <- (send
		(from ?module)
		(level ?level))
	?qb <- (queue
		(side back)
		(id ?back))
	(module
		(name ?module)
		(connections $?connections))
	=>
	(retract ?s)
	(bind ?index 0)
	(foreach ?c ?connections
		(assert (signal
			(id (+ ?back ?index))
			(from ?module)
			(to ?c)
			(level ?level)))
		(bind ?index (+ ?index 1))
		(modify ?qb (id (+ ?back ?index)))
	)
)

(defrule consume-signal
	(declare (salience 10))
	?co <- (consume)
	?qf <- (queue
		(side front)
		(id ?front))
	?s <- (signal
		(id ?front)
		(level ?level))
	?c <- (counter
		(level ?level)
		(count ?count))
	=>
	(retract ?co)
	(modify ?qf (id (+ ?front 1)))
	(retract ?s)
	(modify ?c (count (+ ?count 1)))
)

;; MODULES

(defrule normal
	?qf <- (queue
		(side front)
		(id ?front))
	?s <- (signal
		(id ?front)
		(level ?level)
		(to ?module))
	(module
		(name ?module)
		(type normal))
	=>
	(assert (consume))
	(assert (send
		(from ?module)
		(level ?level)))
)

(defrule flip-flop-low
	?qf <- (queue
		(side front)
		(id ?front))
	?s <- (signal
		(id ?front)
		(level low)
		(to ?module))
	(module
		(name ?module)
		(type flip-flop))
	?st <- (flip-flop-state
		(module ?module)
		(state ?state))
	=>
	(assert (consume))
	(if (eq ?state off)
		then
		(modify ?st (state on))
		(assert (send
			(from ?module)
			(level high)))
		
		else
		(modify ?st (state off))
		(assert (send
			(from ?module)
			(level low)))
	)
)

(defrule flip-flop-high
	?qf <- (queue
		(side front)
		(id ?front))
	?s <- (signal
		(id ?front)
		(level high)
		(to ?module))
	(module
		(name ?module)
		(type flip-flop))
	=>
	(assert (consume))
)

(defrule conjunction
	?qf <- (queue
		(side front)
		(id ?front))
	?s <- (signal
		(id ?front)
		(level ?level)
		(from ?from)
		(to ?module))
	(module
		(name ?module)
		(type conjunction))
	?st <- (conjunction-state
		(module ?module)
		(from ?from))
	=>
	(assert (consume))
	(modify ?st (level ?level))
	(if 
		(any-factp ((?cs conjunction-state)) 
			(and
				(eq ?cs:module ?module)
				(eq ?cs:level low)
			)
		)
		then
		(assert (send
			(from ?module)
			(level high)))
		else
		(assert	(send
			(from ?module)
			(level low)))
	)
)

(defrule undefined
	(declare (salience -5))
	?qf <- (queue
		(side front)
		(id ?front))
	?s <- (signal
		(id ?front))
	=>
	(assert (consume))
)

;; START

(defrule def-modules
	?lf <- (file
		(filename ?filename))
	=>
	(retract ?lf)
	(open ?filename f "r")
	(while (neq EOF (bind ?line (readline f)))
		(bind ?arrow (str-index " -> " ?line))
		(bind ?rhs (str-replace
			(sub-string (+ ?arrow 4) 100000 ?line)
			"," ""))
		(bind ?connections (explode$ ?rhs))
		(switch (sub-string 1 1 ?line)
			(case "%" then
				(bind ?module (sub-string 2 (- ?arrow 1) ?line))
				(bind ?module (string-to-field ?module))
				(assert (module
					(name ?module)
					(type flip-flop)
					(connections ?connections)))
				(assert (flip-flop-state
					(module ?module)
					(state off))))
			(case "&" then
				(bind ?module (sub-string 2 (- ?arrow 1) ?line))
				(bind ?module (string-to-field ?module))
				(assert (module
					(name ?module)
					(type conjunction)
					(connections ?connections))))
			(default
				(bind ?module (sub-string 1 (- ?arrow 1) ?line))
				(bind ?module (string-to-field ?module))
				(assert (module
					(name ?module)
					(type normal)
					(connections ?connections))))
		)
	)
	(close f)
	(do-for-all-facts ((?conj module) (?from module))
		(and
			(eq ?conj:type conjunction)
			(member$ ?conj:name ?from:connections))
		(assert (conjunction-state
			(module ?conj:name)
			(from ?from:name)
			(level low)))
	)
)

(defrule press-button
	(declare (salience -20))
	?b <- (buttons
		(count ?count))
	(test (> ?count 0))
	=>
	(assert (signal
		(id 0)
		(from button)
		(to broadcaster)
		(level low)))
	(assert (queue
		(side front)
		(id 0)))
	(assert (queue
		(side back)
		(id 1)))
	(assert (counter
		(level low)
		(count 0)))
	(assert (counter
		(level high)
		(count 0)))
)

(defrule finish-run
	(declare (salience -10))
	?b <- (buttons
		(count ?count)
		(start ?start))
	(test (> ?count 0))
	(not (run
		(id ?start)))
	?qf <- (queue
		(side front))
	?qb <- (queue
		(side back))
	?cl <- (counter
		(level low)
		(count ?low))
	?ch <- (counter
		(level high)
		(count ?high))
	=>
	(modify ?b
		(start (+ ?start 1))
		(count (- ?count 1)))
	(retract ?qf)
	(retract ?qb)
	(retract ?cl)
	(retract ?ch)
	(assert (run
		(id ?start)
		(low ?low)
		(high ?high)))
)

(defrule remove-button
	?b <- (buttons
		(count 0))
	=>
	(retract ?b)
)

(defrule task1
	(declare (salience -100))
	=>
	(bind ?lows 0)
	(bind ?highs 0)
	(do-for-all-facts ((?r run))
		TRUE
		(bind ?lows (+ ?lows ?r:low))
		(bind ?highs (+ ?highs ?r:high))
	)
	(println (* ?lows ?highs))
)

(defrule rx-gets-low
	(declare (salience 10))
	?qf <- (queue
		(side front)
		(id ?front))
	?s <- (signal
		(id ?front)
		(level ?level)
		(from ?from)
		(to ls))
	(test (eq ?level high))
	(buttons
		(start ?start))
	=>
	(println ?level " to ls from " ?from " during " ?start)
)
	

(assert (file (filename "input")))
(assert (buttons
	(start 1)
	(count 1000)))
; (watch all)
(run)
;(facts)
(exit)
