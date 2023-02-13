/*
 Bread Machine */

mtype = {checkIngredients, stillWorking, yesAnswer}

chan signal = [0] of {mtype};
byte secondsCount=0;
bool bread_is_being_made = false;
bool has_water = false;
bool has_flour = false;

active proctype WaterSensor() {

	waiting: atomic {
				printf("There is enough water to start making the bread \n");
				has_water = true;

				signal!checkIngredients;

				goto waitingAnswer;
			   }
;	
	waitingAnswer: 
		if
		:: signal?yesAnswer -> atomic {
								printf("The bread was made \n");
								goto finishingBread;
		   					  }
;
		:: signal?stillWorking -> atomic {
								printf("The bread is not done yet  \n");
								goto waiting;
								};            
		fi;
    finishingBread:
 atomic { bread_is_being_made = true;};
}

active proctype FlourSensor() {

	waiting: atomic {
				printf("There is enough flour to start making the bread \n");
		
				signal!checkIngredients;

				has_flour = true;
				goto waitingAnswer;
			   }
;	
	waitingAnswer: 
		if
		:: signal?yesAnswer -> atomic {
								printf("The bread was made \n");
								goto finishingBread;
		   					  }
;
		:: signal?stillWorking -> atomic {
								printf("The bread is not done yet  \n");
								goto waiting;
								};            
		fi;
    finishingBread:
 atomic { bread_is_being_made = true;};
}

active proctype MachineController() {
	
	waiting: atomic {
				signal?checkIngredients -> {
					printf("We check the ingredients \n");
			
					if 
						:: has_water == true && has_flour == true -> atomic{
										secondsCount = 0;
										goto makingBread;
									};
						:: has_water == false || has_flour == false -> atomic{goto waiting;}
					fi;
			   }
;
	   }
;
	
	makingBread: atomic {		
		if 
			:: secondsCount < 5 -> atomic{
										secondsCount++;										
										goto makingBread;
									}
	        :: secondsCount == 5 -> atomic {signal!yesAnswer; goto finishingBread;}
			:: secondsCount == 5 -> atomic {signal!stillWorking; goto makingBread;}
		fi;
	}
;
	
	finishingBread: {
		bread_is_being_made = true;
		has_water = false;
		has_flour = false;
	}
;
};


/* [](!bread_is_being_made-> <> bread_is_being_made)  */
/* <>(has_water==true && has_flour==true) */
/* [](bread_is_being_made -> <> !has_water && !has_flour)   */

 
