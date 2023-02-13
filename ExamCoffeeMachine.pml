#define ESPRESSO 1
#define LATTE 2
#define CAPPUCCINO 3
#define FLAT_WHITE 4
#define MACCHIATO 5

byte coffee_request = 0;

byte coffeeProduced = 0;
bool descaling_needed = false;

#define coffeeToProduce 12

active proctype coffee_machine() {
    byte coffee_type;
    descaling_needed = false;
    coffeeProduced = 0;
    do
    :: (descaling_needed == false) ->
        coffee_type = coffee_request;
        if
        :: (coffee_type == ESPRESSO) -> coffeeProduced++;
        :: (coffee_type == LATTE) -> coffeeProduced++;
        :: (coffee_type == CAPPUCCINO) -> coffeeProduced++;
        :: (coffee_type == FLAT_WHITE) -> coffeeProduced++;
        :: (coffee_type == MACCHIATO) -> coffeeProduced++;
        fi;
        
		if
          :: coffeeProduced >= coffeeToProduce -> descaling_needed = true;
        fi;
    od
}

active proctype client() {
    do
    :: coffee_request = ESPRESSO;
    :: coffee_request = LATTE;
    :: coffee_request = CAPPUCCINO;
    :: coffee_request = FLAT_WHITE;
    :: coffee_request = MACCHIATO;
	:: coffee_request = ESPRESSO;
    :: coffee_request = LATTE;
    :: coffee_request = CAPPUCCINO;
    :: coffee_request = FLAT_WHITE;
    :: coffee_request = MACCHIATO;
	:: coffee_request = FLAT_WHITE;
    :: coffee_request = MACCHIATO;
    od
};

init {run coffee_machine(); }

/* [](coffeeProduced <= coffeeToProduce)  */
/* <>(coffeeProduced == coffeeToProduce) */



