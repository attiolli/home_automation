#include "esphome.h"
using namespace esphome;

class MyScreen {
  public:
    struct settings_t {
        int timeout=60;
        int xres=480;
        int yres=320;
        int hxn=xres/3;         //header x position name
        int hxv=xres/1.5;       //header x position value
        int hyn=0;              //header y position name
        int hyv=0;              //header y position value
        int icon_padding=85;    //general icon padding
        int icon_padding_vert=65;       //general icon padding
        int i1xi=hxn/6;         //x position 1st column image
        int i1xv=i1xi+80;       //x position 1st column value
        int i1yi=hyn+45;        //y position 1st column image
        int i1yv=hyn+45;        //y position 1st column value
        int i2xi=hxv/1.2;       //x position 2nd column image
        int i2xv=i2xi+80;       //x position 2nd column value
        int f1xi=20;            //x position 1st footer icon
        int f1yi=yres-40;       //y position 1st footer icon
        int f2xi=xres-55;       //x position 2nd footer icon
        int f2yi=yres-40;       //y position 2nd footer icon
        int i1r2xi=hxn/6;       //Row2 x position 1st column image
        int i1r2xv=i1xi+80;     //Row2 x position 1st column value
        int i1r2yi=hyn+45+45;   //Row2 y position 1st column image
        int i1r2yv=hyn+45+45;   //Row2 y position 1st column value
        int i1r3xi=20;                          //Row3 x position 1st column image
        int i2r3xi=i1r3xi+icon_padding;         //Row3 x position 2nd column image
        int i3r3xi=i2r3xi+icon_padding;         //Row3 x position 3rd column image
        int i4r3xi=i3r3xi+icon_padding;         //Row3 x position 4th column image
        int i1r3yv=hyn+45+45+85;                //Row3 y position
        int i1c4xi=xres-85;                     //1st image x position 4th column image
        int i1c4yi=yres-190;                    //1nd image y position 4th column image
        int i2c4xi=i1c4xi;                      //2st image x position 4th column image
        int i2c4yi=i1c4yi+icon_padding_vert;    //2nd image y position 4th column image
    } settings;

} myscreen;
