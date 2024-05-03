# TTT4145
TTT4145 - Radio Communication project

To run the system, two computers and Adalm-Pluto SDRs are needed.

Inside FullSystem there is a transmitter and receiver, voiceTransmit and voiceReceiveMultiThread respectively.

## To run the transmitter:
  Inside voiceTransmit, first run "setupTransmitter.m" before running "realtimeTransmit_multiple.m".
  Now the audio should automatically be recorded and transmitted through the SDR.

## To run the reciever:
  Inside voiceReceiveMultiThread, run "setupReceiver.m" and then "receiver.m".
  Whenever the receiver is run again after stopping the program, "clearTimers.m" needs to be ran in-between to ensure correct playback of the audio.
