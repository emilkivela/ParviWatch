import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Activity;
import Toybox.ActivityMonitor;
import Toybox.Time.Gregorian;

class ParviWatchView extends WatchUi.WatchFace {
    private var screenHeight;
    private var screenWidth;
    private var parviGreen;
    private var retroFont;
    private var retroFontSmall;

    function initialize() {
        WatchFace.initialize();

    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
        screenHeight = dc.getHeight();
        screenWidth = dc.getWidth();
        parviGreen = Graphics.createColor(255, 15, 215, 135);
        retroFont = WatchUi.loadResource(Rez.Fonts.retroFont);
        retroFontSmall = WatchUi.loadResource(Rez.Fonts.retroFontSmall);
        
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {

        
        

        // Get the current time and format it correctly
        var timeFormat = "$1$:$2$";
        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        } else {
            if (getApp().getProperty("UseMilitaryFormat")) {
                timeFormat = "$1$$2$";
                hours = hours.format("%02d");
            }
        }
        var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);

        // Update the view
        //var view = View.findDrawableById("TimeLabel") as Text;
        //view.setColor(parviGreen);
        //view.setText(timeString);
        //view.setFont(retroFontBig);
        
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        drawDate(dc);
        drawBattery(dc);
        drawHeartrate(dc);
        drawCalories(dc);
        dc.drawText(
            screenWidth / 2,
            10,
            retroFont,
            timeString,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );



    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

    private function drawDate(dc) {
        System.println(retroFont);
        var now = Time.now();
        var date = Toybox.Time.Gregorian.info(now, Time.FORMAT_MEDIUM);
        var dayString = date.day_of_week;
        var dateString = date.day;

        dc.setColor(parviGreen, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            screenWidth-37,
            screenHeight-95,
            retroFont,
            dayString,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
        dc.drawText(
            screenWidth-35,
            screenHeight-60,
            retroFont,
            dateString,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }

    private function drawBattery(dc) {
        var battery = System.getSystemStats().battery;

        var height = 16;
        var width = 24;
        var x = 60;
        var y = screenHeight-105;
        var fontHeight = dc.getFontHeight(Graphics.FONT_TINY)-15;

        dc.setPenWidth(2);
        dc.setColor(
            battery <= 20 ? Graphics.COLOR_DK_RED : parviGreen,
            Graphics.COLOR_TRANSPARENT
        );
        // Draw the outer rect
        dc.drawRoundedRectangle(
            x - 35,
            y + fontHeight,
            width,
            height,
            2
        );
        // Draw the small + on the right
        dc.drawLine(
            x-10,
            y + fontHeight + 3,
            x-10,
            y+fontHeight + height - 3
        );
        // Fill the rect based on current battery
        dc.fillRectangle(
            x - 35 + 1,
            y + fontHeight,
            (width - 2) * battery / 100,
            height
        );

        // Draw the text
        dc.drawText(
            x,
            y + 10,
            retroFont,
            battery.format("%d"),
            Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }

    private function drawHeartrate(dc) {
        var heartRate = Activity.getActivityInfo().currentHeartRate == null ? "--" : Activity.getActivityInfo().currentHeartRate;
        dc.drawText(
            70,
            20,
            retroFont,
            heartRate,
            Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER
        );
        dc.drawText(
            50,
            40,
            retroFont,
            9829.toChar(),
            Graphics.TEXT_JUSTIFY_RIGHT);
    }

    private function drawCalories(dc) {
        var calories = ActivityMonitor.getInfo().calories;
        dc.drawText(
            screenWidth-7,
            15,
            retroFontSmall,
            calories,
            Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER
        );
        dc.drawText(
            screenWidth-7,
            40,
            retroFontSmall,
            "kcal",
            Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }


    

}


