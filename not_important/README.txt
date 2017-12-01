This directory not_important/ is just a directory for doing some tests of

my new wonderful Raspberry Pi based high quality IQAUDIO sound card

To start on RPI:

$ cd rpi/not_important

pi@raspberrypi:~/rpi/not_important $ bash radio_cmd.bash

Any time you may run status from:  $ bash radio_cmd.bash status

Feel free to add entries in the file not_important/radiolist.txt  which is read by the radio_cmd.bash program.

For install in the car, I recommend the 'radio_button.bash' program instead. Then you can just push a button to switch for

new stations: start it by the command $bash radio_button.bash  and put it as a script started on boot up of the RPI

In the car:

For install in the car, I recommend the 'radio_button.bash' program instead. Then you can just push a button repeatidly for

safter operation in the traffic. You then must have a button attached to GPIO23 (phys pin 16) in order to use the radio_button.bash 

Notice: As the radio_button.bash program is using GPIO and those GPIOs pins must be wired up in order for the program to work.   
        
        The radio_cmd.bash program is NOT doing any GPIO operations and you only need a naked Raspberry PC without any HATs or
        
        piggybacks attached.


- Steinar/LA7XQ
