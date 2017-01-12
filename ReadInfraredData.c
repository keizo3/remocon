/*
  ReadInfraredData.c
*/

#include <wiringPi.h>
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <sys/time.h>
#define READ_PIN 7

static int g_readFlag = 1;
 
void signalCallBackHandler(int sig)
{
    g_readFlag = 0;
}

double getSecTime()
{
    struct timeval tv;
    gettimeofday(&tv, NULL);
    return tv.tv_sec + tv.tv_usec;
}

int difMicros(double t1, double t2)
{
    return (int)(t2-t1);
}

int turnOnTime()
{
    int tenMicroSecCount = 0;
    double startTime, endTime;

    startTime = getSecTime();
    while( !digitalRead(READ_PIN) );
    endTime = getSecTime();

    return difMicros(startTime, endTime);
}

int turnOffTime()
{
    int tenMicroSecCount = 0;
    double startTime, endTime;

    startTime = getSecTime();
    while( digitalRead(READ_PIN) ){
    	delayMicroseconds(10);
    	tenMicroSecCount++;
    	if(tenMicroSecCount > 20000)  //over 20[ms]
    	    break;
    }
    endTime = getSecTime();

    return difMicros(startTime, endTime);
}

        

int main(int argc, char *argv[])
{
    int onTime, offTime;
    char *fileName = "ir_data.txt";
    
    FILE *fp;
    
    printf("start\n");
    printf("Pressed Ctrl+C, this program will exit.\n");
    
    if(argc == 2){
    	fileName = argv[1];
    }

    if((fp = fopen(fileName, "w")) == NULL){
        printf("can't open file : %s\n", fileName);
        exit(1);
    }
    
    if(signal(SIGINT, signalCallBackHandler) == SIG_ERR){
        printf("can't set signal\n");
        exit(1);
    }
    
    if(wiringPiSetup() == -1){
        printf("error wiringPi setup\n");
        exit(1);
    }
    
    pinMode(READ_PIN, INPUT);

    printf("please, send irData!\n");
    
    while( g_readFlag ){
    
        //on
        if( !digitalRead(READ_PIN) ){
            
            //data, footer
            while( g_readFlag ){
                onTime = turnOnTime();    //onTime
                offTime = turnOffTime();  //ofTtime
                fprintf(fp, "%6d ", onTime);
                fprintf(fp, "%6d\n", offTime);

                //foooter
                if(offTime > 200000){
                    fprintf(fp, "\n\n");
                    break;
                }
            }
            printf("finish recording\n");
        }
    }
    
    printf("program exit\n");
    fclose(fp);
    return 0;
}

