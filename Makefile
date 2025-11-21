all: tower
tower:  lights.o joystick.o tower.o
        ld $^ -o $@
lights.o: lights.s
        as -g $^ -o $@
joystick.o: joystick.s
        as -g $^ -o $@
tower.o: tower.s
        as -g $^ -o $@
clean:
        rm -f *.o tower
