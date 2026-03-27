import string
# Event code legend: see EVENT_CODES.md in this folder

# Event code reference
# Cxxx: cache update events
# Txxx: communication timeout events
# Vxxx: validation failures
# Lxxx: command limit-reached events
def CoreLog(evt, message)
    print("BRY: evt=", evt, " ", message)
end

class StoveClass
static var STOVE_OFFSET_RAM_READ              = 0x00  #    read Ram Address
static var STOVE_OFFSET_EEPROM_READ           = 0x20  #    read EEPROM Address
static var STOVE_OFFSET_RAM_WRITE             = 0x80  #   Write Ram
static var STOVE_OFFSET_EEPROM_WRITE          = 0xA0  #   Write Eeprom

static var STOVE_ADDRESS_RAM_INTERNAL_TIMER              = 0x00  #    internal timer of the program (ranging from 0-255 continuously)
static var STOVE_ADDRESS_RAM_AMBIENT_TEMPERATURE_X2      = 0x01  #    ambient temperature multiplied by 2
static var STOVE_ADDRESS_RAM_WATER_TEMP                  = 0x03  #    water Temp
static var STOVE_ADDRESS_RAM_PELLET_TIME                 = 0x0D  #    Pellet loading activation time
static var STOVE_ADDRESS_RAM_STOVE_STATE                 = 0x21  #    Stove state (status of stove 0 to 10 )
static var STOVE_ADDRESS_RAM_STOVE_REAMING_TIME_SEC      = 0x31  #    Current operation remaining time SEC
static var STOVE_ADDRESS_RAM_STOVE_REAMING_TIME_MIN      = 0x32  #    Current operation remaining time SEC
static var STOVE_ADDRESS_RAM_CURRENT_OUTPUT_POWER        = 0x34  #    Current stove output
static var STOVE_ADDRESS_RAM_FUMES_FAN                   = 0x37  #    fumes fan speed
static var STOVE_ADDRESS_RAM_FUMES_TEMPERATURE           = 0x5a  #    Fumes temperature
static var STOVE_ADDRESS_RAM_SECONDS                     = 0x65  #    Secounds, decimal, read only
static var STOVE_ADDRESS_RAM_DAY                         = 0x66  #    Day of week, decimal, read only
static var STOVE_ADDRESS_RAM_HOUR_DECIMAL                = 0x67  #    Hour, decimal, read only
static var STOVE_ADDRESS_RAM_MINUTE_DECIMAL              = 0x68  #    Minute, decimal, read only
static var STOVE_ADDRESS_RAM_DATE_DECIMAL                = 0x69  #    Day of Month, decimal, read only
static var STOVE_ADDRESS_RAM_MONTH_DECIMAL               = 0x6A  #    Month, decimal, read only
static var STOVE_ADDRESS_RAM_YEAR_DECIMAL                = 0x6B  #    Year since 2000, decimal, read only
static var STOVE_ADDRESS_RAM_DISPLAY_MESSAGE             = 0x80  #    Display Message From 0x80 to 0x8F, each address corresponds to a char on the display, read only
static var STOVE_ADDRESS_RAM_DISPLAY_MESSAGE_LENGTH      = 0x10  #    Length of display message (0x80 to 0x8F) 16 bytes

static var STOVE_ADDRESS_EEPROM_MINUTES_START                 =0x01    #   Minutes Start 2-12min N-9-6-02
static var STOVE_ADDRESS_EEPROM_CADENCE_CLEANING              =0x02    #   Cadence cleaning 3-240 sec N-9-6-03
static var STOVE_ADDRESS_EEPROM_AUGER_LINGHTS                 =0x03    #   Auger Linghts 0.1-8.0sec val/10 N-9-6-04
static var STOVE_ADDRESS_EEPROM_COCLEA_START                  =0x04    #   Coclea Start 0.1-8.0sec val/10 N-9-6-05
static var STOVE_ADDRESS_EEPROM_COCLEA_POWER1                 =0x05    #   Coclea Power 1 0.1-8.0sec val/10 N-9-6-06
static var STOVE_ADDRESS_EEPROM_COCLEA_POWER2                 =0x06    #   Coclea Power 2 0.1-8.0sec val/10 N-9-6-07
static var STOVE_ADDRESS_EEPROM_COCLEA_POWER3                 =0x07    #   Coclea Power 3 0.1-8.0sec val/10 N-9-6-08
static var STOVE_ADDRESS_EEPROM_COCLEA_POWER4                 =0x08    #   Coclea Power 4 0.1-8.0sec val/10 N-9-6-09
static var STOVE_ADDRESS_EEPROM_COCLEA_POWER5                 =0x09    #   Coclea Power 5 0.1-8.0sec val/10 N-9-6-10
static var STOVE_ADDRESS_EEPROM_DURATION_CLEANING             =0x0B    #   duration cleaning N-9-6-12
static var STOVE_ADDRESS_EEPROM_EXHAUST_START_FUSE_RPM        =0x0F    #   exhaust start N-9-6-16
static var STOVE_ADDRESS_EEPROM_EXHAUST_WAIT_FIRE             =0x10    #   exhaust waiting for fire N-9-6-17
static var STOVE_ADDRESS_EEPROM_EXHAUST_ENGINE_1              =0x11    #   exhaust engine 1 N-9-6-18
static var STOVE_ADDRESS_EEPROM_EXHAUST_ENGINE_2              =0x12    #   exhaust engine 2 N-9-6-19
static var STOVE_ADDRESS_EEPROM_EXHAUST_ENGINE_3              =0x13    #   exhaust engine 3 N-9-6-20
static var STOVE_ADDRESS_EEPROM_EXHAUST_ENGINE_4              =0x14    #   exhaust engine 4 N-9-6-21
static var STOVE_ADDRESS_EEPROM_EXHAUST_ENGINE_5              =0x15    #   exhaust engine 5 N-9-6-22
static var STOVE_ADDRESS_EEPROM_EXHHAUST_FINAL_CLEANING_SPEED =0x1C    #   exh speed final cleaning (stove off) N-9-6-29
static var STOVE_ADDRESS_EEPROM_AUGER_CLEANING_PELLET_TIME    =0x1D    #   auger cleaning  N-9-6-30
static var STOVE_ADDRESS_EEPROM_THRESHOL_PUMP                 =0x20    #   Water pump minimum temp to switch off N-9-6-33
static var STOVE_ADDRESS_EEPROM_STOVE_OFF_EXHAUST_TIME        =0x26    #   Stove Off exhaust time 0-20min N-9-4-02
static var STOVE_ADDRESS_EEPROM_PRELOAD_LIGHT                 =0x27    #   Preload light 0-255 N-9-4-03
static var STOVE_ADDRESS_EEPROM_WAITING_FIRE                  =0x28    #   Waiting fire 0-255sec n-9-4-04
static var STOVE_ADDRESS_EEPROM_EXHAUST_SPEED_PRELOAD         =0x29    #   Exhaust speed Preload  300-3000 (val/10)+25 N-9-4-05
static var STOVE_ADDRESS_EEPROM_PELLET_TYPE                   =0x35    #   Pellet type -9 +9 val-9
static var STOVE_ADDRESS_EEPROM_CHIMNEY_TYPE                  =0x36    #   Chimney type -9 +9 val-9
static var STOVE_ADDRESS_EEPROM_WEEKEND_TIMER_ON              =0x42    #   Timer WEEK-END On N-2-4-01
static var STOVE_ADDRESS_EEPROM_WEEKEND_TIMER_1_START         =0x43    #   Timer WEEK-END Start 1 N-2-4-02
static var STOVE_ADDRESS_EEPROM_WEEKEND_TIMER_1_STOP          =0x44    #   Timer WEEK-END Stop 1 N-2-4-03
static var STOVE_ADDRESS_EEPROM_WEEKEND_TIMER_2_START         =0x45    #   Timer WEEK-END Start 2 N-2-4-04
static var STOVE_ADDRESS_EEPROM_WEEKEND_TIMER_2_STOP          =0x46    #   Timer WEEK-END Stop 2 N-2-4-05
static var STOVE_ADDRESS_EEPROM_PROGRAM_DAY_ON                =0x47    #   Program Day ON On-off N-2-2-01
static var STOVE_ADDRESS_EEPROM_START_DAY_1                   =0x48    #   Start Day 1 00:00-23:50 N-2-2-02 ret_vlue(0-143 , 144-off)
static var STOVE_ADDRESS_EEPROM_STOP_DAY_1                    =0x49    #   Stop Day 1 00:00-23:50 N-2-2-03 ret_vlue(0-143 , 144-off)
static var STOVE_ADDRESS_EEPROM_START_DAY_2                   =0x4A    #   Start Day 2 00:00-23:50 N-2-2-04 ret_vlue(0-143 , 144-off)
static var STOVE_ADDRESS_EEPROM_STOP_DAY_2                    =0x4B    #   Stop Day 2 00:00-23:50 N-2-2-05 ret_vlue(0-143 , 144-off)
static var STOVE_ADDRESS_EEPROM_ENABLE_CHRONO                 =0x4C    #   Enable chrono On-Off N-2-1-01
static var STOVE_ADDRESS_EEPROM_STAND_BY_MODE_ON              =0x4D    #   Stand-by mode Off-On N05
static var STOVE_ADDRESS_EEPROM_MODE_BUZZER_ON                =0x4E    #   Mode Buzzer Off-On N-06
static var STOVE_ADDRESS_EEPROM_LANGUAGE                      =0x4F    #   Language Engish-Italiano Espanyol Franchais Deutch N-3
static var STOVE_ADDRESS_EEPROM_WEEK_TIMER_1_ENABLE           =0x50    #   Week Chrono Enable Prog-1 On-Off N-2-3-01
static var STOVE_ADDRESS_EEPROM_WEEK_TIMER_1_START            =0x51    #   Week Chrono Prog Start 00:00-23:50 N-2-3-02
static var STOVE_ADDRESS_EEPROM_WEEK_TIMER_1_STOP             =0x52    #   Week Chrono Prog Stop 00:00-23:50 N-2-3-03
static var STOVE_ADDRESS_EEPROM_WEEK_TIMER_1_MONDAY_ON        =0x53    #   Monday Timer ON 0-1 N-2-3-04
static var STOVE_ADDRESS_EEPROM_WEEK_TIMER_1_TUESDAY_ON       =0x54    #   Tuesday Timer ON 0-1 N-2-3-05
static var STOVE_ADDRESS_EEPROM_WEEK_TIMER_1_WENSDAY_ON       =0x55    #   Wensday Timer ON 0-1 N-2-3-06
static var STOVE_ADDRESS_EEPROM_WEEK_TIMER_1_THURSDAY_ON      =0x56    #   Thursday Timer ON 0-1 N-2-3-07
static var STOVE_ADDRESS_EEPROM_WEEK_TIMER_1_FRIDAY_ON        =0x57    #   Friday Timer ON 0-1 N-2-3-08
static var STOVE_ADDRESS_EEPROM_WEEK_TIMER_1_SATURDAY_ON      =0x58    #   Saturday Timer ON 0-1 N-2-3-09
static var STOVE_ADDRESS_EEPROM_WEEK_TIMER_1_SUNNDAY_ON       =0x59    #   Sunday Timer ON 0-1 N-2-3-10
static var STOVE_ADDRESS_EEPROM_WEEK_TIMER_2_START            =0x5A    #   Start Program 2 N-2-3-11
static var STOVE_ADDRESS_EEPROM_WEEK_TIMER_2_STOP             =0x5B    #   Stop Program 2 N-2-3-12
static var STOVE_ADDRESS_EEPROM_WEEK_TIMER_2_MONDAY_ON        =0x5C    #   Monday Prog 2 ON 0-1 N-2-3-13
static var STOVE_ADDRESS_EEPROM_WEEK_TIMER_2_TUESDAY_ON       =0x5D    #   Tuesday Prog 2 ON 0-1 N-2-3-14
static var STOVE_ADDRESS_EEPROM_WEEK_TIMER_2_WENSDAY_ON       =0x5E    #   Wensday Prog 2 ON 0-1 N-2-3-15
static var STOVE_ADDRESS_EEPROM_WEEK_TIMER_2_THURSDAY_ON      =0x5F    #   Thursday Prog 2 ON 0-1 N-2-3-16
static var STOVE_ADDRESS_EEPROM_WEEK_TIMER_2_FRIDAY_ON        =0x60    #   Friday Prog 2 ON 0-1 N-2-3-17
static var STOVE_ADDRESS_EEPROM_WEEK_TIMER_2_SATURDAY_ON      =0x61    #   Saturday Prog 2 ON 0-1 N-2-3-18
static var STOVE_ADDRESS_EEPROM_WEEK_TIMER_2_SUNNDAY_ON       =0x62    #   Sunday Prog 2 ON 0-1 N-2-3-19
static var STOVE_ADDRESS_EEPROM_WEEK_TIMER_3_START            =0x63    #   Start Program 3 N-2-3-20
static var STOVE_ADDRESS_EEPROM_WEEK_TIMER_3_STOP             =0x64    #   Stop Program 3 N-2-3-21
static var STOVE_ADDRESS_EEPROM_WEEK_TIMER_3_MONDAY_ON        =0x65    #   Monday Prog 3 ON 0-1 N-2-3-22
static var STOVE_ADDRESS_EEPROM_WEEK_TIMER_3_TUESDAY_ON       =0x66    #   Tuesday Prog 3 ON 0-1 N-2-3-23
static var STOVE_ADDRESS_EEPROM_WEEK_TIMER_3_WENSDAY_ON       =0x67    #   Wensday Prog 3 ON 0-1 N-2-3-24
static var STOVE_ADDRESS_EEPROM_WEEK_TIMER_3_THURSDAY_ON      =0x68    #   Thursday Prog 3 ON 0-1 N-2-3-25
static var STOVE_ADDRESS_EEPROM_WEEK_TIMER_3_FRIDAY_ON        =0x69    #   Friday Prog 3 ON 0-1 N-2-3-26
static var STOVE_ADDRESS_EEPROM_WEEK_TIMER_3_SATURDAY_ON      =0x6A    #   Saturday Prog 3 ON 0-1 N-2-3-27
static var STOVE_ADDRESS_EEPROM_WEEK_TIMER_3_SUNNDAY_ON       =0x6B    #   Sunday Prog 3 ON 0-1 N-2-3-28
static var STOVE_ADDRESS_EEPROM_WEEK_TIMER_4_START            =0x6C    #   Start Program 4 N-2-3-29
static var STOVE_ADDRESS_EEPROM_WEEK_TIMER_4_STOP             =0x6D    #   Stop Program 4 N-2-3-30
static var STOVE_ADDRESS_EEPROM_WEEK_TIMER_4_MONDAY_ON        =0x6E    #   Monday Prog 4 ON 0-1 N-2-3-31
static var STOVE_ADDRESS_EEPROM_WEEK_TIMER_4_TUESDAY_ON       =0x6F    #   Tuesday Prog 4 ON 0-1 N-2-3-32
static var STOVE_ADDRESS_EEPROM_WEEK_TIMER_4_WENSDAY_ON       =0x70    #   Wensday Prog 4 ON 0-1 N-2-3-33
static var STOVE_ADDRESS_EEPROM_WEEK_TIMER_4_THURSDAY_ON      =0x71    #   Thursday Prog 4 ON 0-1 N-2-3-34
static var STOVE_ADDRESS_EEPROM_WEEK_TIMER_4_FRIDAY_ON        =0x72    #   Friday Prog 4 ON 0-1 N-2-3-35
static var STOVE_ADDRESS_EEPROM_WEEK_TIMER_4_SATURDAY_ON      =0x73    #   Saturday Prog 4 ON 0-1 N-2-3-36
static var STOVE_ADDRESS_EEPROM_WEEK_TIMER_4_SUNNDAY_ON       =0x74    #   Sunday Prog 4 ON 0-1 N-2-3-37
static var STOVE_ADDRESS_EEPROM_ROOM_TEMP                     =0x7D    #   Room temp
static var STOVE_ADDRESS_EEPROM_POWER_OUTPUT                  =0x7F    #   Power output
static var STOVE_ADDRESS_EEPROM_WATER_TEMP                    =0x80    #   Water temp

# IRCOMMANDS
static var STOVE_IR_POWERUP       =  0x50
static var STOVE_IR_POWERDOWN     =  0x54
static var STOVE_IR_TEMPUP        =  0x52
static var STOVE_IR_TEMPDOWN      =  0x58
static var STOVE_IR_POWER         =  0x5A
static var STOVE_ADDR_IRCOMMAND   =  0x58  

static var STOVE_STATUS_LIST= ["Off","Startup","Pellet Loading","Waiting for fire","Working","Cleanin Fire Pot","Final cleaning","Standby","No-Pellet Alarm","No ignition alarm","Undefined alarms"]
static var stoveOnCommand = [0x80, 0x21, 0x01, 0xA2]
static var stoveOffCommand= [0x80, 0x21, 0x06, 0xA7]
static var EepromPublish_IntervalSec = 600

var address_to_Read_list
 
static var StoveReading_Interval  = 2 # 2 seconds updating interval
var ser
var msgFromStove
var StoveRAM , StoveEEPROM 


#local variables not exposed outside the class
var requestedData
var TimesNotRecieved
var last_invalid_ram_read_addr
var last_invalid_eeprom_read_addr
var last_invalid_ram_write_addr
var last_invalid_eeprom_write_addr
var has_read_eeprom_once
var eeprom_publish_countdown
var publish_eeprom_snapshot


    def init()
        self.StoveRAM= [] 
        for i: 0..255
            self.StoveRAM.push(0) # or any initial value
        end
        self.StoveEEPROM= []
        for i: 0..255
            self.StoveEEPROM.push(0) # or any initial value
        end
        self.ser= serial(17, 16, 1200, serial.SERIAL_8N2)


        self.requestedData=false
        self.TimesNotRecieved=0
        self.last_invalid_ram_read_addr=nil
        self.last_invalid_eeprom_read_addr=nil
        self.last_invalid_ram_write_addr=nil
        self.last_invalid_eeprom_write_addr=nil
        self.has_read_eeprom_once=false
        self.eeprom_publish_countdown=self.EepromPublish_IntervalSec
        self.publish_eeprom_snapshot=false
        self.OtherCommandQuee=[]
        self.has_othercommand=false
        self.address_to_Read_list=[0x00, self.STOVE_ADDRESS_RAM_AMBIENT_TEMPERATURE_X2,
                                0x00, self.STOVE_ADDRESS_RAM_WATER_TEMP,
                                0x00, self.STOVE_ADDRESS_RAM_PELLET_TIME,
                                0x00, self.STOVE_ADDRESS_RAM_STOVE_STATE,
                                0x00, self.STOVE_ADDRESS_RAM_STOVE_REAMING_TIME_SEC,
                                0x00, self.STOVE_ADDRESS_RAM_STOVE_REAMING_TIME_MIN,
                                0x00, self.STOVE_ADDRESS_RAM_CURRENT_OUTPUT_POWER,
                                0x00, self.STOVE_ADDRESS_RAM_FUMES_FAN,
                                0x00, self.STOVE_ADDRESS_RAM_FUMES_TEMPERATURE,
                                0x20, self.STOVE_ADDRESS_EEPROM_PELLET_TYPE,
                                0x20, self.STOVE_ADDRESS_EEPROM_CHIMNEY_TYPE,
                                0x20, self.STOVE_ADDRESS_EEPROM_POWER_OUTPUT,
                                0x20, self.STOVE_ADDRESS_EEPROM_WATER_TEMP,
                                0x20, self.STOVE_ADDRESS_EEPROM_ROOM_TEMP]
    end
    def calculate_CRC(bytes_toCheck, bytecount)
        var crcVal=0
        var Crc1=0
        for i:0..bytecount-1
            crcVal+=bytes_toCheck[i]
        end
        return(crcVal & 0xFF) # return only the last 2 digits of the sum as CRC
    end
    def stove_state_label()
        var state_idx = self.StoveRAM[self.STOVE_ADDRESS_RAM_STOVE_STATE]
        if state_idx==nil || state_idx<0 || state_idx>=self.STOVE_STATUS_LIST.size()
            return "Unknown"
        end
        return self.STOVE_STATUS_LIST[state_idx]
    end
    def stove_is_off()
        return self.StoveRAM[self.STOVE_ADDRESS_RAM_STOVE_STATE]==0
    end
    def write_eeprom_if_changed(address, value)
        if value != self.StoveEEPROM[address]
            self.StoveWriteData(self.STOVE_OFFSET_EEPROM_WRITE, address, value)
        end
    end
    def time_from_int(value)
        if value==nil || value<0 || value>=144
            return "OFF"
        else
            var hours = int(value*10 / 60)
            var minutes = int(value*10 % 60 )
            return format("%02d:%02d",hours,minutes)
        end
    end
    def int_from_time(value)
        if value == nil || value == "" || string.toupper(value) == "OFF"
            return 144
        else
            try
                var parts = string.split(value, ":")
                var hours = int(parts[0])
                var minutes = int(parts[1])
                var total_minutes = hours*60 + minutes
                if total_minutes<0 || total_minutes>1430
                    return 144
                end
                return total_minutes/10
            except .. as e,m
                CoreLog("G001", format("invalid_time_input value='%s' err='%s' msg='%s'", value, e, m))
                return 144
            end
        end
    end
    def load_stove_settings()
        var R = self.STOVE_OFFSET_EEPROM_READ
        self.OtherCommandQuee=[
                R, self.STOVE_ADDRESS_EEPROM_AUGER_LINGHTS,
                R, self.STOVE_ADDRESS_EEPROM_MINUTES_START,
                R, self.STOVE_ADDRESS_EEPROM_CADENCE_CLEANING,
                R, self.STOVE_ADDRESS_EEPROM_COCLEA_START,
                R, self.STOVE_ADDRESS_EEPROM_COCLEA_POWER1,
                R, self.STOVE_ADDRESS_EEPROM_COCLEA_POWER2,
                R, self.STOVE_ADDRESS_EEPROM_COCLEA_POWER3,
                R, self.STOVE_ADDRESS_EEPROM_COCLEA_POWER4,
                R, self.STOVE_ADDRESS_EEPROM_COCLEA_POWER5,
                R, self.STOVE_ADDRESS_EEPROM_DURATION_CLEANING,
                R, self.STOVE_ADDRESS_EEPROM_EXHAUST_START_FUSE_RPM,
                R, self.STOVE_ADDRESS_EEPROM_EXHAUST_WAIT_FIRE,
                R, self.STOVE_ADDRESS_EEPROM_EXHAUST_ENGINE_1,
                R, self.STOVE_ADDRESS_EEPROM_EXHAUST_ENGINE_2,
                R, self.STOVE_ADDRESS_EEPROM_EXHAUST_ENGINE_3,
                R, self.STOVE_ADDRESS_EEPROM_EXHAUST_ENGINE_4,
                R, self.STOVE_ADDRESS_EEPROM_EXHAUST_ENGINE_5,
                R, self.STOVE_ADDRESS_EEPROM_EXHHAUST_FINAL_CLEANING_SPEED,
                R, self.STOVE_ADDRESS_EEPROM_THRESHOL_PUMP]
        self.has_othercommand=true
    end
    var tempMess
    def ReadSerial()
        if self.ser.available() <4
            self.msgFromStove=[0,0,0,0]
        else
            var retVal 
            var AllSerialDataArray
            AllSerialDataArray = self.ser.read()   # read bytes from serial as bytes
            self.requestedData=false #reset requestedData flag to allow next request
            var i=0
           while i<AllSerialDataArray.size()
                if AllSerialDataArray.size() < i+3 # if there are less than 4 bytes left to read,
                    break
                end
                self.msgFromStove=AllSerialDataArray[i..(i+3)]  # convert bytes to int and store in msgFromStove


                if self.msgFromStove[0]==self.STOVE_OFFSET_RAM_READ
                    var ram_address = self.msgFromStove[1]
                    if ram_address>=0 && ram_address<self.StoveRAM.size()
                        self.StoveRAM[ram_address]=self.msgFromStove[3] # store the value read from
                        self.last_invalid_ram_read_addr=nil
                    else
                        if self.last_invalid_ram_read_addr!=ram_address
                            CoreLog("C001", string.format("cache_update_ignored type=read mem=RAM addr=%i offset=%i value=%i", ram_address, self.msgFromStove[0], self.msgFromStove[3]))
                            self.last_invalid_ram_read_addr=ram_address
                        end
                    end
                elif self.msgFromStove[0]==self.STOVE_OFFSET_EEPROM_READ
                    var eeprom_address = self.msgFromStove[1]
                    if eeprom_address>=0 && eeprom_address<self.StoveEEPROM.size()
                        self.StoveEEPROM[eeprom_address]=self.msgFromStove[3]# store the value read from the stove EEPROM 
                        self.has_read_eeprom_once=true
                        self.last_invalid_eeprom_read_addr=nil
                    else
                        if self.last_invalid_eeprom_read_addr!=eeprom_address
                            CoreLog("C002", string.format("cache_update_ignored type=read mem=EEPROM addr=%i offset=%i value=%i", eeprom_address, self.msgFromStove[0], self.msgFromStove[3]))
                            self.last_invalid_eeprom_read_addr=eeprom_address
                        end
                    end
                end 
                i+=4
            end
        end
    end
    def StoveWriteData(offset,adr,data)
        var CRC=self.calculate_CRC([offset, adr, data], 3)
        self.ser.write(offset&0xFF)
        self.ser.write(adr&0xFF)
        self.ser.write(data&0xFF)
        self.ser.write(CRC&0xFF)
        self.ser.read() # read the response from the stove to clear the serial buffer and allow the next command to be processed faster
        self.requestedData=false # reset requestedData flag to allow next request
        self.UpdateInterval=0 # reset update interval to send a new request immediately to get the updated values from the stove after sending a command
        if offset==self.STOVE_OFFSET_RAM_WRITE
            if adr>=0 && adr<self.StoveRAM.size()
                self.StoveRAM[adr]=data
                self.last_invalid_ram_write_addr=nil
            else
                if self.last_invalid_ram_write_addr!=adr
                    CoreLog("C003", string.format("cache_update_ignored type=write mem=RAM addr=%i offset=%i data=%i", adr, offset, data))
                    self.last_invalid_ram_write_addr=adr
                end
            end
        else
            if adr>=0 && adr<self.StoveEEPROM.size()
                self.StoveEEPROM[adr]=data
                self.last_invalid_eeprom_write_addr=nil
            else
                if self.last_invalid_eeprom_write_addr!=adr
                    CoreLog("C004", string.format("cache_update_ignored type=write mem=EEPROM addr=%i offset=%i data=%i", adr, offset, data))
                    self.last_invalid_eeprom_write_addr=adr
                end
            end
        end
        tasmota.delay(50) # delay to ensure stove can process the command before sending the next one
        #print("Writed %2X %2X %2X ",offset,adr,data)
    end
    
    var OtherCommandQuee, has_othercommand
    def RequestFromStove()
        if !self.requestedData #if requestedData is not true then send request
            if self.has_othercommand
                var i=0
                while i<self.OtherCommandQuee.size()
                    if self.OtherCommandQuee.size()>i+1
                        self.ser.write(self.OtherCommandQuee[i])
                        self.ser.write(self.OtherCommandQuee[i+1])
                        if (self.OtherCommandQuee[i]==self.STOVE_OFFSET_RAM_WRITE) || (self.OtherCommandQuee[i]==self.STOVE_OFFSET_EEPROM_WRITE)  
                            if (self.OtherCommandQuee.size()>i+3 )
                                self.ser.write(self.OtherCommandQuee[i+2])
                                self.ser.write(self.OtherCommandQuee[i+3])
                                i+=2
                            end 
                        end
                    end
                    tasmota.delay(50) # delay between bytes to ensure stove can process them
                    i+=2
                end
                self.OtherCommandQuee.clear()
                self.has_othercommand=false
            else
                self.requestedData=true
                var i=0
                while i<self.address_to_Read_list.size()
                    if self.address_to_Read_list.size()<=i+1
                        break
                    end
                    self.ser.write(self.address_to_Read_list[i])   # send Read Rram
                    self.ser.write(self.address_to_Read_list[i+1])   # send Read Rram
                    tasmota.delay(60) # delay between bytes to ensure stove can process them
                    i+=2
                end
                tasmota.set_timer(40, /->self.ReadSerial())
                self.TimesNotRecieved=0
            end
        else
            self.TimesNotRecieved+=1 
                if self.TimesNotRecieved>5
                    CoreLog("T001", string.format("comm_timeout action=request_reset retries=%i", self.TimesNotRecieved))
                    self.requestedData=false
                    self.TimesNotRecieved=0     
                end
        end 
    end
    def simulate_infrared(data,repetitions)
        for i: range(0, repetitions) # Loops from 1 up to (but not including) last
            self.StoveWriteData( self.STOVE_OFFSET_RAM_WRITE,self.STOVE_ADDR_IRCOMMAND,data)
           tasmota.delay(20);
        end
        self.ser.read() # read the response from the stove to clear the serial buffer and allow the next command to be processed faster
    end
    def SendStovePowerON_Command()
        if !self.stove_is_off()
            CoreLog("L007", string.format("command_skipped reason=already_on state=%s", self.stove_state_label()))
            return false
        end
        if !self.has_othercommand
            self.OtherCommandQuee=self.stoveOnCommand
            self.has_othercommand=true
            return true
        else
            tasmota.set_timer(500, /-> self.SendStovePowerON_Command()) # if there is already a command in the quee, wait 500ms and try again
            return true
        end
    end
    def SendStovePowerOFF_Command()
        if self.stove_is_off()
            CoreLog("L008", "command_skipped reason=already_off state=Off")
            return false
        end
        if !self.has_othercommand
             #self.simulate_infrared(self.STOVE_IR_POWER, 15);
             self.OtherCommandQuee=self.stoveOffCommand
             self.has_othercommand=true
             return true
        else
            tasmota.set_timer(100, /-> self.SendStovePowerOFF_Command()) # if there is already a command in the quee, wait 500ms and try again
            return true
        end     
    end


    def SendStovePower(power)
        if power<1 || power>5
            CoreLog("V001", string.format("validation_failed field=power min=1 max=5 value=%i", power))
            return
        end
        if !self.requestedData #if requestedData is not true then send request
            self.StoveWriteData(self.STOVE_OFFSET_EEPROM_WRITE, self.STOVE_ADDRESS_EEPROM_POWER_OUTPUT, power)
            self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_POWER_OUTPUT]=power
            self.ser.read() # Clear serial buffer to allow next command to be processed faster
        else
            tasmota.set_timer(50, /-> self.SendStovePower(power)) # if there is already a command in the quee, wait 500ms and try again
        end
    end
    def SendStovePowerUP_Command()
            if self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_POWER_OUTPUT]>=5
                CoreLog("L001", string.format("command_skipped reason=limit_reached field=power direction=up limit=5 value=%i", self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_POWER_OUTPUT]))
                return
            else
                self.SendStovePower(self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_POWER_OUTPUT]+1)
            end
    end
    def SendStovePowerDOWN_Command()
            if self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_POWER_OUTPUT]<=1
                CoreLog("L002", string.format("command_skipped reason=limit_reached field=power direction=down limit=1 value=%i", self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_POWER_OUTPUT]))
                return
            else
                self.SendStovePower(self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_POWER_OUTPUT]-1)
            end
    end
    def SendStoveWaterTemp(temp)
        if temp<18 || temp>70
            CoreLog("V002", string.format("validation_failed field=water_temp min=18 max=70 value=%i", temp))
            return
        end
        if !self.requestedData #if requestedData is not true then send request
            self.StoveWriteData(self.STOVE_OFFSET_EEPROM_WRITE, self.STOVE_ADDRESS_EEPROM_WATER_TEMP, temp) 
            self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_WATER_TEMP]=temp
            self.ser.read() # clear the serial buffer to allow next command to be processed faster
        else
            tasmota.set_timer(50, /-> self.SendStoveWaterTemp(temp)) # if there is already a command in the quee, wait 500ms and try again
        end
    end
    def StoveWatterTempUP_Command()
            if self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_WATER_TEMP]>=70
                CoreLog("L003", string.format("command_skipped reason=limit_reached field=water_temp direction=up limit=70 value=%i", self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_WATER_TEMP]))
                return
            else
                self.SendStoveWaterTemp(self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_WATER_TEMP]+1)
            end
    end
    def StoveWatterTempDOWN_Command()
            if self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_WATER_TEMP]<=18
                CoreLog("L004", string.format("command_skipped reason=limit_reached field=water_temp direction=down limit=18 value=%i", self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_WATER_TEMP]))
                return
            else
                self.SendStoveWaterTemp(self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_WATER_TEMP]-1)
            end
    end
    def SendStoveAmbientTemp(temp)
        if temp<20 || temp>40   
            CoreLog("V003", string.format("validation_failed field=ambient_temp min=20 max=40 value=%i", temp))
            return
        end
        if !self.requestedData #if requestedData is not true then send request
            self.StoveWriteData(self.STOVE_OFFSET_EEPROM_WRITE, self.STOVE_ADDRESS_EEPROM_ROOM_TEMP, temp)
            self.ser.read() # clear the serial buffer to allow next command to be processed faster
            self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_ROOM_TEMP]=temp
        else
            tasmota.set_timer(50, /-> self.SendStoveAmbientTemp(temp)) # if there is already a command in the quee, wait 500ms and try again
        end
    end
    def StoveAmbientTempUP_Command()
            if self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_ROOM_TEMP]>=40
                CoreLog("L005", string.format("command_skipped reason=limit_reached field=ambient_temp direction=up limit=40 value=%i", self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_ROOM_TEMP]))
                return
            else
                self.SendStoveAmbientTemp(self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_ROOM_TEMP]+1)
            end
    end
    def StoveAmbientTempDOWN_Command()
            if self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_ROOM_TEMP]<=20
                CoreLog("L006", string.format("command_skipped reason=limit_reached field=ambient_temp direction=down limit=20 value=%i", self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_ROOM_TEMP]))
                return
            else
                self.SendStoveAmbientTemp(self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_ROOM_TEMP]-1)
            end
    end
   var UpdateInterval
    def every_second()
        if self.has_othercommand
            self.RequestFromStove()
            self.UpdateInterval=0
            return
        end

        if self.has_read_eeprom_once
            if self.eeprom_publish_countdown==nil || self.eeprom_publish_countdown<=0
                self.publish_eeprom_snapshot=true
                self.eeprom_publish_countdown=self.EepromPublish_IntervalSec
            else
                self.eeprom_publish_countdown-=1
            end
        else
            self.publish_eeprom_snapshot=false
            self.eeprom_publish_countdown=self.EepromPublish_IntervalSec
        end

        if self.UpdateInterval==nil || self.UpdateInterval==0
            self.UpdateInterval=self.StoveReading_Interval
             self.RequestFromStove()    
        else
            self.UpdateInterval-=1
        end
        
    end


    def json_append()
        var msgJson = string.format(",\"Stove\":{\"AmbientTemp\":%.1f,\"WaterTemp\":%i,\"PelletTime\":%.1f,"..
        "\"State\":\"%s\",\"CurrentPower\":%i,\"FumesFan\":%i,\"FumesTemp\":%.1f,\"TargetPower\":%i,\"TargetWaterTemp\":%i,\"TargetAmbientTemp\":%i}",
            self.StoveRAM[self.STOVE_ADDRESS_RAM_AMBIENT_TEMPERATURE_X2 ] / 2.0, #1
            self.StoveRAM[self.STOVE_ADDRESS_RAM_WATER_TEMP] ,                   #2
            self.StoveRAM[self.STOVE_ADDRESS_RAM_PELLET_TIME]/10.0,              #3  
            self.stove_state_label() ,                                            #4
            self.StoveRAM[self.STOVE_ADDRESS_RAM_CURRENT_OUTPUT_POWER] ,         #5
            (self.StoveRAM[self.STOVE_ADDRESS_RAM_FUMES_FAN] == 0 ? 0 : (self.StoveRAM[self.STOVE_ADDRESS_RAM_FUMES_FAN]+25)*10) , #6
            self.StoveRAM[self.STOVE_ADDRESS_RAM_FUMES_TEMPERATURE] ,            #7
            self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_POWER_OUTPUT] ,           #8
            self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_WATER_TEMP] ,             #9
            self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_ROOM_TEMP])               #10
            tasmota.response_append(msgJson)

        if self.publish_eeprom_snapshot
            var eepromJson = string.format(
                ",\"StoveEEPROM\":{\"MinutesStart\":%i,\"CadenceCleaning\":%i,\"AugerLightsX10\":%i,"..
                "\"CocleaStartX10\":%i,\"CocleaPower1X10\":%i,\"CocleaPower2X10\":%i,\"CocleaPower3X10\":%i,"..
                "\"CocleaPower4X10\":%i,\"CocleaPower5X10\":%i,\"DurationCleaning\":%i,"..
                "\"ExhaustStartFuseRpmRaw\":%i,\"ExhaustWaitFireRaw\":%i,\"ExhaustEngine1Raw\":%i,"..
                "\"ExhaustEngine2Raw\":%i,\"ExhaustEngine3Raw\":%i,\"ExhaustEngine4Raw\":%i,\"ExhaustEngine5Raw\":%i,"..
                "\"ExhaustFinalCleaningSpeedRaw\":%i,\"PelletTypeRaw\":%i,\"ChimneyTypeRaw\":%i,"..
                "\"ThresholdPumpTemp\":%i,\"TargetPower\":%i,\"TargetWaterTemp\":%i,\"TargetAmbientTemp\":%i}",
                self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_MINUTES_START],
                self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_CADENCE_CLEANING],
                self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_AUGER_LINGHTS],
                self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_COCLEA_START],
                self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_COCLEA_POWER1],
                self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_COCLEA_POWER2],
                self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_COCLEA_POWER3],
                self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_COCLEA_POWER4],
                self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_COCLEA_POWER5],
                self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_DURATION_CLEANING],
                self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_EXHAUST_START_FUSE_RPM],
                self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_EXHAUST_WAIT_FIRE],
                self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_EXHAUST_ENGINE_1],
                self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_EXHAUST_ENGINE_2],
                self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_EXHAUST_ENGINE_3],
                self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_EXHAUST_ENGINE_4],
                self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_EXHAUST_ENGINE_5],
                self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_EXHHAUST_FINAL_CLEANING_SPEED],
                self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_PELLET_TYPE],
                self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_CHIMNEY_TYPE],
                self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_THRESHOL_PUMP],
                self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_POWER_OUTPUT],
                self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_WATER_TEMP],
                self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_ROOM_TEMP]
            )
            tasmota.response_append(eepromJson)
            self.publish_eeprom_snapshot=false
        end
    end  



    def TurnOn(cmd, idx, payload, payload_json) 
        if payload==nil || payload==""
            var msgJson = string.format("{\"State\":\"%s\"}", self.stove_state_label())
            tasmota.resp_cmnd_str(msgJson)
             return
        elif string.toupper(payload)=="ON" || payload=="1"
            if self.SendStovePowerON_Command()
                tasmota.resp_cmnd_done()
            else
                tasmota.resp_cmnd_str("AlreadyOn")
            end
        elif string.toupper(payload)=="OFF" || payload=="0"
            if self.SendStovePowerOFF_Command()
                tasmota.resp_cmnd_done()
            else
                tasmota.resp_cmnd_str("AlreadyOff")
            end
        else
            tasmota.resp_cmnd_error()
        end
    end
    def WaterTempCommand(cmd, idx, payload, payload_json) 
        if payload==nil || payload==""
            var msgJson = string.format("TargetWaterTemp:%i", self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_WATER_TEMP])
            tasmota.resp_cmnd_str(msgJson)
            return
        end
        var temp= int(payload)
        
        if temp==nil
            tasmota.resp_cmnd_error()
            return
        end
        self.SendStoveWaterTemp(temp)
        tasmota.resp_cmnd_done()
    end
    def AmbientTempCommand(cmd, idx, payload, payload_json) 
        if payload==nil || payload==""
            var msgJson = string.format("TargetAmbientTemp:%i", self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_ROOM_TEMP])
            tasmota.resp_cmnd_str(msgJson)
            return
        end
        var temp= int(payload)
        if temp==nil
            tasmota.resp_cmnd_error()
            return
        end
        self.SendStoveAmbientTemp(temp)
        tasmota.resp_cmnd_done()
    end
    def currentPowerCommand(cmd, idx, payload, payload_json) 
        if payload==nil || payload==""


            var msgJson = string.format("TargetPower:%i", self.StoveEEPROM[self.STOVE_ADDRESS_EEPROM_POWER_OUTPUT])
            tasmota.resp_cmnd_str(msgJson)
            return
        end
        var temp= int(payload)
        if temp==nil
            tasmota.resp_cmnd_error()       
            return
        end 
        if temp<1 || temp>5
            tasmota.resp_cmnd_error()       
            return
        end 
        self.SendStovePower(temp)
        tasmota.resp_cmnd_done()    
    end
    def StoveWriteEEPROMCommand(cmd, idx, payload, payload_json) 
        if payload==nil || payload==""
            tasmota.resp_cmnd_error()       
            return
        end
        if string.find(payload, " ")==-1
            tasmota.resp_cmnd_error()       
            return
        end
        var parts = string.split(payload, " ")


        # Convert to numbers (real for float, int for integer)
        var num1 = int(string.find(parts[0], "0x") !=-1 ? parts[0] : "0x"+parts[0]) 
        var num2 = int(string.find(parts[1], "0x") !=-1 ? parts[1] : "0x"+parts[1])
        self.StoveWriteData(self.STOVE_OFFSET_EEPROM_WRITE, num1, num2)
        tasmota.resp_cmnd_done()
    end
    def StoveWriteRAMCommand(cmd, idx, payload, payload_json) 
        if payload==nil || payload==""
            tasmota.resp_cmnd_error()       
            return
        end
        if string.find(payload, " ")==-1
            tasmota.resp_cmnd_error()       
            return
        end
        var parts = string.split(payload, " ")


        # Convert to numbers (real for float, int for integer)
        var num1 = int(string.find(parts[0], "0x") !=-1 ? parts[0] : "0x"+parts[0]) 
        var num2 = int(string.find(parts[1], "0x") !=-1 ? parts[1] : "0x"+parts[1])
        self.StoveWriteData(self.STOVE_OFFSET_RAM_WRITE, num1, num2)
        tasmota.resp_cmnd_done()
    end
    def StoveReadRamCommand(cmd, idx, payload, payload_json) 
        if payload==nil || payload==""
            tasmota.resp_cmnd_error()       
            return
        end
        var num1 = int(string.find(payload, "0x") !=-1 ? payload : "0x"+payload) 
        if num1==nil
            tasmota.resp_cmnd_error()       
            return
        end
        self.OtherCommandQuee=[self.STOVE_OFFSET_RAM_READ, num1]
        self.has_othercommand=true
        tasmota.resp_cmnd_done()
    end
    def StoveReadEEPROMCommand(cmd, idx, payload, payload_json) 
        if payload==nil || payload==""
            tasmota.resp_cmnd_error()
            return
        end
        var num1 = int(string.find(payload, "0x") !=-1 ? payload : "0x"+payload) 
        if num1==nil
            tasmota.resp_cmnd_error()       
            return
        end
        self.OtherCommandQuee=[self.STOVE_OFFSET_EEPROM_READ, num1]
        self.has_othercommand=true
        tasmota.resp_cmnd_done()
    end
end


stoveObj = StoveClass()
tasmota.add_driver(stoveObj)
tasmota.add_cmd('StovePower',/ cmd, idx, payload, payload_json -> stoveObj.TurnOn(cmd, idx, payload, payload_json))
tasmota.add_cmd('TargetWaterTemp',/ cmd, idx, payload, payload_json -> stoveObj.WaterTempCommand(cmd, idx, payload, payload_json))
tasmota.add_cmd('TargetAmbientTemp',/ cmd, idx, payload, payload_json -> stoveObj.AmbientTempCommand(cmd, idx, payload, payload_json))   
tasmota.add_cmd('TargetPower',/ cmd, idx, payload, payload_json -> stoveObj.currentPowerCommand(cmd, idx, payload, payload_json))
tasmota.add_cmd('StoveWriteEEPROM',/ cmd, idx, payload, payload_json -> stoveObj.StoveWriteEEPROMCommand(cmd, idx, payload, payload_json))
tasmota.add_cmd('StoveWriteRAM',/ cmd, idx, payload, payload_json -> stoveObj.StoveWriteRAMCommand(cmd, idx, payload, payload_json))
tasmota.add_cmd('StoveReadRAM',/ cmd, idx, payload, payload_json -> stoveObj.StoveReadRamCommand(cmd, idx, payload, payload_json))
tasmota.add_cmd('StoveReadEEPROM',/ cmd, idx, payload, payload_json -> stoveObj.StoveReadEEPROMCommand(cmd, idx, payload, payload_json))
