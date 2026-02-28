import webserver # import webserver class
# Event code legend: see EVENT_CODES.md in this folder
# Event code reference
# Gxxx: GUI/input and UI exception events
def CoreLog(evt, message)
    print("BRY: evt=", evt, " ", message)
end
class StoveClassGUI
    var  mainStove
    def init()
        #self.mainStove=Micronova
    end

    def weekly_checkbox_row(day_name, name1, checked1, name2, checked2, name3, checked3, name4, checked4)
        return format("<tr><td class='wkday'><b>%s</b></td><td class='wkcol'><input type='checkbox' name='%s' %s></td><td class='wkcol'><input type='checkbox' name='%s' %s></td><td class='wkcol'><input type='checkbox' name='%s' %s></td><td class='wkcol'><input type='checkbox' name='%s' %s></td></tr>",
            day_name,
            name1, checked1 ? "checked" : "",
            name2, checked2 ? "checked" : "",
            name3, checked3 ? "checked" : "",
            name4, checked4 ? "checked" : "")
    end

    def weekly_day_row(day_name, day_code, addr1, addr2, addr3, addr4)
        return self.weekly_checkbox_row(
            day_name,
            format("WEEK_%s_1", day_code), stoveObj.StoveEEPROM[addr1] != 0,
            format("WEEK_%s_2", day_code), stoveObj.StoveEEPROM[addr2] != 0,
            format("WEEK_%s_3", day_code), stoveObj.StoveEEPROM[addr3] != 0,
            format("WEEK_%s_4", day_code), stoveObj.StoveEEPROM[addr4] != 0)
    end

    def timer_input_row(label, start_name, start_address, stop_name, stop_address)
        return "<tr>"..
            "<td></td>"..
            format("<td><b>%s</b></td>", label)..
            format("<td><input type='text' name='%s' value='%s'></td>", start_name, stoveObj.time_from_int(stoveObj.StoveEEPROM[start_address]))..
            format("<td><input type='text' name='%s' value='%s'></td>", stop_name, stoveObj.time_from_int(stoveObj.StoveEEPROM[stop_address]))..
            "</tr>"
    end

    def number_input_td(name, value, step, min_value, max_value)
        return format("<td><input type='number' step='%s' min='%s' max='%s' name='%s' value='%s'></td>",
                      step, min_value, max_value, name, value)
    end

    def advanced_row(label, left_td, right_td)
        return format("<tr><td><b>%s</b></td>%s%s</tr>", label, left_td, right_td)
    end

    def arg_checkbox(name)
        return webserver.has_arg(name) ? 1 : 0
    end

    def arg_time(name)
        return stoveObj.int_from_time(webserver.arg(name))
    end

    def write_weekday_program(mon_addr, tue_addr, wed_addr, thu_addr, fri_addr, sat_addr, sun_addr,
                              mon_name, tue_name, wed_name, thu_name, fri_name, sat_name, sun_name)
        stoveObj.write_eeprom_if_changed(mon_addr, self.arg_checkbox(mon_name))
        stoveObj.write_eeprom_if_changed(tue_addr, self.arg_checkbox(tue_name))
        stoveObj.write_eeprom_if_changed(wed_addr, self.arg_checkbox(wed_name))
        stoveObj.write_eeprom_if_changed(thu_addr, self.arg_checkbox(thu_name))
        stoveObj.write_eeprom_if_changed(fri_addr, self.arg_checkbox(fri_name))
        stoveObj.write_eeprom_if_changed(sat_addr, self.arg_checkbox(sat_name))
        stoveObj.write_eeprom_if_changed(sun_addr, self.arg_checkbox(sun_name))
    end

    def write_weekday_program_num(mon_addr, tue_addr, wed_addr, thu_addr, fri_addr, sat_addr, sun_addr, program_num)
        self.write_weekday_program(
            mon_addr, tue_addr, wed_addr, thu_addr, fri_addr, sat_addr, sun_addr,
            format("WEEK_MON_%i", program_num), format("WEEK_TUE_%i", program_num), format("WEEK_WED_%i", program_num),
            format("WEEK_THU_%i", program_num), format("WEEK_FRI_%i", program_num), format("WEEK_SAT_%i", program_num), format("WEEK_SUN_%i", program_num))
    end

    def web_sensor()
        # Display the value in the Tasmota Web UI

        var msg = format('<td colspan="2">'
             '<table style="width:100%%;text-align:center;">'
             "<style>"
             ".bx{height:10px;width:10px;display:inline-block;border:1px solid red }"
             "</style>"
             '<tr style="color:green;">{m}Ambient{m}Water{m}Pellet{m}Stove State{e}'
             '<tr style="color:red;">{m}%.1fC{m}%.1fC{m}%.1f{m}%s{e}'
             '<tr style="color:green;">{m}Pow{m}ReamTime{m}Fan{m}Fune{m} {e}'
             '<tr style="color:red;">{m}%i{m}%i.%02d{m}%i{m}%iC{m} {e}'
             '<tr style="color:green;">{m}Target pow{m}Water t{m}Ambient t{e}'
             '<tr style="color:red;">{m}%i{m}%.1f{m}%.1f{e}'
             '<tr></tr>'
             '</td>'
             '</table>'
             ,
            stoveObj.StoveRAM[stoveObj.STOVE_ADDRESS_RAM_AMBIENT_TEMPERATURE_X2 ]/2.0 ,  #1
            stoveObj.StoveRAM[stoveObj.STOVE_ADDRESS_RAM_WATER_TEMP] ,                   #2  
            stoveObj.StoveRAM[stoveObj.STOVE_ADDRESS_RAM_PELLET_TIME]/10.0,              #3
            stoveObj.STOVE_STATUS_LIST[stoveObj.StoveRAM[stoveObj.STOVE_ADDRESS_RAM_STOVE_STATE]] ,  #4
            stoveObj.StoveRAM[stoveObj.STOVE_ADDRESS_RAM_CURRENT_OUTPUT_POWER] ,         #6
            stoveObj.StoveRAM[stoveObj.STOVE_ADDRESS_RAM_STOVE_REAMING_TIME_MIN] ,       #7
            stoveObj.StoveRAM[stoveObj.STOVE_ADDRESS_RAM_STOVE_REAMING_TIME_SEC] ,       #7
            (stoveObj.StoveRAM[stoveObj.STOVE_ADDRESS_RAM_FUMES_FAN]+25)*10 ,                    #7
            stoveObj.StoveRAM[stoveObj.STOVE_ADDRESS_RAM_FUMES_TEMPERATURE] ,            #7
            stoveObj.StoveEEPROM[stoveObj.STOVE_ADDRESS_EEPROM_POWER_OUTPUT] ,           #10
            stoveObj.StoveEEPROM[stoveObj.STOVE_ADDRESS_EEPROM_WATER_TEMP] ,             #11
            stoveObj.StoveEEPROM[stoveObj.STOVE_ADDRESS_EEPROM_ROOM_TEMP]                #12
            ) 
        tasmota.web_send(msg)
        if webserver.has_arg("PowerON_action")
           stoveObj.SendStovePowerON_Command()
        elif webserver.has_arg("PowerOFF_action")
            stoveObj.SendStovePowerOFF_Command()    
        elif webserver.has_arg("Power_UP")
            stoveObj.SendStovePowerUP_Command() 
        elif webserver.has_arg("Power_DOWN")
            stoveObj.SendStovePowerDOWN_Command()   
         elif webserver.has_arg("water_T_UP")
            stoveObj.StoveWatterTempUP_Command()
         elif webserver.has_arg("water_T_DOWN")
            stoveObj.StoveWatterTempDOWN_Command()
         elif webserver.has_arg("Ambient_T_UP")
            stoveObj.StoveAmbientTempUP_Command()
         elif webserver.has_arg("Ambient_T_DOWN")
            stoveObj.StoveAmbientTempDOWN_Command() 
        end
    end
    def web_add_main_button()
        webserver.content_send("<div style='display: flex; gap: 3px;'>")
        webserver.content_send("<p></p><button onclick='la(\"&Power_UP=1\");'>Pow +</button>")
        webserver.content_send("<p></p><button onclick='la(\"&water_T_UP=1\");'>Water +</button>")
        webserver.content_send("<p></p><button onclick='la(\"&Ambient_T_UP=1\");'>Amb +</button>")
        webserver.content_send("</div>")

        webserver.content_send("<div style='display: flex; gap: 3px;'>")
        webserver.content_send("<p></p><button onclick='la(\"&Power_DOWN=1\");'>Pow -</button>")
        webserver.content_send("<p></p><button onclick='la(\"&water_T_DOWN=1\");'>Water -</button>")
        webserver.content_send("<p></p><button onclick='la(\"&Ambient_T_DOWN=1\");'>Amb -</button>")
        webserver.content_send("</div>")

        webserver.content_send("<div style='display: flex; gap: 3px;'>")
        webserver.content_send("<p></p><form id='StoveSettingsGo' action='/StoveSettings_ui' method='get'><button style='height: 80px; width: 80px;'>Stove Settings</button></form>")
        webserver.content_send("<p></p><form id='StoveTimerGo' action='/StoveTimer_ui' method='get'><button style='height: 80px; width: 80px;'>Stove Timer</button></form>")
        webserver.content_send("<p></p><button onclick='if(confirm(\"Are you sure?\")) {la(\"&PowerON_action=1\");}'>Power ON</button>")
        webserver.content_send("<p></p><button onclick='if(confirm(\"Are you sure?\")) {la(\"&PowerOFF_action=1\");}'>Power OFF</button>")
        webserver.content_send("</div>")
    end   
    var StoveSettingsPageLoaded, StoveSettingsLoadRequested
    def page_StoveTimer_ui()
        var R = stoveObj.STOVE_OFFSET_EEPROM_READ
        var FS = "<fieldset><style>.bdis{background:#888;}.bdis:hover{background:#888;}</style>"
        stoveObj.OtherCommandQuee=[
            R, stoveObj.STOVE_ADDRESS_EEPROM_ENABLE_CHRONO,
            R, stoveObj.STOVE_ADDRESS_EEPROM_PROGRAM_DAY_ON,
            R, stoveObj.STOVE_ADDRESS_EEPROM_START_DAY_1,
            R, stoveObj.STOVE_ADDRESS_EEPROM_STOP_DAY_1,
            R, stoveObj.STOVE_ADDRESS_EEPROM_START_DAY_2,
            R, stoveObj.STOVE_ADDRESS_EEPROM_STOP_DAY_2,
            R, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_1_ENABLE,
            R, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_1_START,
            R, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_1_STOP,
            R, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_2_START,
            R, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_2_STOP,
            R, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_3_START,
            R, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_3_STOP,
            R, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_4_START,
            R, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_4_STOP,

            R, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_1_MONDAY_ON,
            R, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_1_TUESDAY_ON,
            R, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_1_WENSDAY_ON,
            R, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_1_THURSDAY_ON,
            R, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_1_FRIDAY_ON,
            R, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_1_SATURDAY_ON,
            R, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_1_SUNNDAY_ON,

            R, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_2_MONDAY_ON,
            R, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_2_TUESDAY_ON,
            R, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_2_WENSDAY_ON,
            R, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_2_THURSDAY_ON,
            R, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_2_FRIDAY_ON,
            R, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_2_SATURDAY_ON,
            R, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_2_SUNNDAY_ON,

            R, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_3_MONDAY_ON,
            R, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_3_TUESDAY_ON,
            R, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_3_WENSDAY_ON,
            R, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_3_THURSDAY_ON,
            R, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_3_FRIDAY_ON,
            R, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_3_SATURDAY_ON,
            R, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_3_SUNNDAY_ON,

            R, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_4_MONDAY_ON,
            R, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_4_TUESDAY_ON,
            R, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_4_WENSDAY_ON,
            R, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_4_THURSDAY_ON,
            R, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_4_FRIDAY_ON,
            R, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_4_SATURDAY_ON,
            R, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_4_SUNNDAY_ON
            ]
            stoveObj.has_othercommand=true

        webserver.content_start("Stove Timer")           #- title of the web page -#
        webserver.content_send_style()                  #- send standard Tasmota styles -#
        webserver.content_send( FS..
            "<legend><b title='Stove Timer settings '>Stove Timer Settings</b></legend>"..
            "<p><form id='StoveTimerForm' style='display: block;' action='/StoveTimer_ui' method='post'>"..
            "<table style='width:100%%'>"..
            "<tr>"..
            format("<td style= 'width:20px'><input type='checkbox' name='TIMER_ENABLED' %s></td>", (stoveObj.StoveEEPROM[stoveObj.STOVE_ADDRESS_EEPROM_ENABLE_CHRONO] != 0) ? "checked" : "" )..
            "<td style='width:180px'><b> Timers Enabled </b></td>"..
            "<td style='width:80px'><button name='TimerSet' class='button bgrn'>SAVE</button></td>"..
            "</tr>"
            "</table>"..
            "</form></p><p></p></fieldset><p></p>"
            )
        webserver.content_send(
            FS..
            "<legend><b title='Stove Daily Timer settings '>Timer Settings</b></legend>"..
            "<p><form id='StoveTimerFormDaily' style='display: block;' action='/StoveTimer_ui' method='post'>"..
            "<table style='width:100%%; table-layout:fixed; border-collapse:separate; border-spacing:0 6px;'>"..
            "<colgroup><col style='width:42%%;'><col style='width:58%%;'></colgroup>"..
            "<tr>"..
            format("<td style='width:20px'><input type='checkbox' name='TIMER_DAY_ENABLED' %s></td>", (stoveObj.StoveEEPROM[stoveObj.STOVE_ADDRESS_EEPROM_PROGRAM_DAY_ON] != 0) ? "checked" : "" )..
            "<td style='width:220px; white-space:nowrap;'><b>Day Timer Enabled</b></td>"..
            "<td style='width:80px'><b>Start</b></td>"..
            "<td style='width:80px'><b>Stop</b></td>"..
            "</tr>"..
            self.timer_input_row("Timer 1", "TIMER_DAY_1_START", stoveObj.STOVE_ADDRESS_EEPROM_START_DAY_1, "TIMER_DAY_1_STOP", stoveObj.STOVE_ADDRESS_EEPROM_STOP_DAY_1)..
            self.timer_input_row("Timer 2", "TIMER_DAY_2_START", stoveObj.STOVE_ADDRESS_EEPROM_START_DAY_2, "TIMER_DAY_2_STOP", stoveObj.STOVE_ADDRESS_EEPROM_STOP_DAY_2)..
            "</table>"..
            "<div style='width:100%;'><button style='width:100%;display:block;' name='DaylyTimerSet' class='button bgrn'>SET</button></div>"..
            "</form></p><p></p></fieldset><p></p>"
            )

        webserver.content_send(
            FS..
            "<legend><b title='Stove Weekly Timer settings '>Weekly Timer Settings</b></legend>"..
            "<p><form id='StoveTimerFormWeekly' style='display: block;' action='/StoveTimer_ui' method='post'>"..
            "<table style='width:100%%; table-layout:fixed; border-collapse:separate; border-spacing:0 6px;'>"..
            "<colgroup><col style='width:42%%;'><col style='width:58%%;'></colgroup>"..
            "<tr>"..
            format("<td style='width:20px'><input type='checkbox' name='TIMER_WEEK_ENABLED' %s></td>", (stoveObj.StoveEEPROM[stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_1_ENABLE] != 0) ? "checked" : "" )..
            "<td style='width:220px; white-space:nowrap;'><b>Weekly Timer Enabled</b></td>"..
            "<td style='width:80px'><b>Start</b></td>"..
            "<td style='width:80px'><b>Stop</b></td>"..
            "</tr>"..
            self.timer_input_row("Prog 1", "TIMER_WEEK_1_START", stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_1_START, "TIMER_WEEK_1_STOP", stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_1_STOP)..
            self.timer_input_row("Prog 2", "TIMER_WEEK_2_START", stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_2_START, "TIMER_WEEK_2_STOP", stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_2_STOP)..
            self.timer_input_row("Prog 3", "TIMER_WEEK_3_START", stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_3_START, "TIMER_WEEK_3_STOP", stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_3_STOP)..
            self.timer_input_row("Prog 4", "TIMER_WEEK_4_START", stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_4_START, "TIMER_WEEK_4_STOP", stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_4_STOP)..
            "</table>"..
            "<p></p>"..
            "<style>.wkday{font-size:20px;font-weight:700;}.wkhead{font-size:16px;font-weight:700;}.wkcol{text-align:right;padding-right:6px;}.wkcol input{float:right;margin-right:0;}</style>"..
            "<table style='width:100%%; table-layout:fixed; font-size:14px;'>"..
            "<colgroup><col style='width:250px;'><col style='width:30px;'><col style='width:30px;'><col style='width:30px;'><col style='width:30px;'></colgroup>"..
            "<tr><td class='wkhead'><b>Day</b></td><td class='wkcol'><b>P1</b></td><td class='wkcol'><b>P2</b></td><td class='wkcol'><b>P3</b></td><td class='wkcol'><b>P4</b></td></tr>"..
            self.weekly_day_row("Monday", "MON",
                                stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_1_MONDAY_ON, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_2_MONDAY_ON,
                                stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_3_MONDAY_ON, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_4_MONDAY_ON)..
            self.weekly_day_row("Tuesday", "TUE",
                                stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_1_TUESDAY_ON, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_2_TUESDAY_ON,
                                stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_3_TUESDAY_ON, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_4_TUESDAY_ON)..
            self.weekly_day_row("Wednesday", "WED",
                                stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_1_WENSDAY_ON, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_2_WENSDAY_ON,
                                stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_3_WENSDAY_ON, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_4_WENSDAY_ON)..
            self.weekly_day_row("Thursday", "THU",
                                stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_1_THURSDAY_ON, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_2_THURSDAY_ON,
                                stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_3_THURSDAY_ON, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_4_THURSDAY_ON)..
            self.weekly_day_row("Friday", "FRI",
                                stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_1_FRIDAY_ON, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_2_FRIDAY_ON,
                                stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_3_FRIDAY_ON, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_4_FRIDAY_ON)..
            self.weekly_day_row("Saturday", "SAT",
                                stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_1_SATURDAY_ON, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_2_SATURDAY_ON,
                                stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_3_SATURDAY_ON, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_4_SATURDAY_ON)..
            self.weekly_day_row("Sunday", "SUN",
                                stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_1_SUNNDAY_ON, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_2_SUNNDAY_ON,
                                stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_3_SUNNDAY_ON, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_4_SUNNDAY_ON)..
            "</table>"..
            "<div style='width:100%;'><button style='width:100%;display:block;' name='WeeklyTimerSet' class='button bgrn'>SET</button></div>"..
            "</form></p><p></p></fieldset><p></p>"
            )
               

        webserver.content_button(webserver.BUTTON_MAIN)
        webserver.content_stop()
        
    end
    def page_StoveTimer_ctl()
        if !webserver.check_privileged_access() 
            return nil 
        end
        try
            if webserver.has_arg("TimerSet") 
                var TIMER_ENABLED = self.arg_checkbox("TIMER_ENABLED")
                stoveObj.write_eeprom_if_changed(stoveObj.STOVE_ADDRESS_EEPROM_ENABLE_CHRONO, TIMER_ENABLED)
                webserver.redirect("/StoveTimer_ui") # redirect to the settings page to display the updated values  
                return
            elif webserver.has_arg("DaylyTimerSet") 
                var TIMER_DAY_ENABLED = self.arg_checkbox("TIMER_DAY_ENABLED")
                var TIMER_DAY_1_START = self.arg_time("TIMER_DAY_1_START")
                var TIMER_DAY_1_STOP = self.arg_time("TIMER_DAY_1_STOP")
                var TIMER_DAY_2_START = self.arg_time("TIMER_DAY_2_START")
                var TIMER_DAY_2_STOP = self.arg_time("TIMER_DAY_2_STOP")

                stoveObj.write_eeprom_if_changed(stoveObj.STOVE_ADDRESS_EEPROM_PROGRAM_DAY_ON, TIMER_DAY_ENABLED)
                stoveObj.write_eeprom_if_changed(stoveObj.STOVE_ADDRESS_EEPROM_START_DAY_1, TIMER_DAY_1_START)
                stoveObj.write_eeprom_if_changed(stoveObj.STOVE_ADDRESS_EEPROM_STOP_DAY_1, TIMER_DAY_1_STOP)
                stoveObj.write_eeprom_if_changed(stoveObj.STOVE_ADDRESS_EEPROM_START_DAY_2, TIMER_DAY_2_START)
                stoveObj.write_eeprom_if_changed(stoveObj.STOVE_ADDRESS_EEPROM_STOP_DAY_2, TIMER_DAY_2_STOP)

                webserver.redirect("/StoveTimer_ui") # redirect to the settings page to display the updated values
                return
            elif webserver.has_arg("WeeklyTimerSet")
                var TIMER_WEEK_ENABLED = self.arg_checkbox("TIMER_WEEK_ENABLED")
                var TIMER_WEEK_1_START = self.arg_time("TIMER_WEEK_1_START")
                var TIMER_WEEK_1_STOP = self.arg_time("TIMER_WEEK_1_STOP")
                var TIMER_WEEK_2_START = self.arg_time("TIMER_WEEK_2_START")
                var TIMER_WEEK_2_STOP = self.arg_time("TIMER_WEEK_2_STOP")
                var TIMER_WEEK_3_START = self.arg_time("TIMER_WEEK_3_START")
                var TIMER_WEEK_3_STOP = self.arg_time("TIMER_WEEK_3_STOP")
                var TIMER_WEEK_4_START = self.arg_time("TIMER_WEEK_4_START")
                var TIMER_WEEK_4_STOP = self.arg_time("TIMER_WEEK_4_STOP")

                stoveObj.write_eeprom_if_changed(stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_1_ENABLE, TIMER_WEEK_ENABLED)
                stoveObj.write_eeprom_if_changed(stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_1_START, TIMER_WEEK_1_START)
                stoveObj.write_eeprom_if_changed(stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_1_STOP, TIMER_WEEK_1_STOP)
                stoveObj.write_eeprom_if_changed(stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_2_START, TIMER_WEEK_2_START)
                stoveObj.write_eeprom_if_changed(stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_2_STOP, TIMER_WEEK_2_STOP)
                stoveObj.write_eeprom_if_changed(stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_3_START, TIMER_WEEK_3_START)
                stoveObj.write_eeprom_if_changed(stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_3_STOP, TIMER_WEEK_3_STOP)
                stoveObj.write_eeprom_if_changed(stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_4_START, TIMER_WEEK_4_START)
                stoveObj.write_eeprom_if_changed(stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_4_STOP, TIMER_WEEK_4_STOP)

                self.write_weekday_program_num(
                    stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_1_MONDAY_ON, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_1_TUESDAY_ON,
                    stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_1_WENSDAY_ON, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_1_THURSDAY_ON,
                    stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_1_FRIDAY_ON, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_1_SATURDAY_ON,
                    stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_1_SUNNDAY_ON, 1)

                self.write_weekday_program_num(
                    stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_2_MONDAY_ON, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_2_TUESDAY_ON,
                    stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_2_WENSDAY_ON, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_2_THURSDAY_ON,
                    stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_2_FRIDAY_ON, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_2_SATURDAY_ON,
                    stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_2_SUNNDAY_ON, 2)

                self.write_weekday_program_num(
                    stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_3_MONDAY_ON, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_3_TUESDAY_ON,
                    stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_3_WENSDAY_ON, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_3_THURSDAY_ON,
                    stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_3_FRIDAY_ON, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_3_SATURDAY_ON,
                    stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_3_SUNNDAY_ON, 3)

                self.write_weekday_program_num(
                    stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_4_MONDAY_ON, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_4_TUESDAY_ON,
                    stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_4_WENSDAY_ON, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_4_THURSDAY_ON,
                    stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_4_FRIDAY_ON, stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_4_SATURDAY_ON,
                    stoveObj.STOVE_ADDRESS_EEPROM_WEEK_TIMER_4_SUNNDAY_ON, 4)

                webserver.redirect("/StoveTimer_ui") # redirect to the settings page to display the updated values
                return
            end
            return
        except .. as e,m
            CoreLog("G002", format("ui_exception page=StoveTimer_ctl err='%s' msg='%s'", e, m))
            webserver.content_start("Parameter error")
            webserver.content_send_style()
            webserver.content_send(format("<p style='width:340px;'><b>Exception:</b><br>'%s'<br>%s</p>", e, m))
            webserver.content_button(webserver.BUTTON_MAIN)
            webserver.content_stop()
        end
    end
    def page_StoveSettings_ui()
        stoveObj.load_stove_settings() 
        var FS = "<fieldset><style>.bdis{background:#888;}.bdis:hover{background:#888;}</style>"
        
        webserver.content_start("Stove Settings")           #- title of the web page -#
        webserver.content_send_style()                  #- send standard Tasmota styles -#
        webserver.content_send(
            FS..
            format("<legend><b title='Stove settings '>Pellet settings</b></legend>")..
            "<p><form id=StoveSettings_ui style='display: block;' action='/StoveSettings_ui' method='post'>"..
            "<table style='width:100%%'>"..
            "<tr><td style='width:130px'><b>Pellet type</b></td>"..
            format(
                "<td style='padding-right:0;'>"..
                "<input type='range' min='-9' max='9' step='1' name='PELLET_TYPE' value='%i' "..
                "oninput='document.getElementById(\"pellet_type_val\").innerText=this.value' "..
                "style='width:300px;display:block;margin:0;'>"..
                "<div style='text-align:center;'><span id='pellet_type_val'>%i</span></div>"..
                "</td></tr>",
                stoveObj.StoveEEPROM[stoveObj.STOVE_ADDRESS_EEPROM_PELLET_TYPE]-9,
                stoveObj.StoveEEPROM[stoveObj.STOVE_ADDRESS_EEPROM_PELLET_TYPE]-9
            )..
            "<tr><td><b>Chimney type</b></td>"..
            format("<td style='padding-right:0;'>"..
                "<input type='range' min='-9' max='9' step='1' name='CHIMNEY_TYPE' value='%i' "..
                "oninput='document.getElementById(\"chimney_type_val\").innerText=this.value' "..
                "style='width:300px;display:block;margin:0;'>"..
                "<div style='text-align:center;'><span id='chimney_type_val'>%i</span></div>"..
                "</td></tr>",
                stoveObj.StoveEEPROM[stoveObj.STOVE_ADDRESS_EEPROM_CHIMNEY_TYPE]-9,
                stoveObj.StoveEEPROM[stoveObj.STOVE_ADDRESS_EEPROM_CHIMNEY_TYPE]-9
            )..
            "<tr><td><b>Min water temp pump ON</b></td>"..
            format("<td><input type='number' step='1' min='0' max='255' name='THRESHOLD_PUMP' value='%i'></td></tr>",
                stoveObj.StoveEEPROM[stoveObj.STOVE_ADDRESS_EEPROM_THRESHOL_PUMP]
            )..
            "</tr>"..
            "</table><hr>"..
            "<table style='width:100%%'><tr>"..
            "<button name='PelletApply' class='button bgrn'>SET</button>"..
            "</tr></table>"..
            "</form></p><p></p></fieldset><p></p>"
            )
        webserver.content_send(
            FS..
            format("<legend><b title='Stove settings '>Advanced settings</b></legend>")..
            "<p><form id=StoveSettings_ui style='display: block;' action='/StoveSettings_ui' method='post'>"..
            "<table style='width:100%%'>"..
            "<tr>"..
            "<td style='width:200px'><b> </b></td>"..
            "<td style='width:80px;  text-align: center;'><b>Time </b></td>"..
            "<td style='width:80px;  text-align: center;'><b>rpm  </b></td>"..
            "</tr>"..
            self.advanced_row("Minutes start ",
                self.number_input_td("Minute_START", format("%i", stoveObj.StoveEEPROM[stoveObj.STOVE_ADDRESS_EEPROM_MINUTES_START]), "1", "2", "12"),
                self.number_input_td("START_EXHAUST", format("%i", stoveObj.StoveEEPROM[stoveObj.STOVE_ADDRESS_EEPROM_EXHAUST_START_FUSE_RPM]*10+250), "10", "1000", "2800"))..
            self.advanced_row("Cadence cleaning ",
                self.number_input_td("CADENCE_CLEANING", format("%i", stoveObj.StoveEEPROM[stoveObj.STOVE_ADDRESS_EEPROM_CADENCE_CLEANING]), "1", "3", "240"),
                self.number_input_td("CADENCE_CLEANING_FUME", format("%i", stoveObj.StoveEEPROM[stoveObj.STOVE_ADDRESS_EEPROM_EXHHAUST_FINAL_CLEANING_SPEED]*10+250), "10", "1000", "2800"))..
            self.advanced_row("Auger Lights",
                self.number_input_td("AUGER_LIGHTS", format("%.1f", stoveObj.StoveEEPROM[stoveObj.STOVE_ADDRESS_EEPROM_AUGER_LINGHTS]/10.0), "0.1", "0.1", "8.0"),
                self.number_input_td("AUGER_LIGHTS_FAN", format("%i", stoveObj.StoveEEPROM[stoveObj.STOVE_ADDRESS_EEPROM_EXHAUST_WAIT_FIRE]*10+250), "10", "1000", "2800"))..
            self.advanced_row("Coclea start",
                self.number_input_td("COCLEA_START", format("%.1f", stoveObj.StoveEEPROM[stoveObj.STOVE_ADDRESS_EEPROM_COCLEA_START]/10.0), "0.1", "0.1", "8.0"),
                self.number_input_td("START_EXHAUST", format("%i", stoveObj.StoveEEPROM[stoveObj.STOVE_ADDRESS_EEPROM_EXHAUST_START_FUSE_RPM]*10+250), "10", "1000", "2800"))..
            self.advanced_row("Coclea Power1",
                self.number_input_td("COCLEA_POWER1", format("%.1f", stoveObj.StoveEEPROM[stoveObj.STOVE_ADDRESS_EEPROM_COCLEA_POWER1]/10.0), "0.1", "0.1", "8.0"),
                self.number_input_td("COCLEA_POWER1_FAN", format("%i", stoveObj.StoveEEPROM[stoveObj.STOVE_ADDRESS_EEPROM_EXHAUST_ENGINE_1]*10+250), "10", "1000", "2800"))..
            self.advanced_row("Coclea Power2",
                self.number_input_td("COCLEA_POWER2", format("%.1f", stoveObj.StoveEEPROM[stoveObj.STOVE_ADDRESS_EEPROM_COCLEA_POWER2]/10.0), "0.1", "0.1", "8.0"),
                self.number_input_td("COCLEA_POWER2_FAN", format("%i", stoveObj.StoveEEPROM[stoveObj.STOVE_ADDRESS_EEPROM_EXHAUST_ENGINE_2]*10+250), "10", "1000", "2800"))..
            self.advanced_row("Coclea Power3",
                self.number_input_td("COCLEA_POWER3", format("%.1f", stoveObj.StoveEEPROM[stoveObj.STOVE_ADDRESS_EEPROM_COCLEA_POWER3]/10.0), "0.1", "0.1", "8.0"),
                self.number_input_td("COCLEA_POWER3_FAN", format("%i", stoveObj.StoveEEPROM[stoveObj.STOVE_ADDRESS_EEPROM_EXHAUST_ENGINE_3]*10+250), "10", "1000", "2800"))..
            self.advanced_row("Coclea Power4",
                self.number_input_td("COCLEA_POWER4", format("%.1f", stoveObj.StoveEEPROM[stoveObj.STOVE_ADDRESS_EEPROM_COCLEA_POWER4]/10.0), "0.1", "0.1", "8.0"),
                self.number_input_td("COCLEA_POWER4_FAN", format("%i", stoveObj.StoveEEPROM[stoveObj.STOVE_ADDRESS_EEPROM_EXHAUST_ENGINE_4]*10+250), "10", "1000", "2800"))..
            self.advanced_row("Coclea Power5",
                self.number_input_td("COCLEA_POWER5", format("%.1f", stoveObj.StoveEEPROM[stoveObj.STOVE_ADDRESS_EEPROM_COCLEA_POWER5]/10.0), "0.1", "0.1", "8.0"),
                self.number_input_td("COCLEA_POWER5_FAN", format("%i", stoveObj.StoveEEPROM[stoveObj.STOVE_ADDRESS_EEPROM_EXHAUST_ENGINE_5]*10+250), "10", "1000", "2800"))..
            "</table><hr>")
        webserver.content_send("<table style='width:100%%'><tr>"..
                       "<button name='AdvancedSettApply' class='button bgrn'>SET</button>"..
                       "</tr></table>")
        webserver.content_send("</form></p>")
        webserver.content_send("<p></p></fieldset><p></p>")
        webserver.content_button(webserver.BUTTON_MAIN)
        webserver.content_stop()
    end
    def page_StoveSettings_ctl()
      if !webserver.check_privileged_access() 
        return nil 
      end
      try
        if webserver.has_arg("PelletApply") 
            # read arguments
            var PelletType= int(webserver.arg("PELLET_TYPE"))+9 & 0xFF
            var ChimneyType= int(webserver.arg("CHIMNEY_TYPE"))+9 & 0xFF
            var ThresholdPump= int(webserver.arg("THRESHOLD_PUMP")) & 0xFF
            stoveObj.StoveWriteData(stoveObj.STOVE_OFFSET_EEPROM_WRITE, stoveObj.STOVE_ADDRESS_EEPROM_PELLET_TYPE, PelletType)
            tasmota.delay(50)
            stoveObj.StoveWriteData(stoveObj.STOVE_OFFSET_EEPROM_WRITE, stoveObj.STOVE_ADDRESS_EEPROM_CHIMNEY_TYPE, ChimneyType)
            tasmota.delay(50)
            stoveObj.write_eeprom_if_changed(stoveObj.STOVE_ADDRESS_EEPROM_THRESHOL_PUMP, ThresholdPump)
            webserver.redirect("/StoveSettings_ui") # redirect to the settings page to display the updated values
            return
        elif webserver.has_arg("AdvancedSettApply")
            # read arguments
            var Minute_START = int(webserver.arg("Minute_START")) & 0xFF
            var CADENCE_CLEANING = int(webserver.arg("CADENCE_CLEANING")) & 0xFF
            var AUGER_LIGHTS = int(real(webserver.arg("AUGER_LIGHTS")) * 10) & 0xFF
            var COCLEA_START = int(real(webserver.arg("COCLEA_START")) * 10) & 0xFF
            var COCLEA_POWER1 = int(real(webserver.arg("COCLEA_POWER1")) * 10) & 0xFF
            var COCLEA_POWER2 = int(real(webserver.arg("COCLEA_POWER2")) * 10) & 0xFF
            var COCLEA_POWER3 =int(real(webserver.arg("COCLEA_POWER3")) * 10) & 0xFF
            var COCLEA_POWER4 = int(real(webserver.arg("COCLEA_POWER4")) * 10) & 0xFF
            var COCLEA_POWER5 = int(real(webserver.arg("COCLEA_POWER5")) * 10) & 0xFF
            var START_EXHAUST = int((int(webserver.arg("START_EXHAUST")) - 250) / 10) & 0xFF
            var CADENCE_CLEANING_FUME = int((int(webserver.arg("CADENCE_CLEANING_FUME")) - 250) / 10) & 0xFF
            
            var AUGER_LIGHTS_FAN = int((int(webserver.arg("AUGER_LIGHTS_FAN")) - 250) / 10) & 0xFF
            var COCLEA_POWER1_FAN = int((int(webserver.arg("COCLEA_POWER1_FAN")) - 250) / 10) & 0xFF
            var COCLEA_POWER2_FAN = int((int(webserver.arg("COCLEA_POWER2_FAN")) - 250) / 10) & 0xFF
            var COCLEA_POWER3_FAN = int((int(webserver.arg("COCLEA_POWER3_FAN")) - 250) / 10) & 0xFF
            var COCLEA_POWER4_FAN = int((int(webserver.arg("COCLEA_POWER4_FAN")) - 250) / 10) & 0xFF
            var COCLEA_POWER5_FAN = int((int(webserver.arg("COCLEA_POWER5_FAN")) - 250) / 10) & 0xFF
            stoveObj.write_eeprom_if_changed(stoveObj.STOVE_ADDRESS_EEPROM_MINUTES_START, Minute_START)
            stoveObj.write_eeprom_if_changed(stoveObj.STOVE_ADDRESS_EEPROM_CADENCE_CLEANING, CADENCE_CLEANING)
            stoveObj.write_eeprom_if_changed(stoveObj.STOVE_ADDRESS_EEPROM_AUGER_LINGHTS, AUGER_LIGHTS)
            stoveObj.write_eeprom_if_changed(stoveObj.STOVE_ADDRESS_EEPROM_COCLEA_START, COCLEA_START)
            stoveObj.write_eeprom_if_changed(stoveObj.STOVE_ADDRESS_EEPROM_COCLEA_POWER1, COCLEA_POWER1)
            stoveObj.write_eeprom_if_changed(stoveObj.STOVE_ADDRESS_EEPROM_COCLEA_POWER2, COCLEA_POWER2)
            stoveObj.write_eeprom_if_changed(stoveObj.STOVE_ADDRESS_EEPROM_COCLEA_POWER3, COCLEA_POWER3)
            stoveObj.write_eeprom_if_changed(stoveObj.STOVE_ADDRESS_EEPROM_COCLEA_POWER4, COCLEA_POWER4)
            stoveObj.write_eeprom_if_changed(stoveObj.STOVE_ADDRESS_EEPROM_COCLEA_POWER5, COCLEA_POWER5)
            stoveObj.write_eeprom_if_changed(stoveObj.STOVE_ADDRESS_EEPROM_EXHAUST_START_FUSE_RPM, START_EXHAUST)
            stoveObj.write_eeprom_if_changed(stoveObj.STOVE_ADDRESS_EEPROM_EXHHAUST_FINAL_CLEANING_SPEED, CADENCE_CLEANING_FUME)
            stoveObj.write_eeprom_if_changed(stoveObj.STOVE_ADDRESS_EEPROM_EXHAUST_WAIT_FIRE, AUGER_LIGHTS_FAN)
            stoveObj.write_eeprom_if_changed(stoveObj.STOVE_ADDRESS_EEPROM_EXHAUST_ENGINE_1, COCLEA_POWER1_FAN)
            stoveObj.write_eeprom_if_changed(stoveObj.STOVE_ADDRESS_EEPROM_EXHAUST_ENGINE_2, COCLEA_POWER2_FAN)
            stoveObj.write_eeprom_if_changed(stoveObj.STOVE_ADDRESS_EEPROM_EXHAUST_ENGINE_3, COCLEA_POWER3_FAN)
            stoveObj.write_eeprom_if_changed(stoveObj.STOVE_ADDRESS_EEPROM_EXHAUST_ENGINE_4, COCLEA_POWER4_FAN)
            stoveObj.write_eeprom_if_changed(stoveObj.STOVE_ADDRESS_EEPROM_EXHAUST_ENGINE_5, COCLEA_POWER5_FAN)

            webserver.redirect("/StoveSettings_ui") # redirect to the settings page to display the updated values
        end
        return
      except .. as e,m
        CoreLog("G003", format("ui_exception page=StoveSettings_ctl err='%s' msg='%s'", e, m))
        #- display error page -#
        webserver.content_start("Parameter error")           #- title of the web page -#
        webserver.content_send_style()                  #- send standard Tasmota styles -#

        webserver.content_send(format("<p style='width:340px;'><b>Exception:</b><br>'%s'<br>%s</p>", e, m))

        webserver.content_button(webserver.BUTTON_MAIN) #- button back to management page -#
        webserver.content_stop()                        #- end of web page -#
      end
    end

    def web_add_handler()
        webserver.on("/StoveSettings_ui", / -> self.page_StoveSettings_ui(), webserver.HTTP_GET)
        webserver.on("/StoveSettings_ui", / -> self.page_StoveSettings_ctl(), webserver.HTTP_POST)
        webserver.on("/StoveTimer_ui", / -> self.page_StoveTimer_ui(), webserver.HTTP_GET)
        webserver.on("/StoveTimer_ui", / -> self.page_StoveTimer_ctl(), webserver.HTTP_POST)
    end
end

stoveObjGUI = StoveClassGUI()
tasmota.add_driver(stoveObjGUI)
stoveObjGUI.web_add_handler()