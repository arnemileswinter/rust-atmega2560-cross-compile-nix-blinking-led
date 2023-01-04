#![no_std]
#![no_main]

use panic_halt as _;

#[arduino_hal::entry]
fn main() -> ! {
    let dp = arduino_hal::Peripherals::take().unwrap();
    let pins = arduino_hal::pins!(dp);
    let mut serial = arduino_hal::default_serial!(dp,pins,57600);

    let mut led = pins.d13.into_output().downgrade();

    loop {
        led.toggle();
        ufmt::uwriteln!(&mut serial, "hello world").unwrap();
        arduino_hal::delay_ms(1000);
    }
}