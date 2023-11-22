/*!
 \file    vbuddy.cpp
 \brief   additional C++ code included in DUT testbench file to communicate with Vbuddy
 \author  Peter Cheung, Imperial College London
 \version 1.3
 \date    22 Oct 2022

This package is written to support a second year module on Electronics & Information Engineering (EIE)
at Imperial College. The module is on the design of the RISC V CPU.
*/

using namespace std;
using std::string;
using std::stoi;

// ---- Vbuddy user functions

// Open Vbuddy device, port path specified in vbuddy.cfg
//      ... return 1 if successful, else return <0 if fail
int vbdOpen();

// Close an opened Vbuddy device
void vbdClose();

// Clear the TFT screen to black
void vbdClear();

// Display 4-bit binary value in v on a 7 segment display
//     ...  digit is from 1 (right-most) to 5 (left most)
void vbdHex(int digit, int v);

// Plot y value scaled between min and max on TFT screen on next x coord.
//    ... When x reaches 240, screen is cleare and x starts from 0 again.
void vbdPlot(int y, int min, int max);

// Write header at top of TFT, centre justified
void vbdHeader(const char* header);

// Report the cycle count on bottom right of TFT screen
void vbdCycle(int cycle);

// Return current Flag value
bool vbdFlag();

// Set Flag mode: 0 - toggle, 1 - one-shot
void vbdSetMode (int mode);

// Return parameter value on Vbuddy set by the rotary encoder
int vbdValue();

// Initialise DAC output buffer with N samples
void vbdInitAnalogOut(int Nsamp);

// Output a sample to Vbuddy DAC buffer
void vbdOutputSample(int sample);

// Turn analog output ON
void vbdAoutON();

// Turn analog output OFF
void vbdAoutOFF();

// Initialise microphone buffer to capture N samples
void vbdInitMicIn(int Nsamp);

// get next sample from microphone buffer
int vbdMicValue();

// Return 0 if no key is pressed, otherwise return ASCII code of key 
// ... this function is non-blocking and does not actually use Vbuddy
char vbdGetkey();

// ---- End of Vbuddy User Function declarations

// Import serial communication functions originally by Philippe Lucidarme (v2.0)
// Modify by Peter Cheung to reduce those functions that are not required by Vbuddy

//  Header for serial communication functions
#ifndef SERIALIB_H
#define SERIALIB_H

#if defined(__CYGWIN__)
    // This is Cygwin special case
    #include <sys/time.h>
#endif

// Include for windows
#if defined (_WIN32) || defined (_WIN64)
#if defined(__GNUC__)
    // This is MinGW special case
    #include <sys/time.h>
#else
    // sys/time.h does not exist on "actual" Windows
    #define NO_POSIX_TIME
#endif
    // Accessing to the serial port under Windows
    #include <windows.h>
#endif

// Include for Linux
#if defined (__linux__) || defined(__APPLE__)
    #include <stdlib.h>
    #include <sys/types.h>
    #include <sys/shm.h>
    #include <termios.h>
    #include <string.h>
    #include <iostream>
    #include <sys/time.h>
    // File control definitions
    #include <fcntl.h>
    #include <unistd.h>
    #include <sys/ioctl.h>
#endif

/*! To avoid unused parameters */
#define UNUSED(x) (void)(x)

/**
 * number of serial data bits
 */
enum SerialDataBits {
    SERIAL_DATABITS_5, /**< 5 databits */
    SERIAL_DATABITS_6, /**< 6 databits */
    SERIAL_DATABITS_7, /**< 7 databits */
    SERIAL_DATABITS_8,  /**< 8 databits */
    SERIAL_DATABITS_16,  /**< 16 databits */
};

/**
 * number of serial stop bits
 */
enum SerialStopBits {
    SERIAL_STOPBITS_1, /**< 1 stop bit */
    SERIAL_STOPBITS_1_5, /**< 1.5 stop bits */
    SERIAL_STOPBITS_2, /**< 2 stop bits */
};

/**
 * type of serial parity bits
 */
enum SerialParity {
    SERIAL_PARITY_NONE, /**< no parity bit */
    SERIAL_PARITY_EVEN, /**< even parity bit */
    SERIAL_PARITY_ODD, /**< odd parity bit */
    SERIAL_PARITY_MARK, /**< mark parity */
    SERIAL_PARITY_SPACE /**< space bit */
};

/*!  \class     serialib
     \brief     This class is used for communication over a serial device.
*/
class serialib
{
public:
    //_____________________________________
    // ::: Constructors and destructors :::

    // Constructor of the class
    serialib    ();

    // Destructor
    ~serialib   ();

    //_________________________________________
    // ::: Configuration and initialization :::

    // Open a device
    char openDevice(const char *Device, const unsigned int Bauds,
                    SerialDataBits Databits = SERIAL_DATABITS_8,
                    SerialParity Parity = SERIAL_PARITY_NONE,
                    SerialStopBits Stopbits = SERIAL_STOPBITS_1);

    // Check device opening state
    bool isDeviceOpen();

    // Close the current device
    void    closeDevice();

    //___________________________________________
    // ::: Read/Write operation on characters :::

    // Write a char
    char    writeChar   (char);

    // Read a char (with timeout)
    char    readChar    (char *pByte,const unsigned int timeOut_ms=0);

    //________________________________________
    // ::: Read/Write operation on strings :::


    // Write a string
    char    writeString (const char *String);

    // Read a string (with timeout)
    int     readString  (   char *receivedString,
                            char finalChar,
                            unsigned int maxNbBytes,
                            const unsigned int timeOut_ms=0);



    // _____________________________________
    // ::: Read/Write operation on bytes :::


    // Write an array of bytes
    char    writeBytes  (const void *Buffer, const unsigned int NbBytes);

    // Read an array of byte (with timeout)
    int     readBytes   (void *buffer,unsigned int maxNbBytes,const unsigned int timeOut_ms=0, unsigned int sleepDuration_us=100);

    // _________________________
    // ::: Special operation :::

    // Empty the received buffer
    char    flushReceiver();

    // Return the number of bytes in the received buffer
    int     available();

    // Read a string (no timeout)
    int             readStringNoTimeOut  (char *String,char FinalChar,unsigned int MaxNbBytes);

#if defined (_WIN32) || defined( _WIN64)
    // Handle on serial device
    HANDLE          hSerial;
    // For setting serial port timeouts
    COMMTIMEOUTS    timeouts;
#endif
#if defined (__linux__) || defined(__APPLE__)
    int             fd;
#endif
};

/*!  \class     timeOut
     \brief     This class can manage a timer which is used as a timeout.
   */
// Class timeOut
class timeOut
{
public:

    // Constructor
    timeOut();

    // Init the timer
    void                initTimer();

    // Return the elapsed time since initialization
    unsigned long int   elapsedTime_ms();

private:
#if defined (NO_POSIX_TIME)
    // Used to store the previous time (for computing timeout)
    LONGLONG       counterFrequency;
    LONGLONG       previousTime;
#else
    // Used to store the previous time (for computing timeout)
    struct timeval      previousTime;
#endif
};
#endif // serialib_H
// End of serial communication function header section

//_____________________________________
// ::: Constructors and destructors :::

/*!
    \brief      Constructor of the class serialib.
*/
serialib::serialib()
{
#if defined (_WIN32) || defined( _WIN64)
    // Set default value for RTS and DTR (Windows only)
    currentStateRTS=true;
    currentStateDTR=true;
    hSerial = INVALID_HANDLE_VALUE;
#endif
#if defined (__linux__) || defined(__APPLE__)
    fd = -1;
#endif
}

/*!
    \brief      Destructor of the class serialib. It close the connection
*/
// Class desctructor
serialib::~serialib()
{
    closeDevice();
}

//_________________________________________
// ::: Configuration and initialization :::
/*!
     \brief Open the serial port
     \param Device : Port name (COM1, COM2, ... for Windows ) or (/dev/ttyS0, /dev/ttyACM0, /dev/ttyUSB0 ... for linux)
     \param Bauds : Baud rate of the serial port.

                \n Supported baud rate for Windows :
                        - 9600
                        - 14400
                        - 19200
                        - 38400
                        - 56000
                        - 57600
                        - 115200
                        - 128000
                        - 256000

               \n Supported baud rate for Linux :\n
                        - 9600
                        - 19200
                        - 38400
                        - 57600
                        - 115200
     \param Databits : Number of data bits in one UART transmission.

            \n Supported values: \n
                - SERIAL_DATABITS_5 (5)
                - SERIAL_DATABITS_6 (6)
                - SERIAL_DATABITS_7 (7)
                - SERIAL_DATABITS_8 (8)
                - SERIAL_DATABITS_16 (16) (not supported on Unix)

     \param Parity: Parity type

            \n Supported values: \n
                - SERIAL_PARITY_NONE (N)
                - SERIAL_PARITY_EVEN (E)
                - SERIAL_PARITY_ODD (O)
                - SERIAL_PARITY_MARK (MARK) (not supported on Unix)
                - SERIAL_PARITY_SPACE (SPACE) (not supported on Unix)
    \param Stopbit: Number of stop bits

            \n Supported values:
                - SERIAL_STOPBITS_1 (1)
                - SERIAL_STOPBITS_1_5 (1.5) (not supported on Unix)
                - SERIAL_STOPBITS_2 (2)

     \return 1 success
     \return -1 device not found
     \return -2 error while opening the device
     \return -3 error while getting port parameters
     \return -4 Speed (Bauds) not recognized
     \return -5 error while writing port parameters
     \return -6 error while writing timeout parameters
     \return -7 Databits not recognized
     \return -8 Stopbits not recognized
     \return -9 Parity not recognized
  */
char serialib::openDevice(const char *Device, const unsigned int Bauds,
                          SerialDataBits Databits,
                          SerialParity Parity,
                          SerialStopBits Stopbits) {
#if defined (_WIN32) || defined( _WIN64)
    // Open serial port
    hSerial = CreateFileA(Device,GENERIC_READ | GENERIC_WRITE,0,0,OPEN_EXISTING,/*FILE_ATTRIBUTE_NORMAL*/0,0);
    if(hSerial==INVALID_HANDLE_VALUE) {
        if(GetLastError()==ERROR_FILE_NOT_FOUND)
            return -1; // Device not found

        // Error while opening the device
        return -2;
    }

    // Set parameters

    // Structure for the port parameters
    DCB dcbSerialParams;
    dcbSerialParams.DCBlength=sizeof(dcbSerialParams);

    // Get the port parameters
    if (!GetCommState(hSerial, &dcbSerialParams)) return -3;

    // Set the speed (Bauds)
    switch (Bauds)
    {
    case 9600 :     dcbSerialParams.BaudRate=CBR_9600; break;
    case 14400 :    dcbSerialParams.BaudRate=CBR_14400; break;
    case 19200 :    dcbSerialParams.BaudRate=CBR_19200; break;
    case 38400 :    dcbSerialParams.BaudRate=CBR_38400; break;
    case 56000 :    dcbSerialParams.BaudRate=CBR_56000; break;
    case 57600 :    dcbSerialParams.BaudRate=CBR_57600; break;
    case 115200 :   dcbSerialParams.BaudRate=CBR_115200; break;
    case 128000 :   dcbSerialParams.BaudRate=CBR_128000; break;
    case 256000 :   dcbSerialParams.BaudRate=CBR_256000; break;
    default : return -4;
    }
    //select data size
    BYTE bytesize = 0;
    switch(Databits) {
        case SERIAL_DATABITS_5: bytesize = 5; break;
        case SERIAL_DATABITS_6: bytesize = 6; break;
        case SERIAL_DATABITS_7: bytesize = 7; break;
        case SERIAL_DATABITS_8: bytesize = 8; break;
        case SERIAL_DATABITS_16: bytesize = 16; break;
        default: return -7;
    }
    BYTE stopBits = 0;
    switch(Stopbits) {
        case SERIAL_STOPBITS_1: stopBits = ONESTOPBIT; break;
        case SERIAL_STOPBITS_1_5: stopBits = ONE5STOPBITS; break;
        case SERIAL_STOPBITS_2: stopBits = TWOSTOPBITS; break;
        default: return -8;
    }
    BYTE parity = 0;
    switch(Parity) {
        case SERIAL_PARITY_NONE: parity = NOPARITY; break;
        case SERIAL_PARITY_EVEN: parity = EVENPARITY; break;
        case SERIAL_PARITY_ODD: parity = ODDPARITY; break;
        case SERIAL_PARITY_MARK: parity = MARKPARITY; break;
        case SERIAL_PARITY_SPACE: parity = SPACEPARITY; break;
        default: return -9;
    }
    // configure byte size
    dcbSerialParams.ByteSize = bytesize;
    // configure stop bits
    dcbSerialParams.StopBits = stopBits;
    // configure parity
    dcbSerialParams.Parity = parity;

    // Write the parameters
    if(!SetCommState(hSerial, &dcbSerialParams)) return -5;

    // Set TimeOut

    // Set the Timeout parameters
    timeouts.ReadIntervalTimeout=0;
    // No TimeOut
    timeouts.ReadTotalTimeoutConstant=MAXDWORD;
    timeouts.ReadTotalTimeoutMultiplier=0;
    timeouts.WriteTotalTimeoutConstant=MAXDWORD;
    timeouts.WriteTotalTimeoutMultiplier=0;

    // Write the parameters
    if(!SetCommTimeouts(hSerial, &timeouts)) return -6;

    // Opening successfull
    return 1;
#endif
#if defined (__linux__) || defined(__APPLE__)
    // Structure with the device's options
    struct termios options;

    // Open device
    fd = open(Device, O_RDWR | O_NOCTTY | O_NDELAY);
    // If the device is not open, return -1
    if (fd == -1) return -2;
    // Open the device in nonblocking mode
    fcntl(fd, F_SETFL, FNDELAY);

    // Get the current options of the port
    tcgetattr(fd, &options);
    // Clear all the options
    bzero(&options, sizeof(options));

    // Prepare speed (Bauds)
    speed_t         Speed;
    switch (Bauds)
    {
    case 9600 :     Speed=B9600; break;
    case 19200 :    Speed=B19200; break;
    case 38400 :    Speed=B38400; break;
    case 57600 :    Speed=B57600; break;
    case 115200 :   Speed=B115200; break;
    default : return -4;
    }
    int databits_flag = 0;
    switch(Databits) {
        case SERIAL_DATABITS_5: databits_flag = CS5; break;
        case SERIAL_DATABITS_6: databits_flag = CS6; break;
        case SERIAL_DATABITS_7: databits_flag = CS7; break;
        case SERIAL_DATABITS_8: databits_flag = CS8; break;
        //16 bits and everything else not supported
        default: return -7;
    }
    int stopbits_flag = 0;
    switch(Stopbits) {
        case SERIAL_STOPBITS_1: stopbits_flag = 0; break;
        case SERIAL_STOPBITS_2: stopbits_flag = CSTOPB; break;
        //1.5 stopbits and everything else not supported
        default: return -8;
    }
    int parity_flag = 0;
    switch(Parity) {
        case SERIAL_PARITY_NONE: parity_flag = 0; break;
        case SERIAL_PARITY_EVEN: parity_flag = PARENB; break;
        case SERIAL_PARITY_ODD: parity_flag = (PARENB | PARODD); break;
        //mark and space parity not supported
        default: return -9;
    }

    // Set the baud rate
    cfsetispeed(&options, Speed);
    cfsetospeed(&options, Speed);
    // Configure the device : data bits, stop bits, parity, no control flow
    // Ignore modem control lines (CLOCAL) and Enable receiver (CREAD)
    options.c_cflag |= ( CLOCAL | CREAD | databits_flag | parity_flag | stopbits_flag);
    options.c_iflag |= ( IGNPAR | IGNBRK );
    // Timer unused
    options.c_cc[VTIME]=0;
    // At least on character before satisfy reading
    options.c_cc[VMIN]=0;
    // Activate the settings
    tcsetattr(fd, TCSANOW, &options);
    // Success
    return (1);
#endif

}

bool serialib::isDeviceOpen()
{
#if defined (_WIN32) || defined( _WIN64)
    return hSerial != INVALID_HANDLE_VALUE;
#endif
#if defined (__linux__) || defined(__APPLE__)
    return fd >= 0;
#endif
}

/*!
     \brief Close the connection with the current device
*/
void serialib::closeDevice()
{
#if defined (_WIN32) || defined( _WIN64)
    CloseHandle(hSerial);
    hSerial = INVALID_HANDLE_VALUE;
#endif
#if defined (__linux__) || defined(__APPLE__)
    close (fd);
    fd = -1;
#endif
}

//___________________________________________
// ::: Read/Write operation on characters :::
/*!
     \brief Write a char on the current serial port
     \param Byte : char to send on the port (must be terminated by '\0')
     \return 1 success
     \return -1 error while writting data
  */
char serialib::writeChar(const char Byte)
{
#if defined (_WIN32) || defined( _WIN64)
    // Number of bytes written
    DWORD dwBytesWritten;
    // Write the char to the serial device
    // Return -1 if an error occured
    if(!WriteFile(hSerial,&Byte,1,&dwBytesWritten,NULL)) return -1;
    // Write operation successfull
    return 1;
#endif
#if defined (__linux__) || defined(__APPLE__)
    // Write the char
    if (write(fd,&Byte,1)!=1) return -1;

    // Write operation successfull
    return 1;
#endif
}

//________________________________________
// ::: Read/Write operation on strings :::
/*!
     \brief     Write a string on the current serial port
     \param     receivedString : string to send on the port (must be terminated by '\0')
     \return     1 success
     \return    -1 error while writting data
  */
char serialib::writeString(const char *receivedString)
{
#if defined (_WIN32) || defined( _WIN64)
    // Number of bytes written
    DWORD dwBytesWritten;
    // Write the string
    if(!WriteFile(hSerial,receivedString,strlen(receivedString),&dwBytesWritten,NULL))
        // Error while writing, return -1
        return -1;
    // Write operation successfull
    return 1;
#endif
#if defined (__linux__) || defined(__APPLE__)
    std::cout << "";        // hack for comms issue with WSL
    // Lenght of the string
    int Lenght=strlen(receivedString);
    // Write the string
    if (write(fd,receivedString,Lenght)!=Lenght) return -1;
    // Write operation successfull
    return 1;
#endif
}

// _____________________________________
// ::: Read/Write operation on bytes :::
/*!
     \brief Write an array of data on the current serial port
     \param Buffer : array of bytes to send on the port
     \param NbBytes : number of byte to send
     \return 1 success
     \return -1 error while writting data
  */
char serialib::writeBytes(const void *Buffer, const unsigned int NbBytes)
{
#if defined (_WIN32) || defined( _WIN64)
    // Number of bytes written
    DWORD dwBytesWritten;
    // Write data
    if(!WriteFile(hSerial, Buffer, NbBytes, &dwBytesWritten, NULL))
        // Error while writing, return -1
        return -1;
    // Write operation successfull
    return 1;
#endif
#if defined (__linux__) || defined(__APPLE__)
    // Write data
    if (write (fd,Buffer,NbBytes)!=(ssize_t)NbBytes) return -1;
    // Write operation successfull
    return 1;
#endif
}

/*!
     \brief Wait for a byte from the serial device and return the data read
     \param pByte : data read on the serial device
     \param timeOut_ms : delay of timeout before giving up the reading
            If set to zero, timeout is disable (Optional)
     \return 1 success
     \return 0 Timeout reached
     \return -1 error while setting the Timeout
     \return -2 error while reading the byte
  */
char serialib::readChar(char *pByte,unsigned int timeOut_ms)
{
#if defined (_WIN32) || defined(_WIN64)
    // Number of bytes read
    DWORD dwBytesRead = 0;

    // Set the TimeOut
    timeouts.ReadTotalTimeoutConstant=timeOut_ms;

    // Write the parameters, return -1 if an error occured
    if(!SetCommTimeouts(hSerial, &timeouts)) return -1;

    // Read the byte, return -2 if an error occured
    if(!ReadFile(hSerial,pByte, 1, &dwBytesRead, NULL)) return -2;

    // Return 0 if the timeout is reached
    if (dwBytesRead==0) return 0;

    // The byte is read
    return 1;
#endif
#if defined (__linux__) || defined(__APPLE__)
    // Timer used for timeout
    timeOut         timer;
    // Initialise the timer
    timer.initTimer();
    // While Timeout is not reached
    while (timer.elapsedTime_ms()<timeOut_ms || timeOut_ms==0)
    {
        // Try to read a byte on the device
        switch (read(fd,pByte,1)) {
        case 1  : return 1; // Read successfull
        case -1 : return -2; // Error while reading
        }
    }
    return 0;
#endif
}

/*!
     \brief Read a string from the serial device (without TimeOut)
     \param receivedString : string read on the serial device
     \param FinalChar : final char of the string
     \param MaxNbBytes : maximum allowed number of bytes read
     \return >0 success, return the number of bytes read
     \return -1 error while setting the Timeout
     \return -2 error while reading the byte
     \return -3 MaxNbBytes is reached
  */
int serialib::readStringNoTimeOut(char *receivedString,char finalChar,unsigned int maxNbBytes)
{
    // Number of characters read
    unsigned int    NbBytes=0;
    // Returned value from Read
    char            charRead;

    // While the buffer is not full
    while (NbBytes<maxNbBytes)
    {
        // Read a character with the restant time
        charRead=readChar(&receivedString[NbBytes]);

        // Check a character has been read
        if (charRead==1)
        {
            // Check if this is the final char
            if (receivedString[NbBytes]==finalChar)
            {
                // This is the final char, add zero (end of string)
                receivedString  [++NbBytes]=0;
                // Return the number of bytes read
                return NbBytes;
            }

            // The character is not the final char, increase the number of bytes read
            NbBytes++;
        }

        // An error occured while reading, return the error number
        if (charRead<0) return charRead;
    }
    // Buffer is full : return -3
    return -3;
}

/*!
     \brief Read a string from the serial device (with timeout)
     \param receivedString : string read on the serial device
     \param finalChar : final char of the string
     \param maxNbBytes : maximum allowed number of bytes read
     \param timeOut_ms : delay of timeout before giving up the reading (optional)
     \return  >0 success, return the number of bytes read
     \return  0 timeout is reached
     \return -1 error while setting the Timeout
     \return -2 error while reading the byte
     \return -3 MaxNbBytes is reached
  */
int serialib::readString(char *receivedString,char finalChar,unsigned int maxNbBytes,unsigned int timeOut_ms)
{
    // Check if timeout is requested
    if (timeOut_ms==0) return readStringNoTimeOut(receivedString,finalChar,maxNbBytes);

    // Number of bytes read
    unsigned int    nbBytes=0;
    // Character read on serial device
    char            charRead;
    // Timer used for timeout
    timeOut         timer;
    long int        timeOutParam;

    // Initialize the timer (for timeout)
    timer.initTimer();

    // While the buffer is not full
    while (nbBytes<maxNbBytes)
    {
        // Compute the TimeOut for the next call of ReadChar
        timeOutParam = timeOut_ms-timer.elapsedTime_ms();

        // If there is time remaining
        if (timeOutParam>0)
        {
            // Wait for a byte on the serial link with the remaining time as timeout
            charRead=readChar(&receivedString[nbBytes],timeOutParam);

            // If a byte has been received
            if (charRead==1)
            {
                // Check if the character received is the final one
                if (receivedString[nbBytes]==finalChar)
                {
                    // Final character: add the end character 0
                    receivedString  [++nbBytes]=0;
                    // Return the number of bytes read
                    return nbBytes;
                }
                // This is not the final character, just increase the number of bytes read
                nbBytes++;
            }
            // Check if an error occured during reading char
            // If an error occurend, return the error number
            if (charRead<0) return charRead;
        }
        // Check if timeout is reached
        if (timer.elapsedTime_ms()>timeOut_ms)
        {
            // Add the end caracter
            receivedString[nbBytes]=0;
            // Return 0 (timeout reached)
            return 0;
        }
    }

    // Buffer is full : return -3
    return -3;
}

/*!
     \brief Read an array of bytes from the serial device (with timeout)
     \param buffer : array of bytes read from the serial device
     \param maxNbBytes : maximum allowed number of bytes read
     \param timeOut_ms : delay of timeout before giving up the reading
     \param sleepDuration_us : delay of CPU relaxing in microseconds (Linux only)
            In the reading loop, a sleep can be performed after each reading
            This allows CPU to perform other tasks
     \return >=0 return the number of bytes read before timeout or
                requested data is completed
     \return -1 error while setting the Timeout
     \return -2 error while reading the byte
  */
int serialib::readBytes (void *buffer,unsigned int maxNbBytes,unsigned int timeOut_ms, unsigned int sleepDuration_us)
{
#if defined (_WIN32) || defined(_WIN64)
    // Avoid warning while compiling
    UNUSED(sleepDuration_us);

    // Number of bytes read
    DWORD dwBytesRead = 0;

    // Set the TimeOut
    timeouts.ReadTotalTimeoutConstant=(DWORD)timeOut_ms;

    // Write the parameters and return -1 if an error occrured
    if(!SetCommTimeouts(hSerial, &timeouts)) return -1;


    // Read the bytes from the serial device, return -2 if an error occured
    if(!ReadFile(hSerial,buffer,(DWORD)maxNbBytes,&dwBytesRead, NULL))  return -2;

    // Return the byte read
    return dwBytesRead;
#endif
#if defined (__linux__) || defined(__APPLE__)
    // Timer used for timeout
    timeOut          timer;
    // Initialise the timer
    timer.initTimer();
    unsigned int     NbByteRead=0;
    // While Timeout is not reached
    while (timer.elapsedTime_ms()<timeOut_ms || timeOut_ms==0)
    {
        // Compute the position of the current byte
        unsigned char* Ptr=(unsigned char*)buffer+NbByteRead;
        // Try to read a byte on the device
        int Ret=read(fd,(void*)Ptr,maxNbBytes-NbByteRead);
        // Error while reading
        if (Ret==-1) return -2;

        // One or several byte(s) has been read on the device
        if (Ret>0)
        {
            // Increase the number of read bytes
            NbByteRead+=Ret;
            // Success : bytes has been read
            if (NbByteRead>=maxNbBytes)
                return NbByteRead;
        }
        // Suspend the loop to avoid charging the CPU
        usleep (sleepDuration_us);
    }
    // Timeout reached, return the number of bytes read
    return NbByteRead;
#endif
}

// _________________________
// ::: Special operation :::

/*!
    \brief Empty receiver buffer
    \return If the function succeeds, the return value is nonzero.
            If the function fails, the return value is zero.
*/
char serialib::flushReceiver()
{
#if defined (_WIN32) || defined(_WIN64)
    // Purge receiver
    return PurgeComm (hSerial, PURGE_RXCLEAR);
#endif
#if defined (__linux__) || defined(__APPLE__)
    // Purge receiver
    tcflush(fd,TCIFLUSH);
    return true;
#endif
}

/*!
    \brief  Return the number of bytes in the received buffer (UNIX only)
    \return The number of bytes received by the serial provider but not yet read.
*/
int serialib::available()
{    
#if defined (_WIN32) || defined(_WIN64)
    // Device errors
    DWORD commErrors;
    // Device status
    COMSTAT commStatus;
    // Read status
    ClearCommError(hSerial, &commErrors, &commStatus);
    // Return the number of pending bytes
    return commStatus.cbInQue;
#endif
#if defined (__linux__) || defined(__APPLE__)
    int nBytes=0;
    // Return number of pending bytes in the receiver
    ioctl(fd, FIONREAD, &nBytes);
    return nBytes;
#endif
}

// ******************************************
//  Class timeOut
// ******************************************

/*!
    \brief      Constructor of the class timeOut.
*/
// Constructor
timeOut::timeOut()
{}

/*!
    \brief      Initialise the timer. It writes the current time of the day in the structure PreviousTime.
*/
//Initialize the timer
void timeOut::initTimer()
{
#if defined (NO_POSIX_TIME)
    LARGE_INTEGER tmp;
    QueryPerformanceFrequency(&tmp);
    counterFrequency = tmp.QuadPart;
    // Used to store the previous time (for computing timeout)
    QueryPerformanceCounter(&tmp);
    previousTime = tmp.QuadPart;
#else
    gettimeofday(&previousTime, NULL);
#endif
}

/*!
    \brief      Returns the time elapsed since initialization.  It write the current time of the day in the structure CurrentTime.
                Then it returns the difference between CurrentTime and PreviousTime.
    \return     The number of microseconds elapsed since the functions InitTimer was called.
  */
//Return the elapsed time since initialization
unsigned long int timeOut::elapsedTime_ms()
{
#if defined (NO_POSIX_TIME)
    // Current time
    LARGE_INTEGER CurrentTime;
    // Number of ticks since last call
    int sec;

    // Get current time
    QueryPerformanceCounter(&CurrentTime);

    // Compute the number of ticks elapsed since last call
    sec=CurrentTime.QuadPart-previousTime;

    // Return the elapsed time in milliseconds
    return sec/(counterFrequency/1000);
#else
    // Current time
    struct timeval CurrentTime;
    // Number of seconds and microseconds since last call
    int sec,usec;

    // Get current time
    gettimeofday(&CurrentTime, NULL);

    // Compute the number of seconds and microseconds elapsed since last call
    sec=CurrentTime.tv_sec-previousTime.tv_sec;
    usec=CurrentTime.tv_usec-previousTime.tv_usec;

    // If the previous usec is higher than the current one
    if (usec<0)
    {
        // Recompute the microseonds and substract one second
        usec=1000000-previousTime.tv_usec+CurrentTime.tv_usec;
        sec--;
    }

    // Return the elapsed time in milliseconds
    return sec*1000+usec/1000;
#endif
}

char vbdGetkey() {
    static const int STDIN = 0;
    static bool initialized = false;

    if (! initialized) {
        // Use termios to turn off line buffering
        termios term;
        tcgetattr(STDIN, &term);
        term.c_lflag &= ~ICANON;
        tcsetattr(STDIN, TCSANOW, &term);
        setbuf(stdin, NULL);
        initialized = true;
    }

    int bytesWaiting;
    ioctl(STDIN, FIONREAD, &bytesWaiting);
    if (!bytesWaiting)
        return (0);
    else
        return (getchar());
}

// Start of Vbuddy code 
serialib serial;   // this is global for now

void ack( ) {
  char receivedString[80];
  char finalChar = '\n';
  do {
      serial.readString(receivedString, finalChar, 80, 0);
    } while (receivedString[0]!='$');
}

void vbdClear() {
char msg[80];    // max 80 characters
    std::sprintf(msg, "$C\n"); serial.writeString(msg); ack();
}

int vbdOpen() {
  char port_name[80];       // max 80 characters

  // read port name from vbuddy.cfg
  FILE* input_file = fopen("vbuddy.cfg", "r");
    if (input_file == nullptr) 
        perror("Cannot find vbuddy.cfg\n");
    else {
        fgets(port_name, 80, input_file);
    }  
    fclose(input_file);

  // open USB port
  port_name[strlen(port_name)-1] = '\0';   // strip '\n'
  char errorOpening = serial.openDevice(port_name, 115200);
  if (errorOpening!=1) 
    printf ("\n** Error opening port: %s\n", port_name);
  else {
    printf ("\n ** Connected to Vbuddy via: %s\n", port_name);
    // clear Vbuddy screen
    serial.flushReceiver();
    vbdClear();
  }
  return(errorOpening);
}

void vbdClose() {
  char msg[80];    // max 80 characters
  std::sprintf(msg, "$t,    STOP,R\n"); 
  serial.writeString(msg); ack();
  serial.closeDevice();
}

void vbdHex(int digit, int v) {
  char msg[80];    // max 80 characters
  switch (digit) {
    case 5: std::sprintf(msg, "$H5,%d\n", v); break;
    case 4: std::sprintf(msg, "$H4,%d\n", v); break;
    case 3: std::sprintf(msg, "$H3,%d\n", v); break;
    case 2: std::sprintf(msg, "$H2,%d\n", v); break;
    case 1: std::sprintf(msg, "$H1,%d\n", v); break;
    case 0: std::sprintf(msg, "$H0,%d\n", v); break;
  }
  serial.writeString(msg); ack();
}

void vbdPlot(int y, int min, int max) {
  char msg[80];    // max 80 characters
  std::sprintf(msg, "$p,%d,%d,%d\n", y, min, max); 
  serial.writeString(msg); ack();
}

void vbdHeader(const char* header) {
  char msg[80];    // max 80 characters
  std::sprintf(msg, "$T,%s\n", header); 
  serial.writeString(msg); ack();
}

void vbdCycle(int cycle) {
  char msg[80];    // max 80 characters
  std::sprintf(msg, "$t,cyc:%4d,R\n", cycle); 
  serial.writeString(msg); ack();
}

bool vbdFlag() {
  char msg[10];    // max 80 characters
  char finalChar = '*';
  int  n;
  std::sprintf(msg, "$Y\n"); 
  serial.writeString(msg);
  do {
    n = serial.readStringNoTimeOut(msg, finalChar, 10);
  } while (n<=0);
  return((msg[1]=='1'));
}

void vbdSetMode (int m) {
  char msg[80];    // max 80 characters
  std::sprintf(msg, "$y,%1d\n", m); 
  serial.writeString(msg); ack();
}

int vbdValue() {
  char msg[80];    // max 80 characters
  char finalChar = '*';
  int  n;
  int istart;
  int iend;

  sprintf(msg, "$V\n"); 
  serial.writeString(msg);
  serial.flushReceiver();
  do {
    n = serial.readStringNoTimeOut(msg, finalChar, 10);
  } while ((n<=0));   
  string str = msg;
  istart = str.find("$");
  if (int(msg[1])<48) {       // this is a hack !!!!! - if not num, look for 2nd $
    str.erase(istart,1);        // not sure why we need it
    istart = str.find("$");     // spurious $ appears every other run ?????
  } 
  iend = str.find("*");
  str.erase(istart,1);      // remove leading '$'
  str.erase(iend,1);        // remove trailing '*'

  return(stoi(str));
}

void vbdInitAnalogOut(int Nsamp) {
    char msg[80];    // max 80 characters
    sprintf(msg, "$S,%d\n", Nsamp);
    serial.writeString(msg); ack();
}

void vbdOutputSample(int sample) {
    char msg[80];    // max 80 characters
    sprintf(msg, "$s,%d\n", sample);
    serial.writeString(msg); ack();
}

void vbdAoutON() {
    char msg[80];    // max 80 characters
    sprintf(msg, "$O\n");
    serial.writeString(msg); ack();
}

void vbdAoutOFF() {
    char msg[80];    // max 80 characters
    sprintf(msg, "$o\n");
    serial.writeString(msg); ack();
}

void vbdInitMicIn(int Nsamp) {
    char msg[80];    // max 80 characters
    sprintf(msg, "$M,%d\n", Nsamp);
    serial.writeString(msg); ack();
}

int vbdMicValue() {
  char msg[80];    // max 80 characters
  char finalChar = '*';
  int  n;
  int istart;
  int iend;

  sprintf(msg, "$m\n"); 
  serial.writeString(msg);
  serial.flushReceiver();
  do {
    n = serial.readStringNoTimeOut(msg, finalChar, 10);
  } while ((n<=0));   
  string str = msg;
  istart = str.find("$");
  if (int(msg[1])<48) {       // this is a hack !!!!! - if not num, look for 2nd $
    str.erase(istart,1);        // not sure why we need it
    istart = str.find("$");     // spurious $ appears every other run ?????
  } 
  iend = str.find("*");
  str.erase(istart,1);      // remove leading '$'
  str.erase(iend,1);        // remove trailing '*'
  return(stoi(str));
}