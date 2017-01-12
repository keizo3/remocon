/*
  SendInfraredData.c
*/

#include <wiringPi.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

#define BUF_LEN   256
#define WRITE_PIN 0

void sendModulatedData(int modulationTime)
{
    int i;
    
    for(i=0; i<modulationTime/26; i++){
        //high
        digitalWrite(WRITE_PIN, 1);
        delayMicroseconds(9);
    
        //low
        digitalWrite(WRITE_PIN, 0);
        delayMicroseconds(17);
    }
}

void sendData(int onTime, int offTime)
{
    //on
    sendModulatedData(onTime);
    
    //off
    digitalWrite(WRITE_PIN, 0);
    delayMicroseconds(offTime);
}


int main(int argc, char *argv[])
{
    int *onTime, *offTime;
    int i,j, length = 0;
    int repeat = 1;
    
    char *fileName = "ir_data.txt";
    char buf[BUF_LEN];
    
    FILE *fp;
    
    printf("start\n");
    
    if(argc == 2){
    	fileName = argv[1];
    }

    if((fp = fopen(fileName, "r")) == NULL){
        printf("can't open file : %s\n", fileName);
        exit(1);
    }
    
    if(wiringPiSetup() == -1){
        printf("error wiringPi setup\n");
        exit(1);
    }
    pinMode(WRITE_PIN, OUTPUT);

    printf("send irData!\n");
    
    //solve file Length
    while( fgets(buf, BUF_LEN, fp) != NULL)
        length++;
    
    onTime = (int *)calloc(length, sizeof(int));
    offTime = (int *)calloc(length, sizeof(int));
    
    //read data from file
    rewind(fp);
    for(i=0; i<length; i++){
        fscanf(fp,"%d %d", &onTime[i], &offTime[i]);
        //printf("%d  %d\n", onTime[i], offTime[i]);
    }
    
    
    //send data
    for(j=0; j<repeat; j++){
        for(i=0; i<length; i++){
            sendData(onTime[i], offTime[i]);
        }
        usleep(300000);
    }
    
    printf("program exit\n");
    fclose(fp);
    free(onTime);
    free(offTime);
    
    return 0;
}
